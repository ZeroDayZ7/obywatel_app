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
    final metaTitle = metadata['title'] as String?;
    if (metaTitle != null && metaTitle.isNotEmpty) return metaTitle;

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
      default:
        return 'Dokument';
    }
  }

  String get subtitle {
    final issuer = metadata['issuer'] as String?;
    if (issuer != null && issuer.isNotEmpty) return issuer;

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
      default:
        return 'Dokument tożsamości';
    }
  }

  String get documentNumber => metadata['document_number'] as String? ?? '';

  String get iconName {
    switch (type) {
      case 'ID_CARD':
      case 'id_card':
        return 'badge';
      case 'DRIVER_LICENSE':
      case 'driver_license':
        return 'directions_car';
      case 'LARGE_FAMILY_CARD':
      case 'large_family_card':
        return 'family_restroom';
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

    switch (type) {
      case 'ID_CARD':
      case 'id_card':
        return DocumentCategory.identity;
      case 'DRIVER_LICENSE':
      case 'driver_license':
        return DocumentCategory.permissions;
      case 'LARGE_FAMILY_CARD':
      case 'large_family_card':
        return DocumentCategory.social;
      default:
        return DocumentCategory.other;
    }
  }

  bool get isVerified => status.toLowerCase() == 'active';
  String? get expiryDate => expiresAt;
}
