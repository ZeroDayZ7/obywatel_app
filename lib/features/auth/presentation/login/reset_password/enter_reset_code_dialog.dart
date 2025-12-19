import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';

class EnterResetCodeDialog extends StatefulWidget {
  const EnterResetCodeDialog({super.key});

  @override
  State<EnterResetCodeDialog> createState() => _EnterResetCodeDialogState();
}

class _EnterResetCodeDialogState extends State<EnterResetCodeDialog> {
  final ctrl = TextEditingController();

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(LocaleKeys.common_enter_code.tr()),
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
          child: Text(LocaleKeys.common_cancel.tr()),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, ctrl.text),
          child: Text(LocaleKeys.common_confirm.tr()),
        ),
      ],
    );
  }
}
