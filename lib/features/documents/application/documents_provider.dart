import 'package:obywatel_plus/features/documents/data/document_repository.dart';
import 'package:obywatel_plus/features/documents/domain/models/document_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'documents_provider.g.dart';

@riverpod
class Documents extends _$Documents {
  @override
  Stream<List<DocumentModel>> build() {
    final repository = ref.watch(documentRepositoryProvider);
    _triggerInitialSync();

    return repository.watchActiveDocuments();
  }

  Future<void> _triggerInitialSync() async {
    final repository = ref.read(documentRepositoryProvider);
    await repository.syncDocuments();
  }

  Future<void> sync() async {
    final repository = ref.read(documentRepositoryProvider);
    await repository.syncDocuments();
  }
}

@Riverpod(keepAlive: true)
Future<DocumentModel?> documentDetail(Ref ref, String id) {
  final repository = ref.watch(documentRepositoryProvider);
  return repository.getDocumentById(id);
}
