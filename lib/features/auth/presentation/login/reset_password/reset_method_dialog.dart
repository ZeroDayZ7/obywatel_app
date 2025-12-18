import 'package:flutter/material.dart';

class ResetMethodDialog extends StatefulWidget {
  const ResetMethodDialog({super.key});

  @override
  State<ResetMethodDialog> createState() => _ResetMethodDialogState();
}

class _ResetMethodDialogState extends State<ResetMethodDialog> {
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  bool isEmail = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Reset hasła"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: true, label: Text("Email")),
              ButtonSegment(value: false, label: Text("SMS")),
            ],
            selected: {isEmail},
            onSelectionChanged: (v) => setState(() => isEmail = v.first),
          ),

          const SizedBox(height: 20),

          if (isEmail)
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: "Email"),
            )
          else
            TextField(
              controller: phoneCtrl,
              decoration: const InputDecoration(labelText: "Telefon"),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Anuluj"),
        ),
        ElevatedButton(
          onPressed: () {
            final result = isEmail ? emailCtrl.text : phoneCtrl.text;
            Navigator.pop(context, result);
          },
          child: const Text("Wyślij kod"),
        ),
      ],
    );
  }
}
