import 'package:flutter/material.dart';
import 'package:obywatel_plus/features/communication/presentation/pages/contacts_screen.dart';
import 'package:obywatel_plus/features/communication/presentation/pages/conversations_screen.dart';

class CommunicationScreen extends StatelessWidget {
  const CommunicationScreen({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 2,
      initialIndex: initialIndex,
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          title: const Text('Komunikacja'),
          centerTitle: false,
          surfaceTintColor: Colors.transparent,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TabBar(
                  isScrollable: true,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 16),
                  tabAlignment: TabAlignment.start,
                  tabs: const [
                    Tab(text: 'Wiadomości'),
                    Tab(text: 'Kontakty'),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: const SafeArea(
          child: TabBarView(
            children: [
              ConversationsScreen(),
              ContactsScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
