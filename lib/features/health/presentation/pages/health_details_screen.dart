import 'package:flutter/material.dart';

class HealthDetailsScreen extends StatelessWidget {
  final String type;

  const HealthDetailsScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final title = _getTitle();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF1E1E2E),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.hourglass_empty, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Brak danych dla: $title',
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              'Moduł w trakcie wdrażania.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  String _getTitle() {
    switch (type) {
      case 'prescriptions':
        return 'E-recepty';
      case 'referrals':
        return 'Skierowania';
      case 'history':
        return 'Historia leczenia';
      case 'vaccinations':
        return 'Szczepienia';
      case 'insurance':
        return 'Ubezpieczenie';
      default:
        return 'Szczegóły zdrowia';
    }
  }
}
