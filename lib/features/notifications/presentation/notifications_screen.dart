import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = List.generate(
      5,
      (index) => NotificationItem(
        title: 'Powiadomienie ${index + 1}',
        description:
            'To jest przykładowy opis powiadomienia numer ${index + 1}.',
        timeAgo: '${index + 1}h temu',
        isNew: index % 2 == 0,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Powiadomienia'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.mark_email_read),
            tooltip: 'Oznacz wszystkie jako przeczytane',
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[900],
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Nowe powiadomienia',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final item = notifications[index];
                  return NotificationCard(item: item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationItem {
  final String title;
  final String description;
  final String timeAgo;
  final bool isNew;

  NotificationItem({
    required this.title,
    required this.description,
    required this.timeAgo,
    this.isNew = false,
  });
}

class NotificationCard extends StatelessWidget {
  final NotificationItem item;
  const NotificationCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: item.isNew ? Colors.deepPurple[600] : Colors.grey[850],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: ListTile(
        leading: Stack(
          alignment: Alignment.topRight,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.deepPurple[300],
              child: const Icon(Icons.notifications, color: Colors.white),
            ),
            if (item.isNew)
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
              ),
          ],
        ),
        title: Text(
          item.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          item.description,
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: Text(
          item.timeAgo,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
        onTap: () {
          // tu będzie logika np. otwarcia szczegółów powiadomienia
        },
      ),
    );
  }
}
