// lib/app/bootstrap/remote_config_service.dart
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/network/api_client.dart';
import 'package:obywatel_plus/core/storage/secure_storage_service.dart';

class RemoteConfigService {
  final ApiClient _api;
  final SecureStorageService _storage;
  final AppLogger _logger;

  const RemoteConfigService(this._api, this._storage, this._logger);

  /// Pobierz konfigurację z serwera i zapisz niezbędne wartości w storage.
  /// Oczekujemy prostego JSON-a, np. { "theme": "dark", "announcement": "..." }
  Future<void> fetchRemoteConfig() async {
    _logger.i('RemoteConfigService: fetching remote config');
    final resp = await _api.get('/app/config/remote');
    if (resp.statusCode == 200 && resp.data is Map<String, dynamic>) {
      final Map<String, dynamic> data = resp.data as Map<String, dynamic>;
      final theme = data['theme'] as String?;
      final announcement = data['announcement'] as String?;
      if (theme != null)
        await _storage.write(key: 'remote_theme', value: theme);
      if (announcement != null)
        await _storage.write(key: 'remote_announcement', value: announcement);
      _logger.i('RemoteConfigService: remote config stored');
    } else {
      _logger.w(
        'RemoteConfigService: unexpected response status=${resp.statusCode}',
      );
      // Możesz rzucić lub zostawić fallbacky w storage.
    }
  }
}
