import 'package:freezed_annotation/freezed_annotation.dart';

part 'document_model.freezed.dart';
part 'document_model.g.dart';

enum DocumentCategory { identity, transport, permissions, education, social, other }

@freezed
abstract class DocumentField with _$DocumentField {
  const factory DocumentField({
    required String label,
    required String value,
    required String iconName,
  }) = _DocumentField;

  factory DocumentField.fromJson(Map<String, dynamic> json) =>
      _$DocumentFieldFromJson(json);
}

@freezed
abstract class DocumentModel with _$DocumentModel {
  const DocumentModel._();

  const factory DocumentModel({
    required String id,
    required String type,
    required String status,
    required Map<String, dynamic> metadata,
    required List<DocumentField> fields,
    String? profileId,
    String? issuedAt,
    String? expiresAt,
    String? qrData,
  }) = _DocumentModel;

  factory DocumentModel.fromJson(Map<String, dynamic> json) =>
      _$DocumentModelFromJson(json);

  bool get isVerified => status == 'active';

  String? get expiryDate => expiresAt;

String get title {
    switch (type) {
      case 'ID_CARD':
      case 'id_card':
        return 'Dowód osobisty';
      case 'DRIVER_LICENSE':
      case 'driver_license':
        return 'Prawo jazdy';
      case 'LARGE_FAMILY_CARD':
      case 'large_family_card':
        return 'Karta Dużej Rodziny';
      case 'student_card':
        return 'Legitymacja studencka';
      default:
        return metadata['title'] as String? ?? 'Dokument';
    }
  }

String get subtitle {
    switch (type) {
      case 'ID_CARD':
      case 'id_card':
        return 'Rzeczpospolita Polska';
      case 'DRIVER_LICENSE':
      case 'driver_license':
        return 'Uprawnienia do kierowania';
      case 'LARGE_FAMILY_CARD':
      case 'large_family_card':
        return 'Rodzina 3+';
      case 'student_card':
        return 'Legitymacja akademicka';
      default:
        return 'Dokument tożsamości';
    }
  }

String get iconName {
    switch (type) {
      case 'ID_CARD':
      case 'id_card':
        return 'credit_card';
      case 'DRIVER_LICENSE':
      case 'driver_license':
        return 'directions_car';
      case 'LARGE_FAMILY_CARD':
      case 'large_family_card':
        return 'family_restroom';
      case 'student_card':
        return 'school';
      default:
        return 'article';
    }
  }

String get colorHex {
    switch (type) {
      case 'ID_CARD':
      case 'id_card':
        return '#1E3A8A';
      case 'DRIVER_LICENSE':
      case 'driver_license':
        return '#047857';
      case 'LARGE_FAMILY_CARD':
      case 'large_family_card':
        return '#7C3AED';
      case 'student_card':
        return '#B91C1C';
      default:
        return '#374151';
    }
  }

DocumentCategory get category {
    switch (type) {
      case 'ID_CARD':
      case 'id_card':
        return DocumentCategory.identity;
      case 'DRIVER_LICENSE':
      case 'driver_license':
        return DocumentCategory.transport;
      case 'LARGE_FAMILY_CARD':
      case 'large_family_card':
        return DocumentCategory.social;
      case 'student_card':
        return DocumentCategory.education;
      default:
        return DocumentCategory.other;
    }
  }
}
