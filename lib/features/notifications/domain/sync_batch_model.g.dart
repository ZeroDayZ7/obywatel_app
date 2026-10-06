// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_batch_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SyncEventDto _$SyncEventDtoFromJson(Map<String, dynamic> json) =>
    _SyncEventDto(
      id: json['id'] as String,
      eventType: json['event_type'] as String,
      payload: json['payload'] as Map<String, dynamic>,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$SyncEventDtoToJson(_SyncEventDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'event_type': instance.eventType,
      'payload': instance.payload,
      'created_at': instance.createdAt,
    };

_SyncBatchRequestDto _$SyncBatchRequestDtoFromJson(Map<String, dynamic> json) =>
    _SyncBatchRequestDto(
      events: (json['events'] as List<dynamic>)
          .map((e) => SyncEventDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SyncBatchRequestDtoToJson(
  _SyncBatchRequestDto instance,
) => <String, dynamic>{'events': instance.events};

_SyncBatchResponseDto _$SyncBatchResponseDtoFromJson(
  Map<String, dynamic> json,
) => _SyncBatchResponseDto(
  processedEventIds: (json['processed_event_ids'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  failedEventIds: (json['failed_event_ids'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$SyncBatchResponseDtoToJson(
  _SyncBatchResponseDto instance,
) => <String, dynamic>{
  'processed_event_ids': instance.processedEventIds,
  'failed_event_ids': instance.failedEventIds,
};
