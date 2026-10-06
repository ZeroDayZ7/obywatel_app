import 'package:intl/intl.dart';

enum DocumentCategory {
  identity,
  transport,
  permissions,
  education,
  social,
  other,
}

class DocumentField {
  final String label;
  final String value;
  final String iconName;

  const DocumentField({
    required this.label,
    required this.value,
    this.iconName = 'info',
  });
}

class DocumentModel {
  final String id;
  final String type;
  final String status;
  final Map<String, dynamic> metadata;
  final List<DocumentField> fields;
  final String? profileId;
  final String? issuedAt;
  final String? expiresAt;
  final String? qrData;

  const DocumentModel({
    required this.id,
    required this.type,
    required this.status,
    required this.metadata,
    required this.fields,
    this.profileId,
    this.issuedAt,
    this.expiresAt,
    this.qrData,
  });

  String get title {
    final metaTitle = metadata['title']?.toString();
    if (metaTitle != null && metaTitle.trim().isNotEmpty) return metaTitle;

    final normalizedType = type.toUpperCase();
    switch (normalizedType) {
      case 'ID_CARD':
        return 'Dowód osobisty';
      case 'DRIVERS_LICENSE':
        return 'Prawo jazdy';
      case 'PASSPORT':
        return 'Paszport';
      case 'LARGE_FAMILY_CARD':
        return 'Karta Dużej Rodziny';
      case 'VEHICLE_REGISTRATION':
        return 'Dowód rejestracyjny';
      default:
        return 'Dokument';
    }
  }

  String get subtitle {
    final issuer = metadata['issuer']?.toString();
    if (issuer != null && issuer.trim().isNotEmpty) return issuer;

    final normalizedType = type.toUpperCase();
    switch (normalizedType) {
      case 'ID_CARD':
        return 'Rzeczpospolita Polska';
      case 'DRIVERS_LICENSE':
        return 'Uprawnienia do kierowania';
      case 'PASSPORT':
        return 'Dokument podróżny';
      case 'LARGE_FAMILY_CARD':
        return 'Rodzina 3+';
      case 'VEHICLE_REGISTRATION':
        return 'Rejestracja pojazdu';
      default:
        return 'Dokument tożsamości';
    }
  }

  String get documentNumber => metadata['document_number'] as String? ?? '';

  String get iconName {
    final normalizedType = type.toUpperCase();
    switch (normalizedType) {
      case 'ID_CARD':
        return 'badge';
      case 'DRIVERS_LICENSE':
        return 'directions_car';
      case 'PASSPORT':
        return 'travel_explore';
      case 'LARGE_FAMILY_CARD':
        return 'family_restroom';
      case 'VEHICLE_REGISTRATION':
        return 'directions_car';
      default:
        return 'article';
    }
  }

  DocumentCategory get category {
    final rawCat = (metadata['category'] as String?)?.toLowerCase();
    if (rawCat != null) {
      switch (rawCat) {
        case 'identity':
          return DocumentCategory.identity;
        case 'qualification':
        case 'permissions':
          return DocumentCategory.permissions;
        case 'social':
          return DocumentCategory.social;
        case 'transport':
          return DocumentCategory.transport;
        case 'education':
          return DocumentCategory.education;
      }
    }

    switch (type.toUpperCase()) {
      case 'ID_CARD':
        return DocumentCategory.identity;
      case 'DRIVERS_LICENSE':
      case 'PASSPORT':
        return DocumentCategory.permissions;
      case 'LARGE_FAMILY_CARD':
        return DocumentCategory.social;
      case 'VEHICLE_REGISTRATION':
        return DocumentCategory.transport;
      default:
        return DocumentCategory.other;
    }
  }

  String get normalizedStatus => status.toUpperCase();

  String get statusLabel {
    switch (normalizedStatus) {
      case 'ACTIVE':
        return 'Ważny';
      case 'PENDING':
        return 'Oczekujący';
      case 'EXPIRED':
        return 'Wygasły';
      case 'REVOKED':
        return 'Unieważniony';
      default:
        return 'Nieznany';
    }
  }

  bool get isActive => normalizedStatus == 'ACTIVE';
  bool get isPending => normalizedStatus == 'PENDING';
  bool get isExpired => normalizedStatus == 'EXPIRED';
  bool get isRevoked => normalizedStatus == 'REVOKED';

  bool get isVerified => isActive;

  String? get formattedIssuedAt => _formatDisplayDate(issuedAt);
  String? get formattedExpiresAt => _formatDisplayDate(expiresAt);
  String? get expiryDate => formattedExpiresAt;

  String? _formatDisplayDate(String? rawDate) {
    if (rawDate == null || rawDate.trim().isEmpty) {
      return null;
    }

    final parsed = DateTime.tryParse(rawDate);
    if (parsed == null) {
      return rawDate;
    }

    return DateFormat('dd.MM.yyyy', 'pl').format(parsed);
  }
}
