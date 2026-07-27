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
    @JsonKey(name: 'id') @Default('') String id,
    @JsonKey(name: 'profile_id') String? profileId,
    @JsonKey(name: 'type') @Default('') String type,
    @JsonKey(name: 'status') @Default('') String status,
    @JsonKey(name: 'encrypted_meta') @Default('') String encryptedMeta,
    @JsonKey(name: 'issued_at') String? issuedAt,
    @JsonKey(name: 'expires_at') String? expiresAt,
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

  String get colorHex {
    switch (type) {
      case 'id_card':
        return '#2196F3';
      case 'driver_license':
        return '#4CAF50';
      case 'student_card':
        return '#9C27B0';
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
      case 'student_card':
        return DocumentCategory.education;
      default:
        return DocumentCategory.other;
    }
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

  List<DocumentField> get fields {
    return [
      DocumentField(
        label: 'Numer dokumentu',
        value: _parsedMeta['document_number']?.toString() ?? '-',
        iconName: 'badge',
      ),
      DocumentField(
        label: 'Organ wydający',
        value: _parsedMeta['issuer']?.toString() ?? '-',
        iconName: 'public',
      ),
    ];
  }

  String? get qrData => _parsedMeta['qr_code']?.toString();
}
