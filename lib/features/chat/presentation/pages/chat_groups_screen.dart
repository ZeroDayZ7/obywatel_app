import 'package:flutter/material.dart';

class ChatGroupsScreen extends StatelessWidget {
  const ChatGroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          color: theme.colorScheme.surface.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: theme.colorScheme.primary,
              child: Icon(Icons.group, color: theme.colorScheme.onSecondary),
            ),
            title: Text(
              'Cyber Squad ${index + 1}',
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text('Last message: Let\'s hack the main frame...'),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.secondary),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text('12 Active', style: TextStyle(fontSize: 10)),
            ),
          ),
        );
      },
    );
  }
}
