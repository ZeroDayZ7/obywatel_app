// lib/features/contacts/data/repositories/contacts_repository_impl.dart
import 'package:obywatel_plus/core/database/daos/contacts_dao.dart';
import 'package:obywatel_plus/core/database/database_provider.dart';
import 'package:obywatel_plus/features/contacts/data/datasources/contacts_api_client.dart';
import 'package:obywatel_plus/features/contacts/data/dtos/contact_dto.dart';
import 'package:obywatel_plus/features/contacts/domain/models/contact.dart';
import 'package:obywatel_plus/features/contacts/domain/repositories/contacts_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'contacts_repository_impl.g.dart';

class ContactsRepositoryImpl implements ContactsRepository {
  final ContactsApiClient _apiClient;
  final ContactsDao _dao;

  ContactsRepositoryImpl(this._apiClient, this._dao);

  @override
  Stream<List<Contact>> watchAcceptedContacts() {
    return _dao.watchAcceptedContacts().map(
      (entities) => entities.map(Contact.fromEntity).toList(),
    );
  }

  @override
  Stream<List<Contact>> watchPendingContacts() {
    return _dao.watchPendingContacts().map(
      (entities) => entities.map(Contact.fromEntity).toList(),
    );
  }

  @override
  Future<void> fetchAndSyncContacts() async {
    final dtos = await _apiClient.getContacts();
    final companions = dtos.map((dto) => dto.toCompanion()).toList();
    await _dao.upsertContacts(companions);
  }

  @override
  Future<void> sendRequest(String targetUserId) async {
    await _apiClient.sendContactRequest(targetUserId);
    // Po udanym request wywołujemy sync, aby pobrać wpis z bazą
    await fetchAndSyncContacts();
  }

  @override
  Future<void> respondToRequest(String requestId, bool accept) async {
    await _apiClient.respondToRequest(requestId, accept);
    await _dao.updateStatus(
      id: requestId,
      status: accept ? 'accepted' : 'blocked',
    );
  }
}

@riverpod
ContactsRepository contactsRepository(Ref ref) {
  final apiClient = ref.watch(contactsApiClientProvider);
  final db = ref.watch(appDatabaseProvider);
  return ContactsRepositoryImpl(apiClient, db.contactsDao);
}
