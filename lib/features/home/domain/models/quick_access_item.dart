import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';

part 'quick_access_item.freezed.dart';

enum QuickAccessAccent { primary, secondary, tertiary, error }

@freezed
sealed class QuickAccessItem with _$QuickAccessItem {
  const factory QuickAccessItem({
    required String id,
    required String title,
    @Default('') String subtitle,
    required String iconName,
    @Default(QuickAccessAccent.primary) QuickAccessAccent accent,
    required String route,
    @Default(true) bool isEnabled,
  }) = _QuickAccessItem;

  const QuickAccessItem._();

  static List<QuickAccessItem> defaultItems() => [
    const QuickAccessItem(
      id: 'communication',
      title: 'Komunikacja',
      subtitle: 'Wiadomości i kontakty',
      iconName: 'forum_outlined',
      accent: QuickAccessAccent.primary,
      route: AppRoutes.communication,
    ),
    const QuickAccessItem(
      id: 'evoting',
      title: 'Płynna Demokracja',
      subtitle: 'Głosowanie i delegacje',
      iconName: 'how_to_vote_rounded',
      accent: QuickAccessAccent.primary,
      route: AppRoutes.eVoting,
    ),
    const QuickAccessItem(
      id: 'market',
      title: 'Giełda Zaufania',
      subtitle: 'Rynek reputacji',
      iconName: 'trending_up_rounded',
      accent: QuickAccessAccent.tertiary,
      route: '/evoting/exchange',
    ),
  ];

  IconData get iconData {
    return switch (iconName) {
      'forum_outlined' => Icons.forum_outlined,
      'description_outlined' => Icons.description_outlined,
      'grid_view_rounded' => Icons.grid_view_rounded,
      'notifications_none_rounded' => Icons.notifications_none_rounded,
      'how_to_vote_rounded' => Icons.how_to_vote_rounded,
      'trending_up_rounded' => Icons.trending_up_rounded,
      _ => Icons.apps_rounded,
    };
  }
}
