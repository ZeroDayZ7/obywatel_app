import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:obywatel_plus/core/database/daos/user_documents_dao.dart';
import 'package:obywatel_plus/core/database/database.dart';
import 'package:obywatel_plus/core/database/database_provider.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/network/api_endpoints.dart';
import 'package:obywatel_plus/core/network/providers.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:obywatel_plus/features/documents/domain/models/document_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'document_repository.g.dart';

@riverpod
DocumentRepository documentRepository(Ref ref) {
  final database = ref.watch(appDatabaseProvider);
  return LocalFirstDocumentRepository(ref, database.userDocumentsDao);
}

class DocumentSyncManifest {
  const DocumentSyncManifest._();

  static String compute(Map<String, dynamic> payload) {
    final normalized = _normalizeMap(payload);
    final serialized = jsonEncode(normalized);
    final digest = sha256.convert(utf8.encode(serialized));
    return digest.toString();
  }

  static dynamic _normalizeMap(dynamic value) {
    if (value is Map) {
      final normalized = <String, dynamic>{};
      final keys = value.keys.map((key) => key.toString()).toList()..sort();

      for (final key in keys) {
        final child = value[key];
        normalized[key] = _normalizeMap(child);
      }

      return normalized;
    }

    if (value is List) {
      return value.map(_normalizeMap).toList();
    }

    if (value is DateTime) {
      return value.toUtc().toIso8601String();
    }

    return value;
  }
}

abstract class DocumentRepository {
  Stream<List<DocumentModel>> watchDocuments();
  Future<DocumentModel?> getDocumentById(String id);
  Future<void> syncDocuments();
}

class LocalFirstDocumentRepository implements DocumentRepository {
  final Ref _ref;
  final UserDocumentsDao _dao;

  LocalFirstDocumentRepository(this._ref, this._dao);

  @override
  Stream<List<DocumentModel>> watchDocuments() {
    return _dao.watchDocuments().map(
      (dbRows) => dbRows.map(_mapDbToDomain).toList(),
    );
  }

  @override
  Future<DocumentModel?> getDocumentById(String id) async {
    final dbRow = await _dao.getDocumentById(id);
    if (dbRow == null) return null;
    return _mapDbToDomain(dbRow);
  }

  @override
  Future<void> syncDocuments() async {
    final apiClient = _ref.read(apiClientProvider);
    final logger = _ref.read(appLoggerProvider);
    final storage = _ref.read(secureStorageProvider);

    try {
      final storedEtag = await storage.read(key: StorageKeys.documentsEtag);
      final storedStateVersion = await storage.read(
        key: StorageKeys.documentsStateVersion,
      );
      final currentVersion =
          int.tryParse(storedStateVersion ?? '') ?? await _dao.getMaxVersion();
      final headers = <String, dynamic>{};
      if (storedEtag != null && storedEtag.isNotEmpty) {
        headers['If-None-Match'] = storedEtag;
      }

      final response = await apiClient.get(
        ApiEndpoints.documentsMe,
        queryParams: currentVersion > 0
            ? {'since_version': currentVersion}
            : null,
        options: Options(headers: headers),
      );

      if (response.statusCode == 304) {
        logger.i('Skipping document sync: server reports no changes');
        return;
      }

      if (response.data == null || response.data is! List) return;

      final items = response.data as List;
      final stateVersionHeader = response.headers.value(
        'x-document-state-version',
      );
      final stateVersion =
          int.tryParse(stateVersionHeader ?? '') ?? currentVersion;
      final responseEtag =
          response.headers.value('etag') ?? response.headers.value('ETag');

      if (responseEtag != null && responseEtag.isNotEmpty) {
        await storage.write(
          key: StorageKeys.documentsEtag,
          value: responseEtag,
        );
      }
      if (stateVersion > 0) {
        await storage.write(
          key: StorageKeys.documentsStateVersion,
          value: stateVersion.toString(),
        );
      }

      if (items.isEmpty) return;

      final companions = <UserDocumentsCompanion>[];

      for (final item in items) {
        if (item is! Map) continue;

        final map = Map<String, dynamic>.from(item);
        final id = map['id']?.toString();
        if (id == null || id.isEmpty) continue;

        final manifestHash = DocumentSyncManifest.compute(map);
        final existingHash = await _dao.getDocumentManifestHash(id);
        if (existingHash != null && existingHash == manifestHash) {
          continue;
        }

        final metaJson = _extractMetadata(map);
        final rawSignature = map['issuer_signature'] as String? ?? '';
        final typeCode =
            (map['type_code'] ?? map['document_type'] ?? map['type'] ?? '')
                .toString();
        final version = map['version'] is int ? map['version'] as int : 1;

        List<int> signatureBytes;
        try {
          signatureBytes = rawSignature.isEmpty
              ? <int>[]
              : base64.decode(rawSignature);
        } catch (_) {
          signatureBytes = utf8.encode(rawSignature);
        }

        final issuedAtValue = _parseDate(map['issued_at']);
        final expiresAtValue = _parseDate(map['expires_at']);
        final issuerSignatureBlob = Uint8List.fromList(signatureBytes);

        companions.add(
          UserDocumentsCompanion(
            id: Value(id),
            typeCode: Value(typeCode),
            status: Value((map['status'] ?? 'active').toString()),
            title: Value(metaJson['title'] as String? ?? ''),
            issuer: Value(metaJson['issuer'] as String? ?? ''),
            category: Value(metaJson['category'] as String? ?? 'identity'),
            documentNumber: Value(metaJson['document_number'] as String? ?? ''),
            issuerSignature: Value(issuerSignatureBlob),
            signingKeyId: Value(map['signing_key_id'] as String? ?? ''),
            revocationSerial: Value(map['revocation_serial'] as String? ?? ''),
            version: Value(version),
            issuedAt: Value(issuedAtValue),
            expiresAt: Value(expiresAtValue),
            allowedScopesJson: Value(
              metaJson['allowed_scopes'] != null
                  ? jsonEncode(metaJson['allowed_scopes'])
                  : null,
            ),
            customAttributesJson: Value(
              metaJson['custom_attributes'] != null
                  ? jsonEncode(metaJson['custom_attributes'])
                  : null,
            ),
            updatedAt: Value(DateTime.now().toUtc()),
          ),
        );
      }

      if (companions.isNotEmpty) {
        await _dao.upsertDocuments(companions);
      }
    } catch (e, stackTrace) {
      logger.e('Failed to sync documents', error: e, stackTrace: stackTrace);
    }
  }

  Map<String, dynamic> _extractMetadata(Map<String, dynamic> payload) {
    final metadata = payload['metadata'];
    if (metadata is Map) {
      return Map<String, dynamic>.from(metadata);
    }
    return _parseMetadata(payload['encrypted_meta'] as String?);
  }

  Map<String, dynamic> _parseMetadata(String? rawMeta) {
    if (rawMeta == null || rawMeta.isEmpty) return {};
    try {
      final decodedBytes = base64.decode(rawMeta);
      final decodedString = utf8.decode(decodedBytes);
      final dec = jsonDecode(decodedString);
      if (dec is Map) {
        return Map<String, dynamic>.from(dec);
      }
    } catch (_) {
      return {};
    }
    return {};
  }

  DateTime? _parseDate(dynamic rawValue) {
    if (rawValue == null || rawValue.toString().isEmpty) return null;
    try {
      return DateTime.parse(rawValue.toString());
    } catch (_) {
      return null;
    }
  }

  DocumentModel _mapDbToDomain(DbUserDocument dbRow) {
    final Map<String, dynamic> parsedMeta = {
      'title': dbRow.title,
      'issuer': dbRow.issuer,
      'category': dbRow.category,
      'document_number': dbRow.documentNumber,
    };

    Map<String, dynamic> customAttrs = {};
    if (dbRow.customAttributesJson != null &&
        dbRow.customAttributesJson!.isNotEmpty) {
      try {
        customAttrs =
            jsonDecode(dbRow.customAttributesJson!) as Map<String, dynamic>;
        parsedMeta.addAll(customAttrs);
      } catch (_) {}
    }

    final fields = <DocumentField>[];

    if (dbRow.documentNumber.isNotEmpty) {
      fields.add(
        DocumentField(
          label: 'Numer dokumentu',
          value: dbRow.documentNumber,
          iconName: 'numbers',
        ),
      );
    }

    if (dbRow.issuer.isNotEmpty) {
      fields.add(
        DocumentField(
          label: 'Organ wydający',
          value: dbRow.issuer,
          iconName: 'account_balance',
        ),
      );
    }

    // Dodatkowe atrybuty specyficzne dla typu dokumentu (z custom_attributes z API/bazy)
    customAttrs.forEach((key, val) {
      if (val == null) return;

      String formattedValue = val.toString();
      if (val is List) {
        formattedValue = val.join(', ');
      }

      String label = key;
      String icon = 'info';

      switch (key) {
        case 'can_number':
          label = 'Numer CAN';
          icon = 'lock';
          break;
        case 'organ_wydajacy_kod':
          label = 'Kod organu wydającego';
          icon = 'code';
          break;
        case 'categories':
          label = 'Kategorie prawa jazdy';
          icon = 'style';
          break;
        case 'restrictions':
          label = 'Ograniczenia';
          icon = 'warning';
          break;
        case 'children_count':
          label = 'Liczba dzieci';
          icon = 'child_care';
          break;
        case 'role':
          label = 'Rola w rodzinie';
          icon = 'person';
          break;
      }

      fields.add(
        DocumentField(label: label, value: formattedValue, iconName: icon),
      );
    });

    return DocumentModel(
      id: dbRow.id,
      type: dbRow.typeCode,
      status: dbRow.status,
      metadata: parsedMeta,
      fields: fields,
      issuedAt: dbRow.issuedAt?.toIso8601String(),
      expiresAt: dbRow.expiresAt?.toIso8601String(),
    );
  }
}
