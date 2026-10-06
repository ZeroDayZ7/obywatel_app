import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/features/home/config/home_menu_items.dart';
import 'package:obywatel_plus/features/home/presentation/widgets/home/home_grid_item.dart';

class HomeGridMenu extends StatelessWidget {
  const HomeGridMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final visibleItems = homeMenuItems.where((item) => !item.isHidden).toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: visibleItems.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 100,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        mainAxisExtent: 110,
      ),
      itemBuilder: (context, index) {
        final item = visibleItems[index];
        final label = item.labelKey.tr();

        return HomeGridItem(
          icon: item.icon,
          color: item.color,
          label: label,
          isEnabled: item.isEnabled,
          onTap: () {
            if (!item.isEnabled) return;

            if (item.route != null && item.route!.isNotEmpty) {
              context.push(item.route!);
            }
          },
        );
      },
    );
  }
}