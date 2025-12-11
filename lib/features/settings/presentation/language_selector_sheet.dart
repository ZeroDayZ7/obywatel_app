import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:obywatel_plus/core/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/lang/language_notifier.dart';
import 'package:obywatel_plus/core/lang/languages.dart';

class LanguageSelectorSheet extends ConsumerWidget {
  const LanguageSelectorSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(languageProvider);
    final notifier = ref.read(languageProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.settings_language.tr(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          RadioGroup<String>(
            groupValue: currentLocale.languageCode,
            onChanged: (String? value) async {
              if (value != null) {
                await notifier.setLanguage(value);
                if (context.mounted) {
                  await context.setLocale(Locale(value));
                }
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: AppLanguages.supported.map((lang) {
                final languageCode = lang.code;
                final languageName = lang.name;

                return RadioListTile<String>(
                  title: Text(languageName),
                  value: languageCode,
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
