import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';

class AppAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final bool centerTitle;
  final VoidCallback? onBackButtonPressed;

  const AppAppBar({
    super.key,
    required this.title,
    this.onBackButtonPressed,
    this.actions,
    this.leading,
    this.showBackButton = true,
    this.centerTitle = true,
  });

  void _defaultBack(BuildContext context, WidgetRef ref) {
    final logger = ref.read(appLoggerProvider);

    if (context.canPop()) {
      logger.i('AppAppBar: Navigating back');
      context.pop();
    } else {
      logger.w('AppAppBar:  Navigating to home');
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: primaryColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: AppBar(
        title: Text(title),
        centerTitle: centerTitle,
        automaticallyImplyLeading: false,
        leading:
            leading ??
            (showBackButton
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed:
                        onBackButtonPressed ?? () => _defaultBack(context, ref),
                  )
                : null),
        elevation: 0,
        actions: [if (actions != null) ...actions!, const SizedBox(width: 8)],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
