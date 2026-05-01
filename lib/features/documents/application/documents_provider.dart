import 'package:obywatel_plus/features/documents/data/document_repository.dart';
import 'package:obywatel_plus/features/documents/domain/models/document_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'documents_provider.g.dart';

@riverpod
class DocumentsNotifier extends _$DocumentsNotifier {
  @override
  Future<List<DocumentModel>> build() {
    return ref.watch(documentRepositoryProvider).fetchDocuments();
  }

  // Tutaj możesz dodać metody typu refresh() lub addDocument()
}
