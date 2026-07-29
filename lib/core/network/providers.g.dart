// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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

String _$authDioHash() => r'6202494bae6bed3e2b4a057a7d062a4d4b4d294e';

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

String _$refreshDioHash() => r'a721ce324776cc0de0ff32aa4b6921257511a665';

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

String _$noAuthDioHash() => r'c282cbc7be31bb6249a8bf7b16ec2b97f87448b9';

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

String _$publicDioHash() => r'3dbfc92ca38d77d439e736c88dd7ae0075eda085';

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
