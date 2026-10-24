import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/design/models/action_item.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/widgets/action_group.dart';
import 'package:obywatel_plus/core/design/widgets/action_tile.dart';
import 'package:obywatel_plus/core/design/widgets/main/app_scaffold.dart';
import 'package:obywatel_plus/features/settings/presentation/config/account_settings_config.dart';

class AccountSettingsScreen extends ConsumerWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sections = AccountSettingsConfig.getSections(context, ref);

    return AppScaffold(
      title: Text(LocaleKeys.settings_account_title.tr()),
      size: ContainerSize.medium,
      child: ListView.builder(
        itemCount: sections.length,
        itemBuilder: (context, sectionIndex) {
          final section = sections[sectionIndex];
          return ActionGroup(
            title: section.title,
            children: section.items
                .map(
                  (item) => ActionTile(
                    icon: item.icon,
                    title: item.title,
                    subtitle: item.subtitle,
                    isDanger: item.isDanger,
                    isEnabled: item.isEnabled,
                    showArrow: item.type == ActionType.navigation ||
                        item.type == ActionType.sheet ||
                        item.type == ActionType.selection,
                    onTap: item.onTap,
                    onToggle: item.type == ActionType.toggle ? item.onToggle : null,
                    value: item.initialValue,
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}
