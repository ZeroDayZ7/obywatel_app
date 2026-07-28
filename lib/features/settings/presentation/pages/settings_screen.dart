import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/design/models/action_item.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/widgets/action_group.dart';
import 'package:obywatel_plus/core/design/widgets/action_tile.dart';
import 'package:obywatel_plus/core/design/widgets/main/app_bar.dart';
import 'package:obywatel_plus/core/design/widgets/main/app_scaffold.dart';
import 'package:obywatel_plus/features/settings/presentation/config/settings_config.dart';
import 'package:obywatel_plus/features/settings/presentation/sheets/language_selector_sheet.dart';
import 'package:obywatel_plus/features/settings/presentation/sheets/theme_selector_sheet.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sections = SettingsConfig.getSections(
      context,
      onLanguageTap: () => _showLanguageSelectorSheet(context),
      onThemeTap: () => _showThemeSelectorSheet(context),
      biometryValue: true,
      onBiometryToggle: (val) {},
    );

    return AppScaffold(
      size: ContainerSize.medium,
      appBar: AppAppBar(
        title: LocaleKeys.settings_title.tr(),
        showBackButton: true,
      ),
      child: ListView.builder(
        itemCount: sections.length,
        itemBuilder: (context, index) {
          final section = sections[index];
          final items = section['items'] as List<ActionItem>;

          return ActionGroup(
            title: section['title'] as String,
            children: items
                .map(
                  (item) => ActionTile(
                    icon: item.icon,
                    title: item.title,
                    subtitle: item.subtitle,
                    isDanger: item.isDanger,
                    showArrow: item.type == ActionType.navigation,
                    onToggle: item.type == ActionType.toggle
                        ? item.onToggle
                        : null,
                    value: item.initialValue,
                    onTap: item.onTap,
                    isEnabled: item.isEnabled,
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }

  void _showThemeSelectorSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const ThemeSelectorSheet(),
    );
  }

  void _showLanguageSelectorSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const LanguageSelectorSheet(),
    );
  }
}
