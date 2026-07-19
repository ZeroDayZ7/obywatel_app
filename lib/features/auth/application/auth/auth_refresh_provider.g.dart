// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_refresh_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AuthRefreshListenable)
final authRefreshListenableProvider = AuthRefreshListenableProvider._();

final class AuthRefreshListenableProvider
    extends $NotifierProvider<AuthRefreshListenable, void> {
  AuthRefreshListenableProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRefreshListenableProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRefreshListenableHash();

  @$internal
  @override
  AuthRefreshListenable create() => AuthRefreshListenable();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$authRefreshListenableHash() =>
    r'fc47c270645961bd1f5d87c2e84ac8c72128478e';

abstract class _$AuthRefreshListenable extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
