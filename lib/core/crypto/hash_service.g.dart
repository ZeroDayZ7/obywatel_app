// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hash_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(hashService)
final hashServiceProvider = HashServiceProvider._();

final class HashServiceProvider
    extends $FunctionalProvider<HashService, HashService, HashService>
    with $Provider<HashService> {
  HashServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hashServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hashServiceHash();

  @$internal
  @override
  $ProviderElement<HashService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  HashService create(Ref ref) {
    return hashService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HashService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HashService>(value),
    );
  }
}

String _$hashServiceHash() => r'6c334933b9616aa6e688f2cc2dd9028cd3322735';
