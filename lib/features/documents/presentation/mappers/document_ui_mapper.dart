import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/theme/app_colors.dart';
import 'package:obywatel_plus/features/documents/domain/models/document_model.dart';

extension DocumentModelUiX on DocumentModel {
  String get title {
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
    final number = metadata['document_number'];
    if (number != null) {
      return number.toString();
    }
    return isVerified ? 'Ważny' : 'Nieważny';
  }

  Color get color {
    switch (type.toUpperCase()) {
      case 'ID_CARD':
        return AppColors.documentIdentity;
      case 'DRIVERS_LICENSE':
        return AppColors.documentLicense;
      case 'PASSPORT':
        return AppColors.documentPassport;
      case 'VEHICLE_REGISTRATION':
        return AppColors.documentVehicle;
      case 'LARGE_FAMILY_CARD':
        return AppColors.documentFamily;
      default:
        return AppColors.documentDefault;
    }
  }

  IconData get icon {
    switch (type.toUpperCase()) {
      case 'ID_CARD':
        return Icons.badge_outlined;
      case 'DRIVERS_LICENSE':
        return Icons.directions_car_outlined;
      case 'PASSPORT':
        return Icons.travel_explore_outlined;
      case 'VEHICLE_REGISTRATION':
        return Icons.directions_car_outlined;
      case 'LARGE_FAMILY_CARD':
        return Icons.family_restroom_outlined;
      default:
        return Icons.article_outlined;
    }
  }
}
