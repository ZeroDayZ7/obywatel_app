import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/features/communication/presentation/screens/contacts_screen.dart';
import 'package:obywatel_plus/features/communication/presentation/screens/conversations_screen.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/communication/communication_groups_section.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/communication/communication_navigation.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/communication/websocket_status_bar.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/contacts_screen/add_contact_modal.dart';

export 'communication_navigation.dart';

class CommunicationTabView extends ConsumerStatefulWidget {
  const CommunicationTabView({super.key, required this.initialIndex});

  final int initialIndex;

  @override
  ConsumerState<CommunicationTabView> createState() =>
      _CommunicationTabViewState();
}

class _CommunicationTabViewState extends ConsumerState<CommunicationTabView> {
  late int _selectedIndex;
  bool _isRailExpanded = true;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex.clamp(
      0,
      communicationNavigationItems.length - 1,
    );
  }

  void _toggleRailExpanded() {
    if (!mounted) return;
    setState(() {
      _isRailExpanded = !_isRailExpanded;
    });
  }

  void _handleBack() {
    if (context.canPop()) {
      context.pop();
      return;
    }

    context.go(AppRoutes.home);
  }

  void _handleAction() {
    switch (_selectedIndex) {
      case 1:
        showDialog(context: context, builder: (_) => const AddContactModal());
        break;
      case 2:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Historia połączeń będzie dostępna po aktywacji funkcji backendowej.',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
        break;
      case 3:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Tworzenie grup jest obecnie niedostępne w istniejącym backendzie.',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Rozpoczęcie nowej rozmowy nie jest dostępne w obecnym przepływie.',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
        break;
    }
  }

  Widget _buildFeaturePlaceholder({
    required IconData icon,
    required String title,
    required String description,
    String? actionLabel,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                description,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
              if (actionLabel != null) ...[
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: _handleAction,
                  icon: const Icon(Icons.add_rounded),
                  label: Text(actionLabel),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < 720;

    final sectionContent = [
      const ConversationsScreen(),
      const ContactsScreen(),
      _buildFeaturePlaceholder(
        icon: Icons.call_rounded,
        title: 'Połączenia',
        description:
            'Historia połączeń i statusy rozmów zostaną dodane wraz z dostępnością funkcji backendowej.',
        actionLabel: 'Sprawdź dostępność',
      ),
      const GroupsSection(),
    ];

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Komunikacja'),
        centerTitle: false,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          tooltip: 'Wróć do głównego ekranu',
          onPressed: _handleBack,
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        actions: [
          if (!isCompact && _selectedIndex == 1)
            IconButton(
              tooltip: 'Dodaj kontakt',
              onPressed: _handleAction,
              icon: const Icon(Icons.person_add_rounded),
            ),
        ],
      ),
      floatingActionButton: isCompact && _selectedIndex == 1
          ? FloatingActionButton.extended(
              onPressed: _handleAction,
              icon: const Icon(Icons.person_add_rounded),
              label: const Text('Dodaj kontakt'),
              heroTag: null,
            )
          : null,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isCompact) ...[
              Align(
                alignment: Alignment.topLeft,
                child: CommunicationNavigationShell(
                  selectedIndex: _selectedIndex,
                  isExpanded: _isRailExpanded,
                  onToggleExpanded: _toggleRailExpanded,
                  onSelected: (index) => setState(() => _selectedIndex = index),
                ),
              ),
              const VerticalDivider(width: 1),
            ],
            Expanded(
              child: Column(
                children: [
                  const WebSocketStatusBar(),
                  Expanded(
                    child: IndexedStack(
                      index: _selectedIndex,
                      children: sectionContent,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: isCompact
          ? CommunicationNavigationShell(
              selectedIndex: _selectedIndex,
              isExpanded: true,
              onSelected: (index) => setState(() => _selectedIndex = index),
            )
          : null,
    );
  }
}
