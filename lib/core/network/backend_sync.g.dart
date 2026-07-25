// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backend_sync.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BackendStateNotifier)
final backendStateProvider = BackendStateNotifierProvider._();

final class BackendStateNotifierProvider
    extends $AsyncNotifierProvider<BackendStateNotifier, BackendState> {
  BackendStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'backendStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$backendStateNotifierHash();

  @$internal
  @override
  BackendStateNotifier create() => BackendStateNotifier();
}

String _$backendStateNotifierHash() =>
    r'823435ef30a83fa70329fd49034bbb2731fea0f3';

abstract class _$BackendStateNotifier extends $AsyncNotifier<BackendState> {
  FutureOr<BackendState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<BackendState>, BackendState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<BackendState>, BackendState>,
              AsyncValue<BackendState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
