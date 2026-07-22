import 'package:flutter/material.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/widgets/main/app_scaffold.dart';
import 'package:obywatel_plus/features/home/presentation/widgets/home/action_items_feed.dart';
import 'package:obywatel_plus/features/home/presentation/widgets/home/home_grid_menu.dart';
import 'package:obywatel_plus/features/home/presentation/widgets/home_app_bar.dart';
import 'package:obywatel_plus/features/home/presentation/widgets/main_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final badgeCounts = {'notifications': 4, 'chats': 2};

    // Podział na dwie główne zakładki
    final List<Widget> pages = [
      // Zakładka 0: Aplikacje (Siatka)
      SingleChildScrollView(child: HomeGridMenu(badgeCounts: badgeCounts)),
      // Zakładka 1: Sprawy Obywatelskie (Feed)
      const SingleChildScrollView(child: ActionItemsFeed()),
    ];

    return AppScaffold(
      appBar: const HomeAppBar(),
      drawer: const MainDrawer(),
      size: ContainerSize.medium,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            activeIcon: Icon(Icons.grid_view_rounded, color: Color(0xFF26C6DA)),
            label: 'Aplikacje',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.gavel_rounded),
            activeIcon: Icon(Icons.gavel_rounded, color: Color(0xFF26C6DA)),
            label: 'Sprawy Obywatelskie',
          ),
        ],
      ),
      child: IndexedStack(index: _currentIndex, children: pages),
    );
  }
}
