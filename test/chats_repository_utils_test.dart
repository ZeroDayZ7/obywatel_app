import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/features/communication/data/dtos/message_dto.dart';
import 'package:obywatel_plus/features/communication/data/repositories/chats_repository_utils.dart';

void main() {
  group('attachment-only message validation', () {
    test('allows empty text when attachmentId is present', () {
      expect(
        isMessageSendAllowed(content: '', attachmentId: 'attachment-123'),
        isTrue,
      );
      expect(
        isMessageSendAllowed(content: '   ', attachmentId: 'attachment-123'),
        isTrue,
      );
    });

    test('rejects empty text and missing attachment', () {
      expect(
        isMessageSendAllowed(content: '', attachmentId: null),
        isFalse,
      );
      expect(
        isMessageSendAllowed(content: '   ', attachmentId: null),
        isFalse,
      );
    });
  });

  test('maps attachment metadata from DTO into domain message', () {
    final dto = MessageDto(
      id: 'msg-1',
      conversationId: 'conv-1',
      senderId: 'user-1',
      senderDeviceId: 'device-1',
      attachmentId: 'attachment-123',
      type: 'text',
      encryptedPayload: 'ciphertext',
      createdAt: DateTime.utc(2026, 10, 14),
    );

    final message = mapMessageFromDto(dto, 'user-1');

    expect(message.attachmentId, 'attachment-123');
    expect(message.content, 'ciphertext');
  });
}
