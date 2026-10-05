import 'package:flutter/material.dart';
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
        return const Color(0xFF2196F3);
      case 'DRIVERS_LICENSE':
        return const Color(0xFF4CAF50);
      case 'PASSPORT':
        return const Color(0xFF1E88E5);
      case 'VEHICLE_REGISTRATION':
        return const Color(0xFFFB8C00);
      case 'LARGE_FAMILY_CARD':
        return const Color(0xFF43A047);
      default:
        return const Color(0xFF607D8B);
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
