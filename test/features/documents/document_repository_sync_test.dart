import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/features/documents/data/document_repository.dart';

void main() {
  group('DocumentSyncManifest', () {
    test('produces the same hash for equivalent document payloads', () {
      final a = {
        'id': 'doc-1',
        'type_code': 'ID_CARD',
        'status': 'active',
        'version': 3,
        'issued_at': '2025-01-01T00:00:00Z',
        'expires_at': '2028-01-01T00:00:00Z',
        'issuer_signature': 'c2lnbmF0dXJl',
        'signing_key_id': 'sig-key-1',
        'revocation_serial': 'rev-1',
        'encrypted_meta': 'eyJ0aXRsZSI6IkRvd8QifQ==',
      };

      final b = {
        'id': 'doc-1',
        'type_code': 'ID_CARD',
        'status': 'active',
        'version': 3,
        'issued_at': '2025-01-01T00:00:00Z',
        'expires_at': '2028-01-01T00:00:00Z',
        'issuer_signature': 'c2lnbmF0dXJl',
        'signing_key_id': 'sig-key-1',
        'revocation_serial': 'rev-1',
        'encrypted_meta': 'eyJ0aXRsZSI6IkRvd8QifQ==',
      };

      expect(
        DocumentSyncManifest.compute(a),
        equals(DocumentSyncManifest.compute(b)),
      );
    });

    test('detects meaningful changes in the document payload', () {
      final before = {
        'id': 'doc-1',
        'type_code': 'ID_CARD',
        'status': 'active',
        'version': 3,
        'issuer_signature': 'sig-a',
        'signing_key_id': 'key-1',
        'revocation_serial': 'rev-1',
        'encrypted_meta': 'meta-a',
      };

      final after = {
        'id': 'doc-1',
        'type_code': 'ID_CARD',
        'status': 'expired',
        'version': 4,
        'issuer_signature': 'sig-b',
        'signing_key_id': 'key-1',
        'revocation_serial': 'rev-2',
        'encrypted_meta': 'meta-b',
      };

      expect(
        DocumentSyncManifest.compute(before),
        isNot(equals(DocumentSyncManifest.compute(after))),
      );
    });
  });
}
