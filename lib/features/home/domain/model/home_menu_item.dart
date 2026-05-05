import 'package:flutter/material.dart';

class HomeMenuItem {
  final String id;
  final IconData icon;
  final String labelKey;
  final String? route;
  final Color color;
  final bool isHidden;
  final bool isEnabled;

  const HomeMenuItem({
    required this.id,
    required this.icon,
    required this.labelKey,
    required this.route,
    required this.color,
    this.isHidden = false,
    this.isEnabled = true,
  });
}
