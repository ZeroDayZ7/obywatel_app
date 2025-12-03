import '../domain/message.dart';

class MessageDto {
  final String id;
  final String chatId;
  final String senderId;
  final String text;
  final String timestamp;

  final int status;
  final bool synced;
  final String? imageUrl;

  MessageDto({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.text,
    required this.timestamp,
    required this.status,
    required this.synced,
    required this.imageUrl,
  });

  factory MessageDto.fromJson(Map<String, dynamic> json) => MessageDto(
    id: json['id'] as String,
    chatId: json['chatId'] as String,
    senderId: json['senderId'] as String,
    text: json['text'] as String,
    timestamp: json['timestamp'] as String,
    status: json['status'] as int,
    synced: json['synced'] ?? false,
    imageUrl: json['imageUrl'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'chatId': chatId,
    'senderId': senderId,
    'text': text,
    'timestamp': timestamp,
    'status': status,
    'synced': synced,
    'imageUrl': imageUrl,
  };

  /// DTO → DOMAIN
  Message toDomain({String? currentUserId}) {
    return Message(
      id: id,
      chatId: chatId,
      senderId: senderId,
      text: text,
      timestamp: DateTime.parse(timestamp),
      isMe: currentUserId != null ? senderId == currentUserId : false,
      status: MessageStatus.values[status],
      synced: synced,
      imageUrl: imageUrl,
    );
  }

  /// DOMAIN → DTO
  factory MessageDto.fromDomain(Message message) => MessageDto(
    id: message.id,
    chatId: message.chatId,
    senderId: message.senderId,
    text: message.text,
    timestamp: message.timestamp.toIso8601String(),
    status: message.status.index,
    synced: message.synced,
    imageUrl: message.imageUrl,
  );
}
