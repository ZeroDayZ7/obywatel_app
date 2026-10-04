import 'package:obywatel_plus/features/contacts/data/repositories/contacts_repository_impl.dart';
import 'package:obywatel_plus/features/contacts/domain/repositories/contacts_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'contacts_service.g.dart';

class ContactsService {
  final ContactsRepository _repository;

  ContactsService(this._repository);

  Future<void> addContact(String userId, {String? localAlias}) async {
    await _repository.sendRequest(userId, localAlias: localAlias);
  }

  Future<void> updateLocalAlias(String contactId, String localAlias) async {
    await _repository.updateLocalAlias(contactId, localAlias);
  }

  Future<void> respondToRequest(String requestId, bool accept) async {
    await _repository.respondToRequest(requestId, accept);
  }
}

@riverpod
ContactsService contactsService(Ref ref) {
  final repo = ref.watch(contactsRepositoryProvider);
  return ContactsService(repo);
}
