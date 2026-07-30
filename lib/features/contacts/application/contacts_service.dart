import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:obywatel_plus/features/contacts/data/repositories/contacts_repository_impl.dart';
import 'package:obywatel_plus/features/contacts/domain/repositories/contacts_repository.dart';

part 'contacts_service.g.dart';

class ContactsService {
  final ContactsRepository _repository;

  ContactsService(this._repository);

  Future<void> addContact(String userId) async {
    await _repository.sendRequest(userId);
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
