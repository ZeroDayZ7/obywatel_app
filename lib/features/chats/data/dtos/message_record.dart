class MessageRecord {
  const MessageRecord({
    this.id,
    this.messageId,
    this.conversationId,
    this.senderUserId,
    this.senderDeviceId,
    this.recipientUserId,
    this.recipientDeviceId,
    this.ciphertext,
    this.type,
    this.createdAt,
    this.expiresAt,
    this.isDelivered = false,
    this.version = 1,
  });

  final String? id;
  final String? messageId;
  final String? conversationId;
  final String? senderUserId;
  final String? senderDeviceId;
  final String? recipientUserId;
  final String? recipientDeviceId;
  final String? ciphertext;
  final String? type;
  final DateTime? createdAt;
  final DateTime? expiresAt;
  final bool isDelivered;
  final int version;

  factory MessageRecord.fromJson(Map<String, dynamic> json) {
    return MessageRecord(
      id: (json['id'] as String?) ?? json['id']?.toString(),
      messageId: (json['messageId'] ?? json['message_id']) as String?,
      conversationId: (json['conversationId'] ?? json['conversation_id']) as String?,
      senderUserId: (json['senderUserId'] ?? json['sender_user_id']) as String?,
      senderDeviceId: (json['senderDeviceId'] ?? json['sender_device_id']) as String?,
      recipientUserId: (json['recipientUserId'] ?? json['recipient_user_id']) as String?,
      recipientDeviceId: (json['recipientDeviceId'] ?? json['recipient_device_id']) as String?,
      ciphertext: (json['ciphertext'] as String?) ?? json['ciphertext']?.toString(),
      type: (json['type'] as String?) ?? json['type']?.toString(),
      createdAt: _parseDate(json['createdAt'] ?? json['created_at']),
      expiresAt: _parseDate(json['expiresAt'] ?? json['expires_at']),
      isDelivered: ((json['isDelivered'] ?? json['is_delivered']) as bool?) ?? false,
      version: (json['version'] as int?) ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'messageId': messageId,
        'conversationId': conversationId,
        'senderUserId': senderUserId,
        'senderDeviceId': senderDeviceId,
        'recipientUserId': recipientUserId,
        'recipientDeviceId': recipientDeviceId,
        'ciphertext': ciphertext,
        'type': type,
        'createdAt': createdAt?.toIso8601String(),
        'expiresAt': expiresAt?.toIso8601String(),
        'isDelivered': isDelivered,
        'version': version,
      };

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
