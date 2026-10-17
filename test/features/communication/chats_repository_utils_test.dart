import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/features/communication/data/dtos/message_dto.dart';
import 'package:obywatel_plus/features/communication/data/repositories/chats_repository_utils.dart';

void main() {
  group('mapMessageFromDto', () {
    test('resolves attachmentId from decrypted attachment envelope when dto metadata is empty', () {
      final dto = MessageDto(
        id: 'msg-1',
        conversationId: 'conv-1',
        senderId: 'alice',
        type: 'text',
        encryptedPayload: 'ciphertext',
        createdAt: DateTime.utc(2024, 1, 2, 3, 4, 5),
      );

      final plaintext = jsonEncode({
        'text': 'hello',
        'attachment': {
          'id': 'attachment-42',
          'key': 'abc123',
          'contentType': 'image/png',
          'fileName': 'photo.png',
          'size': 123,
          'sha256': 'hash',
        },
      });

      final message = mapMessageFromDto(dto, 'bob', plaintext: plaintext);

      expect(message.attachmentId, 'attachment-42');
      expect(message.content, 'hello');
    });
  });
}
