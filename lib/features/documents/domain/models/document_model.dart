import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'document_model.freezed.dart';
part 'document_model.g.dart';

enum DocumentCategory {
  identity,
  work,
  education,
  transport,
  permissions, // Dodane, aby obsłużyć prawo jazdy, broń itp.
}

@freezed
sealed class DocumentField with _$DocumentField {
  const factory DocumentField({
    required String label,
    required String value,
    required String iconName,
    @Default(false) bool isSensitive,
  }) = _DocumentField;

  const DocumentField._();

  factory DocumentField.fromJson(Map<String, dynamic> json) =>
      _$DocumentFieldFromJson(json);

  IconData get icon => _getIconData(iconName);
}

@freezed
sealed class DocumentModel with _$DocumentModel {
  const factory DocumentModel({
    required String id,
    required String title,
    required String iconName,
    required String colorHex,
    required DocumentCategory category,
    required List<DocumentField> fields,
    String? qrData,
    String? status,
    @Default(false) bool isVerified,
    String? subtitle,
    String? expiryDate,
  }) = _DocumentModel;

  const DocumentModel._();

  factory DocumentModel.fromJson(Map<String, dynamic> json) =>
      _$DocumentModelFromJson(json);

  Color get themeColor {
    final hex = colorHex.replaceFirst('#', '');
    if (hex.length == 6) return Color(int.parse('FF$hex', radix: 16));
    return Color(int.parse(hex, radix: 16));
  }

  IconData get icon => _getIconData(iconName);
}

IconData _getIconData(String name) {
  switch (name) {
    // Identity & General
    case 'badge':
      return Icons.badge;
    case 'person':
      return Icons.person;
    case 'fingerprint':
      return Icons.fingerprint;
    case 'public':
      return Icons.public;
    case 'male':
      return Icons.male;
    case 'female':
      return Icons.female;

    // Transport
    case 'directions_car':
      return Icons.directions_car;
    case 'directions_bus':
      return Icons.directions_bus;
    case 'train':
      return Icons.train;
    case 'flight_takeoff':
      return Icons.flight_takeoff;
    case 'flight':
      return Icons.flight;
    case 'map':
      return Icons.map;

    // Education & Work
    case 'school':
      return Icons.school;
    case 'apartment':
      return Icons.apartment;
    case 'work':
      return Icons.work;

    // Permissions & Security
    case 'security':
      return Icons.security;
    case 'gavel':
      return Icons.gavel;
    case 'target': // Często używane jako cel pozwolenia
      return Icons.gps_fixed;
    case 'family_restroom':
      return Icons.family_restroom;
    case 'elderly':
      return Icons.elderly;

    // UI Elements
    case 'description':
      return Icons.description;
    case 'numbers':
      return Icons.numbers;
    case 'card_membership':
      return Icons.card_membership;
    case 'credit_card':
      return Icons.credit_card;
    case 'event':
      return Icons.event;
    case 'calendar_today':
      return Icons.calendar_today;
    case 'star':
      return Icons.star;
    case 'loyalty':
      return Icons.loyalty;
    case 'corporate_fare':
      return Icons.corporate_fare;
    case 'event_seat':
      return Icons.event_seat;
    case 'location_city':
      return Icons.location_city;
    case 'category':
      return Icons.category;

    default:
      return Icons.info_outline;
  }
}
