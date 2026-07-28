import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/network/api_endpoints.dart';
import 'package:obywatel_plus/core/network/providers.dart';
import 'package:obywatel_plus/features/documents/domain/models/document_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'document_repository.g.dart';

abstract class DocumentRepository {
  Future<List<DocumentModel>> fetchDocuments();
  Future<DocumentModel> fetchDocumentById(String id);
}

class HttpDocumentRepository implements DocumentRepository {
  final Ref _ref;
  HttpDocumentRepository(this._ref);
  @override
  Future<List<DocumentModel>> fetchDocuments() async {
    final apiClient = _ref.read(apiClientProvider);
    final logger = _ref.read(appLoggerProvider);
    try {
      final response = await apiClient.get(ApiEndpoints.documentsMe);
      logger.d('Fetch documents response: ${response.data}');
      if (response.data == null) {
        return [];
      }
      if (response.data is! List) {
        throw const FormatException('Expected documents list.');
      }
      return (response.data as List)
          .map(
            (item) =>
                DocumentModel.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList();
    } catch (e, stackTrace) {
      logger.e('Fetch documents failed', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<DocumentModel> fetchDocumentById(String id) async {
    final apiClient = _ref.read(apiClientProvider);
    final logger = _ref.read(appLoggerProvider);
    try {
      final response = await apiClient.get(ApiEndpoints.documentById(id));
      logger.d('Fetch document $id response: ${response.data}');
      if (response.data == null || response.data is! Map) {
        throw const FormatException('Expected document object.');
      }
      return DocumentModel.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
    } catch (e, stackTrace) {
      logger.e('Fetch document $id failed', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}

@riverpod
DocumentRepository documentRepository(Ref ref) {
  return HttpDocumentRepository(ref);
}
