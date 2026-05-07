import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/design/models/action_item.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/widgets/action_group.dart';
import 'package:obywatel_plus/core/design/widgets/action_tile.dart';
import 'package:obywatel_plus/core/design/widgets/main/app_scaffold.dart';
import 'package:obywatel_plus/core/security/security/security_service_provider.dart';
import 'package:obywatel_plus/features/settings/presentation/config/security_settings_config.dart';

class SecuritySettingsScreen extends ConsumerWidget {
  const SecuritySettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(securityServiceProvider);
    final notifier = ref.read(securityServiceProvider.notifier);

    final sections = SecuritySettingsConfig.getSections(
      context,
      ref,
      state: state,
      notifier: notifier,
    );

    return AppScaffold(
      title: Text(LocaleKeys.settings_security_title.tr()),
      size: ContainerSize.medium,
      child: ListView.builder(
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
                    isDanger: item.isDanger,
                    isEnabled: item.isEnabled,
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
      ),
    );
  }
}
