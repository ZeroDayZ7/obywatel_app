// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_integrity_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(deviceIntegrityService)
final deviceIntegrityServiceProvider = DeviceIntegrityServiceProvider._();

final class DeviceIntegrityServiceProvider
    extends
        $FunctionalProvider<
          DeviceIntegrityService,
          DeviceIntegrityService,
          DeviceIntegrityService
        >
    with $Provider<DeviceIntegrityService> {
  DeviceIntegrityServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceIntegrityServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceIntegrityServiceHash();

  @$internal
  @override
  $ProviderElement<DeviceIntegrityService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DeviceIntegrityService create(Ref ref) {
    return deviceIntegrityService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeviceIntegrityService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeviceIntegrityService>(value),
    );
  }
}

String _$deviceIntegrityServiceHash() =>
    r'04940a87f4ca10b240aadf9b09ff2abfd5990d70';
