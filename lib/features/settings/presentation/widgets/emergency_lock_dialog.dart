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
        final screenWidth = MediaQuery.of(context).size.width;
        final dialogWidth = screenWidth > 500 ? 400.0 : screenWidth * 0.85;

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
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
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 24),
                ActionSlider.standard(
                  sliderBehavior: SliderBehavior.move,
                  width: dialogWidth,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest,
                  toggleColor: Colors.red,
                  actionThresholdType: ThresholdType.release,
                  icon: const Icon(Icons.lock_reset, color: Colors.white),
                  action: (controller) async {
                    controller.loading();
                    await Future.delayed(const Duration(seconds: 2));
                    await ref.read(securityServiceProvider.notifier).lockApp();

                    // Opcjonalnie tutaj można dodać nawigację do logowania,
                    // jeśli securityNotifier sam tego nie robi
                  },
                  child: Text(
                    LocaleKeys.settings_security_emergency_lock_slider.tr(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
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
              labelKey: LocaleKeys.common_cancel,
              variant: AppButtonVariant.text,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}
