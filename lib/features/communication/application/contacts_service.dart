import 'package:flutter/foundation.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/features/communication/data/repositories/contacts_repository_impl.dart';
import 'package:obywatel_plus/features/communication/domain/repositories/contacts_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'contacts_service.g.dart';

class ContactsService {
  final ContactsRepository _repository;
  final AppLogger _logger = AppLogger();

  ContactsService(this._repository);

  Future<void> addContact(String userId) async {
    _logger.i('[CONTACTS-INVITE-01] UI: wysyłanie zaproszenia do userId=$userId');
    try {
      await _repository.sendRequest(userId);
      _logger.i('[CONTACTS-INVITE-06] UI: zaproszenie wysłane userId=$userId');
    } catch (error, stackTrace) {
      _logger.e('[CONTACTS-INVITE-99] UI: błąd wysyłki zaproszenia userId=$userId', error: error, stackTrace: stackTrace);
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
