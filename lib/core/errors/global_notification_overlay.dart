import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/errors/app_notification.dart';
import 'package:obywatel_plus/core/errors/global_notification_provider.dart';
import 'package:obywatel_plus/core/errors/presentation/animated_toast_widget.dart';
import 'package:obywatel_plus/core/network/network_manager.dart';
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

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final networkState = ref.watch(networkStateProvider).value ?? NetworkState.unknown;
    final networkStatusKey = switch (networkState) {
      NetworkState.offline => LocaleKeys.errors_CONNECTION_ERROR,
      NetworkState.backendUnavailable => LocaleKeys.errors_BACKEND_UNAVAILABLE,
      NetworkState.retrying => LocaleKeys.errors_RETRYING,
      _ => null,
    };
    final showNetworkBanner = networkStatusKey != null;

    return Stack(
      children: [
        widget.child,
        if (showNetworkBanner)
          Positioned(
            top: MediaQuery.paddingOf(context).top + 10,
            left: 20,
            right: 20,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: switch (networkState) {
                      NetworkState.offline => colorScheme.errorContainer,
                      NetworkState.backendUnavailable =>
                        colorScheme.tertiaryContainer,
                      NetworkState.retrying => colorScheme.primaryContainer,
                      _ => colorScheme.surface,
                    },
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            context.tr(networkStatusKey),
                            style: textTheme.labelLarge?.copyWith(
                              color: switch (networkState) {
                                NetworkState.offline =>
                                  colorScheme.onErrorContainer,
                                NetworkState.backendUnavailable =>
                                  colorScheme.onTertiaryContainer,
                                NetworkState.retrying =>
                                  colorScheme.onPrimaryContainer,
                                _ => colorScheme.onSurface,
                              },
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        Positioned(
          top: MediaQuery.paddingOf(context).top + (showNetworkBanner ? 70 : 10),
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
    // 1. Dodawanie nowych elementów
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

    // 2. Usuwanie nieobecnych elementów
    for (int i = _currentItems.length - 1; i >= 0; i--) {
      final item = _currentItems[i];
      final stillExists = newList.any((e) => e.id == item.id);
      if (!stillExists) {
        final removedItem = _currentItems.removeAt(i);
        _listKey.currentState?.removeItem(
          i,
          (context, animation) => _buildItem(removedItem, animation),
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
