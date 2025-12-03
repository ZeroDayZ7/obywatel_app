// /modules/work_and_career/screens/work_and_career_home.dart
import 'package:flutter/material.dart';

class WorkAndCareerHome extends StatelessWidget {
  const WorkAndCareerHome({super.key});

  @override
  Widget build(BuildContext context) {
    // przykładowe podmoduły
    final sections = [
      {'title': 'Oferty pracy', 'icon': Icons.work},
      {'title': 'Moje CV', 'icon': Icons.person},
      {'title': 'Aplikacje', 'icon': Icons.send},
      {'title': 'Doradztwo zawodowe', 'icon': Icons.school},
      {'title': 'Staże i praktyki', 'icon': Icons.school_outlined},
      {'title': 'Wsparcie państwowe', 'icon': Icons.handshake},
      {'title': 'Mapa zatrudnienia', 'icon': Icons.map},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Praca i Kariera'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: sections.length,
          itemBuilder: (context, index) {
            final section = sections[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: Icon(section['icon'] as IconData),
                title: Text(section['title'] as String),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // ignore_for_file: todo
                  // TODO: na razie pokaz snackbar, później nawigacja
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Przejście do: ${section['title']}'),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
