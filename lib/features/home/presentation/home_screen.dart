import 'package:flutter/material.dart';

import 'package:obywatel_plus/features/home/presentation/widgets/home/home_footer.dart';
import 'package:obywatel_plus/features/home/presentation/widgets/home/home_grid_menu.dart';
import 'package:obywatel_plus/features/home/presentation/widgets/home/home_section_title.dart';
import 'package:obywatel_plus/features/home/presentation/widgets/home/home_status_bar.dart';
import 'package:obywatel_plus/features/home/presentation/widgets/main_app_bar.dart';
import 'package:obywatel_plus/features/home/presentation/widgets/main_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final badgeCounts = {'notifications': 4, 'chats': 2};

    return Scaffold(
      appBar: const HomeAppBar(),
      drawer: const MainDrawer(),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0A0A0F),
                  Color(0xFF1A0F2E),
                  Color(0xFF0F1A2E),
                ],
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HomeStatusBar(),
                  const SizedBox(height: 24),
                  const HomeSectionTitle(title: 'USŁUGI'),
                  const SizedBox(height: 20),
                  HomeGridMenu(badgeCounts: badgeCounts),
                  const SizedBox(height: 24),
                  const HomeFooter(),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
