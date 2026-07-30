import 'package:obywatel_plus/features/contacts/domain/models/contact.dart';

abstract class ContactsRepository {
  Stream<List<Contact>> watchAcceptedContacts();
  Stream<List<Contact>> watchPendingContacts();
  Future<void> fetchAndSyncContacts();
  Future<void> sendRequest(String targetUserId);
  Future<void> respondToRequest(String requestId, bool accept);
}
