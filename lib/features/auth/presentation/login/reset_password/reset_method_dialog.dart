import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';

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
      title: Text(LocaleKeys.common_reset_password.tr()),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SegmentedButton<bool>(
            segments: [
              ButtonSegment(
                value: true,
                label: Text(LocaleKeys.common_email.tr()),
              ),
              ButtonSegment(
                value: false,
                label: Text(LocaleKeys.common_phone.tr()),
              ),
            ],
            selected: {isEmail},
            onSelectionChanged: (v) => setState(() => isEmail = v.first),
          ),

          const SizedBox(height: 20),

          if (isEmail)
            TextField(
              controller: emailCtrl,
              decoration: InputDecoration(
                labelText: LocaleKeys.common_email.tr(),
              ),
            )
          else
            TextField(
              controller: phoneCtrl,
              decoration: InputDecoration(
                labelText: LocaleKeys.common_phone.tr(),
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(LocaleKeys.common_cancel.tr()),
        ),
        ElevatedButton(
          onPressed: () {
            final result = isEmail ? emailCtrl.text : phoneCtrl.text;
            Navigator.pop(context, result);
          },
          child: Text(LocaleKeys.common_send_code.tr()),
        ),
      ],
    );
  }
}
