import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/design/models/action_item.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/widgets/action_group.dart';
import 'package:obywatel_plus/core/design/widgets/action_tile.dart';
import 'package:obywatel_plus/core/design/widgets/app_scaffold.dart';
import 'package:obywatel_plus/features/work_and_career/config/work_and_career_config.dart';

class WorkAndCareerHome extends ConsumerWidget {
  const WorkAndCareerHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sections = WorkAndCareerConfig.getSections(context);

    return AppScaffold(
      title: Text(LocaleKeys.workAndCareer_title.tr()),
      size: ContainerSize.medium,
      child: ListView.builder(
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
                    isDanger: item.isDanger,
                    isEnabled: item.isEnabled,
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
