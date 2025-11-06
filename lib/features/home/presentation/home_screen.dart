import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/config/env.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/app/theme/app_text_styles.dart';
import 'package:obywatel_plus/features/home/presentation/widgets/main_app_bar.dart';
import 'package:obywatel_plus/features/home/presentation/widgets/main_drawer.dart';
import './widgets/home_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static final _homeItems = [
    {'icon': Icons.folder, 'label': 'Documents', 'route': AppRoutes.documents},
    {
      'icon': Icons.science,
      'label': 'Test',
      'route': AppRoutes.test,
    }, // nowy kafel
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: apiConstants.appName),
      drawer: const MainDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Welcome back!', style: AppTextStyles.headline),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                itemCount: _homeItems.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                itemBuilder: (context, i) {
                  final item = _homeItems[i];
                  return HomeCard(
                    icon: item['icon'] as IconData,
                    label: item['label'] as String,
                    onTap: () => context.push(item['route'] as String),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
