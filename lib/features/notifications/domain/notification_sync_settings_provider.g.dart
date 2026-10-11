// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_sync_settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NotificationSyncSettings)
final notificationSyncSettingsProvider = NotificationSyncSettingsProvider._();

final class NotificationSyncSettingsProvider
    extends $NotifierProvider<NotificationSyncSettings, NotificationSyncState> {
  NotificationSyncSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationSyncSettingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationSyncSettingsHash();

  @$internal
  @override
  NotificationSyncSettings create() => NotificationSyncSettings();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationSyncState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationSyncState>(value),
    );
  }
}

String _$notificationSyncSettingsHash() =>
    r'93e0ca9fb0d27bd9e119e658c9ff96cface655d3';

abstract class _$NotificationSyncSettings
    extends $Notifier<NotificationSyncState> {
  NotificationSyncState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<NotificationSyncState, NotificationSyncState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NotificationSyncState, NotificationSyncState>,
              NotificationSyncState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
