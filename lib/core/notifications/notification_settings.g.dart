// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationSettings _$NotificationSettingsFromJson(
  Map<String, dynamic> json,
) => _NotificationSettings(
  appNotifications: json['appNotifications'] as bool? ?? true,
  sound: json['sound'] as bool? ?? true,
  vibration: json['vibration'] as bool? ?? true,
  email: json['email'] as bool? ?? false,
  sms: json['sms'] as bool? ?? false,
);

Map<String, dynamic> _$NotificationSettingsToJson(
  _NotificationSettings instance,
) => <String, dynamic>{
  'appNotifications': instance.appNotifications,
  'sound': instance.sound,
  'vibration': instance.vibration,
  'email': instance.email,
  'sms': instance.sms,
};

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AppNotificationSettings)
final appNotificationSettingsProvider = AppNotificationSettingsProvider._();

final class AppNotificationSettingsProvider
    extends $NotifierProvider<AppNotificationSettings, NotificationSettings> {
  AppNotificationSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appNotificationSettingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appNotificationSettingsHash();

  @$internal
  @override
  AppNotificationSettings create() => AppNotificationSettings();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationSettings>(value),
    );
  }
}

String _$appNotificationSettingsHash() =>
    r'bb639bf6e1fb5cd1b452d1edb28d06b036c6335a';

abstract class _$AppNotificationSettings
    extends $Notifier<NotificationSettings> {
  NotificationSettings build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<NotificationSettings, NotificationSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NotificationSettings, NotificationSettings>,
              NotificationSettings,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
