import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'document_model.freezed.dart';
part 'document_model.g.dart';

enum DocumentCategory { identity, transport, permissions, education, other }

class DocumentField {
  final String label;
  final String value;
  final String iconName;

  const DocumentField({
    required this.label,
    required this.value,
    required this.iconName,
  });
}

@freezed
sealed class DocumentModel with _$DocumentModel {
  const DocumentModel._();

  const factory DocumentModel({
    @JsonKey(name: 'ID') required String id,

    @JsonKey(name: 'ProfileID') required String profileId,

    @JsonKey(name: 'Type') required String type,

    @JsonKey(name: 'Status') required String status,

    @JsonKey(name: 'EncryptedMeta') required String encryptedMeta,

    @JsonKey(name: 'IssuedAt') String? issuedAt,

    @JsonKey(name: 'ExpiresAt') String? expiresAt,

    @JsonKey(name: 'CreatedAt') String? createdAt,

    @JsonKey(name: 'UpdatedAt') String? updatedAt,
  }) = _DocumentModel;

  factory DocumentModel.fromJson(Map<String, dynamic> json) =>
      _$DocumentModelFromJson(json);

  bool get isVerified => status == 'active';

  String get expiryDate => expiresAt ?? '';

  Map<String, dynamic> get _parsedMeta {
    if (encryptedMeta.isEmpty) {
      return {};
    }

    try {
      final decoded = utf8.decode(base64.decode(encryptedMeta));

      return jsonDecode(decoded) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }

  String get title {
    switch (type) {
      case 'id_card':
        return 'Dowód osobisty';

      case 'driver_license':
        return 'Prawo jazdy';

      case 'student_card':
        return 'Legitymacja studencka';

      default:
        return 'Dokument';
    }
  }

  String get subtitle {
    final number = _parsedMeta['document_number'];

    if (number != null) {
      return number.toString();
    }

    return isVerified ? 'Ważny' : 'Nieważny';
  }

  String get iconName {
    switch (type) {
      case 'id_card':
        return 'badge';

      case 'driver_license':
        return 'directions_car';

      case 'student_card':
        return 'school';

      default:
        return 'article';
    }
  }

  String get colorHex {
    switch (type) {
      case 'id_card':
        return '#2196F3';

      case 'driver_license':
        return '#4CAF50';

      default:
        return '#607D8B';
    }
  }

  DocumentCategory get category {
    switch (type) {
      case 'id_card':
        return DocumentCategory.identity;

      case 'driver_license':
        return DocumentCategory.transport;

      default:
        return DocumentCategory.other;
    }
  }

  List<DocumentField> get fields {
    final meta = _parsedMeta;

    final number = meta['document_number']?.toString() ?? '-';

    final issuer = meta['issuer']?.toString() ?? '-';

    return [
      DocumentField(label: 'Numer dokumentu', value: number, iconName: 'badge'),

      DocumentField(label: 'Organ wydający', value: issuer, iconName: 'public'),
    ];
  }

  String? get qrData => _parsedMeta['qr_code']?.toString();
}
