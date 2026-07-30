import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MyQrCodeDialog extends StatelessWidget {
  const MyQrCodeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    // TUTAJ podmień na zmienną pobieraną z profilu użytkownika (np. AuthState/User.id)
    const String myUserId = '707a8869-6867-4601-9337-e23fcb51b0ad';

    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Twój Kod QR', textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Pokaż ten kod drugiej osobie, aby mogła Cię dodać do kontaktów.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: QrImageView(
              data: myUserId,
              version: QrVersions.auto,
              size: 200.0,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Zamknij'),
        ),
      ],
    );
  }
}
