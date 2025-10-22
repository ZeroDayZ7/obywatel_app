import 'package:flutter/material.dart';

class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Documents')),
      body: const Center(
        child: Text(
          'Documents Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
