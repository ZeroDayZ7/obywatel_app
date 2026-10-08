import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/widgets/main/app_scaffold.dart';
import 'package:obywatel_plus/features/home/application/quick_access_notifier.dart';
import 'package:obywatel_plus/features/home/domain/models/quick_access_item.dart';
import 'package:obywatel_plus/features/home/presentation/widgets/home_app_bar.dart';
import 'package:obywatel_plus/features/home/presentation/widgets/main_drawer.dart';

class QuickAccessScreen extends ConsumerStatefulWidget {
  const QuickAccessScreen({super.key});

  @override
  ConsumerState<QuickAccessScreen> createState() => _QuickAccessScreenState();
}

class _QuickAccessScreenState extends ConsumerState<QuickAccessScreen> {
  bool _editMode = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final items = ref.watch(quickAccessProvider);
    final visibleItems = _editMode
        ? items
        : items.where((item) => item.isEnabled).toList();

    return AppScaffold(
      appBar: const HomeAppBar(),
      drawer: const MainDrawer(),
      size: ContainerSize.medium,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compactMode = constraints.maxWidth < 620;

          final columns = compactMode
              ? [
                  for (final item in visibleItems)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _QuickAccessWallTile(
                        item: item,
                        editMode: _editMode,
                        onToggleEnabled: () => ref
                            .read(quickAccessProvider.notifier)
                            .toggleEnabled(item.id),
                        onMoveUp: () {
                          final currentIndex = items.indexWhere(
                            (entry) => entry.id == item.id,
                          );
                          if (currentIndex <= 0) return;
                          ref
                              .read(quickAccessProvider.notifier)
                              .reorder(item.id, currentIndex - 1);
                        },
                        onMoveDown: () {
                          final currentIndex = items.indexWhere(
                            (entry) => entry.id == item.id,
                          );
                          if (currentIndex == -1 ||
                              currentIndex >= items.length - 1) {
                            return;
                          }
                          ref
                              .read(quickAccessProvider.notifier)
                              .reorder(item.id, currentIndex + 1);
                        },
                        onRename: () => _showRenameDialog(context, item),
                      ),
                    ),
                ]
              : [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final item in visibleItems.where((item) =>
                          visibleItems.indexOf(item) % 2 == 0))
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _QuickAccessWallTile(
                            item: item,
                            editMode: _editMode,
                            onToggleEnabled: () => ref
                                .read(quickAccessProvider.notifier)
                                .toggleEnabled(item.id),
                            onMoveUp: () {
                              final currentIndex = items.indexWhere(
                                (entry) => entry.id == item.id,
                              );
                              if (currentIndex <= 0) return;
                              ref
                                  .read(quickAccessProvider.notifier)
                                  .reorder(item.id, currentIndex - 1);
                            },
                            onMoveDown: () {
                              final currentIndex = items.indexWhere(
                                (entry) => entry.id == item.id,
                              );
                              if (currentIndex == -1 ||
                                  currentIndex >= items.length - 1) {
                                return;
                              }
                              ref
                                  .read(quickAccessProvider.notifier)
                                  .reorder(item.id, currentIndex + 1);
                            },
                            onRename: () => _showRenameDialog(context, item),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 18),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      for (final item in visibleItems.where((item) =>
                          visibleItems.indexOf(item) % 2 == 1))
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _QuickAccessWallTile(
                            item: item,
                            editMode: _editMode,
                            onToggleEnabled: () => ref
                                .read(quickAccessProvider.notifier)
                                .toggleEnabled(item.id),
                            onMoveUp: () {
                              final currentIndex = items.indexWhere(
                                (entry) => entry.id == item.id,
                              );
                              if (currentIndex <= 0) return;
                              ref
                                  .read(quickAccessProvider.notifier)
                                  .reorder(item.id, currentIndex - 1);
                            },
                            onMoveDown: () {
                              final currentIndex = items.indexWhere(
                                (entry) => entry.id == item.id,
                              );
                              if (currentIndex == -1 ||
                                  currentIndex >= items.length - 1) {
                                return;
                              }
                              ref
                                  .read(quickAccessProvider.notifier)
                                  .reorder(item.id, currentIndex + 1);
                            },
                            onRename: () => _showRenameDialog(context, item),
                          ),
                        ),
                    ],
                  ),
                ];

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1040),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.bolt_rounded,
                            color: colorScheme.primary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Szybki dostęp',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        if (_editMode)
                          TextButton.icon(
                            onPressed: () => ref
                                .read(quickAccessProvider.notifier)
                                .restoreDefaults(),
                            icon: const Icon(Icons.restore_rounded),
                            label: const Text('Domyślne'),
                          )
                        else
                          FilledButton.tonal(
                            onPressed: () => setState(() => _editMode = true),
                            child: const Text('Edytuj'),
                          ),
                        if (_editMode) ...[
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: () => setState(() => _editMode = false),
                            child: const Text('Zapisz'),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 22),
                    if (visibleItems.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Text(
                          'Brak aktywnych elementów. Włącz dowolny moduł w trybie edycji.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      )
                    else if (compactMode)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: columns.cast<Widget>(),
                      )
                    else
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: columns,
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _showRenameDialog(BuildContext context, QuickAccessItem item) async {
    final controller = TextEditingController(text: item.title);

    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Zmień nazwę modułu'),
          content: TextField(
            controller: controller,
            autofocus: true,
            maxLength: 28,
            decoration: const InputDecoration(hintText: 'Nazwa modułu'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Anuluj'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(controller.text.trim()),
              child: const Text('Zapisz'),
            ),
          ],
        );
      },
    );

    if (result == null || result.isEmpty) return;

    await ref.read(quickAccessProvider.notifier).updateItem(
      item.id,
      title: result,
    );
  }
}

class _QuickAccessWallTile extends StatelessWidget {
  final QuickAccessItem item;
  final bool editMode;
  final VoidCallback onToggleEnabled;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;
  final VoidCallback onRename;

  const _QuickAccessWallTile({
    required this.item,
    required this.editMode,
    required this.onToggleEnabled,
    required this.onMoveUp,
    required this.onMoveDown,
    required this.onRename,
  });

  Color _resolveAccentColor(ColorScheme colorScheme) {
    return switch (item.accent) {
      QuickAccessAccent.primary => colorScheme.primary,
      QuickAccessAccent.secondary => colorScheme.secondary,
      QuickAccessAccent.tertiary => colorScheme.tertiary,
      QuickAccessAccent.error => colorScheme.error,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final accentColor = _resolveAccentColor(colorScheme);
    final enabled = item.isEnabled;

    return Transform.translate(
      offset: Offset(item.visualOffsetX.toDouble(), item.visualOffsetY.toDouble()),
      child: AnimatedScale(
        scale: item.isEnabled ? 1 : 0.98,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          width: 320 * item.widthScale,
          constraints: const BoxConstraints(minHeight: 122),
          foregroundDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: enabled
                  ? colorScheme.surface
                  : colorScheme.surfaceContainerHighest.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: accentColor.withValues(alpha: enabled ? 0.22 : 0.12),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withValues(alpha: enabled ? 0.14 : 0.06),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.08),
                  blurRadius: 18,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: enabled ? () => context.push(item.route) : null,
                splashColor: accentColor.withValues(alpha: 0.12),
                highlightColor: accentColor.withValues(alpha: 0.08),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: accentColor.withValues(alpha: 0.22),
                            width: 1,
                          ),
                        ),
                        child: Icon(item.iconData, color: accentColor, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              item.title,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: enabled
                                    ? colorScheme.onSurface
                                    : colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            if (item.subtitle.isNotEmpty)
                              Text(
                                item.subtitle,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: enabled
                                      ? colorScheme.onSurface.withValues(alpha: 0.72)
                                      : colorScheme.onSurfaceVariant,
                                  height: 1.3,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                      if (editMode) ...[
                        const SizedBox(width: 8),
                        Column(
                          children: [
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              onPressed: onToggleEnabled,
                              icon: Icon(
                                enabled ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                              ),
                              tooltip: enabled ? 'Ukryj' : 'Pokaż',
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  visualDensity: VisualDensity.compact,
                                  onPressed: onMoveUp,
                                  icon: const Icon(Icons.arrow_upward_rounded),
                                  tooltip: 'Wyżej',
                                ),
                                IconButton(
                                  visualDensity: VisualDensity.compact,
                                  onPressed: onMoveDown,
                                  icon: const Icon(Icons.arrow_downward_rounded),
                                  tooltip: 'Niżej',
                                ),
                              ],
                            ),
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              onPressed: onRename,
                              icon: const Icon(Icons.edit_rounded),
                              tooltip: 'Zmień nazwę',
                            ),
                          ],
                        ),
                      ] else
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            size: 18,
                            color: colorScheme.onSurface.withValues(alpha: 0.42),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

