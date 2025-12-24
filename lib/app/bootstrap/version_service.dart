import 'dart:convert';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:obywatel_plus/core/network/public_client.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/network/api_endpoints.dart';

class VersionData {
  final String minVersion;
  final String latestVersion;
  final bool forceUpdate;
  final String windowsUrl;

  VersionData({
    required this.minVersion,
    required this.latestVersion,
    required this.forceUpdate,
    required this.windowsUrl,
  });
}

class VersionService {
  final PublicApiClient _api;
  final AppLogger _logger;

  const VersionService(this._api, this._logger);

  Future<String> currentVersion() async {
    _logger.i('VersionService.currentVersion: reading version from device');

    try {
      final info = await PackageInfo.fromPlatform();
      _logger.i('VersionService.currentVersion: version = ${info.version}');
      return info.version;
    } catch (e, s) {
      _logger.e(
        'VersionService.currentVersion: failed to get version',
        error: e,
        stackTrace: s,
      );
      return '0.0.0';
    }
  }

  bool isBelowMinimum(String current, String minimum) {
    _logger.i(
      'VersionService.isBelowMinimum: comparing current=$current with minimum=$minimum',
    );

    List<int> toParts(String v) =>
        v.split('.').map((s) => int.tryParse(s) ?? 0).toList();

    final a = toParts(current);
    final b = toParts(minimum);

    final len = a.length > b.length ? a.length : b.length;

    for (int i = 0; i < len; i++) {
      final ai = i < a.length ? a[i] : 0;
      final bi = i < b.length ? b[i] : 0;

      if (ai < bi) {
        _logger.i(
          'VersionService.isBelowMinimum: $current is BELOW minimum ($minimum)',
        );
        return true;
      }
      if (ai > bi) {
        _logger.i(
          'VersionService.isBelowMinimum: $current is ABOVE minimum ($minimum)',
        );
        return false;
      }
    }

    _logger.i(
      'VersionService.isBelowMinimum: $current == $minimum -> not below',
    );

    return false;
  }

  Future<VersionData> fetchVersionData() async {
    try {
      final resp = await _api.get(ApiEndpoints.checkVersion);

      _logger.i('VersionService.fetchVersionData: raw response = ${resp.data}');

      if (resp.statusCode == 200 && resp.data is Map<String, dynamic>) {
        final data = resp.data as Map<String, dynamic>;

        _logger.i(
          'VersionService.fetchVersionData: parsed JSON = ${jsonEncode(data)}',
        );

        return VersionData(
          minVersion: data['minVersion'] as String? ?? '0.0.0',
          latestVersion: data['latestVersion'] as String? ?? '0.0.0',
          forceUpdate: data['forceUpdate'] as bool? ?? false,
          windowsUrl: data['updateUrlWindows'] as String? ?? '',
        );
      }

      _logger.w(
        'VersionService.fetchVersionData: unexpected response, returning defaults',
      );
      return VersionData(
        minVersion: '0.0.0',
        latestVersion: '0.0.0',
        forceUpdate: false,
        windowsUrl: '',
      );
    } catch (e, s) {
      _logger.e(
        'VersionService.fetchVersionData failed',
        error: e,
        stackTrace: s,
      );
      return VersionData(
        minVersion: '0.0.0',
        latestVersion: '0.0.0',
        forceUpdate: false,
        windowsUrl: '',
      );
    }
  }
}
