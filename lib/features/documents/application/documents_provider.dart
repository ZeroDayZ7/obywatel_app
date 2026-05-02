import 'package:obywatel_plus/features/documents/data/document_repository.dart';
import 'package:obywatel_plus/features/documents/domain/models/document_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'documents_provider.g.dart';

@riverpod
class DocumentsNotifier extends _$DocumentsNotifier {
  @override
  FutureOr<List<DocumentModel>> build() {
    return ref.watch(documentRepositoryProvider).fetchDocuments();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(documentRepositoryProvider).fetchDocuments(),
    );
  }
}

@riverpod
class DocumentDetailNotifier extends _$DocumentDetailNotifier {
  @override
  FutureOr<DocumentModel> build(String id) {
    return ref.watch(documentRepositoryProvider).fetchDocumentById(id);
  }
}
