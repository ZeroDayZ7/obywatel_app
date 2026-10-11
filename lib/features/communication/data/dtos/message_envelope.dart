class MessageEnvelope {
  const MessageEnvelope({
    this.messageId,
    this.conversationId,
    this.senderUserId,
    this.senderDeviceId,
    this.recipientUserId,
    this.recipientDeviceId,
    this.ciphertext,
    this.type,
    this.nonce,
    this.createdAt,
    this.expiresAt,
    this.version = 1,
  });

  final String? messageId;
  final String? conversationId;
  final String? senderUserId;
  final String? senderDeviceId;
  final String? recipientUserId;
  final String? recipientDeviceId;
  final String? ciphertext;
  final int? type;
  final String? nonce;
  final DateTime? createdAt;
  final DateTime? expiresAt;
  final int version;

  factory MessageEnvelope.fromJson(Map<String, dynamic> json) {
    return MessageEnvelope(
      messageId: (json['messageId'] ?? json['message_id']) as String?,
      conversationId: (json['conversationId'] ?? json['conversation_id']) as String?,
      senderUserId: (json['senderUserId'] ?? json['sender_user_id']) as String?,
      senderDeviceId: (json['senderDeviceId'] ?? json['sender_device_id']) as String?,
      recipientUserId: (json['recipientUserId'] ?? json['recipient_user_id']) as String?,
      recipientDeviceId: (json['recipientDeviceId'] ?? json['recipient_device_id']) as String?,
      ciphertext: (json['ciphertext'] as String?) ?? json['ciphertext']?.toString(),
      type: (json['type'] ?? json['signal_message_type']) as int?,
      nonce: (json['nonce'] as String?) ?? json['nonce']?.toString(),
      createdAt: _parseDate(json['createdAt'] ?? json['created_at']),
      expiresAt: _parseDate(json['expiresAt'] ?? json['expires_at']),
      version: (json['version'] as int?) ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
        'messageId': messageId,
        'conversationId': conversationId,
        'senderUserId': senderUserId,
        'senderDeviceId': senderDeviceId,
        'recipientUserId': recipientUserId,
        'recipientDeviceId': recipientDeviceId,
        'ciphertext': ciphertext,
        'type': type,
        'nonce': nonce,
        'createdAt': createdAt?.toIso8601String(),
        'expiresAt': expiresAt?.toIso8601String(),
        'version': version,
      };

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
