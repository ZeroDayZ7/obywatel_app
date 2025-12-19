import 'package:flutter/material.dart';

class SecurityVerificationScreen extends StatelessWidget {
  const SecurityVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          '🔐 Security Verification Screen',
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
