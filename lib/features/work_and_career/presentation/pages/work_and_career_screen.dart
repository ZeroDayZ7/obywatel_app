import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/design/models/action_item.dart';
import 'package:obywatel_plus/core/design/widgets/action_group.dart';
import 'package:obywatel_plus/core/design/widgets/action_tile.dart';
import 'package:obywatel_plus/features/work_and_career/config/work_and_career_config.dart';

class WorkAndCareerHome extends ConsumerWidget {
  const WorkAndCareerHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sections = WorkAndCareerConfig.getSections(context);

    return ListView.builder(
      itemCount: sections.length,
      itemBuilder: (context, index) {
        final section = sections[index];
        final items = section['items'] as List<ActionItem>;
        final visibleItems = items.where((item) => !item.isHidden).toList();

        if (visibleItems.isEmpty) return const SizedBox.shrink();

        return ActionGroup(
          title: section['title'] as String?,
          children: visibleItems.map((item) {
            return ActionTile(
              icon: item.icon,
              title: item.title,
              subtitle: item.subtitle,
              isDanger: item.isDanger,
              isEnabled: item.isEnabled,
              showArrow: item.type == ActionType.navigation,
              onTap: item.onTap,
              value: item.initialValue,
              onToggle: item.onToggle,
            );
          }).toList(),
        );
      },
    );
  }
}
