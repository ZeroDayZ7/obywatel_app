import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:obywatel_plus/core/database/daos/user_documents_dao.dart';
import 'package:obywatel_plus/core/database/database.dart';
import 'package:obywatel_plus/core/database/database_provider.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/network/api_endpoints.dart';
import 'package:obywatel_plus/core/network/providers.dart';
import 'package:obywatel_plus/features/documents/domain/models/document_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'document_repository.g.dart';

@riverpod
DocumentRepository documentRepository(Ref ref) {
  final database = ref.watch(appDatabaseProvider);
  return LocalFirstDocumentRepository(ref, database.userDocumentsDao);
}

abstract class DocumentRepository {
  Stream<List<DocumentModel>> watchActiveDocuments();
  Future<DocumentModel?> getDocumentById(String id);
  Future<void> syncDocuments();
}

class LocalFirstDocumentRepository implements DocumentRepository {
  final Ref _ref;
  final UserDocumentsDao _dao;

  LocalFirstDocumentRepository(this._ref, this._dao);

  @override
  Stream<List<DocumentModel>> watchActiveDocuments() {
    return _dao.watchActiveDocuments().map(
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

    try {
      final maxVersion = await _dao.getMaxVersion();
      final response = await apiClient.get(
        ApiEndpoints.documentsMe,
        queryParams: {'since_version': maxVersion},
      );

      if (response.data == null || response.data is! List) return;

      final items = response.data as List;
      if (items.isEmpty) return;

      final companions = items.map((item) {
        final map = Map<String, dynamic>.from(item as Map);

        final metaJson = _parseMetadata(map['encrypted_meta'] as String?);
        final rawSignature = map['issuer_signature'] as String? ?? '';

        return UserDocumentsCompanion(
          id: Value(map['id'] as String),
          typeCode: Value(map['type_code'] as String? ?? ''),
          status: Value(map['status'] as String? ?? 'active'),
          title: Value(metaJson['title'] as String? ?? ''),
          issuer: Value(metaJson['issuer'] as String? ?? ''),
          category: Value(metaJson['category'] as String? ?? 'identity'),
          documentNumber: Value(metaJson['document_number'] as String? ?? ''),
          issuerSignature: Value(base64.decode(rawSignature)),
          signingKeyId: Value(map['signing_key_id'] as String? ?? ''),
          revocationSerial: Value(map['revocation_serial'] as String? ?? ''),
          version: Value(map['version'] as int? ?? 1),
          issuedAt: Value(
            map['issued_at'] != null
                ? DateTime.parse(map['issued_at'] as String)
                : null,
          ),
          expiresAt: Value(
            map['expires_at'] != null
                ? DateTime.parse(map['expires_at'] as String)
                : null,
          ),
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
        );
      }).toList();

      await _dao.upsertDocuments(companions);
    } catch (e, stackTrace) {
      logger.e('Failed to sync documents', error: e, stackTrace: stackTrace);
    }
  }

  Map<String, dynamic> _parseMetadata(String? rawMeta) {
    if (rawMeta == null || rawMeta.isEmpty) return {};
    try {
      final decodedBytes = base64.decode(rawMeta);
      final decodedString = utf8.decode(decodedBytes);
      return jsonDecode(decodedString) as Map<String, dynamic>;
    } catch (_) {
      return {};
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
