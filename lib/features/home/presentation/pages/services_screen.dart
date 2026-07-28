import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/widgets/main/app_scaffold.dart';
import 'package:obywatel_plus/features/home/presentation/widgets/home/home_grid_menu.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const badgeCounts = {'notifications': 4, 'chats': 2};

    return AppScaffold(
      appBar: AppBar(title: Text(LocaleKeys.navigation_apps.tr())),
      size: ContainerSize.medium,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [HomeGridMenu(badgeCounts: badgeCounts)],
        ),
      ),
    );
  }
}
