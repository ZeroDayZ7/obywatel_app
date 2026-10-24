import 'package:action_slider/action_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/design/widgets/ui/button.dart';
import 'package:obywatel_plus/core/security/security/security_service_provider.dart';

abstract class EmergencyLockDialog {
  static void show(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        final screenWidth = MediaQuery.sizeOf(context).width;
        final dialogWidth = screenWidth > 588 ? 400.0 : screenWidth * 0.68;
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return AlertDialog(
          scrollable: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: colorScheme.error,
                size: 28,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  LocaleKeys.settings_security_emergency_lock.tr(),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: dialogWidth,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  LocaleKeys.settings_security_emergency_lock_description.tr(),
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                ActionSlider.standard(
                  sliderBehavior: SliderBehavior.move,
                  width: dialogWidth,
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  toggleColor: colorScheme.error,
                  actionThresholdType: ThresholdType.release,
                  icon: Icon(Icons.lock_reset, color: colorScheme.onError),
                  action: (controller) async {
                    controller.loading();
                    await Future.delayed(const Duration(seconds: 2));
                    await ref.read(securityServiceProvider.notifier).lockApp();

                    // Opcjonalnie tutaj można dodać nawigację do logowania,
                    // jeśli securityNotifier sam tego nie robi
                  },
                  child: Text(
                    LocaleKeys.settings_security_emergency_lock_slider.tr(),
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colorScheme.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            AppButton(
              label: LocaleKeys.common_cancel.tr(),
              variant: AppButtonVariant.text,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}
