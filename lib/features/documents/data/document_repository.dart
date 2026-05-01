import 'package:obywatel_plus/features/documents/domain/models/document_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'document_repository.g.dart';

class DocumentRepository {
  Future<List<DocumentModel>> fetchDocuments() async {
    await Future.delayed(const Duration(milliseconds: 800));

    return [
      const DocumentModel(
        id: '1',
        title: 'Dowód osobisty',
        iconName: 'badge',
        colorHex: 'FF2196F3',
        category: DocumentCategory.identity,
        isVerified: true,
        qrData: 'USER_ID_123_DATA',
        fields: [
          DocumentField(
            label: 'Numer dowodu',
            value: 'ABC 123456',
            iconName: 'description',
            isSensitive: true,
          ),
          DocumentField(
            label: 'PESEL',
            value: '90010112345',
            iconName: 'fingerprint',
            isSensitive: true,
          ),
        ],
      ),
      const DocumentModel(
        id: '2',
        title: 'Prawo jazdy',
        iconName: 'directions_car',
        colorHex: 'FF4CAF50',
        category: DocumentCategory.work,
        status: 'Kat. B, A',
        qrData: 'LICENSE_DRV_456',
        fields: [
          DocumentField(
            label: 'Numer dokumentu',
            value: '12345/67/890',
            iconName: 'card_membership',
          ),
        ],
      ),
    ];
  }
}

@riverpod
DocumentRepository documentRepository(Ref ref) => DocumentRepository();
