class NewMessageNotification {
  const NewMessageNotification({
    this.eventType,
    this.conversationId,
    this.messageId,
    this.senderUserId,
    this.senderDeviceId,
    this.timestamp,
  });

  final String? eventType;
  final String? conversationId;
  final String? messageId;
  final String? senderUserId;
  final String? senderDeviceId;
  final DateTime? timestamp;

  factory NewMessageNotification.fromJson(Map<String, dynamic> json) {
    return NewMessageNotification(
      eventType: (json['eventType'] ?? json['event_type']) as String?,
      conversationId: (json['conversationId'] ?? json['conversation_id']) as String?,
      messageId: (json['messageId'] ?? json['message_id']) as String?,
      senderUserId: (json['senderUserId'] ?? json['sender_user_id']) as String?,
      senderDeviceId: (json['senderDeviceId'] ?? json['sender_device_id']) as String?,
      timestamp: _parseDate(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() => {
        'eventType': eventType,
        'conversationId': conversationId,
        'messageId': messageId,
        'senderUserId': senderUserId,
        'senderDeviceId': senderDeviceId,
        'timestamp': timestamp?.toIso8601String(),
      };

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
