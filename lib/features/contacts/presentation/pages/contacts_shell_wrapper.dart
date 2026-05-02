import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/core/design/widgets/app_bar.dart';
import 'package:obywatel_plus/core/design/widgets/app_scaffold.dart';
import 'package:obywatel_plus/features/contacts/presentation/widgets/contacts_screen/contacts_bottom_nav.dart';

class ContactsShellWrapper extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ContactsShellWrapper({super.key, required this.navigationShell});

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Tytuły dopasowane do indeksów branchy w routerze
    final titles = ['Kontakty', 'Ulubione', 'Ustawienia'];

    return AppScaffold(
      backgroundColor: const Color(0xFF0A0E27),
      scrollable: false,
      appBar: AppAppBar(
        title: titles[navigationShell.currentIndex],
        onBackButtonPressed: () => context.go(AppRoutes.home),
      ),
      bottomNavigationBar: ContactsBottomNav(
        currentIndex: navigationShell.currentIndex,
        onTap: _onTap,
      ),
      child: navigationShell,
    );
  }
}
