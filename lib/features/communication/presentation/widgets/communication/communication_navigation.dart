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
          final colorScheme = Theme.of(context).colorScheme;

          return SafeArea(
            top: false,
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.8),
                  ),
                ),
              ),
              padding: const EdgeInsets.only(top: 8, bottom: 4),
              child: Row(
                children: List.generate(
                  communicationNavigationItems.length,
                  (index) {
                    final item = communicationNavigationItems[index];
                    final isSelected = selectedIndex == index;
                    final iconColor = isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant.withValues(alpha: 0.72);
                    final labelColor = isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant.withValues(alpha: 0.7);

                    return Expanded(
                      child: Semantics(
                        selected: isSelected,
                        button: true,
                        label: item.label,
                        child: InkWell(
                          onTap: () => onSelected(index),
                          borderRadius: BorderRadius.circular(14),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 4,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  curve: Curves.easeOutCubic,
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? colorScheme.primary.withValues(
                                            alpha: 0.12,
                                          )
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected
                                          ? colorScheme.primary.withValues(
                                              alpha: 0.18,
                                            )
                                          : Colors.transparent,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Icon(
                                    isSelected
                                        ? item.selectedIcon
                                        : item.icon,
                                    color: iconColor,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.label,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: labelColor,
                                    letterSpacing: 0.1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
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

        final railSurface = Theme.of(context).colorScheme.surface;
        final railForeground = Theme.of(context).colorScheme.onSurfaceVariant;

        return Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 12, right: 8),
            child: NavigationRail(
              backgroundColor: railSurface,
              indicatorColor: Colors.transparent,
              selectedIconTheme: IconThemeData(
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              unselectedIconTheme: IconThemeData(
                color: railForeground.withValues(alpha: 0.72),
                size: 22,
              ),
              selectedLabelTextStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
              unselectedLabelTextStyle: TextStyle(
                color: railForeground.withValues(alpha: 0.7),
                fontWeight: FontWeight.w500,
              ),
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
