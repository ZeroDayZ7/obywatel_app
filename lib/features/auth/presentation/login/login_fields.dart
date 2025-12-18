import 'package:flutter/material.dart';

class LoginEmailField extends StatelessWidget {
  const LoginEmailField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(decoration: const InputDecoration(labelText: 'Email'));
  }
}

class LoginPasswordField extends StatelessWidget {
  const LoginPasswordField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: true,
      decoration: const InputDecoration(labelText: 'Password'),
    );
  }
}
