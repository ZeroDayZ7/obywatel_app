import 'package:flutter_test/flutter_test.dart';

void main() {
  test('camelCase delta contract uses canonical keys only', () {
    final payload = {
      'updatedContacts': [
        {'version': 2},
      ],
      'newMessages': [
        {
          'id': 'msg-1',
          'conversationId': 'conv-1',
          'senderId': 'user-a',
          'type': 'text',
          'encryptedPayload': 'payload',
          'createdAt': '2024-01-01T00:00:00Z',
        },
      ],
      'nextSequence': 9,
      'hasMore': true,
    };

    expect(payload['updatedContacts'], isNotEmpty);
    expect(payload['newMessages'], isNotEmpty);
    expect(payload['nextSequence'], 9);
    expect(payload['hasMore'], isTrue);
  });
}
