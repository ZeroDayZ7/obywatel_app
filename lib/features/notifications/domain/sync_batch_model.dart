import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_batch_model.freezed.dart';
part 'sync_batch_model.g.dart';

@freezed
abstract class SyncEventDto with _$SyncEventDto {
  const factory SyncEventDto({
    required String id,
    @JsonKey(name: 'event_type') required String eventType,
    required Map<String, dynamic> payload,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _SyncEventDto;

  factory SyncEventDto.fromJson(Map<String, dynamic> json) => _$SyncEventDtoFromJson(json);
}

@freezed
abstract class SyncBatchRequestDto with _$SyncBatchRequestDto {
  const factory SyncBatchRequestDto({
    required List<SyncEventDto> events,
  }) = _SyncBatchRequestDto;

  factory SyncBatchRequestDto.fromJson(Map<String, dynamic> json) => _$SyncBatchRequestDtoFromJson(json);
}

@freezed
abstract class SyncBatchResponseDto with _$SyncBatchResponseDto {
  const factory SyncBatchResponseDto({
    @JsonKey(name: 'processed_event_ids') required List<String> processedEventIds,
    @JsonKey(name: 'failed_event_ids') List<String>? failedEventIds,
  }) = _SyncBatchResponseDto;

  factory SyncBatchResponseDto.fromJson(Map<String, dynamic> json) => _$SyncBatchResponseDtoFromJson(json);
}
