import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/widgets/action_group.dart';
import 'package:obywatel_plus/core/design/widgets/action_tile.dart';
import 'package:obywatel_plus/core/design/widgets/main/app_scaffold.dart';
import 'package:obywatel_plus/core/utils/device_capabilities_provider.dart';
import 'package:obywatel_plus/features/settings/domain/notification_settings_notifier.dart';
import 'package:obywatel_plus/features/settings/presentation/config/notifications_settings_config.dart';

class NotificationsSettingsScreen extends ConsumerWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final caps = ref.watch(deviceCapabilitiesProvider);
    final settings = ref.watch(notificationSettingsProvider);
    final notifier = ref.read(notificationSettingsProvider.notifier);

    if (!caps.initialized) {
      return const Center(child: CircularProgressIndicator());
    }

    final sections = NotificationsSettingsConfig.getSections(
      caps: caps,
      settings: settings,
      notifier: notifier,
    );

    return AppScaffold(
      title: Text(LocaleKeys.settings_notifications_settings_title.tr()),
      size: ContainerSize.medium,
      child: ListView(
        children: sections
            .map(
              (section) => ActionGroup(
                title: section.title,
                children: section.items
                    .map(
                      (item) => ActionTile(
                        icon: item.icon,
                        title: item.title,
                        subtitle: item.subtitle,
                        isDanger: item.isDanger,
                        isEnabled: item.isEnabled,
                        value: item.initialValue,
                        onToggle: item.onToggle,
                      ),
                    )
                    .toList(),
              ),
            )
            .toList(),
      ),
    );
  }
}
