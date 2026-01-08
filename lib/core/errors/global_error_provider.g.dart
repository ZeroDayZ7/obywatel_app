// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'global_error_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GlobalNotification)
final globalNotificationProvider = GlobalNotificationProvider._();

final class GlobalNotificationProvider
    extends $NotifierProvider<GlobalNotification, AppNotification?> {
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
  Override overrideWithValue(AppNotification? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppNotification?>(value),
    );
  }
}

String _$globalNotificationHash() =>
    r'f4c207cf04ee652d63f7e2563730bfe7e0043b1a';

abstract class _$GlobalNotification extends $Notifier<AppNotification?> {
  AppNotification? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AppNotification?, AppNotification?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppNotification?, AppNotification?>,
              AppNotification?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
