import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/design/models/action_item.dart';

class HelpConfig {
  static List<Map<String, dynamic>> getSections({
    required VoidCallback onEmailTap,
    required VoidCallback onPhoneTap,
  }) {
    return [
      {
        'title': LocaleKeys.help_contact_section.tr(),
        'items': [
          ActionItem(
            icon: Icons.email,
            title: 'support@yourapp.com',
            subtitle: LocaleKeys.help_contact_email.tr(),
            type: ActionType.navigation,
            onTap: onEmailTap,
          ),
          ActionItem(
            icon: Icons.phone,
            title: '+48 123 456 789',
            subtitle: LocaleKeys.help_contact_phone.tr(),
            type: ActionType.navigation,
            onTap: onPhoneTap,
          ),
        ],
      },
    ];
  }
}
