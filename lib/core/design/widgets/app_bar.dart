import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
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

  void _defaultBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                        onBackButtonPressed ?? () => _defaultBack(context),
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
