// lib/features/communication/data/datasources/contacts_api_client.dart
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/network/clients/api_client.dart';
import 'package:obywatel_plus/core/network/providers.dart';
import 'package:obywatel_plus/features/communication/data/dtos/contact_dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'contacts_api_client.g.dart';

class ContactsApiClient {
  final ApiClient _apiClient;
  final AppLogger _logger;

  ContactsApiClient(this._apiClient, this._logger);

  Future<List<ContactDto>> getContacts() async {
    _logger.i('[CONTACTS-03] HTTP: GET /contacts rozpoczęty');

    final response = await _apiClient.get('/contacts');
    final responseMap = response.data as Map<String, dynamic>;

    final rawList = responseMap['contacts'] as List<dynamic>? ?? [];
    final contacts = rawList
        .map((json) => ContactDto.fromJson(json as Map<String, dynamic>))
        .toList();

    _logger.i(
      '[CONTACTS-04] HTTP: GET /contacts odpowiedź status=${response.statusCode} count=${contacts.length}',
      module: 'CONTACTS',
    );

    return contacts;
  }

  Future<void> sendContactRequest(String targetUserId) async {
    _logger.i(
      '[CONTACTS-INVITE-01] HTTP: POST /contacts/request start targetUserId=$targetUserId',
    );
    final payload = {'targetUserId': targetUserId};
    await _apiClient.post('/contacts/request', data: payload);
    _logger.i(
      '[CONTACTS-INVITE-02] HTTP: POST /contacts/request success targetUserId=$targetUserId',
    );
  }

  Future<void> respondToRequest(String requestId, bool accept) async {
    _logger.i(
      '[CONTACTS-RESPOND-01] HTTP: PUT /contacts/request/$requestId/respond start accept=$accept',
    );
    await _apiClient.put(
      '/contacts/request/$requestId/respond',
      data: {'accept': accept},
    );
    _logger.i(
      '[CONTACTS-RESPOND-02] HTTP: PUT /contacts/request/$requestId/respond success accept=$accept',
    );
  }

  Future<void> cancelRequest(String requestId) async {
    _logger.i(
      '[CONTACTS-CANCEL-01] HTTP: DELETE /contacts/request/$requestId start',
    );
    await _apiClient.delete('/contacts/request/$requestId');
    _logger.i(
      '[CONTACTS-CANCEL-02] HTTP: DELETE /contacts/request/$requestId success',
    );
  }
}

@riverpod
ContactsApiClient contactsApiClient(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  final logger = ref.watch(appLoggerProvider);
  return ContactsApiClient(apiClient, logger);
}