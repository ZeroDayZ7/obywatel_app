// lib/core/design/models/action_item.dart

import 'package:flutter/material.dart';

enum ActionType { navigation, sheet, toggle }

class ActionItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final ActionType type;
  final VoidCallback? onTap;
  final bool isDanger;
  final bool initialValue;
  final Function(bool)? onToggle;
  final bool isEnabled;

  ActionItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.type = ActionType.navigation,
    this.onTap,
    this.isDanger = false,
    this.initialValue = false,
    this.onToggle,
    this.isEnabled = true,
  });
}
