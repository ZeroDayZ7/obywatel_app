// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_coordinator.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SyncCoordinator)
final syncCoordinatorProvider = SyncCoordinatorProvider._();

final class SyncCoordinatorProvider
    extends $NotifierProvider<SyncCoordinator, SyncReadiness> {
  SyncCoordinatorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncCoordinatorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncCoordinatorHash();

  @$internal
  @override
  SyncCoordinator create() => SyncCoordinator();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncReadiness value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncReadiness>(value),
    );
  }
}

String _$syncCoordinatorHash() => r'98d61a3871161f813d3da913c95e3ae7bd740e1f';

abstract class _$SyncCoordinator extends $Notifier<SyncReadiness> {
  SyncReadiness build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SyncReadiness, SyncReadiness>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SyncReadiness, SyncReadiness>,
              SyncReadiness,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
