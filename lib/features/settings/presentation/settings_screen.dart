import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
// Importy Twoich tokenów i widgetów
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/widgets/app_scaffold.dart';
import 'package:obywatel_plus/features/settings/presentation/sheets/language_selector_sheet.dart';
import 'package:obywatel_plus/features/settings/presentation/sheets/theme_selector_sheet.dart';
import 'package:obywatel_plus/features/settings/presentation/widgets/settings_card.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    return AppScaffold(
      size: ContainerSize.medium,
      title: Text(LocaleKeys.settings_title.tr()),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.settings_general.tr(),
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            SettingsCard(
              icon: Icons.notifications,
              title: LocaleKeys.settings_notifications.tr(),
              subtitle: LocaleKeys.settings_notifications_subtitle.tr(),
              showArrow: true,
              onTap: () => context.push(
                '${AppRoutes.settings}/${AppRoutes.settingsNotifications}',
              ),
            ),
            SettingsCard(
              icon: Icons.language,
              title: LocaleKeys.settings_language.tr(),
              subtitle: LocaleKeys.settings_language_subtitle.tr(),
              onTap: () => _showLanguageSelectorSheet(context, ref),
            ),
            SettingsCard(
              icon: Icons.palette,
              title: LocaleKeys.settings_theme.tr(),
              subtitle: LocaleKeys.settings_theme_subtitle.tr(),
              onTap: () => _showThemeSelectorSheet(context, ref),
            ),
            const SizedBox(height: 32),
            Text(
              LocaleKeys.settings_security_title.tr(),
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            SettingsCard(
              icon: Icons.security,
              title: LocaleKeys.settings_security_title.tr(),
              subtitle: LocaleKeys.settings_security_subtitle.tr(),
              showArrow: true,
              onTap: () => context.push(
                '${AppRoutes.settings}/${AppRoutes.settingsSecurity}',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeSelectorSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<ThemeMode>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const ThemeSelectorSheet(),
    );
  }

  void _showLanguageSelectorSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const LanguageSelectorSheet(),
    );
  }
}
