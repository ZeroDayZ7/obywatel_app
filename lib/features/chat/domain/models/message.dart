import 'package:equatable/equatable.dart';

enum MessageStatus { sent, delivered, read }

class Message extends Equatable {
  final String id;
  final String chatId;
  final String senderId;
  final String text;
  final DateTime timestamp;

  /// Wyliczane lokalnie, nie pochodzi z API
  final bool isMe;

  /// NOWE POLE
  final MessageStatus status;

  /// Opcjonalne – czy zsynchronizowane z backendem
  final bool synced;

  const Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.text,
    required this.timestamp,
    required this.isMe,
    required this.status,
    this.synced = false,
  });

  // ============================================================
  // JSON → Message
  // ============================================================
  factory Message.fromJson(Map<String, dynamic> json, {String? currentUserId}) {
    return Message(
      id: json['id'] as String,
      chatId: json['chatId'] as String,
      senderId: json['senderId'] as String,
      text: json['text'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),

      isMe: currentUserId != null ? json['senderId'] == currentUserId : false,

      status: MessageStatus.values[json['status'] as int],
      synced: json['synced'] ?? false,
    );
  }

  // ============================================================
  // Message → JSON
  // ============================================================
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'senderId': senderId,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
      'status': status.index,
      'synced': synced,
    };
  }

  // ============================================================
  // Kopiowanie
  // ============================================================
  Message copyWith({
    String? id,
    String? chatId,
    String? senderId,
    String? text,
    DateTime? timestamp,
    bool? isMe,
    MessageStatus? status,
    bool? synced,
  }) {
    return Message(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      isMe: isMe ?? this.isMe,
      status: status ?? this.status,
      synced: synced ?? this.synced,
    );
  }

  @override
  List<Object?> get props => [
    id,
    chatId,
    senderId,
    text,
    timestamp,
    isMe,
    status,
    synced,
  ];
}
