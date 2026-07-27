import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/app/theme/app_theme.dart';
import 'package:obywatel_plus/app/theme/theme_notifier.dart';

class ThemeSelectorSheet extends ConsumerWidget {
  const ThemeSelectorSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                LocaleKeys.settings_theme.tr(),
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            RadioGroup<AppThemeType>(
              groupValue: currentTheme,
              onChanged: (AppThemeType? selectedType) async {
                if (selectedType == null) return;
                await ref.read(themeProvider.notifier).setTheme(selectedType);

                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: AppThemeType.values
                    .map(
                      (type) => RadioListTile<AppThemeType>(
                        value: type,
                        title: Text(_getThemeLabel(type)),
                        subtitle: type == AppThemeType.matrix
                            ? const Text('Neon Green / Hacker Style')
                            : null,
                        contentPadding: EdgeInsets.zero,
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getThemeLabel(AppThemeType type) {
    switch (type) {
      case AppThemeType.light:
        return LocaleKeys.settings_light_mode.tr();
      case AppThemeType.dark:
        return LocaleKeys.settings_dark_mode.tr();
      case AppThemeType.system:
        return LocaleKeys.settings_system_default.tr();
      case AppThemeType.matrix:
        return 'Matrix';
    }
  }
}
