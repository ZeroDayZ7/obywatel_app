import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_controller.dart';
import 'package:obywatel_plus/features/home/config/drawer_items.dart';
import 'package:obywatel_plus/features/home/presentation/widgets/drawer/drawer_header.dart';
import 'package:obywatel_plus/features/home/presentation/widgets/drawer/drawer_tile.dart';
import 'package:obywatel_plus/features/home/presentation/widgets/drawer/logout_confirm_dialog.dart';
import 'package:obywatel_plus/features/home/presentation/widgets/drawer/logout_tile.dart';

class MainDrawer extends ConsumerWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = DrawerConstants.menuItems;

    return Drawer(
      child: Column(
        children: [
          const CustomDrawerHeader(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ...items.map((item) => DrawerTile(item: item)),
                const Divider(),
                LogoutTile(
                  onLogoutSelected: (result) => _handleLogout(ref, result),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogout(WidgetRef ref, LogoutDialogResult result) async {
    final authController = ref.read(authControllerProvider.notifier);

    if (result.removeDevice) {
      await authController.unpairAndReset();
    } else {
      await authController.logout();
    }
  }
}
