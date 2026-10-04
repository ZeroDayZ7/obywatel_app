// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'e2ee_crypto_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(e2eeCryptoService)
final e2eeCryptoServiceProvider = E2eeCryptoServiceProvider._();

final class E2eeCryptoServiceProvider
    extends
        $FunctionalProvider<
          E2eeCryptoService,
          E2eeCryptoService,
          E2eeCryptoService
        >
    with $Provider<E2eeCryptoService> {
  E2eeCryptoServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'e2eeCryptoServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$e2eeCryptoServiceHash();

  @$internal
  @override
  $ProviderElement<E2eeCryptoService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  E2eeCryptoService create(Ref ref) {
    return e2eeCryptoService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(E2eeCryptoService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<E2eeCryptoService>(value),
    );
  }
}

String _$e2eeCryptoServiceHash() => r'c5b65bb75909d29c52ef9ea05fa1f0c8918a24a8';
