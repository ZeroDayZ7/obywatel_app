import 'package:flutter/material.dart';

abstract final class DocumentIconMapper {
  static const Map<String, IconData> _iconMap = {
    // Identity & General
    'badge': Icons.badge,
    'person': Icons.person,
    'fingerprint': Icons.fingerprint,
    'public': Icons.public,
    'male': Icons.male,
    'female': Icons.female,

    // Transport
    'directions_car': Icons.directions_car,
    'directions_bus': Icons.directions_bus,
    'train': Icons.train,
    'flight_takeoff': Icons.flight_takeoff,
    'flight': Icons.flight,
    'map': Icons.map,

    // Education & Work
    'school': Icons.school,
    'apartment': Icons.apartment,
    'work': Icons.work,

    // Permissions & Security
    'security': Icons.security,
    'gavel': Icons.gavel,
    'target': Icons.gps_fixed,
    'family_restroom': Icons.family_restroom,
    'elderly': Icons.elderly,

    // UI Elements
    'description': Icons.description,
    'numbers': Icons.numbers,
    'card_membership': Icons.card_membership,
    'credit_card': Icons.credit_card,
    'event': Icons.event,
    'calendar_today': Icons.calendar_today,
    'star': Icons.star,
    'loyalty': Icons.loyalty,
    'corporate_fare': Icons.corporate_fare,
    'event_seat': Icons.event_seat,
    'location_city': Icons.location_city,
    'category': Icons.category,
  };

  static IconData getIcon(String name) {
    return _iconMap[name] ?? Icons.info_outline;
  }
}
