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
import 'package:obywatel_plus/features/notifications/domain/notifications_controller.dart';
import 'package:obywatel_plus/features/notifications/presentation/widgets/notification_card.dart';
import 'package:obywatel_plus/features/notifications/presentation/widgets/notification_details_sheet.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final notificationsAsync = ref.watch(notificationsControllerProvider);

    final hasUnread = notificationsAsync.maybeWhen(
      data: (items) => items.any((item) => !item.isRead),
      orElse: () => false,
    );

    return AppScaffold(
      title: Text(LocaleKeys.notifications_title.tr()),
      size: ContainerSize.medium,
      padding: EdgeInsets.zero,
      actions: [
        IconButton(
          onPressed: () => ref
              .read(notificationsControllerProvider.notifier)
              .syncWithBackend(),
          icon: const Icon(Icons.refresh),
          tooltip: LocaleKeys.common_refresh.tr(),
        ),
        IconButton(
          onPressed: hasUnread
              ? () => ref
                    .read(notificationsControllerProvider.notifier)
                    .markAllAsRead()
              : null,
          icon: const Icon(Icons.done_all),
          tooltip: hasUnread
              ? LocaleKeys.notifications_mark_all_read.tr()
              : null,
        ),
        IconButton(
          onPressed: () => context.push(
            '${AppRoutes.notifications}/${AppRoutes.notificationsTrash}',
          ),
          icon: const Icon(Icons.delete_sweep_outlined),
          tooltip: LocaleKeys.notifications_trash_title.tr(),
        ),
      ],
      child: notificationsAsync.when(
        data: (notifications) => RefreshIndicator(
          onRefresh: () => ref
              .read(notificationsControllerProvider.notifier)
              .syncWithBackend(),
          child: notifications.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: Center(
                        child: Text(LocaleKeys.notifications_empty.tr()),
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Header(theme: theme),
                    Expanded(
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
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
                            confirmDismiss: (direction) async {
                              await ref
                                  .read(
                                    notificationsControllerProvider.notifier,
                                  )
                                  .moveToTrash(item.id);

                              if (context.mounted) {
                                _showUndoSnackBar(context, ref, item.id);
                              }

                              return true;
                            },
                            onDismissed: (_) {},
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
                                _handleDelete(context, ref, item.id);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
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
