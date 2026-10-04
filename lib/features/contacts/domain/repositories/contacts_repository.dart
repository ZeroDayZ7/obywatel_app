import 'package:obywatel_plus/features/contacts/domain/models/contact.dart';

abstract class ContactsRepository {
  Stream<List<Contact>> watchAcceptedContacts();
  Stream<List<Contact>> watchPendingContacts();
  Future<void> fetchAndSyncContacts();
  Future<void> sendRequest(String targetUserId, {String? localAlias});
  Future<void> updateLocalAlias(String contactId, String localAlias);
  Future<void> respondToRequest(String requestId, bool accept);
}
