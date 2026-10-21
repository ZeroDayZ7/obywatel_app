import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/features/communication/data/repositories/chats_repository_impl.dart';
import 'package:obywatel_plus/features/communication/domain/outbox/outbox_event.dart';

void main() {
  group('Outbox signal filtering', () {
    test('SEND_MESSAGE payload is still processed as Signal message', () {
      final event = OutboxEvent(
        id: 'message-1',
        eventType: 'SEND_MESSAGE',
        payload:
            '{"eventType":"SEND_MESSAGE","type":2,"conversationId":"123e4567-e89b-12d3-a456-426614174000"}',
      );

      expect(
        ChatsRepositoryImpl.shouldProcessSignalMessageEvent(event),
        isTrue,
      );
    });

    test('ADD_CONTACT is ignored by SIGNAL message path', () {
      final event = OutboxEvent(
        id: 'contact-1',
        eventType: 'ADD_CONTACT',
        payload: '{"eventType":"ADD_CONTACT"}',
      );

      expect(
        ChatsRepositoryImpl.shouldProcessSignalMessageEvent(event),
        isFalse,
      );
    });

    test('notification.* entries are ignored by SIGNAL message path', () {
      final event = OutboxEvent(
        id: 'notification-1',
        eventType: 'notification.mark_read',
        payload: '{"eventType":"notification.mark_read"}',
      );

      expect(
        ChatsRepositoryImpl.shouldProcessSignalMessageEvent(event),
        isFalse,
      );
    });

    test('SEND_MESSAGE without signal_type is still rejected by validation', () {
      final event = OutboxEvent(
        id: 'invalid-message',
        eventType: 'SEND_MESSAGE',
        payload:
            '{"eventType":"SEND_MESSAGE","conversationId":"123e4567-e89b-12d3-a456-426614174000"}',
      );

      expect(
        ChatsRepositoryImpl.shouldProcessSignalMessageEvent(event),
        isTrue,
      );
    });
  });
}
