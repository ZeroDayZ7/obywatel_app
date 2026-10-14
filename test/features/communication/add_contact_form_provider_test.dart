import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/features/auth/application/session/session_service.dart';
import 'package:obywatel_plus/features/communication/application/contacts_service.dart';
import 'package:obywatel_plus/features/communication/domain/contacts/contact.dart';
import 'package:obywatel_plus/features/communication/domain/repositories/contacts_repository.dart';
import 'package:obywatel_plus/features/communication/presentation/providers/add_contact_form_provider.dart';

class _FakeContactsRepository implements ContactsRepository {
  _FakeContactsRepository({this.fail = false, this.onSend});

  final bool fail;
  final Future<void> Function()? onSend;
  String? lastTargetUserId;

  @override
  Future<void> fetchAndSyncContacts() async {}

  @override
  Future<void> respondToRequest(String requestId, bool accept) async {}

  @override
  Future<void> sendRequest(String targetUserId) async {
    lastTargetUserId = targetUserId;
    if (onSend != null) {
      await onSend!();
    }
    if (fail) {
      throw const FormatException('Contact already exists');
    }
  }

  @override
  Future<void> updateLocalAlias(String contactId, String localAlias) async {}

  @override
  Stream<List<Contact>> watchAcceptedContacts() => const Stream.empty();

  @override
  Stream<List<Contact>> watchPendingContacts() => const Stream.empty();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const secureStorageChannel = MethodChannel(
    'plugins.it_nomads.com/flutter_secure_storage',
  );
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(secureStorageChannel, (
        MethodCall methodCall,
      ) async {
        switch (methodCall.method) {
          case 'write':
          case 'delete':
          case 'deleteAll':
            return null;
          case 'read':
            return null;
          case 'readAll':
            return <String, String>{};
          default:
            return null;
        }
      });

  group('AddContactFormNotifier', () {
    test('validates malformed identifiers before submitting', () async {
      final container = ProviderContainer(
        overrides: [
          contactsServiceProvider.overrideWithValue(
            ContactsService(_FakeContactsRepository()),
          ),
          sessionServiceProvider.overrideWithValue(
            SessionService(
              SecureStorageService(const FlutterSecureStorage(), AppLogger()),
              AppLogger(),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(addContactFormProvider.notifier);
      final result = await notifier.submit('bad@id');

      expect(result, isFalse);
      expect(
        container.read(addContactFormProvider).error,
        'Sprawdź identyfikator użytkownika.',
      );
    });

    test(
      'successfully submits normalized UUID and clears loading state',
      () async {
        final completer = Completer<void>();
        final container = ProviderContainer(
          overrides: [
            contactsServiceProvider.overrideWithValue(
              ContactsService(
                _FakeContactsRepository(onSend: () => completer.future),
              ),
            ),
            sessionServiceProvider.overrideWithValue(
              SessionService(
                SecureStorageService(const FlutterSecureStorage(), AppLogger()),
                AppLogger(),
              ),
            ),
          ],
        );
        addTearDown(container.dispose);

        final notifier = container.read(addContactFormProvider.notifier);
        final future = notifier.submit('8e681e7c-6ccc-4854-8fc6-b6dd5074f39e');

        expect(container.read(addContactFormProvider).isSubmitting, isTrue);

        completer.complete();
        final result = await future;

        expect(result, isTrue);
        expect(container.read(addContactFormProvider).error, isNull);
        expect(container.read(addContactFormProvider).isSubmitting, isFalse);
      },
    );

    test(
      'maps submit errors into UI-ready message and keeps state stable',
      () async {
        final container = ProviderContainer(
          overrides: [
            contactsServiceProvider.overrideWithValue(
              ContactsService(_FakeContactsRepository(fail: true)),
            ),
            sessionServiceProvider.overrideWithValue(
              SessionService(
                SecureStorageService(const FlutterSecureStorage(), AppLogger()),
                AppLogger(),
              ),
            ),
          ],
        );
        addTearDown(container.dispose);

        final notifier = container.read(addContactFormProvider.notifier);
        final result = await notifier.submit(
          '8e681e7c-6ccc-4854-8fc6-b6dd5074f39e',
        );

        expect(result, isFalse);
        expect(
          container.read(addContactFormProvider).error,
          anyOf(contains('Sprawdź'), contains('Nie udało się')),
        );
        expect(container.read(addContactFormProvider).isSubmitting, isFalse);
      },
    );
  });
}
