import 'dart:convert';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:obywatel_plus/core/network/public_api_client.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/network/api_endpoints.dart';

class VersionService {
  final PublicApiClient _api;
  final AppLogger _logger;

  const VersionService(this._api, this._logger);

  Future<String> currentVersion() async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }

  Future<String> fetchMinimumSupportedVersion() async {
    final resp = await _api.get(ApiEndpoints.checkVersion);

    if (resp.statusCode == 200) {
      final data = resp.data;
      if (data is Map<String, dynamic>) {
        return (data['minimum_supported'] as String?) ?? '0.0.0';
      }
      if (data is String) {
        final parsed = jsonDecode(data);
        return (parsed['minimum_supported'] as String?) ?? '0.0.0';
      }
    }

    _logger.w(
      'VersionService: unexpected response; defaulting min version to 0.0.0',
    );
    return '0.0.0';
  }

  bool isBelowMinimum(String current, String minimum) {
    List<int> toParts(String v) =>
        v.split('.').map((s) => int.tryParse(s) ?? 0).toList();

    final a = toParts(current);
    final b = toParts(minimum);
    final len = a.length > b.length ? a.length : b.length;

    for (int i = 0; i < len; i++) {
      final ai = i < a.length ? a[i] : 0;
      final bi = i < b.length ? b[i] : 0;
      if (ai < bi) return true;
      if (ai > bi) return false;
    }
    return false;
  }
}
