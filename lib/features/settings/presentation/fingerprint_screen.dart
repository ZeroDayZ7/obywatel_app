import 'package:flutter/material.dart';

class FingerprintScreen extends StatelessWidget {
  const FingerprintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fingerprint')),
      body: const Center(
        child: Text('Scan your fingerprint', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
