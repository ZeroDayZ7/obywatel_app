import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/core/design/widgets/app_app_bar.dart';
import 'package:obywatel_plus/features/chat/presentation/widgets/chat_screen/bottom_nav_bar.dart';

class ChatShellWrapper extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ChatShellWrapper({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final titles = ['Messages', 'Groups', 'Chat Settings'];

    return Scaffold(
      appBar: AppAppBar(
        title: titles[navigationShell.currentIndex],
        showBackButton: true,

        onBackButtonPressed: () => context.go(AppRoutes.home),
      ),
      body: navigationShell,
      bottomNavigationBar: CyberpunkBottomNavBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(index),
      ),
    );
  }
}
