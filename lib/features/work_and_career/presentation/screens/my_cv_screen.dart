// lib/features/work_and_career/presentation/screens/my_cv_screen.dart
import 'package:flutter/material.dart';

class MyCVScreen extends StatelessWidget {
  const MyCVScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My CV'),
        backgroundColor: Colors.blueGrey[900],
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              // ignore: todo
              // TODO: podpiąć akcje np. save, sync, export
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'save_local',
                child: Text('Save Locally'),
              ),
              const PopupMenuItem(
                value: 'sync_server',
                child: Text('Sync with Server'),
              ),
              const PopupMenuItem(value: 'export', child: Text('Export CV')),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ----------------- Personal Info -----------------
            const Text(
              'Personal Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            // ----------------- Skills -----------------
            const Text(
              'Skills',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(
                3,
                (index) => Chip(
                  label: Text('Skill ${index + 1}'),
                  backgroundColor: Colors.blueGrey[100],
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // ignore: todo
                // TODO: add skill
              },
              child: const Text('Add Skill'),
            ),

            const SizedBox(height: 24),

            // ----------------- Experience -----------------
            const Text(
              'Experience',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 2,
              // ignore: todo
              // TODO: dynamic length
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    title: Text('Job Title ${index + 1}'),
                    subtitle: Text('Company ${index + 1} | 2021-2023'),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // ignore: todo
                        // TODO: edit experience
                      },
                    ),
                  ),
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                // ignore: todo
                // TODO: add experience
              },
              child: const Text('Add Experience'),
            ),

            const SizedBox(height: 24),

            // ----------------- Actions -----------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.save),
                  label: const Text('Save Locally'),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.cloud_upload),
                  label: const Text('Sync Server'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
