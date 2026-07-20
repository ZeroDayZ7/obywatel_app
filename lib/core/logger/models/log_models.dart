import 'package:freezed_annotation/freezed_annotation.dart';

part 'log_models.freezed.dart';
part 'log_models.g.dart';

enum LogLevel {
  @JsonValue('trace')
  trace,
  @JsonValue('debug')
  debug,
  @JsonValue('info')
  info,
  @JsonValue('warning')
  warning,
  @JsonValue('error')
  error,
}

@freezed
sealed class Breadcrumb with _$Breadcrumb {
  const factory Breadcrumb({
    required String timestamp,
    required String message,
    required LogLevel level,
    required String module,
  }) = _Breadcrumb;

  factory Breadcrumb.fromJson(Map<String, dynamic> json) =>
      _$BreadcrumbFromJson(json);
}

@freezed
sealed class LogPayload with _$LogPayload {
  const factory LogPayload({
    required LogLevel level,
    required String message,
    required String env,
    String? error,
    String? stackTrace,
    required List<Breadcrumb> breadcrumbs,
    @Default('obywatel_app') String service,
  }) = _LogPayload;

  factory LogPayload.fromJson(Map<String, dynamic> json) =>
      _$LogPayloadFromJson(json);
}
