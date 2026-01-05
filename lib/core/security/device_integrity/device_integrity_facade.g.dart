// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_integrity_facade.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(deviceIntegrityFacade)
final deviceIntegrityFacadeProvider = DeviceIntegrityFacadeProvider._();

final class DeviceIntegrityFacadeProvider
    extends
        $FunctionalProvider<
          IDeviceIntegrityFacade,
          IDeviceIntegrityFacade,
          IDeviceIntegrityFacade
        >
    with $Provider<IDeviceIntegrityFacade> {
  DeviceIntegrityFacadeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceIntegrityFacadeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceIntegrityFacadeHash();

  @$internal
  @override
  $ProviderElement<IDeviceIntegrityFacade> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IDeviceIntegrityFacade create(Ref ref) {
    return deviceIntegrityFacade(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IDeviceIntegrityFacade value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IDeviceIntegrityFacade>(value),
    );
  }
}

String _$deviceIntegrityFacadeHash() =>
    r'b2339bf535b911bfe735e4affa0fc8fb9636db5f';
