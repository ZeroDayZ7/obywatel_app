import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

enum NotificationPriority { info, success, warning, error }

enum NotificationCategory {
  payments,
  security,
  administrative,
  system;

  IconData get icon {
    return switch (this) {
      NotificationCategory.payments => Icons.payments_outlined,
      NotificationCategory.security => Icons.security_outlined,
      NotificationCategory.administrative => Icons.account_balance_outlined,
      NotificationCategory.system => Icons.settings_suggest_outlined,
    };
  }

  // Pobieranie przetłumaczonej nazwy kategorii
  String get label {
    return switch (this) {
      NotificationCategory.payments =>
        LocaleKeys.notifications_categories_payments.tr(),
      NotificationCategory.security =>
        LocaleKeys.notifications_categories_security.tr(),
      NotificationCategory.administrative =>
        LocaleKeys.notifications_categories_administrative.tr(),
      NotificationCategory.system =>
        LocaleKeys.notifications_categories_system.tr(),
    };
  }
}

// Rozszerzenie dla kolorów priorytetów
extension NotificationPriorityX on NotificationPriority {
  Color color(ColorScheme colors) {
    return switch (this) {
      NotificationPriority.info => colors.primary,
      NotificationPriority.success => Colors.green,
      NotificationPriority.warning => Colors.orange,
      NotificationPriority.error => colors.error,
    };
  }

  // Kolor tła karty (bardzo delikatny odcień)
  Color containerColor(ColorScheme colors) {
    return switch (this) {
      NotificationPriority.info => colors.primaryContainer.withValues(
        alpha: 0.2,
      ),
      NotificationPriority.success => Colors.green.withValues(alpha: 0.1),
      NotificationPriority.warning => Colors.orange.withValues(alpha: 0.1),
      NotificationPriority.error => colors.errorContainer.withValues(
        alpha: 0.2,
      ),
    };
  }
}

@freezed
sealed class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required String id,
    required String title,
    required String content,
    required DateTime createdAt,
    required NotificationPriority priority,
    required NotificationCategory category,
    @Default(false) bool isRead,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}
