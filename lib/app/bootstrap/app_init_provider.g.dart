// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_init_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AppInitNotifier)
final appInitProvider = AppInitNotifierProvider._();

final class AppInitNotifierProvider
    extends $NotifierProvider<AppInitNotifier, AppInitStatus> {
  AppInitNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appInitProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appInitNotifierHash();

  @$internal
  @override
  AppInitNotifier create() => AppInitNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppInitStatus value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppInitStatus>(value),
    );
  }
}

String _$appInitNotifierHash() => r'd714bb19342a1bab8456ae0128b714c5447964cf';

abstract class _$AppInitNotifier extends $Notifier<AppInitStatus> {
  AppInitStatus build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AppInitStatus, AppInitStatus>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppInitStatus, AppInitStatus>,
              AppInitStatus,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
