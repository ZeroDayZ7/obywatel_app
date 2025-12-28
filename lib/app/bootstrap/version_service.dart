import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/network/api_endpoints.dart';
import 'package:obywatel_plus/core/network/public_client.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'version_state.dart';

class VersionService {
  final PublicApiClient _api;
  final AppLogger _logger;

  const VersionService(this._api, this._logger);

  Future<String> currentVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      return info.version;
    } catch (e, s) {
      _logger.e('Failed to read app version', error: e, stackTrace: s);
      return '0.0.0';
    }
  }

  bool isBelowMinimum(String current, String minimum) {
    List<int> parts(String v) =>
        v.split('.').map((e) => int.tryParse(e) ?? 0).toList();

    final a = parts(current);
    final b = parts(minimum);

    for (int i = 0; i < (a.length > b.length ? a.length : b.length); i++) {
      final ai = i < a.length ? a[i] : 0;
      final bi = i < b.length ? b[i] : 0;
      if (ai != bi) return ai < bi;
    }
    return false;
  }

  Future<VersionState> fetchVersionState() async {
    try {
      final resp = await _api.get(ApiEndpoints.checkVersion);

      if (resp.statusCode == 200 && resp.data is Map<String, dynamic>) {
        final data = resp.data as Map<String, dynamic>;

        return VersionState(
          minVersion: data['minVersion'] as String? ?? '0.0.0',
          latestVersion: data['latestVersion'] as String? ?? '0.0.0',
          forceUpdate: data['forceUpdate'] as bool? ?? false,
        );
      }
    } catch (e, s) {
      _logger.e('Version check failed', error: e, stackTrace: s);
    }

    return const VersionState(
      minVersion: '0.0.0',
      latestVersion: '0.0.0',
      forceUpdate: false,
    );
  }
}
