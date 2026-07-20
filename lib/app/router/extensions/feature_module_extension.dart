import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/features/work_and_career/presentation/feature_shell.dart';


extension FeatureModuleExtension on List<RouteBase> {
  /// Zamienia listę tras w spójny moduł z jednym Shellem.
  /// [defaultTitle] - tytuł używany, gdy konkretna trasa nie ma przypisanego tytułu.
  /// [routeTitles] - mapa ścieżka -> tytuł (np. {'/work/jobs': 'Oferty'}).
  ShellRoute asFeatureModule({
    required String defaultTitle,
    Map<String, String> routeTitles = const {},
    Widget? bottomNavigationBar,
  }) {
    return ShellRoute(
      builder: (context, state, child) {
        return FeatureShell(
          defaultTitle: defaultTitle,
          routeTitles: routeTitles,
          bottomNavigationBar: bottomNavigationBar,
          child: child,
        );
      },
      routes: this,
    );
  }
}
