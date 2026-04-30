import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/features/home/presentation/config/home_menu_items.dart';

import 'home_grid_item.dart';

class HomeGridMenu extends StatelessWidget {
  final Map<String, int> badgeCounts;
  const HomeGridMenu({super.key, required this.badgeCounts});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 600 ? 5 : 4;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: homeMenuItems.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            final item = homeMenuItems[index];
            final color = item['color'] as Color;
            final label = (item['labelKey'] as String).tr();
            final route = item['route'] as String?;
            final badgeCount = badgeCounts[item['id']] ?? 0;

            return HomeGridItem(
              icon: item['icon'] as IconData,
              color: color,
              label: label,
              badgeCount: badgeCount,
              onTap: () {
                if (route != null && route.isNotEmpty) {
                  context.push(route);
                }
              },
            );
          },
        );
      },
    );
  }
}