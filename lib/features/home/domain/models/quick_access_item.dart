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
    @Default(0) int sortOrder,
    @Default(false) bool isHidden,
    @Default(0) int visualOffsetX,
    @Default(0) int visualOffsetY,
    @Default(1.0) double widthScale,
  }) = _QuickAccessItem;

  const QuickAccessItem._();

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'subtitle': subtitle,
    'iconName': iconName,
    'accent': accent.name,
    'route': route,
    'isEnabled': isEnabled,
    'sortOrder': sortOrder,
    'isHidden': isHidden,
    'visualOffsetX': visualOffsetX,
    'visualOffsetY': visualOffsetY,
    'widthScale': widthScale,
  };

  static QuickAccessItem fromMap(Map<String, dynamic> json) {
    return QuickAccessItem(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      iconName: json['iconName'] as String? ?? 'apps_rounded',
      accent: QuickAccessAccent.values.firstWhere(
        (value) => value.name == (json['accent'] as String? ?? 'primary'),
        orElse: () => QuickAccessAccent.primary,
      ),
      route: json['route'] as String? ?? AppRoutes.home,
      isEnabled: json['isEnabled'] as bool? ?? true,
      sortOrder: json['sortOrder'] as int? ?? 0,
      isHidden: json['isHidden'] as bool? ?? false,
      visualOffsetX: json['visualOffsetX'] as int? ?? 0,
      visualOffsetY: json['visualOffsetY'] as int? ?? 0,
      widthScale: (json['widthScale'] as num?)?.toDouble() ?? 1.0,
    );
  }

  static List<QuickAccessItem> defaultItems() => [
    const QuickAccessItem(
      id: 'communication',
      title: 'Komunikacja',
      subtitle: 'Wiadomości i kontakty',
      iconName: 'forum_outlined',
      accent: QuickAccessAccent.primary,
      route: AppRoutes.communication,
      sortOrder: 0,
      visualOffsetX: 0,
      visualOffsetY: 0,
      widthScale: 1.0,
    ),
    QuickAccessItem(
      id: 'documents',
      title: 'Dokumenty',
      subtitle: 'Dokumenty i eID',
      iconName: 'description_outlined',
      accent: QuickAccessAccent.secondary,
      route: AppRoutes.documents,
      sortOrder: 1,
      visualOffsetX: 18,
      visualOffsetY: 24,
      widthScale: 0.96,
    ),
    QuickAccessItem(
      id: 'services',
      title: 'Usługi',
      subtitle: 'Najczęstsze działania',
      iconName: 'grid_view_rounded',
      accent: QuickAccessAccent.tertiary,
      route: AppRoutes.services,
      sortOrder: 2,
      visualOffsetX: -20,
      visualOffsetY: 10,
      widthScale: 1.04,
    ),
    QuickAccessItem(
      id: 'notifications',
      title: 'Powiadomienia',
      subtitle: 'Aktualności i alerty',
      iconName: 'notifications_none_rounded',
      accent: QuickAccessAccent.error,
      route: AppRoutes.notifications,
      sortOrder: 3,
      visualOffsetX: 24,
      visualOffsetY: 18,
      widthScale: 0.98,
    ),
    QuickAccessItem(
      id: 'evoting',
      title: 'Płynna Demokracja',
      subtitle: 'Głosowanie i delegacje',
      iconName: 'how_to_vote_rounded',
      accent: QuickAccessAccent.primary,
      route: AppRoutes.eVoting,
      sortOrder: 4,
      visualOffsetX: -14,
      visualOffsetY: 18,
      widthScale: 1.02,
    ),
    QuickAccessItem(
      id: 'market',
      title: 'Giełda Zaufania',
      subtitle: 'Rynek reputacji',
      iconName: 'trending_up_rounded',
      accent: QuickAccessAccent.tertiary,
      route: '/evoting/exchange',
      sortOrder: 5,
      visualOffsetX: 10,
      visualOffsetY: 20,
      widthScale: 0.94,
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
