import 'package:flutter/material.dart';

class HealthDetailsScreen extends StatelessWidget {
  final String type;

  const HealthDetailsScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final title = _getTitle();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.hourglass_empty, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text('Brak danych dla: $title', style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          const Text('Moduł w trakcie wdrażania.'),
        ],
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
      default:
        return 'Szczegóły zdrowia';
    }
  }
}
