import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/widgets/app_bar.dart';
import 'package:obywatel_plus/core/design/widgets/app_scaffold.dart';

class HealthShellWrapper extends StatelessWidget {
  final Widget child;
  final GoRouterState state;

  const HealthShellWrapper({
    super.key,
    required this.child,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      size: ContainerSize.medium,
      appBar: AppAppBar(title: _getBreadcrumbTitle()),
      child: child,
    );
  }

  String _getBreadcrumbTitle() {
    final location = state.uri.path;

    if (location.endsWith(AppRoutes.healthPrescriptions)) {
      return 'Zdrowie / Recepty';
    }
    if (location.endsWith(AppRoutes.healthReferrals)) {
      return 'Zdrowie / Skierowania';
    }
    if (location.endsWith(AppRoutes.healthHistory)) {
      return 'Zdrowie / Historia';
    }
    if (location.endsWith(AppRoutes.healthVaccinations)) {
      return 'Zdrowie / Szczepienia';
    }
    if (location.endsWith(AppRoutes.healthInsurance)) {
      return 'Zdrowie / Ubezpieczenie';
    }

    return 'Zdrowie';
  }
}
