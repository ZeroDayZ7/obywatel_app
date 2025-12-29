// lib/app/bootstrap/logic/version_logic.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/network/api_endpoints.dart';
import 'package:obywatel_plus/core/network/providers.dart';
import 'package:obywatel_plus/core/network/public_client.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'version_models.dart';

// --- Providers ---

final versionServiceProvider = Provider<VersionService>(
  (ref) => VersionService(
    ref.read(publicApiClientProvider),
    ref.read(appLoggerProvider),
  ),
);

final versionNotifierProvider = NotifierProvider<VersionNotifier, VersionState>(
  VersionNotifier.new,
);

// --- Notifier (Implementation of Facade) ---

class VersionNotifier extends Notifier<VersionState> implements IVersionFacade {
  @override
  VersionState build() => const VersionState();

  @override
  bool get forceUpdate => state.forceUpdate;

  @override
  Future<void> check() async {
    final service = ref.read(versionServiceProvider);

    // 1. Pobierz dane z API i aktualną wersję apki
    final stateFromApi = await service.fetchVersionState();
    final current = await service.currentVersion();

    // 2. Porównaj wersje
    final mustUpdate = service.isBelowMinimum(current, stateFromApi.minVersion);

    // 3. Zaktualizuj stan
    state = stateFromApi.copyWith(forceUpdate: mustUpdate);

    ref
        .read(appLoggerProvider)
        .i(
          '📱 Version Check: Current: $current, Min: ${state.minVersion}, Force: ${state.forceUpdate}',
        );
  }
}

// --- Service (Infrastructure Layer) ---

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
    List<int> parse(String v) =>
        v.split('.').map((e) => int.tryParse(e) ?? 0).toList();

    final a = parse(current);
    final b = parse(minimum);

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
        return VersionState.fromJson(resp.data as Map<String, dynamic>);
      }
    } catch (e, s) {
      _logger.e('Version check API failed', error: e, stackTrace: s);
    }

    return const VersionState();
  }
}
