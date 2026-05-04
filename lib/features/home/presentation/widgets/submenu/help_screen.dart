import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/design/models/action_item.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/widgets/action_group.dart';
import 'package:obywatel_plus/core/design/widgets/action_tile.dart';
import 'package:obywatel_plus/core/design/widgets/app_scaffold.dart';
import 'package:obywatel_plus/features/home/presentation/widgets/config/help_config.dart';

class HelpScreen extends ConsumerWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sections = HelpConfig.getSections(
      onEmailTap: () {},
      onPhoneTap: () {},
    );

    return AppScaffold(
      title: Text(LocaleKeys.help_title.tr()),
      size: ContainerSize.medium,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sections.length,
        itemBuilder: (context, index) {
          final section = sections[index];
          final items = section['items'] as List<ActionItem>;

          return ActionGroup(
            title: section['title'] as String?,
            children: items
                .map(
                  (item) => ActionTile(
                    icon: item.icon,
                    title: item.title,
                    subtitle: item.subtitle,
                    showArrow: item.type == ActionType.navigation,
                    onTap: item.onTap,
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}
