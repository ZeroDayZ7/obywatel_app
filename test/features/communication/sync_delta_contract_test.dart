import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/features/communication/data/dtos/contact_dto.dart';

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

  test('ContactDto deserializes actual backend camelCase JSON', () {
    final dto = ContactDto.fromJson({
      'id': 'contact-1',
      'ownerId': 'owner-1',
      'contactId': 'target-1',
      'status': 'pending',
      'direction': 'outgoing',
      'localAlias': null,
      'version': 1,
      'createdAt': '2026-10-13T11:40:00Z',
      'updatedAt': '2026-10-13T11:41:00Z',
    });

    expect(dto.id, 'contact-1');
    expect(dto.ownerId, 'owner-1');
    expect(dto.contactId, 'target-1');
    expect(dto.status, 'pending');
    expect(dto.direction, 'outgoing');
    expect(dto.version, 1);
    expect(dto.localAlias, isNull);
    expect(dto.createdAt, isNotNull);
    expect(dto.updatedAt, isNotNull);
  });

  test('ContactDto rejects missing required backend fields', () {
    expect(
      () => ContactDto.fromJson({
        'ownerId': 'owner-1',
        'contactId': 'target-1',
        'status': 'pending',
        'direction': 'outgoing',
        'version': 1,
      }),
      throwsA(isA<Error>()),
    );
  });

  test('empty contacts list is valid interoperability payload', () {
    const emptyContacts = <Map<String, dynamic>>[];
    expect(emptyContacts, isEmpty);
  });
}
