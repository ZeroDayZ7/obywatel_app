import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/widgets/action_group.dart';
import 'package:obywatel_plus/core/design/widgets/action_tile.dart';
import 'package:obywatel_plus/core/design/widgets/main/app_scaffold.dart';
import 'package:obywatel_plus/core/errors/app_notification.dart';
import 'package:obywatel_plus/core/errors/global_notification_provider.dart';
import 'package:obywatel_plus/core/notifications/feedback_service.dart';
import 'package:obywatel_plus/core/notifications/feedback_type.dart';
import 'package:obywatel_plus/core/security/pin/presentation/pin_verification_screen.dart';

class TestScreen extends ConsumerWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScaffold(
      title: const Text('Feature Test Bed'),
      size: ContainerSize.medium,
      child: ListView(
        children: [
          // SEKCJA 1: POWIADOMIENIA GLOBALNE
          ActionGroup(
            title: 'Global Notifications',
            children: [
              ActionTile(
                icon: Icons.check_circle_outline,
                title: 'Trigger Success',
                onTap: () => _showNotify(
                  ref,
                  'Operacja zakończona sukcesem!',
                  NotificationType.success,
                ),
              ),
              ActionTile(
                icon: Icons.error_outline,
                title: 'Trigger Error',
                isDanger: true,
                onTap: () => _showNotify(
                  ref,
                  'Wystąpił krytyczny błąd systemu',
                  NotificationType.error,
                ),
              ),
              ActionTile(
                icon: Icons.warning_amber_rounded,
                title: 'Trigger Warning',
                onTap: () => _showNotify(
                  ref,
                  'Uwaga: Twoja sesja wygasa',
                  NotificationType.warning,
                ),
              ),
            ],
          ),

          // SEKCJA 2: HAPTYKA I FEEDBACK
          ActionGroup(
            title: 'Haptic Feedback (Vibrations)',
            children: [
              ActionTile(
                icon: Icons.vibration,
                title: 'Security Alert Haptic',
                onTap: () => ref
                    .read(feedbackServiceProvider)
                    .trigger(FeedbackType.securityAlert),
              ),
              ActionTile(
                icon: Icons.touch_app,
                title: 'Light Impact Feedback',
                onTap: () => ref
                    .read(feedbackServiceProvider)
                    .trigger(FeedbackType.light),
              ),
              ActionTile(
                icon: Icons.phonelink_erase,
                title: 'Error/Failure Pattern',
                onTap: () => ref
                    .read(feedbackServiceProvider)
                    .trigger(FeedbackType.error),
              ),
            ],
          ),

          // SEKCJA 3: UI COMPONENTS TEST
          ActionGroup(
            title: 'UI Component States',
            children: [
              const ActionTile(
                icon: Icons.block,
                title: 'Disabled Tile Example',
                isEnabled: false,
              ),
              ActionTile(
                icon: Icons.ads_click,
                title: 'Custom Action Item',
                onTap: () {
                  // Tu możesz dodać testowanie modalów, dialogów itp.
                },
              ),
            ],
          ),
          ActionGroup(
            title: 'Active Feature Sandboxes',
            children: [
              ActionTile(
                icon: Icons.lock_outline,
                title: 'Test Pin Verification Screen',
                onTap: () {
                  // Opcja 1: Jeśli masz zdefiniowany route w GoRouter
                  // context.push('/auth/pin-test');

                  // Opcja 2: Szybki "Full Screen" bez definiowania route (do testów)
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const PinVerificationScreen(),
                    ),
                  );
                },
              ),
              ActionTile(
                icon: Icons.style_outlined,
                title: 'Component Library / Design System',
                onTap: () {
                  // Tu możesz dodać kolejny ekran z samymi przyciskami, inputami itp.
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showNotify(WidgetRef ref, String msg, NotificationType type) {
    ref
        .read(globalNotificationProvider.notifier)
        .show(AppNotification(messageKey: msg, type: type));
  }
}
