import 'package:flutter/material.dart';

class CommunicationNavigationItemData {
  const CommunicationNavigationItemData({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

const communicationNavigationItems = <CommunicationNavigationItemData>[
  CommunicationNavigationItemData(
    label: 'Wiadomości',
    icon: Icons.chat_bubble_outline_rounded,
    selectedIcon: Icons.chat_bubble_rounded,
  ),
  CommunicationNavigationItemData(
    label: 'Kontakty',
    icon: Icons.people_outline_rounded,
    selectedIcon: Icons.people_rounded,
  ),
  CommunicationNavigationItemData(
    label: 'Połączenia',
    icon: Icons.call_outlined,
    selectedIcon: Icons.call_rounded,
  ),
  CommunicationNavigationItemData(
    label: 'Grupy',
    icon: Icons.group_outlined,
    selectedIcon: Icons.group_rounded,
  ),
];

List<NavigationDestination> buildCommunicationNavigationDestinations() {
  return communicationNavigationItems
      .map(
        (item) => NavigationDestination(
          icon: Icon(item.icon),
          selectedIcon: Icon(item.selectedIcon),
          label: item.label,
        ),
      )
      .toList();
}

List<NavigationRailDestination> buildCommunicationRailDestinations() {
  return communicationNavigationItems
      .map(
        (item) => NavigationRailDestination(
          icon: Icon(item.icon),
          selectedIcon: Icon(item.selectedIcon),
          label: Text(item.label),
        ),
      )
      .toList();
}

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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isCompact = width < 720;
        final useDesktopRail = width >= 1100;
        final useMediumRail = width >= 720 && width < 1100;

        if (isCompact) {
          return NavigationBar(
            selectedIndex: selectedIndex,
            onDestinationSelected: onSelected,
            destinations: buildCommunicationNavigationDestinations(),
          );
        }

        final railEnabled = useDesktopRail || useMediumRail;
        if (!railEnabled) {
          return const SizedBox.shrink();
        }

        final isRailExtended = useDesktopRail && isExpanded;
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
              leading: onToggleExpanded != null
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
              destinations: buildCommunicationRailDestinations(),
            ),
          ),
        );
      },
    );
  }
}
