import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/features/communication/application/outbox_event_builder.dart';
import 'package:obywatel_plus/features/communication/domain/chats/message.dart';

void main() {
  test('buildOutboxEventPayload rejects empty app device id', () {
    final message = Message(
      id: '11111111-1111-4111-8111-111111111111',
      conversationId: '22222222-2222-4222-8222-222222222222',
      senderId: '33333333-3333-4333-8333-333333333333',
      content: 'hello',
      isMine: true,
      createdAt: DateTime.now().toUtc(),
      encryptedPayload: 'Zm9v',
    );

    expect(
      () => buildOutboxEventPayload(
        message,
        '   ',
        encryptedContent: 'Zm9v',
        outboxEventId: '11111111-1111-4111-8111-111111111111',
        signalType: 1,
      ),
      throwsA(isA<StateError>()),
    );
  });

  test('buildOutboxEventPayload preserves app device id for backend send', () {
    final message = Message(
      id: '44444444-4444-4444-8444-444444444444',
      conversationId: '55555555-5555-4555-8555-555555555555',
      senderId: '66666666-6666-4666-8666-666666666666',
      content: 'hello',
      isMine: true,
      createdAt: DateTime.now().toUtc(),
      encryptedPayload: 'Zm9v',
    );

    final payload = buildOutboxEventPayload(
      message,
      'device-app-uuid-123',
      encryptedContent: 'Zm9v',
      outboxEventId: '77777777-7777-4777-8777-777777777777',
      signalType: 1,
    );

    expect(payload['senderDeviceId'], 'device-app-uuid-123');
    expect(payload['eventType'], 'SEND_MESSAGE');
  });
}
