import 'package:obywatel_plus/features/documents/data/document_repository.dart';
import 'package:obywatel_plus/features/documents/domain/models/document_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'documents_provider.g.dart';

@riverpod
class Documents extends _$Documents {
  @override
  FutureOr<List<DocumentModel>> build() {
    return ref.watch(documentRepositoryProvider).fetchDocuments();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

@riverpod
Future<DocumentModel> documentDetail(Ref ref, String id) {
  return ref.watch(documentRepositoryProvider).fetchDocumentById(id);
}
