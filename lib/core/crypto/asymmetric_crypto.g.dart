// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asymmetric_crypto.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(asymmetricCrypto)
final asymmetricCryptoProvider = AsymmetricCryptoProvider._();

final class AsymmetricCryptoProvider
    extends
        $FunctionalProvider<
          AsymmetricCrypto,
          AsymmetricCrypto,
          AsymmetricCrypto
        >
    with $Provider<AsymmetricCrypto> {
  AsymmetricCryptoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'asymmetricCryptoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$asymmetricCryptoHash();

  @$internal
  @override
  $ProviderElement<AsymmetricCrypto> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AsymmetricCrypto create(Ref ref) {
    return asymmetricCrypto(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsymmetricCrypto value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsymmetricCrypto>(value),
    );
  }
}

String _$asymmetricCryptoHash() => r'3730fcb07608ffc5c52987d33e7977f9a61c543f';
