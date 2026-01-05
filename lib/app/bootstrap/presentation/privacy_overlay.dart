import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:secure_application/secure_application.dart';

class PrivacyOverlay extends StatelessWidget {
  final SecureApplicationController controller;

  const PrivacyOverlay({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(
        context,
      ).scaffoldBackgroundColor.withValues(alpha: 0.9),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo.png', width: 96, height: 96),
                const SizedBox(height: 32),
                Text(
                  LocaleKeys.system_privacy_title.tr(),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  LocaleKeys.system_privacy_description.tr(),
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
