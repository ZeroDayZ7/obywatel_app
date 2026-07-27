import 'package:flutter/material.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/widgets/main/app_scaffold.dart';
import 'package:obywatel_plus/features/home/presentation/widgets/home/home_grid_menu.dart';
import 'package:obywatel_plus/features/home/presentation/widgets/home_app_bar.dart';
import 'package:obywatel_plus/features/home/presentation/widgets/main_drawer.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const badgeCounts = {'notifications': 4, 'chats': 2};

    return const AppScaffold(
      appBar: HomeAppBar(),
      drawer: MainDrawer(),
      size: ContainerSize.medium,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pełny katalog usług i aplikacji obywatelskich
            HomeGridMenu(badgeCounts: badgeCounts),
          ],
        ),
      ),
    );
  }
}
