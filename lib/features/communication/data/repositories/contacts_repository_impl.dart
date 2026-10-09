// lib/features/communication/data/repositories/contacts_repository_impl.dart
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:obywatel_plus/core/database/daos/contacts_dao.dart';
import 'package:obywatel_plus/core/database/daos/outbox_dao.dart';
import 'package:obywatel_plus/core/database/database.dart';
import 'package:obywatel_plus/core/database/database_provider.dart';
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

  ContactsRepositoryImpl(this._apiClient, this._dao, this._outboxDao);

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
    final normalized = ContactIdentifier.parse(targetUserId).normalized;
    debugPrint('[ContactsRepository] sendRequest: starting backend request for $normalized');

    try {
      await _apiClient.sendContactRequest(normalized);
      debugPrint('[ContactsRepository] sendRequest: backend accepted request for $normalized');
    } catch (error, stackTrace) {
      debugPrint('[ContactsRepository] sendRequest: backend request failed for $normalized: $error');
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
      ownerId: Value('local_user'),
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
    debugPrint('[ContactsRepository] respondToRequest: starting backend update for $requestId accept=$accept');

    try {
      await _apiClient.respondToRequest(requestId, accept);
      debugPrint('[ContactsRepository] respondToRequest: backend accepted response for $requestId');
    } catch (error, stackTrace) {
      debugPrint('[ContactsRepository] respondToRequest: backend response failed for $requestId: $error');
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
  return ContactsRepositoryImpl(apiClient, db.contactsDao, db.outboxDao);
}
