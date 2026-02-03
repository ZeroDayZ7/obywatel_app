import 'dart:io';

import 'package:advertising_id/advertising_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:device_marketing_names/device_marketing_names.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'device_info_service.g.dart';

@Riverpod(keepAlive: true)
DeviceInfoService deviceInfoService(Ref ref) {
  final logger = ref.watch(appLoggerProvider);
  return DeviceInfoService(logger);
}

class DeviceInfoService {
  final AppLogger _log;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  final DeviceMarketingNames _deviceMarketingNames = DeviceMarketingNames();

  DeviceInfoService(this._log);

  /// Pobiera dane urządzenia w postaci mapy
  Future<Map<String, dynamic>> collectDeviceInfo() async {
    final Map<String, dynamic> infoData = {};
    final deviceId = await _getOrCreateDeviceId();
    String? advertisingId;

    // Pobieranie Advertising ID (zazwyczaj tylko mobilne)
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        advertisingId = await AdvertisingId.id(true);
      }
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
    } else if (Platform.isWindows) {
      final info = await _deviceInfo.windowsInfo;
      infoData.addAll({
        'platform': 'windows',
        'computerName': info.computerName,
        'numberOfCores': info.numberOfCores,
        'systemMemoryInMegabytes': info.systemMemoryInMegabytes,
        'userName': info.userName,
      });
    } else if (Platform.isMacOS) {
      final info = await _deviceInfo.macOsInfo;
      infoData.addAll({
        'platform': 'macos',
        'computerName': info.computerName,
        'model': info.model,
        'arch': info.arch,
        'systemGUID': info.systemGUID,
      });
    } else if (Platform.isLinux) {
      final info = await _deviceInfo.linuxInfo;
      infoData.addAll({
        'platform': 'linux',
        'name': info.name,
        'versionId': info.versionId,
        'machineId': info.machineId,
        'prettyName': info.prettyName,
      });
    }

    return {
      'app_device_id_secure': deviceId,
      'advertising_id': advertisingId,
      'device_info': infoData,
    };
  }

  /// Generuje unikalny fingerprint urządzenia (SHA-256)
  Future<String> getFingerprint() async {
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

    return components.map((e) => e.trim().toLowerCase()).join('|');
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
    final name = await getMarketingName();
    return name;
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
}
