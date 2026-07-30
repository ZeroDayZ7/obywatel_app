// lib/features/contacts/data/datasources/contacts_api_client.dart
import 'package:obywatel_plus/core/network/clients/api_client.dart';
import 'package:obywatel_plus/core/network/providers.dart';
import 'package:obywatel_plus/features/contacts/data/dtos/contact_dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'contacts_api_client.g.dart';

class ContactsApiClient {
  final ApiClient _apiClient;

  const ContactsApiClient(this._apiClient);

  Future<List<ContactDto>> getContacts() async {
    final response = await _apiClient.get('/contacts');
    final responseMap = response.data as Map<String, dynamic>;

    // Backend w Go zwraca {"contacts": [...]}, wyciągamy listę spod klucza "contacts"
    final rawList = responseMap['contacts'] as List<dynamic>? ?? [];

    return rawList
        .map((json) => ContactDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> sendContactRequest(String targetUserId) async {
    await _apiClient.post(
      '/contacts/request',
      data: {'target_user_id': targetUserId},
    );
  }

  Future<void> respondToRequest(String requestId, bool accept) async {
    await _apiClient.put(
      '/contacts/request/$requestId/respond',
      data: {'accept': accept},
    );
  }
}

@riverpod
ContactsApiClient contactsApiClient(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ContactsApiClient(apiClient);
}
