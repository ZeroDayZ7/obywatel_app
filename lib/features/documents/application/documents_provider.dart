import 'package:obywatel_plus/features/documents/data/document_repository.dart';
import 'package:obywatel_plus/features/documents/domain/models/document_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'documents_provider.g.dart';

@riverpod
class Documents extends _$Documents {
  @override
  FutureOr<List<DocumentModel>> build() async {
    final repository = ref.watch(documentRepositoryProvider);
    return repository.fetchDocuments();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(documentRepositoryProvider);
      return repository.fetchDocuments();
    });
  }
}

@Riverpod(keepAlive: true)
Future<DocumentModel> documentDetail(Ref ref, String id) {
  final repository = ref.watch(documentRepositoryProvider);
  return repository.fetchDocumentById(id);
}
