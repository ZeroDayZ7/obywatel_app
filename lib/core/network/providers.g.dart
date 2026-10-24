// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WsLifecycleRefresh)
final wsLifecycleRefreshProvider = WsLifecycleRefreshProvider._();

final class WsLifecycleRefreshProvider
    extends $NotifierProvider<WsLifecycleRefresh, int> {
  WsLifecycleRefreshProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wsLifecycleRefreshProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wsLifecycleRefreshHash();

  @$internal
  @override
  WsLifecycleRefresh create() => WsLifecycleRefresh();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$wsLifecycleRefreshHash() =>
    r'c79ab081dbb52fc77d31e4f76fcc2e28fe22cb07';

abstract class _$WsLifecycleRefresh extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(globalWebSocketLifecycle)
final globalWebSocketLifecycleProvider = GlobalWebSocketLifecycleProvider._();

final class GlobalWebSocketLifecycleProvider
    extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  GlobalWebSocketLifecycleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'globalWebSocketLifecycleProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$globalWebSocketLifecycleHash();

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    return globalWebSocketLifecycle(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$globalWebSocketLifecycleHash() =>
    r'5d87aef7d707d8cc7ba7aea8a8a22e374425978e';

@ProviderFor(authFresh)
final authFreshProvider = AuthFreshProvider._();

final class AuthFreshProvider
    extends
        $FunctionalProvider<
          Fresh<OAuth2Token>,
          Fresh<OAuth2Token>,
          Fresh<OAuth2Token>
        >
    with $Provider<Fresh<OAuth2Token>> {
  AuthFreshProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authFreshProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authFreshHash();

  @$internal
  @override
  $ProviderElement<Fresh<OAuth2Token>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Fresh<OAuth2Token> create(Ref ref) {
    return authFresh(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Fresh<OAuth2Token> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Fresh<OAuth2Token>>(value),
    );
  }
}

String _$authFreshHash() => r'af2b6e66b778c0135225a532cd9234f1d390d2ea';

@ProviderFor(authDio)
final authDioProvider = AuthDioProvider._();

final class AuthDioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  AuthDioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authDioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authDioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return authDio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$authDioHash() => r'76f732eae6ab762618c4a4951739b5b36d985832';

@ProviderFor(refreshDio)
final refreshDioProvider = RefreshDioProvider._();

final class RefreshDioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  RefreshDioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'refreshDioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$refreshDioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return refreshDio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$refreshDioHash() => r'505f8489ec04594180c141f3a20cf4e67b62a710';

@ProviderFor(noAuthDio)
final noAuthDioProvider = NoAuthDioProvider._();

final class NoAuthDioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  NoAuthDioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'noAuthDioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$noAuthDioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return noAuthDio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$noAuthDioHash() => r'12033c9502911283d1cea511666462dbc075429d';

@ProviderFor(publicDio)
final publicDioProvider = PublicDioProvider._();

final class PublicDioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  PublicDioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'publicDioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$publicDioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return publicDio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$publicDioHash() => r'796f53635a980bfa2ba54af2ea70a0813cfd3313';

@ProviderFor(apiClient)
final apiClientProvider = ApiClientProvider._();

final class ApiClientProvider
    extends $FunctionalProvider<ApiClient, ApiClient, ApiClient>
    with $Provider<ApiClient> {
  ApiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiClientHash();

  @$internal
  @override
  $ProviderElement<ApiClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ApiClient create(Ref ref) {
    return apiClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ApiClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ApiClient>(value),
    );
  }
}

String _$apiClientHash() => r'a5b461a3c5bcb7cd7880a74b4806ee7b682c1c89';

@ProviderFor(appWebSocketClient)
final appWebSocketClientProvider = AppWebSocketClientProvider._();

final class AppWebSocketClientProvider
    extends
        $FunctionalProvider<
          AppWebSocketClient,
          AppWebSocketClient,
          AppWebSocketClient
        >
    with $Provider<AppWebSocketClient> {
  AppWebSocketClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appWebSocketClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appWebSocketClientHash();

  @$internal
  @override
  $ProviderElement<AppWebSocketClient> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AppWebSocketClient create(Ref ref) {
    return appWebSocketClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppWebSocketClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppWebSocketClient>(value),
    );
  }
}

String _$appWebSocketClientHash() =>
    r'85334deae5d959d06ef2a1eca4f6271b178bbd72';

@ProviderFor(appWebSocketStatus)
final appWebSocketStatusProvider = AppWebSocketStatusProvider._();

final class AppWebSocketStatusProvider
    extends
        $FunctionalProvider<
          AsyncValue<WsConnectionStatus>,
          WsConnectionStatus,
          Stream<WsConnectionStatus>
        >
    with
        $FutureModifier<WsConnectionStatus>,
        $StreamProvider<WsConnectionStatus> {
  AppWebSocketStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appWebSocketStatusProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appWebSocketStatusHash();

  @$internal
  @override
  $StreamProviderElement<WsConnectionStatus> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<WsConnectionStatus> create(Ref ref) {
    return appWebSocketStatus(ref);
  }
}

String _$appWebSocketStatusHash() =>
    r'e9223bcd167e1f64d24da5ce31440ee65afbcc79';

@ProviderFor(noAuthApiClient)
final noAuthApiClientProvider = NoAuthApiClientProvider._();

final class NoAuthApiClientProvider
    extends
        $FunctionalProvider<NoAuthApiClient, NoAuthApiClient, NoAuthApiClient>
    with $Provider<NoAuthApiClient> {
  NoAuthApiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'noAuthApiClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$noAuthApiClientHash();

  @$internal
  @override
  $ProviderElement<NoAuthApiClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  NoAuthApiClient create(Ref ref) {
    return noAuthApiClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NoAuthApiClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NoAuthApiClient>(value),
    );
  }
}

String _$noAuthApiClientHash() => r'80b2a76cd3a13207f44ca093ec8ae92fee47ed03';

@ProviderFor(publicApiClient)
final publicApiClientProvider = PublicApiClientProvider._();

final class PublicApiClientProvider
    extends
        $FunctionalProvider<PublicApiClient, PublicApiClient, PublicApiClient>
    with $Provider<PublicApiClient> {
  PublicApiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'publicApiClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$publicApiClientHash();

  @$internal
  @override
  $ProviderElement<PublicApiClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PublicApiClient create(Ref ref) {
    return publicApiClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PublicApiClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PublicApiClient>(value),
    );
  }
}

String _$publicApiClientHash() => r'20b91b552704a886f8ae3ff7b5aca36f8d9154e9';
