import 'package:flutter/material.dart';

class EnterResetCodeDialog extends StatefulWidget {
  const EnterResetCodeDialog({super.key});

  @override
  State<EnterResetCodeDialog> createState() => _EnterResetCodeDialogState();
}

class _EnterResetCodeDialogState extends State<EnterResetCodeDialog> {
  final ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Wprowadź kod"),
      content: TextField(
        controller: ctrl,
        maxLength: 6,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 28, letterSpacing: 6),
        decoration: const InputDecoration(counterText: ""),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Anuluj"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, ctrl.text),
          child: const Text("Potwierdź"),
        ),
      ],
    );
  }
}
