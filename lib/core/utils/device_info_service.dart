import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:advertising_id/advertising_id.dart';
import 'package:logger/logger.dart';

class DeviceInfoService {
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
}
