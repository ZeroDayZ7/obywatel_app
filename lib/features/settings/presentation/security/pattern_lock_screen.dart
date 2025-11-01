import 'package:flutter/material.dart';

class PatternLockScreen extends StatelessWidget {
  const PatternLockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pattern Lock')),
      body: const Center(
        child: Text('Draw your pattern', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
