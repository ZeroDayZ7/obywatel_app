import 'package:flutter/material.dart';
import 'package:obywatel_plus/features/home/presentation/widgets/home/home_grid_menu.dart';
import 'package:obywatel_plus/features/home/presentation/widgets/home/home_status_bar.dart';
import 'package:obywatel_plus/features/home/presentation/widgets/home_app_bar.dart';
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
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HomeStatusBar(),
                const SizedBox(height: 24),
                const SizedBox(height: 20),
                HomeGridMenu(badgeCounts: badgeCounts),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}