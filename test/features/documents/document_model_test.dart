import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/features/documents/domain/models/document_model.dart';

void main() {
  group('DocumentModel', () {
    test('expired documents are visible but not marked as verified', () {
      final doc = DocumentModel(
        id: 'doc-1',
        type: 'ID_CARD',
        status: 'EXPIRED',
        metadata: {'title': 'Dowód osobisty'},
        fields: const [],
      );

      expect(doc.status, 'EXPIRED');
      expect(doc.isVerified, isFalse);
    });

    test('active documents are marked as verified', () {
      final doc = DocumentModel(
        id: 'doc-2',
        type: 'ID_CARD',
        status: 'ACTIVE',
        metadata: {'title': 'Dowód osobisty'},
        fields: const [],
      );

      expect(doc.status, 'ACTIVE');
      expect(doc.isVerified, isTrue);
    });
  });
}
