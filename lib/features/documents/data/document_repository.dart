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

      logger.d('Fetch documents raw response: ${response.data}');

      if (response.data == null) {
        return [];
      }

      final json = response.data as Map<String, dynamic>;

      final docs = json['docs'] as List<dynamic>?;

      if (docs == null) {
        logger.w('No docs field in response');
        return [];
      }

      return docs
          .map((item) => DocumentModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e, stackTrace) {
      logger.e(
        'Failed to fetch my documents',
        error: e,
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  @override
  Future<DocumentModel> fetchDocumentById(String id) async {
    final apiClient = _ref.read(apiClientProvider);
    final logger = _ref.read(appLoggerProvider);

    try {
      final response = await apiClient.get(ApiEndpoints.documentById(id));

      logger.d('Fetch document $id raw response: ${response.data}');

      return DocumentModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e, stackTrace) {
      logger.e(
        'Failed to fetch document $id',
        error: e,
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }
}

@riverpod
DocumentRepository documentRepository(Ref ref) {
  return HttpDocumentRepository(ref);
}
