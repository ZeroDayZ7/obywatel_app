// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    _NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      priority: $enumDecode(_$NotificationPriorityEnumMap, json['priority']),
      category: $enumDecode(_$NotificationCategoryEnumMap, json['category']),
      isRead: json['isRead'] as bool? ?? false,
    );

Map<String, dynamic> _$NotificationModelToJson(_NotificationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'createdAt': instance.createdAt.toIso8601String(),
      'priority': _$NotificationPriorityEnumMap[instance.priority]!,
      'category': _$NotificationCategoryEnumMap[instance.category]!,
      'isRead': instance.isRead,
    };

const _$NotificationPriorityEnumMap = {
  NotificationPriority.info: 'info',
  NotificationPriority.success: 'success',
  NotificationPriority.warning: 'warning',
  NotificationPriority.error: 'error',
};

const _$NotificationCategoryEnumMap = {
  NotificationCategory.payments: 'payments',
  NotificationCategory.security: 'security',
  NotificationCategory.administrative: 'administrative',
  NotificationCategory.system: 'system',
};
