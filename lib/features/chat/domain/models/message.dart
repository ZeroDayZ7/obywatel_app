import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String id;
  final String chatId;
  final String senderId;
  final String text;
  final DateTime timestamp;

  /// To pole NIE pochodzi z API – wyliczasz je w kontrolerze.
  final bool isMe;

  const Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.text,
    required this.timestamp,
    required this.isMe,
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

      /// Jeśli nie podasz currentUserId – domyślnie false
      isMe: currentUserId != null ? json['senderId'] == currentUserId : false,
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
    };
  }

  // ============================================================
  // Kopiowanie (immutability)
  // ============================================================
  Message copyWith({
    String? id,
    String? chatId,
    String? senderId,
    String? text,
    DateTime? timestamp,
    bool? isMe,
  }) {
    return Message(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      isMe: isMe ?? this.isMe,
    );
  }

  @override
  List<Object?> get props => [id, chatId, senderId, text, timestamp, isMe];
}
