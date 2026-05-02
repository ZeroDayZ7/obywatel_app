import 'package:obywatel_plus/features/documents/data/mock_document_service.dart';
import 'package:obywatel_plus/features/documents/domain/models/document_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'document_repository.g.dart';

abstract class IDocumentRepository {
  Future<List<DocumentModel>> fetchDocuments();
  Future<DocumentModel> fetchDocumentById(String id);
}

class DocumentRepository implements IDocumentRepository {
  @override
  Future<List<DocumentModel>> fetchDocuments() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return MockDocumentService.getAllDocuments();
  }

  @override
  Future<DocumentModel> fetchDocumentById(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final all = MockDocumentService.getAllDocuments();
    return all.firstWhere((doc) => doc.id == id);
  }
}

@riverpod
IDocumentRepository documentRepository(Ref ref) {
  return DocumentRepository();
}
