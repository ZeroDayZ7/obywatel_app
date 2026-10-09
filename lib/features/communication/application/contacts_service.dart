import 'package:flutter/foundation.dart';
import 'package:obywatel_plus/features/communication/data/repositories/contacts_repository_impl.dart';
import 'package:obywatel_plus/features/communication/domain/repositories/contacts_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'contacts_service.g.dart';

class ContactsService {
  final ContactsRepository _repository;

  ContactsService(this._repository);

  Future<void> addContact(String userId) async {
    debugPrint('[ContactsService] addContact: starting request for $userId');
    try {
      await _repository.sendRequest(userId);
      debugPrint('[ContactsService] addContact: request completed for $userId');
    } catch (error, stackTrace) {
      debugPrint('[ContactsService] addContact: request failed for $userId: $error');
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'contacts_service',
          context: ErrorDescription('Contact request failed'),
        ),
      );
      rethrow;
    }
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
