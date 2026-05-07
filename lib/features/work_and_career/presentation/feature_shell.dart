import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/widgets/main/app_bar.dart';
import 'package:obywatel_plus/core/design/widgets/main/app_scaffold.dart';

class FeatureShell extends StatelessWidget {
  final Widget child;
  final String defaultTitle;
  final Map<String, String> routeTitles;
  final Widget? bottomNavigationBar;

  const FeatureShell({
    super.key,
    required this.child,
    this.defaultTitle = '',
    this.routeTitles = const {},
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    final state = GoRouterState.of(context);
    final location = state.uri.path;

    // 1. Logika dynamicznego tytułu
    final title = routeTitles[location] ?? defaultTitle;

    // 2. Logika przycisku prowadzącego wstecz
    // Sprawdzamy czy możemy wrócić wewnątrz tego modułu
    final bool canPop = context.canPop();

    return AppScaffold(
      size: ContainerSize.medium,
      appBar: AppAppBar(
        title: title,
        // Jeśli możemy cofnąć, dajemy BackButton, jeśli nie - np. Drawer lub nic
        leading: canPop ? BackButton(onPressed: () => context.pop()) : null,
        actions: [
          // Przycisk "Home" zawsze pod ręką w Super App
          if (canPop)
            IconButton(
              icon: const Icon(Icons.home_outlined),
              onPressed: () => context.go('/home'),
            ),
        ],
      ),
      bottomNavigationBar: bottomNavigationBar,
      child: child,
    );
  }
}
