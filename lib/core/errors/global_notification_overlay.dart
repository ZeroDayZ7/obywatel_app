import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/errors/app_notification.dart';
import 'package:obywatel_plus/core/errors/global_notification_provider.dart';
import 'package:obywatel_plus/core/errors/presentation/animated_toast_widget.dart';
import 'package:obywatel_plus/core/notifications/feedback_service.dart';
import 'package:obywatel_plus/core/notifications/feedback_type.dart';

class GlobalNotificationOverlay extends ConsumerStatefulWidget {
  final Widget child;
  const GlobalNotificationOverlay({super.key, required this.child});

  @override
  ConsumerState<GlobalNotificationOverlay> createState() =>
      _GlobalNotificationOverlayState();
}

class _GlobalNotificationOverlayState
    extends ConsumerState<GlobalNotificationOverlay> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<AppNotification> _currentItems = [];

  @override
  Widget build(BuildContext context) {
    ref.listen<List<AppNotification>>(globalNotificationProvider, (prev, next) {
      _handleChanges(prev ?? const [], next);
    });

    return Stack(
      children: [
        widget.child,
        Positioned(
          top: MediaQuery.paddingOf(context).top + 10,
          right: 20,
          left: 20,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: AnimatedList(
              key: _listKey,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              initialItemCount: _currentItems.length,
              itemBuilder: (context, index, animation) {
                return _buildItem(_currentItems[index], animation);
              },
            ),
          ),
        ),
      ],
    );
  }

  void _handleChanges(
    List<AppNotification> oldList,
    List<AppNotification> newList,
  ) {
    for (final item in newList) {
      final exists = _currentItems.any((e) => e.id == item.id);
      if (!exists) {
        _currentItems.add(item);
        _listKey.currentState?.insertItem(
          _currentItems.length - 1,
          duration: const Duration(milliseconds: 500),
        );

        _triggerHapticFeedback(item.type);
      }
    }

    for (int i = _currentItems.length - 1; i >= 0; i--) {
      final item = _currentItems[i];
      final stillExists = newList.any((e) => e.id == item.id);
      if (!stillExists) {
        final removedItem = _currentItems.removeAt(i);
        _listKey.currentState?.removeItem(
          i,
          (context, animation) => _buildRemovalItem(removedItem, animation),
          duration: const Duration(milliseconds: 300),
        );
      }
    }
  }

  void _removeLocalItem(String id, {bool syncProvider = true}) {
    final index = _currentItems.indexWhere((item) => item.id == id);
    if (index == -1) {
      return;
    }

    final removedItem = _currentItems.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildRemovalItem(removedItem, animation),
      duration: const Duration(milliseconds: 300),
    );

    if (syncProvider) {
      ref.read(globalNotificationProvider.notifier).remove(id);
    }
  }

  void _triggerHapticFeedback(NotificationType type) {
    final feedbackService = ref.read(feedbackServiceProvider);
    final feedbackType = switch (type) {
      NotificationType.error => FeedbackType.error,
      NotificationType.warning => FeedbackType.warning,
      NotificationType.success => FeedbackType.success,
      NotificationType.info => FeedbackType.info,
    };
    feedbackService.trigger(feedbackType);
  }

  Widget _buildItem(AppNotification item, Animation<double> animation) {
    return SlideTransition(
      position: animation.drive(
        Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOutQuart)),
      ),
      child: FadeTransition(
        opacity: animation,
        child: Dismissible(
          key: ValueKey(item.id),
          direction: DismissDirection.horizontal,
          onDismissed: (_) {
            _removeLocalItem(item.id);
          },
          child: AnimatedToastWidget(
            notification: item,
            onClose: () => _removeLocalItem(item.id),
          ),
        ),
      ),
    );
  }

  Widget _buildRemovalItem(AppNotification item, Animation<double> animation) {
    return SlideTransition(
      position: animation.drive(
        Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(1, 0),
        ).chain(CurveTween(curve: Curves.easeInCubic)),
      ),
      child: FadeTransition(
        opacity: animation,
        child: AnimatedToastWidget(
          notification: item,
          onClose: () {},
        ),
      ),
    );
  }
}
