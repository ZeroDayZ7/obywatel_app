// Lightweight DTOs for outbox sync without code generation
class SyncEventDto {
  final String id;
  final String eventType;
  final Map<String, dynamic> payload;
  final String createdAt;

  SyncEventDto({
    required this.id,
    required this.eventType,
    required this.payload,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'event_type': eventType,
        'payload': payload,
        'created_at': createdAt,
      };

  factory SyncEventDto.fromJson(Map<String, dynamic> json) => SyncEventDto(
        id: json['id'] as String,
        eventType: json['event_type'] as String,
        payload: Map<String, dynamic>.from(json['payload'] as Map<String, dynamic>),
        createdAt: json['created_at'] as String,
      );
}

class SyncBatchRequestDto {
  final List<SyncEventDto> events;

  SyncBatchRequestDto({required this.events});

  Map<String, dynamic> toJson() => {
        'events': events.map((e) => e.toJson()).toList(),
      };

  factory SyncBatchRequestDto.fromJson(Map<String, dynamic> json) => SyncBatchRequestDto(
        events: (json['events'] as List<dynamic>)
            .map((e) => SyncEventDto.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class SyncBatchResponseDto {
  final List<String> processedEventIds;
  final List<String>? failedEventIds;

  SyncBatchResponseDto({required this.processedEventIds, this.failedEventIds});

  Map<String, dynamic> toJson() => {
        'processed_event_ids': processedEventIds,
        'failed_event_ids': failedEventIds,
      };

  factory SyncBatchResponseDto.fromJson(Map<String, dynamic> json) => SyncBatchResponseDto(
        processedEventIds: (json['processed_event_ids'] as List<dynamic>).cast<String>(),
        failedEventIds: json['failed_event_ids'] == null ? null : (json['failed_event_ids'] as List<dynamic>).cast<String>(),
      );
}
