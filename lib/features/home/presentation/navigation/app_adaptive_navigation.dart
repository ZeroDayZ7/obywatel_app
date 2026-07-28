import 'package:flutter/material.dart';
import 'package:obywatel_plus/features/home/presentation/navigation/app_bottom_bar.dart';
import 'package:obywatel_plus/features/home/presentation/navigation/app_desktop_sidebar.dart';

class AppAdaptiveNavigation extends StatelessWidget {
  final Widget child;
  final double desktopBreakpoint;

  const AppAdaptiveNavigation({
    super.key,
    required this.child,
    this.desktopBreakpoint = 800.0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= desktopBreakpoint;

        if (isDesktop) {
          return Scaffold(
            body: Row(
              children: [
                const AppDesktopSidebar(),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(child: child),
              ],
            ),
          );
        }

        return Scaffold(body: child, bottomNavigationBar: const AppBottomBar());
      },
    );
  }
}
