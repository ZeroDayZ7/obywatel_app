import 'dart:convert';
import 'dart:io';

import 'package:advertising_id/advertising_id.dart';
import 'package:crypto/crypto.dart' as standard_crypto;
import 'package:cryptography/cryptography.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:device_marketing_names/device_marketing_names.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

// 1. Dodaj wygenerowany plik
part 'device_info_service.g.dart';

// 2. Wygeneruj provider za pomocą adnotacji @riverpod
@Riverpod(keepAlive: true)
DeviceInfoService deviceInfoService(Ref ref) {
  return DeviceInfoService();
}

class DeviceInfoService {
  SimpleKeyPair? _activeKeyPair;
  bool get isUnlocked => _activeKeyPair != null;
  final _algorithm = AesGcm.with256bits();
  final _deviceMarketingNames = DeviceMarketingNames();
  final _storage = const FlutterSecureStorage();
  final _deviceInfo = DeviceInfoPlugin();
  final _log = Logger();

  // 1. Odblokowanie (Wywoływane raz przy wejściu do apki / loginie)
  Future<void> unlockWithPin(List<int> pinBytes) async {
    try {
      // Pobieramy ID urządzenia bezpośrednio ze storage wewnątrz serwisu
      String? deviceId = await _storage.read(key: 'app_device_id');

      if (deviceId == null) {
        _log.e('🚨 Nie znaleziono app_device_id podczas odblokowywania!');
        throw Exception('Urządzenie nie zostało zainicjalizowane (brak ID).');
      }

      _activeKeyPair = await getStoredKeyPair(
        pinBytes: pinBytes,
        deviceId: deviceId,
      );

      _log.i('🔓 Skarbiec odblokowany dla urządzenia: $deviceId');
    } catch (e) {
      _activeKeyPair = null;
      _log.e('❌ Błąd odblokowania skarbca: $e');
      rethrow;
    }
  }

  // 2. Bezpieczne podpisywanie (Używane w całej aplikacji)
  Future<String> signData(String data) async {
    if (_activeKeyPair == null) {
      throw Exception('Vault locked! Wymagane odblokowanie aplikacji.');
    }

    final message = utf8.encode(data);
    final signature = await Ed25519().sign(message, keyPair: _activeKeyPair!);
    return base64Encode(signature.bytes);
  }

  // 3. Blokowanie (Wywoływane przy logout lub gdy apka idzie do tła)
  void lock() {
    _activeKeyPair = null; // Usuwamy klucz z RAM
    _log.i('🔒 Skarbiec zablokowany');
  }

  /// Generuje klucz AES z PIN-u użytkownika przy użyciu PBKDF2
  Future<SecretKey> deriveKeyFromPin(List<int> pinBytes, String userId) async {
    final pbkdf2 = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: 10000,
      bits: 256,
    );

    return await pbkdf2.deriveKey(
      secretKey: SecretKey(pinBytes),
      nonce: utf8.encode(userId),
    );
  }

  /// Szyfruje dane za pomocą klucza z PIN-u
  Future<String> encryptWithPin({
    required String plainText,
    required List<int> pinBytes,
    required String userId,
  }) async {
    final secretKey = await deriveKeyFromPin(pinBytes, userId);
    final nonce = _algorithm.newNonce();

    final secretBox = await _algorithm.encrypt(
      utf8.encode(plainText),
      secretKey: secretKey,
      nonce: nonce,
    );

    return base64Encode(secretBox.concatenation());
  }

  /// Deszyfruje dane za pomocą PIN-u
  Future<String> decryptWithPin({
    required String encryptedBase64,
    required List<int> pinBytes,
    required String userId,
  }) async {
    try {
      final secretKey = await deriveKeyFromPin(pinBytes, userId);
      final combinedBytes = base64Decode(encryptedBase64);

      final secretBox = SecretBox.fromConcatenation(
        combinedBytes,
        nonceLength: _algorithm.nonceLength,
        macLength: _algorithm.macAlgorithm.macLength,
      );

      final clearBytes = await _algorithm.decrypt(
        secretBox,
        secretKey: secretKey,
      );

      return utf8.decode(clearBytes);
    } catch (e) {
      _log.e('Błąd deszyfrowania danych PIN-em: $e');
      return "Zaszyfrowane dane";
    }
  }

  Future<String> getPlatformName() async {
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    if (Platform.isWindows) return 'windows';
    if (Platform.isMacOS) return 'macos';
    if (Platform.isLinux) return 'linux';
    return 'unknown';
  }

  /// Pobiera wszystkie dane urządzenia i zwraca jako Map
  Future<Map<String, dynamic>> collectDeviceInfo() async {
    final Map<String, dynamic> deviceData = {};
    String? storedId = await _storage.read(key: 'app_device_id');

    if (storedId == null) {
      storedId = const Uuid().v4();
      await _storage.write(key: 'app_device_id', value: storedId);
    }

    String? advertisingId;
    try {
      if (Platform.isAndroid) {
        advertisingId = await AdvertisingId.id(true);
      }
    } catch (e) {
      _log.w('Nie udało się pobrać Advertising ID: $e');
    }

    if (Platform.isAndroid) {
      final info = await _deviceInfo.androidInfo;
      deviceData.addAll({
        'platform': 'android',
        'manufacturer': info.manufacturer,
        'model': info.model,
        'androidId': info.id,
        'isPhysicalDevice': info.isPhysicalDevice,
      });
    } else if (Platform.isIOS) {
      final info = await _deviceInfo.iosInfo;
      deviceData.addAll({
        'platform': 'ios',
        'identifierForVendor': info.identifierForVendor,
        'model': info.model,
        'isPhysicalDevice': info.isPhysicalDevice,
      });
    }

    return {
      'app_device_id_secure': storedId,
      'advertising_id': advertisingId,
      'device_info': deviceData,
    };
  }

  /// Tworzy unikalny hash urządzenia
  Future<String> getSecureFingerprint() async {
    final data = await collectDeviceInfo();
    final info = data['device_info'] as Map<String, dynamic>;

    List<String> components = [];
    if (Platform.isAndroid) {
      String aId = (info['androidId'] ?? '').toString();
      if (aId == "9774d56d682e549c" || aId.isEmpty) aId = "fallback_id";
      components.add(aId);
      components.add(info['model'] ?? 'unknown');
    } else if (Platform.isIOS) {
      components.add(info['identifierForVendor'] ?? 'unknown');
    }

    final cleanComponents = components
        .map((e) => e.toString().trim().toLowerCase())
        .join('|');

    final String rawFingerprint =
        "$cleanComponents|${data['app_device_id_secure']}";

    // POPRAWKA: Używamy aliasu standard_crypto
    final bytes = utf8.encode(rawFingerprint);
    return standard_crypto.sha256.convert(bytes).toString();
  }

  /// Pobiera czytelną nazwę (np. "iPhone 13")
  Future<String> getMarketingName() async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        return await _deviceMarketingNames.getSingleName();
      }
    } catch (e) {
      _log.w('Marketing name error: $e');
    }
    return Platform.operatingSystem;
  }

  /// Zarządzanie Master Key (AES)
  Future<List<int>> generateMasterKey() async {
    final key = await _algorithm.newSecretKey();
    final bytes = await key.extractBytes();
    await _storage.write(key: 'device_master_key', value: base64Encode(bytes));
    return bytes;
  }

  Future<String> encryptDeviceName(String name, List<int> masterKey) async {
    final secretKey = SecretKey(masterKey);
    final nonce = _algorithm.newNonce();
    final box = await _algorithm.encrypt(
      utf8.encode(name),
      secretKey: secretKey,
      nonce: nonce,
    );
    return base64Encode(box.concatenation());
  }

  /// Klucze asymetryczne (Ed25519) - ZASZYFROWANE PIN-em
  Future<SimpleKeyPair> generateDeviceKeyPair({
    required List<int> pinBytes,
    required String userId,
  }) async {
    final algorithm = Ed25519();
    final keyPair = await algorithm.newKeyPair();
    final privateKeyBytes = await keyPair.extractPrivateKeyBytes();

    // Konwertujemy klucz prywatny na String, żeby go zaszyfrować
    final String rawKey = base64Encode(privateKeyBytes);

    // Szyfrujemy PIN-em
    final encryptedKey = await encryptWithPin(
      plainText: rawKey,
      pinBytes: pinBytes,
      userId: userId,
    );

    await _storage.write(
      key: 'device_private_key_encrypted',
      value: encryptedKey,
    );

    _log.i('✅ Wygenerowano parę kluczy i zaszyfrowano PIN-em');
    return keyPair;
  }

  Future<SimpleKeyPair> getStoredKeyPair({
    required List<int> pinBytes,
    required String deviceId,
  }) async {
    final encryptedKey = await _storage.read(
      key: 'device_private_key_encrypted',
    );

    if (encryptedKey == null) {
      throw Exception('Brak zaszyfrowanego klucza w bezpiecznej pamięci.');
    }

    final decryptedRaw = await decryptWithPin(
      encryptedBase64: encryptedKey,
      pinBytes: pinBytes,
      userId: deviceId, // deviceId służy jako sól (nonce)
    );

    if (decryptedRaw == "Zaszyfrowane dane") {
      throw Exception('Niepoprawny PIN (błąd deszyfrowania klucza).');
    }

    final privateKeyBytes = base64Decode(decryptedRaw);
    return Ed25519().newKeyPairFromSeed(privateKeyBytes);
  }

  /// Helper łączący pobieranie nazwy i szyfrowanie
  Future<String> getEncryptedMarketingName() async {
    String? storedMasterKey = await _storage.read(key: 'device_master_key');
    List<int> masterKeyBytes;

    if (storedMasterKey == null) {
      masterKeyBytes = await generateMasterKey();
    } else {
      masterKeyBytes = base64Decode(storedMasterKey);
    }

    final name = await getMarketingName();
    return encryptDeviceName(name, masterKeyBytes);
  }

  Future<String> decryptDeviceName(String encryptedBase64) async {
    try {
      final storedMasterKey = await _storage.read(key: 'device_master_key');
      if (storedMasterKey == null) return "Unknown Device";

      final masterKeyBytes = base64Decode(storedMasterKey);
      final secretKey = SecretKey(masterKeyBytes);
      final combinedBytes = base64Decode(encryptedBase64);

      final box = SecretBox.fromConcatenation(
        combinedBytes,
        nonceLength: 12,
        macLength: 16,
      );

      final clearBytes = await _algorithm.decrypt(box, secretKey: secretKey);
      return utf8.decode(clearBytes);
    } catch (e) {
      _log.e('Błąd deszyfrowania nazwy urządzenia: $e');
      return "Encrypted Device";
    }
  }

  /// Podpisuje challenge (UUID) przy użyciu klucza prywatnego urządzenia
  Future<String> signChallenge(String challenge, SimpleKeyPair keyPair) async {
    try {
      final message = utf8.encode(challenge);
      final signature = await Ed25519().sign(message, keyPair: keyPair);
      return base64Encode(signature.bytes);
    } catch (e) {
      _log.e('Błąd podczas podpisywania challenge: $e');
      throw Exception('Nie udało się podpisać wyzwania bezpieczeństwa.');
    }
  }
}
