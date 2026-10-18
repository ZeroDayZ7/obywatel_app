import 'package:flutter/material.dart';
import 'package:obywatel_plus/features/communication/presentation/screens/contacts_screen.dart';
import 'package:obywatel_plus/features/communication/presentation/screens/conversations_screen.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/communication/websocket_status_bar.dart';

class CommunicationTabView extends StatelessWidget {
  const CommunicationTabView({super.key, required this.initialIndex});

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
        body: SafeArea(
          child: Column(
            children: [
              const WebSocketStatusBar(),
              const Expanded(
                child: TabBarView(
                  children: [ConversationsScreen(), ContactsScreen()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
