import 'package:obywatel_plus/features/communication/domain/contacts/contact.dart';

abstract class ContactsRepository {
  Stream<List<Contact>> watchAcceptedContacts();
  Stream<List<Contact>> watchPendingContacts();
  Future<void> fetchAndSyncContacts();
  Future<void> sendRequest(String targetUserId);
  Future<void> cancelRequest(String requestId);
  Future<void> updateLocalAlias(String contactId, String localAlias);
  Future<void> respondToRequest(String requestId, bool accept);
}
