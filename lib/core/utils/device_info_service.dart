import 'dart:convert';
import 'dart:io';

import 'package:advertising_id/advertising_id.dart';
import 'package:crypto/crypto.dart';
import 'package:cryptography/cryptography.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:device_marketing_names/device_marketing_names.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

// PRZENIESIONO: Provider musi być poza klasą, aby był widoczny globalnie
final deviceInfoServiceProvider = Provider<DeviceInfoService>((ref) {
  return DeviceInfoService();
});

class DeviceInfoService {
  final _algorithm = AesGcm.with256bits();
  final _deviceMarketingNames = DeviceMarketingNames();
  final _storage = const FlutterSecureStorage();
  final _deviceInfo = DeviceInfoPlugin();
  final _log = Logger();

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
    } else if (Platform.isWindows) {
      final info = await _deviceInfo.windowsInfo;
      deviceData.addAll({
        'platform': 'windows',
        'computerName': info.computerName,
        'numberOfCores': info.numberOfCores,
      });
    }

    final result = {
      'app_device_id_secure': storedId,
      'advertising_id': advertisingId,
      'device_info': deviceData,
    };

    return result;
  }

  /// Tworzy unikalny hash urządzenia
  Future<String> getSecureFingerprint(String userId) async {
    final data = await collectDeviceInfo();
    final info = data['device_info'] as Map<String, dynamic>;

    List<String> components = [];

    if (Platform.isAndroid) {
      String aId = (info['androidId'] ?? '').toString();
      if (aId == "9774d56d682e549c" || aId.isEmpty) {
        aId = "fallback_id";
      }
      components.add(aId);
      components.add(info['model'] ?? 'unknown');
    } else if (Platform.isIOS) {
      components.add(info['identifierForVendor'] ?? 'unknown');
    } else {
      components.add(info['computerName'] ?? 'pc');
    }

    final cleanComponents = components
        .map((e) => e.toString().trim().toLowerCase())
        .join('|');

    final String rawFingerprint =
        "$cleanComponents|${data['app_device_id_secure']}|$userId";

    final bytes = utf8.encode(rawFingerprint);
    return sha256.convert(bytes).toString();
  }

  /// Pobiera czytelną nazwę (np. "iPhone 13")
  Future<String> getMarketingName() async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        return await _deviceMarketingNames.getSingleName();
      }
      if (Platform.isWindows) return "Windows PC";
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

  /// Klucze asymetryczne (Ed25519) do podpisywania logowań
  Future<SimpleKeyPair> generateDeviceKeyPair() async {
    final algorithm = Ed25519();
    final keyPair = await algorithm.newKeyPair();
    final privateKeyBytes = await keyPair.extractPrivateKeyBytes();

    await _storage.write(
      key: 'device_private_key',
      value: base64Encode(privateKeyBytes),
    );

    _log.i('✅ Wygenerowano parę kluczy Ed25519');
    return keyPair;
  }

  Future<SimpleKeyPair> getStoredKeyPair() async {
    final storedRaw = await _storage.read(key: 'device_private_key');
    if (storedRaw == null) {
      throw Exception('Brak klucza prywatnego urządzenia.');
    }

    final privateKeyBytes = base64Decode(storedRaw);
    final algorithm = Ed25519();

    // Klucze Ed25519 można odtworzyć z samego seeda (bajty klucza prywatnego)
    return algorithm.newKeyPairFromSeed(privateKeyBytes);
  }

  /// Helper łączący pobieranie nazwy i szyfrowanie
  Future<String> getEncryptedMarketingName() async {
    // 1. Sprawdzamy czy mamy Master Key, jak nie to generujemy
    String? storedMasterKey = await _storage.read(key: 'device_master_key');
    List<int> masterKeyBytes;

    if (storedMasterKey == null) {
      masterKeyBytes = await generateMasterKey();
    } else {
      masterKeyBytes = base64Decode(storedMasterKey);
    }

    // 2. Pobieramy nazwę (np. iPhone 13)
    final name = await getMarketingName();

    // 3. Szyfrujemy
    return encryptDeviceName(name, masterKeyBytes);
  }

  // DeviceInfoService
  Future<String> decryptDeviceName(String encryptedBase64) async {
    try {
      // 1. Pobierz Master Key z Secure Storage
      final storedMasterKey = await _storage.read(key: 'device_master_key');
      if (storedMasterKey == null) return "Unknown Device";

      final masterKeyBytes = base64Decode(storedMasterKey);
      final secretKey = SecretKey(masterKeyBytes);

      // 2. Rozkoduj Base64 do bajtów
      final combinedBytes = base64Decode(encryptedBase64);

      // 3. Wyodrębnij Nonce (AesGcm domyślnie używa 12 bajtów)
      // Twój kod w encryptDeviceName używał box.concatenation()
      final box = SecretBox.fromConcatenation(
        combinedBytes,
        nonceLength: 12,
        macLength: 16,
      );

      // 4. Deszyfruj
      final clearBytes = await _algorithm.decrypt(box, secretKey: secretKey);

      return utf8.decode(clearBytes);
    } catch (e) {
      _log.e('Błąd deszyfrowania nazwy urządzenia: $e');
      return "Encrypted Device"; // Fallback
    }
  }
}
