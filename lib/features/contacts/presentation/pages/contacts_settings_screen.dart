import 'package:flutter/material.dart';
import 'package:obywatel_plus/core/design/models/action_item.dart';
import 'package:obywatel_plus/core/design/widgets/action_group.dart';
import 'package:obywatel_plus/core/design/widgets/action_tile.dart';
import 'package:obywatel_plus/features/contacts/presentation/config/contacts_settings_config.dart';

class ContactsSettingsScreen extends StatelessWidget {
  const ContactsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sections = ContactsSettingsConfig.getSections();

    return ListView.builder(
      itemCount: sections.length,
      itemBuilder: (context, index) {
        final section = sections[index];
        final items = section['items'] as List<ActionItem>;

        return ActionGroup(
          title: section['title'] as String?,
          children: items
              .map(
                (item) => ActionTile(
                  icon: item.icon,
                  title: item.title,
                  subtitle: item.subtitle,
                  showArrow: item.type == ActionType.navigation,
                  onTap: item.onTap,
                  onToggle: item.type == ActionType.toggle
                      ? item.onToggle
                      : null,
                  value: item.initialValue,
                ),
              )
              .toList(),
        );
      },
    );
  }
}
