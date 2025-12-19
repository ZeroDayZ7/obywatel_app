import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final pass = TextEditingController();
  final repeat = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.common_reset_password.tr())),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: pass,
              decoration: InputDecoration(
                labelText: LocaleKeys.common_password.tr(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: repeat,
              decoration: InputDecoration(
                labelText: LocaleKeys.common_repeat_password.tr(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                if (pass.text == repeat.text) {
                  Navigator.pop(context, pass.text);
                }
              },
              child: Text(LocaleKeys.common_save_password.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
