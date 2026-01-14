// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_info_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(deviceInfoService)
final deviceInfoServiceProvider = DeviceInfoServiceProvider._();

final class DeviceInfoServiceProvider
    extends
        $FunctionalProvider<
          DeviceInfoService,
          DeviceInfoService,
          DeviceInfoService
        >
    with $Provider<DeviceInfoService> {
  DeviceInfoServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceInfoServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceInfoServiceHash();

  @$internal
  @override
  $ProviderElement<DeviceInfoService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DeviceInfoService create(Ref ref) {
    return deviceInfoService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeviceInfoService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeviceInfoService>(value),
    );
  }
}

String _$deviceInfoServiceHash() => r'bdaf5c7e489dabd712d240648fcb8561ab2b1d66';
