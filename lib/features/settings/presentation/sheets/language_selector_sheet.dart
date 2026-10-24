import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/lang/languages.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';

class LanguageSelectorSheet extends StatelessWidget {
  const LanguageSelectorSheet({super.key});

  void _changeLanguage(BuildContext context, String languageCode) {
    if (context.mounted) {
      context.setLocale(Locale(languageCode)).then((_) {
        if (context.mounted) Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentCode = context.locale.languageCode;

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.85,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.settings_language.tr(),
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                RadioGroup<String>(
                  groupValue: currentCode,
                  onChanged: (value) => _changeLanguage(context, value!),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: AppLanguages.supported.map((lang) {
                      return RadioListTile<String>(
                        value: lang.code,
                        title: Text(lang.name),
                        contentPadding: EdgeInsets.zero,
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
