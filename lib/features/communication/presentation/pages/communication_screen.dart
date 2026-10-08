import 'package:flutter/material.dart';
import 'package:obywatel_plus/features/communication/presentation/pages/contacts_screen.dart';
import 'package:obywatel_plus/features/communication/presentation/pages/conversations_screen.dart';

class CommunicationScreen extends StatelessWidget {
  const CommunicationScreen({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: initialIndex,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Komunikacja'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Wiadomości'),
              Tab(text: 'Kontakty'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ConversationsScreen(),
            ContactsScreen(),
          ],
        ),
      ),
    );
  }
}
