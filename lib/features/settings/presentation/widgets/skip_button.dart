import 'package:flutter/material.dart';

class SkipButton extends StatelessWidget {
  final VoidCallback onSkip;

  const SkipButton({super.key, required this.onSkip});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onSkip,
      child: const Text('Pomiń', style: TextStyle(color: Colors.redAccent)),
    );
  }
}
