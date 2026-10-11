import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/theme/theme_extensions.dart';

class PinVerificationDialog extends StatefulWidget {
  const PinVerificationDialog({super.key});

  static Future<bool> show(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const PinVerificationDialog(),
    );
    return result ?? false;
  }

  @override
  State<PinVerificationDialog> createState() => _PinVerificationDialogState();
}

class _PinVerificationDialogState extends State<PinVerificationDialog> {
  late final TextEditingController _pinController;

  @override
  void initState() {
    super.initState();
    _pinController = TextEditingController();
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  void _submit() {
    final colorScheme = context.colorScheme;

    if (_pinController.text == '1234') {
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Niepoprawny PIN'),
          backgroundColor: colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Weryfikacja dostępu', textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Wprowadź kod PIN, aby wyświetlić dane wrażliwe.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _pinController,
            obscureText: true,
            keyboardType: TextInputType.number,
            maxLength: 4,
            textAlign: TextAlign.center,
            autofocus: true,
            onSubmitted: (_) => _submit(),
            style: const TextStyle(fontSize: 24, letterSpacing: 16),
            decoration: InputDecoration(
              counterText: '',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colorScheme.outlineVariant),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colorScheme.primary),
              ),
              filled: true,
            ),
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Anuluj'),
        ),
        ElevatedButton(onPressed: _submit, child: const Text('Zatwierdź')),
      ],
    );
  }
}
