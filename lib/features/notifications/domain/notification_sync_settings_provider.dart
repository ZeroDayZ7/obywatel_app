import 'package:obywatel_plus/core/storage/shared_preferences_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_sync_settings_provider.g.dart';

@riverpod
class NotificationSyncSettings extends _$NotificationSyncSettings {
  static const _kAutoSync = 'notif_auto_sync_v2';
  static const _kRealtimeSync = 'notif_realtime_sync_v2';
  static const _kLastSync = 'notif_last_sync_v2';

  SharedPreferencesService get _prefs => ref.read(activePrefsProvider);

  @override
  NotificationSyncState build() {
    final auto = _prefs.readBool(_kAutoSync) ?? true;
    final realtime = _prefs.readBool(_kRealtimeSync) ?? true;
    final lastIso = _prefs.read(_kLastSync);
    final last = lastIso != null ? DateTime.tryParse(lastIso)?.toUtc() : null;

    return NotificationSyncState(
      autoSyncEnabled: auto,
      realtimeSyncEnabled: realtime,
      lastSyncTimestamp: last,
    );
  }

  Future<void> setAutoSync(bool v) async {
    state = state.copyWith(autoSyncEnabled: v);
    await _prefs.writeBool(_kAutoSync, v);
  }

  Future<void> setRealtimeSync(bool v) async {
    state = state.copyWith(realtimeSyncEnabled: v);
    await _prefs.writeBool(_kRealtimeSync, v);
  }

  Future<void> setLastSyncTimestamp(DateTime t) async {
    final iso = t.toUtc().toIso8601String();
    state = state.copyWith(lastSyncTimestamp: t.toUtc());
    await _prefs.write(_kLastSync, iso);
  }

  Future<void> clearLastSync() async {
    state = state.copyWith(lastSyncTimestamp: null);
    await _prefs.remove(_kLastSync);
  }
}

class NotificationSyncState {
  final bool autoSyncEnabled;
  final bool realtimeSyncEnabled;
  final DateTime? lastSyncTimestamp;

  NotificationSyncState({
    required this.autoSyncEnabled,
    required this.realtimeSyncEnabled,
    required this.lastSyncTimestamp,
  });

  NotificationSyncState copyWith({
    bool? autoSyncEnabled,
    bool? realtimeSyncEnabled,
    DateTime? lastSyncTimestamp,
  }) {
    return NotificationSyncState(
      autoSyncEnabled: autoSyncEnabled ?? this.autoSyncEnabled,
      realtimeSyncEnabled: realtimeSyncEnabled ?? this.realtimeSyncEnabled,
      lastSyncTimestamp: lastSyncTimestamp ?? this.lastSyncTimestamp,
    );
  }
}
