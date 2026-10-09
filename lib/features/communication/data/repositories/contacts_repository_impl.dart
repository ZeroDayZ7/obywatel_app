// lib/features/communication/data/repositories/contacts_repository_impl.dart
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:obywatel_plus/core/database/daos/contacts_dao.dart';
import 'package:obywatel_plus/core/database/daos/outbox_dao.dart';
import 'package:obywatel_plus/core/database/database.dart';
import 'package:obywatel_plus/core/database/database_provider.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/features/auth/presentation/providers/auth_providers.dart';
import 'package:obywatel_plus/features/communication/data/datasources/contacts_api_client.dart';
import 'package:obywatel_plus/features/communication/data/dtos/contact_dto.dart';
import 'package:obywatel_plus/features/communication/domain/contacts/contact.dart';
import 'package:obywatel_plus/features/communication/domain/contacts/contact_identifier.dart';
import 'package:obywatel_plus/features/communication/domain/repositories/contacts_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'contacts_repository_impl.g.dart';

class ContactsRepositoryImpl implements ContactsRepository {
  final ContactsApiClient _apiClient;
  final ContactsDao _dao;
  final OutboxDao _outboxDao;
  final String _currentUserId;
  final AppLogger _logger = AppLogger();

  ContactsRepositoryImpl(
    this._apiClient,
    this._dao,
    this._outboxDao,
    this._currentUserId,
  );

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
    _logger.i('[CONTACTS-02] SYNC: rozpoczęto pobieranie kontaktów');
    final dtos = await _apiClient.getContacts();

    final companions = dtos.map((dto) => dto.toCompanion()).toList();
    await _dao.upsertContacts(companions);

    for (final dto in dtos) {
      if (dto.ownerId == _currentUserId || dto.contactId == _currentUserId) {
        await _dao.removePlaceholderPendingDuplicates(
          contactId: dto.contactId,
          currentUserId: _currentUserId,
          keepRowId: dto.id,
        );
      }

      final shouldResolveAcceptedState =
          dto.status == 'accepted' || dto.status == 'blocked';
      if (!shouldResolveAcceptedState) {
        continue;
      }

      await _dao.removeStalePendingDuplicates(
        contactId: dto.contactId,
        keepRowId: dto.id,
      );
    }

    _logger.i('[CONTACTS-10] UI: stan kontaktów zaktualizowany count=${companions.length}');
  }

  @override
  Future<void> sendRequest(String targetUserId) async {
    final normalized = ContactIdentifier.parse(targetUserId).normalized;
    _logger.i('[CONTACTS-INVITE-02] REPOSITORY: wysyłka zaproszenia do $normalized');

    try {
      await _apiClient.sendContactRequest(normalized);
      _logger.i('[CONTACTS-INVITE-03] REPOSITORY: backend przyjął zaproszenie dla $normalized');
    } catch (error, stackTrace) {
      _logger.e('[CONTACTS-INVITE-99] REPOSITORY: błąd wysyłki zaproszenia dla $normalized', error: error, stackTrace: stackTrace);
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'contacts_repository_impl',
          context: ErrorDescription('Failed to send contact request to backend'),
        ),
      );
      rethrow;
    }

    final now = DateTime.now();
    final eventId = const Uuid().v7();

    final companion = ContactsCompanion(
      id: Value(eventId),
      ownerId: Value(_currentUserId),
      contactId: Value(normalized),
      status: const Value('pending'),
      syncState: const Value('pending_create'),
      direction: const Value('outgoing'),
      changeSequence: Value(BigInt.one),
      localAlias: const Value.absent(),
      encryptedAlias: const Value.absent(),
      version: Value(BigInt.one),
      createdAt: Value(now),
      updatedAt: Value(now),
      deletedAt: const Value.absent(),
    );

    await _dao.db.transaction(() async {
      await _dao.upsertContacts([companion]);
      await _outboxDao.enqueueEvent(
        OutboxEventsCompanion(
          id: Value(eventId),
          entityType: const Value('CONTACT'),
          entityId: Value(normalized),
          eventType: const Value('ADD_CONTACT'),
          conversationId: const Value.absent(),
          payload: Value(
            jsonEncode({
              'entity_type': 'CONTACT',
              'entity_id': normalized,
              'event_type': 'ADD_CONTACT',
              'action': 'request',
              'target_user_id': normalized,
              'created_at': now.toUtc().toIso8601String(),
            }),
          ),
          status: const Value('pending'),
          retryCount: const Value(0),
          attemptCount: const Value(0),
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
      );
    });
  }

  @override
  Future<void> updateLocalAlias(String contactId, String localAlias) async {
    final normalized = ContactIdentifier.parse(contactId).normalized;
    final normalizedAlias = ContactIdentifier.normalizeAlias(localAlias);
    if (normalizedAlias.isEmpty) {
      return;
    }

    await _dao.updateLocalAlias(
      contactId: normalized,
      localAlias: normalizedAlias,
    );
  }

  @override
  Future<void> respondToRequest(String requestId, bool accept) async {
    _logger.i('[CONTACTS-RESPOND-02] REPOSITORY: rozpoczęto odpowiedź dla $requestId accept=$accept');

    try {
      await _apiClient.respondToRequest(requestId, accept);
      _logger.i('[CONTACTS-RESPOND-03] REPOSITORY: backend zaakceptował odpowiedź dla $requestId');
    } catch (error, stackTrace) {
      _logger.e('[CONTACTS-RESPOND-99] REPOSITORY: błąd odpowiedzi dla $requestId', error: error, stackTrace: stackTrace);
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'contacts_repository_impl',
          context: ErrorDescription('Failed to respond to contact request on backend'),
        ),
      );
      rethrow;
    }

    final now = DateTime.now();
    final eventId = const Uuid().v7();

    await _dao.db.transaction(() async {
      await _dao.updateStatus(
        id: requestId,
        status: accept ? 'accepted' : 'blocked',
      );

      await (_dao.update(_dao.contacts)
            ..where((t) => t.id.equals(requestId)))
          .write(
        ContactsCompanion(
          syncState: Value(accept ? 'pending_update' : 'pending_delete'),
          direction: const Value('incoming'),
          updatedAt: Value(now),
        ),
      );

      await _outboxDao.enqueueEvent(
        OutboxEventsCompanion(
          id: Value(eventId),
          entityType: const Value('CONTACT'),
          entityId: Value(requestId),
          eventType: Value(accept ? 'RESPOND_CONTACT' : 'REMOVE_CONTACT'),
          conversationId: const Value.absent(),
          payload: Value(
            jsonEncode({
              'entity_type': 'CONTACT',
              'entity_id': requestId,
              'event_type': accept ? 'RESPOND_CONTACT' : 'REMOVE_CONTACT',
              'action': accept ? 'ACCEPT' : 'REJECT',
              'accepted': accept,
              'created_at': now.toUtc().toIso8601String(),
            }),
          ),
          status: const Value('pending'),
          retryCount: const Value(0),
          attemptCount: const Value(0),
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
      );
    });
  }
}

@riverpod
ContactsRepository contactsRepository(Ref ref) {
  final apiClient = ref.watch(contactsApiClientProvider);
  final db = ref.watch(appDatabaseProvider);
  final currentUserId = ref.watch(currentUserIdProvider);
  return ContactsRepositoryImpl(
    apiClient,
    db.contactsDao,
    db.outboxDao,
    currentUserId,
  );
}
