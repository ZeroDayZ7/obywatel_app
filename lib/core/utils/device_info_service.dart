import 'dart:convert';
import 'dart:io';

import 'package:advertising_id/advertising_id.dart';
import 'package:crypto/crypto.dart';
import 'package:cryptography/cryptography.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:device_marketing_names/device_marketing_names.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

class DeviceInfoService {
  final _algorithm = AesGcm.with256bits();
  final _deviceMarketingNames = DeviceMarketingNames();
  final _storage = const FlutterSecureStorage();
  final _deviceInfo = DeviceInfoPlugin();
  final _log = Logger();

  /// Pobiera wszystkie możliwe dane urządzenia i zwraca jako Map
  Future<Map<String, dynamic>> collectDeviceInfo() async {
    final Map<String, dynamic> deviceData = {};
    String? storedId = await _storage.read(key: 'app_device_id');

    // Generowanie bezpiecznego UUID jeśli brak
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
      advertisingId = null;
    }

    // Pobranie informacji specyficznych dla platformy
    if (Platform.isAndroid) {
      final info = await _deviceInfo.androidInfo;
      deviceData.addAll({
        'platform': 'android',
        'manufacturer': info.manufacturer,
        'model': info.model,
        'device': info.device,
        'version_sdkInt': info.version.sdkInt,
        'version_release': info.version.release,
        'board': info.board,
        'brand': info.brand,
        'hardware': info.hardware,
        'isPhysicalDevice': info.isPhysicalDevice,
        'androidId': info.id,
        'supportedAbis': info.supportedAbis,
      });
    } else if (Platform.isIOS) {
      final info = await _deviceInfo.iosInfo;
      deviceData.addAll({
        'platform': 'ios',
        'name': info.name,
        'systemName': info.systemName,
        'systemVersion': info.systemVersion,
        'model': info.model,
        'localizedModel': info.localizedModel,
        'identifierForVendor': info.identifierForVendor,
        'isPhysicalDevice': info.isPhysicalDevice,
      });
    } else if (Platform.isWindows) {
      final info = await _deviceInfo.windowsInfo;
      deviceData.addAll({
        'platform': 'windows',
        'computerName': info.computerName,
        'numberOfCores': info.numberOfCores,
        'systemMemoryInMegabytes': info.systemMemoryInMegabytes,
        'userName': info.userName,
      });
    } else if (Platform.isLinux) {
      final info = await _deviceInfo.linuxInfo;
      deviceData.addAll({
        'platform': 'linux',
        'name': info.name,
        'version': info.version,
        'id': info.id,
        'machineId': info.machineId,
      });
    } else if (Platform.isMacOS) {
      final info = await _deviceInfo.macOsInfo;
      deviceData.addAll({
        'platform': 'macos',
        'computerName': info.computerName,
        'osRelease': info.osRelease,
        'arch': info.arch,
      });
    }

    final result = {
      'app_device_id_secure': storedId,
      'advertising_id': advertisingId,
      'device_info': deviceData,
    };

    // Używamy loggera zamiast print
    _log.i('===== DEVICE INFO =====');
    _log.d(result);
    _log.i('=======================');

    return result;
  }

  Future<String> getSecureFingerprint(String userId) async {
    final data = await collectDeviceInfo();
    final info = data['device_info'] as Map<String, dynamic>;

    List<String> components = [];

    if (Platform.isAndroid) {
      // Android ID + parametry sprzętowe dla unikalności
      String aId = (info['androidId'] ?? '').toString();
      if (aId == "9774d56d682e549c" || aId.isEmpty) {
        aId = "${info['board']}-${info['hardware']}";
      }
      components.add(aId);
      components.add(info['brand'] ?? 'unknown_brand');
      components.add(info['model'] ?? 'unknown_model');
    } else if (Platform.isIOS) {
      components.add(info['identifierForVendor'] ?? 'unknown_vendor');
      components.add(info['model'] ?? 'unknown_model');
    } else {
      // Desktop: machineId jest najstabilniejszy
      components.add(
        info['machineId'] ?? info['id'] ?? info['computerName'] ?? 'unknown_pc',
      );
    }

    // 1. Normalizacja komponentów
    final cleanComponents = components
        .map((e) => e.toString().trim().toLowerCase())
        .join('|');

    // 2. Budowa finalnego ziarna (Seed)
    // app_device_id_secure (UUID z storage) jest kluczowy, bo przetrwa update aplikacji
    final String rawFingerprint =
        "$cleanComponents|${data['app_device_id_secure']}|$userId";

    // 3. Hashowanie
    final bytes = utf8.encode(rawFingerprint);
    return sha256.convert(bytes).toString();
  }

  Future<String> getMarketingName() async {
    try {
      // Jeśli używasz tej biblioteki, nie potrzebujesz ręcznie wyciągać 'info'
      // biblioteka sama sprawdzi czy to iOS czy Android.

      if (Platform.isAndroid || Platform.isIOS) {
        // ZAMIAST: final info = await _deviceInfo.androidInfo; (to usuwamy)
        return await _deviceMarketingNames.getSingleName();
      }

      if (Platform.isWindows) return "Windows PC";
      if (Platform.isMacOS) return "Mac";
      if (Platform.isLinux) return "Linux Workstation";
    } catch (e) {
      _log.w('Nie udało się pobrać nazwy marketingowej: $e');
    }
    return Platform.operatingSystem;
  }

  Future<List<int>> generateMasterKey() async {
    // Generujemy losowy 256-bitowy klucz
    final key = await _algorithm.newSecretKey();
    final bytes = await key.extractBytes();

    // Zapisujemy go bezpiecznie - to nasz "Root of Trust" dla tego urządzenia
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

    // Zwracamy połączenie nonce + ciphertext, żeby dało się to odszyfrować
    return base64Encode(box.concatenation());
  }
}
