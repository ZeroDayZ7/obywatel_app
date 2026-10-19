import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/features/communication/presentation/providers/conversations_provider.dart';
import 'package:obywatel_plus/features/communication/presentation/screens/contacts_screen.dart';
import 'package:obywatel_plus/features/communication/presentation/screens/conversations_screen.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/communication/websocket_status_bar.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/contacts_screen/add_contact_modal.dart';

class CommunicationNavigationShell extends StatelessWidget {
  const CommunicationNavigationShell({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
    this.isExpanded = true,
    this.onToggleExpanded,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final bool isExpanded;
  final VoidCallback? onToggleExpanded;

  static const _sectionLabels = [
    'Wiadomości',
    'Kontakty',
    'Połączenia',
    'Grupy',
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isCompact = width < 720;
        final useDesktopRail = width >= 1100;
        final useMediumRail = width >= 720 && width < 1100;

        final destinations = [
          NavigationDestination(
            icon: const Icon(Icons.chat_bubble_outline_rounded),
            selectedIcon: const Icon(Icons.chat_bubble_rounded),
            label: _sectionLabels[0],
          ),
          NavigationDestination(
            icon: const Icon(Icons.people_outline_rounded),
            selectedIcon: const Icon(Icons.people_rounded),
            label: _sectionLabels[1],
          ),
          NavigationDestination(
            icon: const Icon(Icons.call_outlined),
            selectedIcon: const Icon(Icons.call_rounded),
            label: _sectionLabels[2],
          ),
          NavigationDestination(
            icon: const Icon(Icons.group_outlined),
            selectedIcon: const Icon(Icons.group_rounded),
            label: _sectionLabels[3],
          ),
        ];

        if (isCompact) {
          return NavigationBar(
            selectedIndex: selectedIndex,
            onDestinationSelected: onSelected,
            destinations: destinations,
          );
        }

        final railEnabled = useDesktopRail || useMediumRail;
        if (!railEnabled) {
          return const SizedBox.shrink();
        }

        final isRailExtended = useDesktopRail && isExpanded;
        final showToggle = onToggleExpanded != null;
        final railLabelType = isRailExtended
            ? null
            : NavigationRailLabelType.none;

        return Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 12, right: 8),
            child: NavigationRail(
              selectedIndex: selectedIndex,
              onDestinationSelected: onSelected,
              labelType: railLabelType,
              minWidth: useDesktopRail ? 88 : 72,
              minExtendedWidth: useDesktopRail ? 180 : 88,
              extended: isRailExtended,
              leading: showToggle
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        tooltip: isExpanded
                            ? 'Zwiń panel nawigacji'
                            : 'Rozwiń panel nawigacji',
                        onPressed: onToggleExpanded,
                        icon: Icon(
                          isExpanded
                              ? Icons.chevron_left_rounded
                              : Icons.chevron_right_rounded,
                        ),
                        splashRadius: 20,
                      ),
                    )
                  : null,
              destinations: destinations
                  .map(
                    (destination) => NavigationRailDestination(
                      icon: destination.icon,
                      selectedIcon: destination.selectedIcon,
                      label: Text(destination.label),
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}

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

  static const _sectionLabels = [
    'Wiadomości',
    'Kontakty',
    'Połączenia',
    'Grupy',
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex.clamp(0, _sectionLabels.length - 1);
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
      const _GroupsSection(),
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

class _GroupsSection extends ConsumerWidget {
  const _GroupsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(conversationsProvider);

    return state.when(
      data: (conversations) {
        final groups = conversations
            .where((conversation) => conversation.type == 'group')
            .toList();

        if (groups.isEmpty) {
          return const _GroupEmptyState();
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: groups.length,
          itemBuilder: (context, index) {
            final conversation = groups[index];
            final title = (conversation.title ?? '').trim();
            final safeTitle = title.isNotEmpty
                ? title
                : conversation.id.trim().isNotEmpty
                ? 'Grupa ${conversation.id.trim().substring(0, conversation.id.trim().length > 4 ? 4 : conversation.id.trim().length)}'
                : 'Grupa';
            final memberCount = conversation.members.length;

            return Card(
              child: ListTile(
                enabled: false,
                leading: CircleAvatar(
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primaryContainer,
                  child: Icon(
                    Icons.group_rounded,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                title: Text(safeTitle),
                subtitle: Text(
                  memberCount > 0
                      ? '$memberCount uczestników'
                      : 'Brak uczestników',
                ),
                trailing: const Icon(Icons.info_outline_rounded),
              ),
            );
          },
          separatorBuilder: (_, _) => const SizedBox(height: 8),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text('Nie udało się pobrać grup: $error'),
        ),
      ),
    );
  }
}

class _GroupEmptyState extends StatelessWidget {
  const _GroupEmptyState();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.group_work_rounded,
              size: 56,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Brak dostępnych grup',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Obecna integracja backendowa nie udostępnia jeszcze obsługi grup.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Funkcja będzie dostępna po uruchomieniu pełnej obsługi backendu.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
