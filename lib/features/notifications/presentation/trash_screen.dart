import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/widgets/app_scaffold.dart';
import 'package:obywatel_plus/features/notifications/domain/notification_model.dart';
import 'package:obywatel_plus/features/notifications/domain/notifications_controller.dart';

class TrashScreen extends ConsumerWidget {
  const TrashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trashAsync = ref.watch(trashNotificationsProvider);

    return AppScaffold(
      title: Text(LocaleKeys.notifications_trash_title.tr()),
      size: ContainerSize.medium,
      padding: EdgeInsets.zero,
      actions: [
        trashAsync.maybeWhen(
          data: (items) => items.isNotEmpty
              ? IconButton(
                  onPressed: () => _handleClearAll(context, ref),
                  icon: const Icon(Icons.delete_sweep),
                  tooltip: LocaleKeys.notifications_trash_clear_all.tr(),
                )
              : const SizedBox.shrink(),
          orElse: () => const SizedBox.shrink(),
        ),
      ],
      child: trashAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text(err.toString())),
        data: (items) =>
            items.isEmpty ? const _EmptyTrashView() : _TrashList(items: items),
      ),
    );
  }

  void _handleClearAll(BuildContext context, WidgetRef ref) {
    _confirmAction(
      context,
      title: LocaleKeys.notifications_trash_clear_all_confirm_title.tr(),
      content: LocaleKeys.notifications_trash_clear_all_confirm_content.tr(),
      onConfirm: () =>
          ref.read(notificationsControllerProvider.notifier).clearAllTrash(),
    );
  }
}

class _EmptyTrashView extends StatelessWidget {
  const _EmptyTrashView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_delete_outlined,
            size: 64,
            color: Theme.of(context).hintColor.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          Text(LocaleKeys.notifications_trash_empty.tr()),
        ],
      ),
    );
  }
}

class _TrashList extends ConsumerWidget {
  final List<NotificationModel> items;
  const _TrashList({required this.items});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  tooltip: LocaleKeys.notifications_trash_restore.tr(),
                  onPressed: () => ref
                      .read(notificationsControllerProvider.notifier)
                      .restoreFromTrash(item.id),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_forever, color: Colors.red),
                  tooltip: LocaleKeys
                      .notifications_trash_delete_permanent_action
                      .tr(),
                  onPressed: () => _handleDeleteSingle(context, ref, item.id),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleDeleteSingle(BuildContext context, WidgetRef ref, String id) {
    _confirmAction(
      context,
      title: LocaleKeys.notifications_trash_delete_permanent_title.tr(),
      content: LocaleKeys.notifications_trash_delete_permanent_content.tr(),
      onConfirm: () => ref
          .read(notificationsControllerProvider.notifier)
          .deletePermanently(id),
    );
  }
}

void _confirmAction(
  BuildContext context, {
  required String title,
  required String content,
  required VoidCallback onConfirm,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(LocaleKeys.common_cancel.tr()),
        ),
        TextButton(
          onPressed: () {
            onConfirm();
            Navigator.pop(context);
          },
          child: Text(
            LocaleKeys.common_delete.tr(),
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}
