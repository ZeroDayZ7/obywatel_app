// lib/features/work_and_career/presentation/screens/my_cv_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/notifications/feedback_service.dart';
import 'package:obywatel_plus/core/notifications/feedback_type.dart';

class MyCVScreen extends ConsumerWidget {
  const MyCVScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Uzyskujemy dostęp do serwisu feedbacku
    final feedback = ref.read(feedbackServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My CV'),
        backgroundColor: Colors.blueGrey[900],
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'export') {
                feedback.trigger(FeedbackType.info);
              }
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
            const SizedBox(height: 16),
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
                feedback.trigger(FeedbackType.info);
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
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    title: Text('Job Title ${index + 1}'),
                    subtitle: Text('Company ${index + 1} | 2021-2023'),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        feedback.trigger(FeedbackType.info);
                      },
                    ),
                  ),
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                feedback.trigger(FeedbackType.info);
              },
              child: const Text('Add Experience'),
            ),

            const SizedBox(height: 32),

            // ----------------- Enterprise Actions (Testowanie) -----------------
            const Divider(),
            const Text(
              'Feedback Testing',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Przycisk krytyczny
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => feedback.trigger(FeedbackType.securityAlert),
                icon: const Icon(Icons.security, color: Colors.red),
                label: const Text('TRIGGER SECURITY ALERT'),
                style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      feedback.trigger(FeedbackType.success);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Saved Locally!')),
                      );
                    },
                    icon: const Icon(Icons.save),
                    label: const Text('Success'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      feedback.trigger(FeedbackType.error);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Sync Error!'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    },
                    icon: const Icon(Icons.cloud_upload),
                    label: const Text('Error'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade50,
                      foregroundColor: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
