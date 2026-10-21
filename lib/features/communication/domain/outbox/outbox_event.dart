class OutboxEvent {
  final String id;
  final String payload;
  final String? eventType;
  final String? conversationId;
  final int retryCount;
  final DateTime? nextAttemptAt;

  const OutboxEvent({
    required this.id,
    required this.payload,
    this.eventType,
    this.conversationId,
    this.retryCount = 0,
    this.nextAttemptAt,
  });
}
