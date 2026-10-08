// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'global_notification_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GlobalNotification)
final globalNotificationProvider = GlobalNotificationProvider._();

final class GlobalNotificationProvider
    extends $NotifierProvider<GlobalNotification, List<AppNotification>> {
  GlobalNotificationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'globalNotificationProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$globalNotificationHash();

  @$internal
  @override
  GlobalNotification create() => GlobalNotification();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<AppNotification> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<AppNotification>>(value),
    );
  }
}

String _$globalNotificationHash() =>
    r'03f7d66b9bfd10b67c834a80cfcd5be79ab94509';

abstract class _$GlobalNotification extends $Notifier<List<AppNotification>> {
  List<AppNotification> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<AppNotification>, List<AppNotification>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<AppNotification>, List<AppNotification>>,
              List<AppNotification>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
