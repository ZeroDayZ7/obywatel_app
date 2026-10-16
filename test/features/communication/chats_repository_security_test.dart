import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('communication plaintext persistence', () {
    test('does not persist plaintext message content in secure storage', () async {
      final repoSource = await File(
        'lib/features/communication/data/repositories/chats_repository_impl.dart',
      ).readAsString();
      final utilsSource = await File(
        'lib/features/communication/data/repositories/chats_repository_utils.dart',
      ).readAsString();

      expect(repoSource.contains('_persistPlaintextForMessage'), isFalse);
      expect(repoSource.contains('_hydratePlaintextCacheForIds'), isFalse);
      expect(repoSource.contains('chat_plaintext_'), isFalse);
      expect(repoSource.contains('_plaintextStorageKey'), isFalse);
      expect(utilsSource.contains('LocalPlaintextMessageCache'), isFalse);
    });
  });
}
