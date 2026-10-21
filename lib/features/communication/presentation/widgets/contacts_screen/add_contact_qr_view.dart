import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AddContactQrView extends StatelessWidget {
  const AddContactQrView({
    super.key,
    required this.myUserId,
    required this.onCopy,
  });

  final String myUserId;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Zeskanuj ten kod na drugim urządzeniu, aby szybko nawiązać kontakt.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 20),
        if (myUserId.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: CircularProgressIndicator(color: colorScheme.primary),
            ),
          )
        else ...[
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: QrImageView(
                data: myUserId,
                version: QrVersions.auto,
                size: 190,
                eyeStyle: QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: colorScheme.onSurface,
                ),
                dataModuleStyle: QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: FilledButton.tonalIcon(
              onPressed: onCopy,
              icon: const Icon(Icons.copy_rounded, size: 18),
              label: const Text('Kopiuj moje ID'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
