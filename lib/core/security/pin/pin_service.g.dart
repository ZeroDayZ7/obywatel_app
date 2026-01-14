// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pin_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(pinService)
final pinServiceProvider = PinServiceProvider._();

final class PinServiceProvider
    extends $FunctionalProvider<PinService, PinService, PinService>
    with $Provider<PinService> {
  PinServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pinServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pinServiceHash();

  @$internal
  @override
  $ProviderElement<PinService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PinService create(Ref ref) {
    return pinService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PinService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PinService>(value),
    );
  }
}

String _$pinServiceHash() => r'057cd552056ef8963f8535fc1a93b9f44d86fea7';
