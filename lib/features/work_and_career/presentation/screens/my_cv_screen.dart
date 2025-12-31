import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/errors/app_notification.dart';
import 'package:obywatel_plus/core/errors/global_error_provider.dart';
import 'package:obywatel_plus/core/notifications/feedback_service.dart';
import 'package:obywatel_plus/core/notifications/feedback_type.dart';

class MyCVScreen extends ConsumerWidget {
  const MyCVScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback & Notification Test'),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.vibration, size: 64, color: Colors.blueGrey),
            const SizedBox(height: 32),

            // 1. TEST SUKCESU - Usuwamy 'const' sprzed AppNotification
            _TestButton(
              label: 'Test Success',
              color: Colors.green,
              icon: Icons.check_circle,
              onPressed: () {
                ref
                    .read(globalNotificationProvider.notifier)
                    .show(
                      // USUNIĘTO 'const'
                      AppNotification(
                        messageKey: 'Zapytanie wysłane pomyślnie!',
                        type: NotificationType.success,
                      ),
                    );
              },
            ),

            const SizedBox(height: 16),

            // 2. TEST BŁĘDU
            _TestButton(
              label: 'Test Error',
              color: Colors.red,
              icon: Icons.error,
              onPressed: () {
                ref
                    .read(globalNotificationProvider.notifier)
                    .show(
                      // USUNIĘTO 'const'
                      AppNotification(
                        messageKey: 'Błąd połączenia z serwerem',
                        type: NotificationType.error,
                      ),
                    );
              },
            ),

            const SizedBox(height: 16),

            // 3. TEST WARNING
            _TestButton(
              label: 'Test Warning',
              color: Colors.orange,
              icon: Icons.warning,
              onPressed: () {
                ref
                    .read(globalNotificationProvider.notifier)
                    .show(
                      // USUNIĘTO 'const'
                      AppNotification(
                        messageKey: 'Twoja sesja wkrótce wygaśnie',
                        type: NotificationType.warning,
                      ),
                    );
              },
            ),

            const Divider(height: 64),

            TextButton.icon(
              onPressed: () => ref
                  .read(feedbackServiceProvider)
                  .trigger(FeedbackType.securityAlert),
              icon: const Icon(Icons.security, color: Colors.red),
              label: const Text('Direct Security Haptic (No UI)'),
            ),
          ],
        ),
      ),
    );
  }
}

class _TestButton extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback onPressed;

  const _TestButton({
    required this.label,
    required this.color,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
