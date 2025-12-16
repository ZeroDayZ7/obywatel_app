import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/config/services_config.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:obywatel_plus/app/config/env.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';

class ForceUpdateScreen extends StatelessWidget {
  const ForceUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.system_update_alt,
                size: 96,
                color: Colors.orangeAccent,
              ),
              const SizedBox(height: 32),
              Text(
                LocaleKeys.force_update_screen_title.tr(),
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                tr(
                  LocaleKeys.force_update_screen_description,
                  args: [apiConstants.appName],
                ),
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              FilledButton.icon(
                icon: const Icon(Icons.open_in_new),
                label: Text(LocaleKeys.force_update_screen_update_button.tr()),
                onPressed: _openStore,
              ),
              const SizedBox(height: 12),
              Text(
                LocaleKeys.force_update_screen_mandatory_info.tr(),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openStore() async {
    final url = Uri.parse(ServicesConfig.playStoreUrl);

    await launchUrl(url, mode: LaunchMode.externalApplication);
  }
}
