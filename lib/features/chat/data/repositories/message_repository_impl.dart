import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models/message.dart';
import '../../domain/repositories/message_repository.dart';

class MessageRepositoryImpl implements MessageRepository {
  static const _boxName = 'messages_box';
  late final Box _box;

  MessageRepositoryImpl() {
    _box = Hive.box(_boxName);
  }

  @override
  Future<void> saveMessage(Message message) async {
    final key = message.id ?? const Uuid().v4();

    final data = {
      'id': key,
      'chatId': message.chatId,
      'senderId': message.senderId,
      'text': message.text,
      'timestamp': message.timestamp.toIso8601String(),
      'isMe': message.isMe,
      'status': message.status.index,
    };

    await _box.put(key, data);
  }

  @override
  Future<List<Message>> loadMessages(String chatId) async {
    final messages = <Message>[];

    for (var entry in _box.values) {
      if (entry is Map && entry['chatId'] == chatId) {
        messages.add(_mapToMessage(entry));
      }
    }

    messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return messages;
  }

  @override
  Future<void> deleteMessage(String messageId) async {
    await _box.delete(messageId);
  }

  @override
  Future<void> clearChat(String chatId) async {
    final keysToDelete = <dynamic>[];

    _box.toMap().forEach((key, value) {
      if (value['chatId'] == chatId) {
        keysToDelete.add(key);
      }
    });

    await _box.deleteAll(keysToDelete);
  }

  Message _mapToMessage(Map data) {
    return Message(
      id: data['id'],
      chatId: data['chatId'],
      senderId: data['senderId'],
      text: data['text'],
      timestamp: DateTime.parse(data['timestamp']),
      isMe: data['isMe'],
      status: MessageStatus.values[data['status']],
    );
  }
}
