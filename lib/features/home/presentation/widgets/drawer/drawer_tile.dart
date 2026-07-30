import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/features/home/config/drawer_items.dart';

class DrawerTile extends StatelessWidget {
  final DrawerItem item;
  const DrawerTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(item.icon),
      title: Text(item.labelKey.tr()),
      onTap: () {
        context.go(item.route);
      },
    );
  }
}
