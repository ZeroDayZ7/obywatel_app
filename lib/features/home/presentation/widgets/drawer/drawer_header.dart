import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/config/env.dart';
import 'package:obywatel_plus/features/home/presentation/widgets/drawer/app_logo.dart';

class CustomDrawerHeader extends StatelessWidget {
  const CustomDrawerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DrawerHeader(
      decoration: BoxDecoration(color: theme.colorScheme.primary),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppLogo(),
            const SizedBox(height: 12),
            Text(
              apiConstants.appName,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.onSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
