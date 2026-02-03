// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kdf_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(kdfService)
final kdfServiceProvider = KdfServiceProvider._();

final class KdfServiceProvider
    extends $FunctionalProvider<KdfService, KdfService, KdfService>
    with $Provider<KdfService> {
  KdfServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'kdfServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$kdfServiceHash();

  @$internal
  @override
  $ProviderElement<KdfService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  KdfService create(Ref ref) {
    return kdfService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(KdfService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<KdfService>(value),
    );
  }
}

String _$kdfServiceHash() => r'32dce641f90f5e89cf7b2a5fa1676879ddc1c65b';
