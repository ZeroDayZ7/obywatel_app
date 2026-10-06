import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';
import 'package:obywatel_plus/core/crypto/drift_signal_protocol_store.dart';
import 'package:obywatel_plus/core/database/database.dart';

void main() {
  test('DriftSignalProtocolStore persists identity and session state', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(() async => db.close());

    final store = DriftSignalProtocolStore(
      db,
      identityKeyPair: generateIdentityKeyPair(),
      localRegistrationId: 42,
    );

    final remote = const SignalProtocolAddress('bob', 1);
    final identity = generateIdentityKeyPair().getPublicKey();

    final saved = await store.saveIdentity(remote, identity);
    expect(saved, isTrue);
    expect(await store.getIdentity(remote), equals(identity));
    expect(await store.getLocalRegistrationId(), 42);

    final session = SessionRecord();
    await store.storeSession(remote, session);
    expect(await store.containsSession(remote), isTrue);
    expect(await store.loadSession(remote), isNotNull);
  });
}
