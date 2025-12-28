import 'package:flutter/material.dart';

class RetryView extends StatelessWidget {
  final VoidCallback onRetry;

  const RetryView({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: onRetry,
        child: const Text('Spróbuj ponownie'),
      ),
    );
  }
}
