import 'package:flutter/material.dart';
import 'package:obywatel_plus/core/design/models/action_item.dart';

class ChatSettingsConfig {
  static List<Map<String, dynamic>> getSections() {
    return [
      {
        'title': 'Security',
        'items': [
          ActionItem(
            icon: Icons.lock,
            title: 'End-to-End Encryption',
            type: ActionType.toggle,
            initialValue: true,
            onToggle: (v) {},
          ),
          ActionItem(
            icon: Icons.visibility_off,
            title: 'Stealth Mode',
            type: ActionType.toggle,
            initialValue: false,
            onToggle: (v) {},
          ),
        ],
      },
      {
        'title': 'Appearance',
        'items': [
          ActionItem(
            icon: Icons.palette,
            title: 'Chat Wallpaper',
            type: ActionType.navigation,
            onTap: () {},
          ),
          ActionItem(
            icon: Icons.font_download,
            title: 'Font Size',
            type: ActionType.navigation,
            onTap: () {},
          ),
        ],
      },
      {
        'title': 'Notifications',
        'items': [
          ActionItem(
            icon: Icons.notifications,
            title: 'Push Notifications',
            type: ActionType.toggle,
            initialValue: true,
            onToggle: (v) {},
          ),
        ],
      },
    ];
  }
}
