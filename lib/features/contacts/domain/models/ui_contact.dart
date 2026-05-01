import 'dart:ui';

import 'package:flutter/material.dart';

class UIContact {
  final String id;
  final String name;
  final String phone;
  final bool isOnline;
  final bool isVerified;
  final String category;
  final String avatarInitials;
  final Color glowColor;

  UIContact({
    required this.id,
    required this.name,
    required this.phone,
    this.isOnline = false,
    this.isVerified = false,
    required this.category,
    required this.avatarInitials,
    required this.glowColor,
  });
}
