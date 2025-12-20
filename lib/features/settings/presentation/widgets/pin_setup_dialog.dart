import 'package:flutter/material.dart';

class PinSetupDialog extends StatefulWidget {
  const PinSetupDialog({super.key});

  @override
  State<PinSetupDialog> createState() => _PinSetupDialogState();
}

class _PinSetupDialogState extends State<PinSetupDialog> {
  final _pinController = TextEditingController();
  final _confirmController = TextEditingController();
  String? _error;

  void _submit() {
    if (_pinController.text.length < 4) {
      setState(() => _error = 'PIN musi mieć minimum 4 cyfry');
      return;
    }
    if (_pinController.text != _confirmController.text) {
      setState(() => _error = 'PINy nie są zgodne');
      return;
    }
    Navigator.of(context).pop(_pinController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 400, // maksymalna szerokość dialogu
        ),
        child: AlertDialog(
          title: const Text('Ustaw PIN'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _pinController,
                keyboardType: TextInputType.number,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'PIN'),
              ),
              TextField(
                controller: _confirmController,
                keyboardType: TextInputType.number,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Potwierdź PIN'),
              ),
              if (_error != null) ...[
                const SizedBox(height: 10),
                Text(_error!, style: const TextStyle(color: Colors.red)),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Anuluj'),
            ),
            ElevatedButton(onPressed: _submit, child: const Text('Zapisz')),
          ],
        ),
      ),
    );
  }
}
