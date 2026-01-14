// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'symmetric_crypto.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(symmetricCrypto)
final symmetricCryptoProvider = SymmetricCryptoProvider._();

final class SymmetricCryptoProvider
    extends
        $FunctionalProvider<SymmetricCrypto, SymmetricCrypto, SymmetricCrypto>
    with $Provider<SymmetricCrypto> {
  SymmetricCryptoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'symmetricCryptoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$symmetricCryptoHash();

  @$internal
  @override
  $ProviderElement<SymmetricCrypto> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SymmetricCrypto create(Ref ref) {
    return symmetricCrypto(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SymmetricCrypto value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SymmetricCrypto>(value),
    );
  }
}

String _$symmetricCryptoHash() => r'0d7bfe6b165ef716e46a7676a7a6c121ffa1daa0';
