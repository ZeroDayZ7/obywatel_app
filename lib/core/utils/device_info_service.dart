import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:advertising_id/advertising_id.dart';
import 'package:cryptography/cryptography.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:device_marketing_names/device_marketing_names.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:obywatel_plus/core/crypto/asymmetric_crypto.dart';
import 'package:obywatel_plus/core/crypto/kdf_service.dart';
import 'package:obywatel_plus/core/crypto/symmetric_crypto.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'device_info_service.g.dart';

@Riverpod(keepAlive: true)
DeviceInfoService deviceInfoService(Ref ref) {
  final logger = ref.watch(appLoggerProvider);
  final symmetric = ref.watch(symmetricCryptoProvider);
  final kdf = ref.watch(kdfServiceProvider);
  final asymmetric = ref.watch(asymmetricCryptoProvider);
  return DeviceInfoService(logger, symmetric, kdf, asymmetric);
}

class DeviceInfoService {
  final AppLogger _log;
  final SymmetricCrypto _symmetric;
  final KdfService _kdf;
  final AsymmetricCrypto _asymmetric;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  final DeviceMarketingNames _deviceMarketingNames = DeviceMarketingNames();

  SimpleKeyPair? _activeKeyPair;
  bool get isUnlocked => _activeKeyPair != null;

  DeviceInfoService(this._log, this._symmetric, this._kdf, this._asymmetric);

  /// Odblokowanie vault za pomocą PIN-u
  Future<void> unlockWithPin(List<int> pinBytes) async {
    try {
      final deviceId = await _getOrCreateDeviceId();
      final privateKeyBytes = <int>[];
      _activeKeyPair = await _asymmetric.getStoredKeyPair(
        privateKeyBytes: privateKeyBytes,
      );
      _log.i('Vault odblokowany dla urządzenia: $deviceId');
    } catch (e) {
      _activeKeyPair = null;
      _log.e('Błąd odblokowania vault: $e');
      rethrow;
    }
  }

  void lock() {
    _activeKeyPair = null;
    _log.i('Vault zablokowany');
  }

  /// Podpisuje challenge UUID
  Future<String> signChallenge(String challenge) async {
    if (_activeKeyPair == null) {
      throw Exception('Vault locked! Odblokuj najpierw.');
    }
    return _asymmetric.signBytes(
      message: Uint8List.fromList(utf8.encode(challenge)),
      keyPair: _activeKeyPair!,
    );
  }

  /// Pobiera dane urządzenia w postaci mapy
  Future<Map<String, dynamic>> collectDeviceInfo() async {
    final Map<String, dynamic> infoData = {};
    final deviceId = await _getOrCreateDeviceId();
    String? advertisingId;

    try {
      if (Platform.isAndroid) advertisingId = await AdvertisingId.id(true);
    } catch (e) {
      _log.w('Nie udało się pobrać Advertising ID: $e');
    }

    if (Platform.isAndroid) {
      final info = await _deviceInfo.androidInfo;
      infoData.addAll({
        'platform': 'android',
        'manufacturer': info.manufacturer,
        'model': info.model,
        'androidId': info.id,
        'isPhysicalDevice': info.isPhysicalDevice,
      });
    } else if (Platform.isIOS) {
      final info = await _deviceInfo.iosInfo;
      infoData.addAll({
        'platform': 'ios',
        'identifierForVendor': info.identifierForVendor,
        'model': info.model,
        'isPhysicalDevice': info.isPhysicalDevice,
      });
    }

    return {
      'app_device_id_secure': deviceId,
      'advertising_id': advertisingId,
      'device_info': infoData,
    };
  }

  /// Generuje unikalny fingerprint urządzenia (SHA-256)
  Future<String> getSecureFingerprint() async {
    final data = await collectDeviceInfo();
    final info = data['device_info'] as Map<String, dynamic>;

    final components = <String>[
      Platform.isAndroid
          ? ((info['androidId'] ?? '').toString() == '9774d56d682e549c'
                ? 'fallback_id'
                : info['androidId'] ?? 'unknown')
          : (info['identifierForVendor'] ?? 'unknown'),
      info['model'] ?? 'unknown',
      data['app_device_id_secure'] ?? 'unknown',
    ];

    final raw = components.map((e) => e.trim().toLowerCase()).join('|');
    return _kdf.sha256Hash(utf8.encode(raw));
  }

  /// Pobiera marketingową nazwę urządzenia (iPhone 13, Pixel 7)
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

  /// Encrypt / Decrypt dla nazwy urządzenia przy użyciu MasterKey
  Future<String> getEncryptedMarketingName() async {
    final masterKey = await _getOrCreateMasterKey();
    final name = await getMarketingName();
    return _symmetric.encryptString(clearText: name, secretKey: masterKey);
  }

  Future<String> decryptDeviceName(String encrypted) async {
    final masterKey = await _getOrCreateMasterKey();
    return _symmetric.decryptString(
      encryptedBase64: encrypted,
      secretKey: masterKey,
    );
  }

  /// Prywatne helpery
  Future<String> _getOrCreateDeviceId() async {
    var id = await _storage.read(key: StorageKeys.appDeviceId);
    if (id == null) {
      id = const Uuid().v4();
      await _storage.write(key: StorageKeys.appDeviceId, value: id);
    }
    return id;
  }

  Future<SecretKey> _getOrCreateMasterKey() async {
    final stored = await _storage.read(key: 'device_master_key');
    if (stored != null) return SecretKey(base64Decode(stored));

    final newKey = await _symmetric.generateMasterKey();
    return newKey;
  }

  Future<SimpleKeyPair> generateDeviceKeyPair() async {
    return _asymmetric.generateKeyPair();
  }
}
