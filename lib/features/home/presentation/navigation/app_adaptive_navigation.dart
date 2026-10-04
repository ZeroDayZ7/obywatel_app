import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/features/home/presentation/navigation/app_bottom_bar.dart';
import 'package:obywatel_plus/features/home/presentation/navigation/app_desktop_sidebar.dart';
import 'package:obywatel_plus/features/notifications/domain/notifications_controller.dart';

class AppAdaptiveNavigation extends ConsumerWidget {
  final Widget child;
  final double desktopBreakpoint;

  const AppAdaptiveNavigation({
    super.key,
    required this.child,
    this.desktopBreakpoint = 800.0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsControllerProvider);
    final unreadCount = notificationsAsync.maybeWhen(
      data: (items) => items.where((item) => !item.isRead).length,
      orElse: () => 0,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= desktopBreakpoint;

        if (isDesktop) {
          return Scaffold(
            body: Row(
              children: [
                AppDesktopSidebar(notificationCount: unreadCount),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(child: child),
              ],
            ),
          );
        }

        return Scaffold(
          body: child,
          bottomNavigationBar: AppBottomBar(notificationCount: unreadCount),
        );
      },
    );
  }
}
