import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/database/database_provider.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/widgets/app_scaffold.dart';
import 'package:obywatel_plus/features/notifications/domain/notification_model.dart';
import 'package:obywatel_plus/features/notifications/domain/notifications_controller.dart';

class TrashScreen extends ConsumerWidget {
  const TrashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trashStream = ref
        .watch(notificationsDaoProvider)
        .watchTrashNotifications();

    return AppScaffold(
      title: Text(LocaleKeys.notifications_trash_title.tr()),
      size: ContainerSize.medium,
      scrollable: false,
      padding: EdgeInsets.zero,
      // --- DODANE: Przycisk usuwania wszystkiego ---
      actions: [
        IconButton(
          icon: const Icon(Icons.delete_sweep),
          tooltip: LocaleKeys.notifications_trash_clear_all.tr(),
          onPressed: () => _confirmClearAll(context, ref),
        ),
      ],
      // --------------------------------------------
      child: StreamBuilder<List<NotificationModel>>(
        stream: trashStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data ?? [];

          if (items.isEmpty) {
            return Center(
              child: Text(LocaleKeys.notifications_trash_empty.tr()),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(24),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                child: ListTile(
                  title: Text(item.title),
                  subtitle: Text(
                    item.content,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.restore_from_trash),
                        onPressed: () => ref
                            .read(notificationsControllerProvider.notifier)
                            .restoreFromTrash(item.id),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_forever,
                          color: Colors.red,
                        ),
                        onPressed: () =>
                            _confirmPermanentDelete(context, ref, item.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // NOWA METODA: Potwierdzenie usunięcia wszystkiego
  void _confirmClearAll(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          LocaleKeys.notifications_trash_clear_all_confirm_title.tr(),
        ),
        content: Text(
          LocaleKeys.notifications_trash_clear_all_confirm_content.tr(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(LocaleKeys.common_cancel.tr()),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(notificationsControllerProvider.notifier)
                  .clearAllTrash();
              Navigator.pop(context);
            },
            child: const Text(
              "Usuń wszystko",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmPermanentDelete(BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(LocaleKeys.notifications_trash_delete_permanent_title.tr()),
        content: Text(
          LocaleKeys.notifications_trash_delete_permanent_content.tr(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(LocaleKeys.common_cancel.tr()),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(notificationsControllerProvider.notifier)
                  .deletePermanently(id);
              Navigator.pop(context);
            },
            child: Text(
              LocaleKeys.common_delete.tr(),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
