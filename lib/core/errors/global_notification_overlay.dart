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
      _handleChanges(prev ?? [], next);
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
    // 1. Wykrywanie nowych elementów (Dodawanie)
    for (final item in newList) {
      if (!oldList.contains(item)) {
        _currentItems.add(item);
        _listKey.currentState?.insertItem(
          _currentItems.length - 1,
          duration: const Duration(milliseconds: 500),
        );

        // TRIGGER FEEDBACK (Senior approach: Reagujemy tutaj)
        _triggerHapticFeedback(item.type);
      }
    }

    // 2. Wykrywanie usuniętych elementów (Usuwanie)
    for (int i = _currentItems.length - 1; i >= 0; i--) {
      final item = _currentItems[i];
      if (!newList.contains(item)) {
        _currentItems.removeAt(i);
        _listKey.currentState?.removeItem(
          i,
          (context, animation) => _buildItem(item, animation),
          duration: const Duration(milliseconds: 300),
        );
      }
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
        child: AnimatedToastWidget(
          notification: item,
          onClose: () =>
              ref.read(globalNotificationProvider.notifier).remove(item.id),
        ),
      ),
    );
  }
}
