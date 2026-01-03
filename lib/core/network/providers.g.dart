// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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

String _$publicDioHash() => r'378fe7796cd052e9dd643c58f873dd2ea816605f';

@ProviderFor(resetDio)
final resetDioProvider = ResetDioProvider._();

final class ResetDioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  ResetDioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'resetDioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$resetDioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return resetDio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$resetDioHash() => r'358721c6db901d2fc0a2fc32f60415ee654833d7';

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

String _$authDioHash() => r'd437de59df520afc2039e140a81b974a9ba2552a';

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

@ProviderFor(resetApiClient)
final resetApiClientProvider = ResetApiClientProvider._();

final class ResetApiClientProvider
    extends
        $FunctionalProvider<PublicApiClient, PublicApiClient, PublicApiClient>
    with $Provider<PublicApiClient> {
  ResetApiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'resetApiClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$resetApiClientHash();

  @$internal
  @override
  $ProviderElement<PublicApiClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PublicApiClient create(Ref ref) {
    return resetApiClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PublicApiClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PublicApiClient>(value),
    );
  }
}

String _$resetApiClientHash() => r'e973aefb30384ee7f9f2df7174800b6111d7b3e1';
