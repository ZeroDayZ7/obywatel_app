import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/core/database/database.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/network/clients/api_client.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/features/communication/data/datasources/contacts_api_client.dart';
import 'package:obywatel_plus/features/communication/data/repositories/contacts_repository_impl.dart';

class _FakeApiClient extends ApiClient {
  _FakeApiClient()
      : super(
          dio: Dio(),
          storage: SecureStorageService(
            const FlutterSecureStorage(),
            AppLogger(),
          ),
          logger: AppLogger(),
        );
}

class FakeContactsApiClient extends ContactsApiClient {
  FakeContactsApiClient() : super(_FakeApiClient());

  bool sendRequestCalled = false;
  String? sentTargetUserId;
  bool respondCalled = false;
  String? respondedRequestId;
  bool? respondedAccept;

  @override
  Future<void> sendContactRequest(String targetUserId) async {
    sendRequestCalled = true;
    sentTargetUserId = targetUserId;
  }

  @override
  Future<void> respondToRequest(String requestId, bool accept) async {
    respondCalled = true;
    respondedRequestId = requestId;
    respondedAccept = accept;
  }
}

void main() {
  group('ContactsRepositoryImpl', () {
    test('sendRequest calls backend endpoint before local pending write', () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);

      final apiClient = FakeContactsApiClient();
      final repo = ContactsRepositoryImpl(apiClient, db.contactsDao, db.outboxDao);

      const targetUserId = '123e4567-e89b-12d3-a456-426614174000';

      await repo.sendRequest(targetUserId);

      expect(apiClient.sendRequestCalled, isTrue);
      expect(apiClient.sentTargetUserId, targetUserId);
    });

    test('respondToRequest calls backend endpoint before local status change', () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);

      final apiClient = FakeContactsApiClient();
      final repo = ContactsRepositoryImpl(apiClient, db.contactsDao, db.outboxDao);

      const requestId = '123e4567-e89b-12d3-a456-426614174001';

      await repo.respondToRequest(requestId, true);

      expect(apiClient.respondCalled, isTrue);
      expect(apiClient.respondedRequestId, requestId);
      expect(apiClient.respondedAccept, isTrue);
    });
  });
}
