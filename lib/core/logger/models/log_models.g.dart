// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Breadcrumb _$BreadcrumbFromJson(Map<String, dynamic> json) => _Breadcrumb(
  timestamp: json['timestamp'] as String,
  message: json['message'] as String,
  level: $enumDecode(_$LogLevelEnumMap, json['level']),
  module: json['module'] as String,
);

Map<String, dynamic> _$BreadcrumbToJson(_Breadcrumb instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp,
      'message': instance.message,
      'level': _$LogLevelEnumMap[instance.level]!,
      'module': instance.module,
    };

const _$LogLevelEnumMap = {
  LogLevel.trace: 'trace',
  LogLevel.debug: 'debug',
  LogLevel.info: 'info',
  LogLevel.warning: 'warning',
  LogLevel.error: 'error',
};

_LogPayload _$LogPayloadFromJson(Map<String, dynamic> json) => _LogPayload(
  level: $enumDecode(_$LogLevelEnumMap, json['level']),
  message: json['message'] as String,
  env: json['env'] as String,
  error: json['error'] as String?,
  stackTrace: json['stackTrace'] as String?,
  breadcrumbs: (json['breadcrumbs'] as List<dynamic>)
      .map((e) => Breadcrumb.fromJson(e as Map<String, dynamic>))
      .toList(),
  service: json['service'] as String? ?? 'obywatel_app',
);

Map<String, dynamic> _$LogPayloadToJson(_LogPayload instance) =>
    <String, dynamic>{
      'level': _$LogLevelEnumMap[instance.level]!,
      'message': instance.message,
      'env': instance.env,
      'error': instance.error,
      'stackTrace': instance.stackTrace,
      'breadcrumbs': instance.breadcrumbs,
      'service': instance.service,
    };
