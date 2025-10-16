import 'package:flutter/material.dart';

class SplashStatus extends StatelessWidget {
  final bool isLoading;
  final bool isError;
  final VoidCallback? onRetry;

  const SplashStatus({
    super.key,
    required this.isLoading,
    required this.isError,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Column(
        children: const [
          SizedBox(height: 30),
          CircularProgressIndicator(color: Colors.white),
          SizedBox(height: 10),
          Text(
            'Łączenie z backendem...',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      );
    } else if (isError) {
      return Column(
        children: [
          const SizedBox(height: 30),
          const Text(
            'Nie udało się połączyć z backendem',
            style: TextStyle(color: Colors.redAccent),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Spróbuj ponownie'),
          ),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
