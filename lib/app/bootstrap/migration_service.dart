// lib/app/bootstrap/migration_service.dart
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/storage/secure_storage_service.dart';

/// Prosty, wersjonowany migrator danych w secure storage.
/// Każda migracja ma unikalny ID i jest odhaczana w storage.
class MigrationService {
  final SecureStorageService _storage;
  final AppLogger _logger;

  const MigrationService(this._storage, this._logger);

  /// Lista migracji w kolejności wykonania.
  /// Dodawaj nowe migracje na końcu (id musi być stałe).
  final List<_Migration> _migrations = const [
    _Migration(
      id: '2025-09-01-remove-legacy-key',
      description: 'Remove legacy token format',
    ),
    _Migration(
      id: '2025-10-01-migrate-pin-format',
      description: 'Migrate PIN format to hashed',
    ),
    // dodawaj kolejne...
  ];

  Future<void> performMigrations() async {
    _logger.i('MigrationService: starting migrations');
    for (final m in _migrations) {
      final done = await _storage.read(key: 'migration_${m.id}') == 'done';
      if (done) {
        _logger.i('Migration ${m.id} already applied — skipping');
        continue;
      }
      _logger.i('Applying migration: ${m.id} - ${m.description}');
      try {
        // TODO: Implement real migration cases by id.
        await _applyMigrationById(m.id);
        await _storage.write(key: 'migration_${m.id}', value: 'done');
        _logger.i('Migration ${m.id} applied');
      } catch (e, st) {
        _logger.e('Migration ${m.id} failed', error: e, stackTrace: st);
        // Polecam: nie przerywać wszystkich migracji, ale oznaczyć błąd i kontynuować — decyzja zależy od krytyczności.
        rethrow;
      }
    }
    _logger.i('MigrationService: finished');
  }

  Future<void> _applyMigrationById(String id) async {
    // Przykładowe migracje (stub) — rozbuduj do realnych transformacji.
    switch (id) {
      case '2025-09-01-remove-legacy-key':
        await _storage.delete(key: 'legacy_token');
        break;
      case '2025-10-01-migrate-pin-format':
        final oldPin = await _storage.read(key: 'user_pin');
        if (oldPin != null && oldPin.isNotEmpty) {
          // example: hash or reformat. Tutaj zostawiamy stub — w rzeczywistości hashuj.
          final newPin = 'v2:$oldPin';
          await _storage.write(key: 'user_pin', value: newPin);
        }
        break;
      default:
        _logger.w('No migration handler for id=$id; skipping.');
    }
  }
}

class _Migration {
  final String id;
  final String description;
  const _Migration({required this.id, required this.description});
}
