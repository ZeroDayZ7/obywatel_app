import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:obywatel_plus/core/errors/app_notification.dart';

class AnimatedToastWidget extends StatefulWidget {
  final AppNotification notification;
  final VoidCallback onClose;

  const AnimatedToastWidget({
    super.key,
    required this.notification,
    required this.onClose,
  });

  @override
  State<AnimatedToastWidget> createState() => _AnimatedToastWidgetState();
}

class _AnimatedToastWidgetState extends State<AnimatedToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: widget.notification.duration,
    )..forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = _getStyle(widget.notification.type);
    final theme = Theme.of(context);

    return Dismissible(
      key: Key(widget.notification.id),
      direction: DismissDirection.horizontal,
      onDismissed: (_) => widget.onClose(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Material(
          elevation: 12,
          shadowColor: Colors.black.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(14),

          color: theme.colorScheme.surface,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 550),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),

              border: Border.all(
                color: theme.dividerColor.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Container(width: 6, color: style.color),
                        const SizedBox(width: 12),
                        Icon(style.icon, color: style.color, size: 26),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              widget.notification.messageKey.tr(
                                namedArgs: widget.notification.namedArgs,
                              ),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 20),
                          onPressed: widget.onClose,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  AnimatedBuilder(
                    animation: _progressController,
                    builder: (context, child) {
                      return LinearProgressIndicator(
                        value: 1.0 - _progressController.value,
                        minHeight: 3,
                        backgroundColor: style.color.withValues(alpha: 0.05),
                        valueColor: AlwaysStoppedAnimation<Color>(style.color),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _ToastStyle _getStyle(NotificationType type) {
    return switch (type) {
      NotificationType.error => _ToastStyle(
        color: Colors.redAccent,
        icon: Icons.error_rounded,
      ),
      NotificationType.warning => _ToastStyle(
        color: Colors.orangeAccent,
        icon: Icons.warning_rounded,
      ),
      NotificationType.success => _ToastStyle(
        color: Colors.greenAccent,
        icon: Icons.check_circle_rounded,
      ),
      NotificationType.info => _ToastStyle(
        color: Colors.blueAccent,
        icon: Icons.info_rounded,
      ),
    };
  }
}

class _ToastStyle {
  final Color color;
  final IconData icon;
  _ToastStyle({required this.color, required this.icon});
}
