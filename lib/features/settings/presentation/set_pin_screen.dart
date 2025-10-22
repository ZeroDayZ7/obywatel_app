import 'package:flutter/material.dart';

class SetPinScreen extends StatelessWidget {
  const SetPinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Set PIN')),
      body: const Center(
        child: Text('Set your PIN here', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
