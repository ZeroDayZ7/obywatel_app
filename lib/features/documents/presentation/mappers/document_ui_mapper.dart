import 'package:flutter/material.dart';
import 'package:obywatel_plus/features/documents/domain/models/document_model.dart';

extension DocumentModelUiX on DocumentModel {
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
    final number = metadata['document_number'];
    if (number != null) {
      return number.toString();
    }
    return isVerified ? 'Ważny' : 'Nieważny';
  }

  Color get color {
    switch (type) {
      case 'id_card':
        return const Color(0xFF2196F3);
      case 'driver_license':
        return const Color(0xFF4CAF50);
      case 'student_card':
        return const Color(0xFF9C27B0);
      default:
        return const Color(0xFF607D8B);
    }
  }

  IconData get icon {
    switch (type) {
      case 'id_card':
        return Icons.badge_outlined;
      case 'driver_license':
        return Icons.directions_car_outlined;
      case 'student_card':
        return Icons.school_outlined;
      default:
        return Icons.article_outlined;
    }
  }
}
