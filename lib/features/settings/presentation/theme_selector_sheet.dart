import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:obywatel_plus/app/theme/theme_notifier.dart';
import 'package:obywatel_plus/core/lang/locale_keys.g.dart';

class ThemeSelectorSheet extends ConsumerWidget {
  const ThemeSelectorSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final notifier = ref.read(themeProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(LocaleKeys.settings_theme.tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          RadioGroup<ThemeMode>(
            groupValue: themeMode,
            onChanged: (ThemeMode? value) async {
              if (value == null) return;
              switch (value) {
                case ThemeMode.light:
                  await notifier.setLight();
                  break;
                case ThemeMode.dark:
                  await notifier.setDark();
                  break;
                case ThemeMode.system:
                  await notifier.setSystem();
                  break;
              }
              if (context.mounted) Navigator.of(context).pop();
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<ThemeMode>(
                  title: Text(LocaleKeys.settings_light_mode.tr()),
                  value: ThemeMode.light,
                  contentPadding: EdgeInsets.zero,
                ),
                RadioListTile<ThemeMode>(
                  title: Text(LocaleKeys.settings_dark_mode.tr()),
                  value: ThemeMode.dark,
                  contentPadding: EdgeInsets.zero,
                ),
                RadioListTile<ThemeMode>(
                  title: Text(LocaleKeys.settings_system_default.tr()),
                  value: ThemeMode.system,
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
