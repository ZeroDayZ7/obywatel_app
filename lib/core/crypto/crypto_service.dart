import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:isolate_manager/isolate_manager.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';
import 'package:obywatel_plus/core/crypto/kdf_service.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'crypto_service.g.dart';

class SignRequest {
  final List<int> message;
  final List<int> encryptedPrivateKey;
  final String pin;
  final List<int> salt;

  SignRequest({
    required this.message,
    required this.encryptedPrivateKey,
    required this.pin,
    required this.salt,
  });
}

@pragma('vm:entry-point')
Future<List<int>> secureSignWorker(SignRequest request) async {
  final kdf = KdfService(AppLogger());
  // 1️⃣ Wyprowadzenie KEK z PIN-u i salt
  final kek = await kdf.deriveKeyFromPin(
    pinBytes: utf8.encode(request.pin),
    salt: request.salt,
  );
  // 2️⃣ Odszyfrowanie prywatnego klucza
  final secretBox = SecretBox.fromConcatenation(
    request.encryptedPrivateKey,
    nonceLength: 12,
    macLength: 16,
  );
  final clearPrivateKeyBytes = await AesGcm.with256bits().decrypt(
    secretBox,
    secretKey: kek,
  );

  final privateKeyBytes = Uint8List.fromList(clearPrivateKeyBytes);
  final messageBytes = Uint8List.fromList(request.message);

  // 3️⃣ Obliczenie podpisu
  final privateKey = Curve.decodePrivatePoint(privateKeyBytes);
  final signature = Curve.calculateSignature(privateKey, messageBytes);
  // 4️⃣ Wipe wrażliwych danych
  kdf.wipe(clearPrivateKeyBytes);
  kdf.wipe(privateKeyBytes);

  return signature;
}

@Riverpod(keepAlive: true)
class CryptoService extends _$CryptoService {
  late final IsolateManager<List<int>, SignRequest> _worker;
  SimpleKeyPair? _activeDeviceKeyPair;
  AppLogger get _log => ref.read(appLoggerProvider);

  @override
  void build() {
    _worker = IsolateManager.create(
      secureSignWorker,
      workerName: 'crypto_signing_worker',
      concurrent: 1,
    );
    ref.onDispose(() => _worker.stop());
  }

  /// Sprawdza, czy klucz jest gotowy w pamięci RAM do złożenia podpisu
  Future<bool> hasActiveKey() async {
    _log.i('[HAS-ACTIVE-KEY][1] Sprawdzanie obecności klucza w RAM...');
    final hasKey = _activeDeviceKeyPair != null;
    _log.d(
      '[HAS-ACTIVE-KEY][2] Wynik: _activeDeviceKeyPair != null -> $hasKey',
    );
    return hasKey;
  }

  /// Wczytuje i odszyfrowuje klucz prywatny z SecureStorage do RAM przy użyciu PIN-u
  Future<void> loadAndUnlockPrivateKey({
    required List<int> pinBytes,
    required List<int> salt,
  }) async {
    _log.i(
      '[LOAD-UNLOCK-PRIVATE-KEY][1] Rozpoczynam odblokowywanie klucza prywatnego z SecureStorage...',
    );
    _log.d(
      '[LOAD-UNLOCK-PRIVATE-KEY][1.1] Wejściowe pinBytes=$pinBytes (len: ${pinBytes.length}), '
      'saltLen=${salt.length}, salt (pierwsze 4 bajty): ${salt.take(4).toList()}',
    );

    // 2. Odczyt z SecureStorage
    _log.i(
      '[LOAD-UNLOCK-PRIVATE-KEY][2] Odczytuję zaszyfrowany klucz z SecureStorage (${StorageKeys.devicePrivateKey})...',
    );
    final storage = ref.read(secureStorageProvider);
    final encryptedBase64 = await storage.read(
      key: StorageKeys.devicePrivateKey,
    );

    _log.d(
      '[LOAD-UNLOCK-PRIVATE-KEY][2.1] Odczytany Base64: '
      '${encryptedBase64 != null ? "PRESENT (len: ${encryptedBase64.length})" : "NULL/EMPTY"}',
    );

    if (encryptedBase64 == null || encryptedBase64.isEmpty) {
      _log.e(
        '[LOAD-UNLOCK-PRIVATE-KEY][ERR] Brak zapisanego klucza prywatnego na urządzeniu w SecureStorage!',
      );
      throw Exception('Brak zapisanego klucza prywatnego na urządzeniu.');
    }

    try {
      // 3. Dekodowanie Base64
      _log.i(
        '[LOAD-UNLOCK-PRIVATE-KEY][3] Dekoduję zaszyfrowane dane z Base64...',
      );
      final encryptedData = base64Decode(encryptedBase64);
      _log.d(
        '[LOAD-UNLOCK-PRIVATE-KEY][3.1] Długość surowych zaszyfrowanych bajtów: ${encryptedData.length}',
      );

      // 4. Deriwacja KEK z PIN-u i soli
      _log.i(
        '[LOAD-UNLOCK-PRIVATE-KEY][4] Deriwacja KEK z PIN-u i soli (deriveKeyFromPin)...',
      );
      final kek = await ref
          .read(kdfServiceProvider)
          .deriveKeyFromPin(pinBytes: pinBytes, salt: salt);

      final kekBytes = await kek.extractBytes();
      _log.d(
        '[LOAD-UNLOCK-PRIVATE-KEY][4.1] Wygenerowano KEK. Długość bajtów: ${kekBytes.length}, '
        'KEK (pierwsze 4 bajty): ${kekBytes.take(4).toList()}',
      );

      // 5. Rekonstrukcja SecretBox (AES-GCM: Nonce 12B, MAC 16B)
      _log.i(
        '[LOAD-UNLOCK-PRIVATE-KEY][5] Rekonstrukcja SecretBox z bajtów (nonce: 12B, mac: 16B)...',
      );
      final secretBox = SecretBox.fromConcatenation(
        encryptedData,
        nonceLength: 12,
        macLength: 16,
      );
      _log.d(
        '[LOAD-UNLOCK-PRIVATE-KEY][5.1] SecretBox: Nonce len=${secretBox.nonce.length}, '
        'Ciphertext len=${secretBox.cipherText.length}, MAC len=${secretBox.mac.bytes.length}',
      );

      // 6. Odszyfrowanie klucza prywatnego
      _log.i(
        '[LOAD-UNLOCK-PRIVATE-KEY][6] Odszyfrowywanie AesGcm.with256bits().decrypt...',
      );
      final clearPrivateKeyBytes = await AesGcm.with256bits().decrypt(
        secretBox,
        secretKey: kek,
      );
      _log.d(
        '[LOAD-UNLOCK-PRIVATE-KEY][6.1] Pomyślnie odszyfrowano bajty! Długość: ${clearPrivateKeyBytes.length}',
      );

      // 7. Utworzenie Ed25519 KeyPair ze słowa-ziarna (seed = pierwsze 32 bajty)
      _log.i(
        '[LOAD-UNLOCK-PRIVATE-KEY][7] Tworzenie Ed25519 KeyPair z seeda (pierwsze 32 bajty)...',
      );
      final seed = clearPrivateKeyBytes.sublist(0, 32);
      _log.d(
        '[LOAD-UNLOCK-PRIVATE-KEY][7.1] Wycięty seed ma długość: ${seed.length} bajtów',
      );

      final algorithm = Ed25519();
      _activeDeviceKeyPair = await algorithm.newKeyPairFromSeed(seed);
      _log.d(
        '[LOAD-UNLOCK-PRIVATE-KEY][7.2] _activeDeviceKeyPair został pomyślnie zrekonstruowany w RAM.',
      );

      // 8. Czyszczenie pamięci
      _log.i(
        '[LOAD-UNLOCK-PRIVATE-KEY][8] Czyszczenie odszyfrowanych bajtów z RAM (wipe)...',
      );
      ref.read(kdfServiceProvider).wipe(clearPrivateKeyBytes);

      _log.i(
        '🔓 [LOAD-UNLOCK-PRIVATE-KEY][9] ✅ Klucz prywatny urządzenia został pomyślnie odblokowany i załadowany do RAM.',
      );
    } catch (e, st) {
      _log.e(
        '❌ [LOAD-UNLOCK-PRIVATE-KEY][ERR] Błąd podczas odszyfrowywania lub rekonstrukcji klucza prywatnego!',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  /// Czyści klucz prywatny z pamięci RAM (wywoływane np. przy zablokowaniu aplikacji lub logout)
  void lockKey() {
    _log.i(
      '[LOCK-KEY][1] Wywołano lockKey(). Usuwam _activeDeviceKeyPair z RAM.',
    );
    final hadKey = _activeDeviceKeyPair != null;
    _activeDeviceKeyPair = null;
    _log.i(
      '🔒 [LOCK-KEY][2] Klucz prywatny został usunięty z RAM. (Czy klucz istniał w RAM przed usunięciem? -> $hadKey)',
    );
  }

  /// Sign a message using the user's encrypted key + PIN
  Future<List<int>> signMessage({
    required List<int> message,
    required List<int> encryptedKey,
    required String pin,
    required List<int> salt,
  }) async {
    _log.i(
      '[SIGN-MESSAGE][1] Rozpoczynam przekazywanie zadania podpisania wiadomości do workera...',
    );
    _log.d(
      '[SIGN-MESSAGE][1.1] Parametry: msgLen=${message.length}, encryptedKeyLen=${encryptedKey.length}, '
      'pinLength=${pin.length}, saltLen=${salt.length}',
    );

    try {
      _log.i(
        '[SIGN-MESSAGE][2] Uruchamiam obliczenia na workerze (_worker.compute)...',
      );
      final result = await _worker.compute(
        SignRequest(
          message: message,
          encryptedPrivateKey: encryptedKey,
          pin: pin,
          salt: salt,
        ),
      );

      _log.i(
        '[SIGN-MESSAGE][3] ✅ Worker pomyślnie zwrócił podpis. Długość bajtów podpisu: ${result.length}',
      );
      return result;
    } catch (e, st) {
      _log.e(
        '❌ [SIGN-MESSAGE][ERR] Błąd podczas podpisywania wiadomości w workerze!',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  Future<List<int>> generateAndHoldKeyPair() async {
    _log.i(
      '[KEYGEN][1] Generowanie nowej pary kluczy Ed25519 dla urządzenia...',
    );

    final algorithm = Ed25519();
    _activeDeviceKeyPair = await algorithm.newKeyPair();
    _log.d(
      '[KEYGEN][1.1] Utworzono nową instancję _activeDeviceKeyPair w RAM.',
    );

    final publicKey = await _activeDeviceKeyPair!.extractPublicKey();
    _log.i(
      '[KEYGEN][2] Wyekstrahowano klucz publiczny. '
      'Długość: ${publicKey.bytes.length} bajtów, klucz (Base64): ${base64Encode(publicKey.bytes)}',
    );

    return publicKey.bytes;
  }

  // Podpisuje challenge używając klucza z RAM oraz Domain Bindingu
  Future<String> signWithActiveKey(
    String challenge, {
    String domain = 'obywatel.gov.pl',
  }) async {
    _log.i(
      '[SIGN-ACTIVE][1] Rozpoczynam procedurę podpisywania challenge\'a...',
    );
    _log.d('[SIGN-ACTIVE][1.1] Challenge: $challenge | Domain: $domain');

    if (_activeDeviceKeyPair == null) {
      _log.e('[SIGN-ACTIVE][ERR] KRYTYCZNY BŁĄD: Brak aktywnego klucza w RAM!');
      throw Exception('No active key');
    }

    try {
      // 1. Dekodowanie challenge ze STANDARDOWEGO Base64
      _log.i(
        '[SIGN-ACTIVE][2] Dekodowanie challenge\'a ze standardowego Base64...',
      );
      final normalizedChallenge = base64.normalize(challenge);
      final challengeBytes = base64.decode(normalizedChallenge);

      // 2. Składanie payloadu bajtowego odpowiadającego fmt.Appendf(nil, "%s:%s", domain, string(challengeBytes))
      // Generujemy bajty z domeny i dwukropka w UTF-8, a potem doklejamy surowe bajty challenge'a
      final prefixBytes = utf8.encode('$domain:');
      final payloadBytes = <int>[...prefixBytes, ...challengeBytes];

      _log.d(
        '[SIGN-ACTIVE][2.1] Przygotowano payloadBytes (${payloadBytes.length} B). '
        'Prefix len: ${prefixBytes.length}, Challenge len: ${challengeBytes.length}',
      );

      // 3. Podpisywanie Ed25519
      _log.i('[SIGN-ACTIVE][3] Wykonuję podpis algorytmem Ed25519...');
      final algorithm = Ed25519();
      final signature = await algorithm.sign(
        payloadBytes,
        keyPair: _activeDeviceKeyPair!,
      );

      // 4. Kodowanie podpisu do standardowego Base64
      final signatureBase64 = base64Encode(signature.bytes);
      _log.i(
        '[SIGN-ACTIVE][4] ✅ Challenge podpisany pomyślnie. Podpis (Base64): $signatureBase64',
      );

      return signatureBase64;
    } catch (e, st) {
      _log.e(
        '[SIGN-ACTIVE][ERR] Błąd podczas podpisywania challenge\'a',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  Future<void> finalizeAndPersist(List<int> pinBytes, List<int> salt) async {
    _log.i(
      '[FINALIZE-PERSIST][1] Rozpoczynam procedurę szyfrowania i zapisu kluczy urządzenia...',
    );

    if (_activeDeviceKeyPair == null) {
      _log.e(
        '[FINALIZE-PERSIST][1.1] KRITYCZNY BŁĄD: _activeDeviceKeyPair jest NULL! Przerywam zapis.',
      );
      return;
    }

    _log.d(
      '[FINALIZE-PERSIST][1.2] Parametry wejściowe do KDF: pinBytes=$pinBytes (len: ${pinBytes.length}), '
      'saltLen=${salt.length}, salt (pierwsze 4 bajty): ${salt.take(4).toList()}',
    );

    try {
      // 2. Ekstrakcja klucza prywatnego z pary
      _log.i(
        '[FINALIZE-PERSIST][2] Ekstrakcja bajtów klucza prywatnego z _activeDeviceKeyPair...',
      );
      final privateKeyData = await _activeDeviceKeyPair!.extract();
      final privKeyBytes = privateKeyData.bytes;
      _log.d(
        '[FINALIZE-PERSIST][2.1] Wyekstrahowano privKeyBytes, długość: ${privKeyBytes.length}',
      );

      // 3. Generowanie KEK za pomocą KDF
      _log.i('[FINALIZE-PERSIST][3] Wywołuję KDF: deriveKeyFromPin...');
      final kek = await ref
          .read(kdfServiceProvider)
          .deriveKeyFromPin(pinBytes: pinBytes, salt: salt);

      final kekBytes = await kek.extractBytes();
      _log.d(
        '[FINALIZE-PERSIST][3.1] Wygenerowano KEK. Długość bajtów KEK: ${kekBytes.length}',
      );

      // 4. Szyfrowanie AES-GCM (256 bits)
      _log.i(
        '[FINALIZE-PERSIST][4] Szyfrowanie klucza prywatnego algorytmem AES-GCM...',
      );
      final secretBox = await AesGcm.with256bits().encrypt(
        privKeyBytes,
        secretKey: kek,
      );

      final encryptedData = secretBox.concatenation();
      _log.d(
        '[FINALIZE-PERSIST][4.1] Szyfrowanie zakończone. Długość połączonego szyfrogramu (Nonce + Ciphertext + MAC): ${encryptedData.length} bajtów. '
        'MAC len: ${secretBox.mac.bytes.length}, Nonce len: ${secretBox.nonce.length}',
      );

      // 5. Zapis szyfrogramu do SecureStorage
      final storage = ref.read(secureStorageProvider);
      final encryptedBase64 = base64Encode(encryptedData);

      _log.i(
        '[FINALIZE-PERSIST][5] Zapisuję zaszyfrowany klucz prywatny pod kluczem: ${StorageKeys.devicePrivateKey}',
      );
      _log.d(
        '[FINALIZE-PERSIST][5.1] Długość łańcucha Base64 klucza prywatnego: ${encryptedBase64.length}',
      );

      await storage.write(
        key: StorageKeys.devicePrivateKey,
        value: encryptedBase64,
      );

      // 6. Ekstrakcja i zapis klucza publicznego
      _log.i('[FINALIZE-PERSIST][6] Ekstrakcja i zapis klucza publicznego...');
      final publicKey = await _activeDeviceKeyPair!.extractPublicKey();
      final pubKeyBase64 = base64Encode(publicKey.bytes);

      _log.d(
        '[FINALIZE-PERSIST][6.1] Długość bajtów klucza publicznego: ${publicKey.bytes.length}',
      );

      await storage.write(
        key: StorageKeys.devicePublicKey,
        value: pubKeyBase64,
      );

      _log.i(
        '✅ [FINALIZE-PERSIST][7] Klucze urządzenia zostały pomyślnie zaszyfrowane i zapisane w SecureStorage.',
      );

      // 7. Czyszczenie bajtów w pamięci
      _log.i(
        '[FINALIZE-PERSIST][8] Czyszczenie bajtów surowego klucza prywatnego z RAM (wipe)...',
      );
      ref.read(kdfServiceProvider).wipe(privKeyBytes);
      _log.d('[FINALIZE-PERSIST][8.1] Czyszczenie pamięci zakonczone.');

      // ❌ USUNIĘTO: _activeDeviceKeyPair = null;
      // Klucz zostaje w RAM, dopóki registerTrustedDevice nie złoży podpisu!
      _log.d(
        '[FINALIZE-PERSIST][9] _activeDeviceKeyPair pozostaje w RAM dla podpisu rejestracji.',
      );
    } catch (e, st) {
      _log.e(
        '❌ [FINALIZE-PERSIST][ERR] Błąd podczas zaszyfrowywania lub zapisu kluczy w SecureStorage!',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }
}
