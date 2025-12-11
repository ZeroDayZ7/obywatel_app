import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/features/settings/presentation/widgets/settings_card.dart';
import 'theme_selector_sheet.dart';
import 'package:obywatel_plus/core/lang/locale_keys.g.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.settings_title.tr()),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.settings_general.tr(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SettingsCard(
              icon: Icons.notifications,
              title: LocaleKeys.settings_notifications.tr(),
              subtitle: LocaleKeys.settings_notifications.tr(),
              onTap: () {},
            ),
            SettingsCard(
              icon: Icons.language,
              title: LocaleKeys.settings_language.tr(),
              subtitle: LocaleKeys.settings_language.tr(),
              onTap: () {},
            ),
            SettingsCard(
              icon: Icons.palette,
              title: LocaleKeys.settings_theme.tr(),
              subtitle: LocaleKeys.settings_theme.tr(),
              onTap: () => _showThemeSelectorSheet(context, ref),
            ),
            const SizedBox(height: 24),
            Text(
              LocaleKeys.settings_security.tr(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SettingsCard(
              icon: Icons.security,
              title: LocaleKeys.settings_security.tr(),
              subtitle: LocaleKeys.settings_security.tr(),
              onTap: () =>
                  context.push('${AppRoutes.settings}/${AppRoutes.security}'),
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
}
