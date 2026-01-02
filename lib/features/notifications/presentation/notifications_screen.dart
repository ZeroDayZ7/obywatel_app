import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/widgets/app_scaffold.dart';
import 'package:obywatel_plus/core/errors/app_notification.dart';
import 'package:obywatel_plus/core/errors/global_error_provider.dart';

import '../domain/notifications_controller.dart';
import 'widgets/notification_card.dart';
import 'widgets/notification_details_sheet.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final notificationsAsync = ref.watch(notificationsControllerProvider);

    return AppScaffold(
      title: Text(LocaleKeys.notifications_title.tr()),
      size: ContainerSize.medium,
      scrollable: false,
      padding: EdgeInsets.zero,
      actions: [
        // Oznacz wszystkie jako przeczytane
        IconButton(
          onPressed: () => ref
              .read(notificationsControllerProvider.notifier)
              .markAllAsRead(),
          icon: const Icon(Icons.done_all),
          tooltip: LocaleKeys.notifications_mark_all_read.tr(),
        ),
        // Ikona Kosza (prowadzi do usuniętych)
        IconButton(
          onPressed: () => context.push(
            '${AppRoutes.notifications}/${AppRoutes.notificationsTrash}',
          ),
          icon: const Icon(Icons.delete_sweep_outlined),
        ),
        // Przycisk testowy
        IconButton(
          onPressed: () => ref
              .read(notificationsControllerProvider.notifier)
              .addTestNotification(),
          icon: const Icon(Icons.add_alert),
        ),
      ],
      child: notificationsAsync.when(
        data: (notifications) => notifications.isEmpty
            ? Center(child: Text(LocaleKeys.notifications_empty.tr()))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Header(theme: theme),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      itemCount: notifications.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = notifications[index];

                        return Dismissible(
                          key: Key(item.id),
                          direction: DismissDirection.endToStart,
                          // --- POPRAWKA TUTAJ ---
                          confirmDismiss: (direction) async {
                            // 1. Najpierw wywołujemy logikę w kontrolerze (baza danych)
                            await ref
                                .read(notificationsControllerProvider.notifier)
                                .moveToTrash(item.id);

                            // 2. Pokazujemy SnackBar (opcjonalnie)
                            if (context.mounted) {
                              _showUndoSnackBar(context, ref, item.id);
                            }

                            // 3. Zwracamy true, aby pozwolić Flutterowi usunąć widget z drzewa
                            return true;
                          },
                          // onDismissed zostawiamy puste, bo logika jest wyżej w confirmDismiss
                          onDismissed: (_) {},
                          // -----------------------
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 24),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.error,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.delete_outline,
                              color: Colors.white,
                            ),
                          ),
                          child: NotificationCard(
                            item: item,
                            onTap: () => NotificationDetailsSheet.show(
                              context,
                              ref,
                              item,
                            ),
                            onDelete: () {
                              // Przy kliknięciu ikony kosza na karcie wywołujemy zwykłą metodę
                              _handleDelete(context, ref, item.id);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Błąd: $err')),
      ),
    );
  }
}

// NotificationsScreen

// 1. POPRAWIONA METODA USUWANIA (DLA PRZYCISKU NA KARCIE)
void _handleDelete(BuildContext context, WidgetRef ref, String id) {
  // Logika w bazie danych
  ref.read(notificationsControllerProvider.notifier).moveToTrash(id);

  // Używamy globalnego systemu zamiast zwykłego SnackBar!
  ref
      .read(globalNotificationProvider.notifier)
      .show(
        AppNotification(
          messageKey: LocaleKeys.notifications_moved_to_trash,
          type: NotificationType.info,
        ),
      );
}

// 2. METODA DLA SWIPE (JUŻ BYŁA OK, ALE UPEWNIJ SIĘ ŻE JEST TAKA SAMA)
void _showUndoSnackBar(BuildContext context, WidgetRef ref, String id) {
  ref
      .read(globalNotificationProvider.notifier)
      .show(
        AppNotification(
          messageKey: LocaleKeys.notifications_moved_to_trash,
          type: NotificationType.info,
        ),
      );
}

class _Header extends StatelessWidget {
  const _Header({required this.theme});
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Text(
        LocaleKeys.notifications_new_header.tr(),
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
