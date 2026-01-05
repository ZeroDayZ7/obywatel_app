// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_capabilities_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DeviceCapabilities)
final deviceCapabilitiesProvider = DeviceCapabilitiesProvider._();

final class DeviceCapabilitiesProvider
    extends $NotifierProvider<DeviceCapabilities, DeviceCapabilitiesState> {
  DeviceCapabilitiesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceCapabilitiesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceCapabilitiesHash();

  @$internal
  @override
  DeviceCapabilities create() => DeviceCapabilities();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeviceCapabilitiesState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeviceCapabilitiesState>(value),
    );
  }
}

String _$deviceCapabilitiesHash() =>
    r'94da1ac385e9af15d0180e2231f902be8c3a29e0';

abstract class _$DeviceCapabilities extends $Notifier<DeviceCapabilitiesState> {
  DeviceCapabilitiesState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<DeviceCapabilitiesState, DeviceCapabilitiesState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DeviceCapabilitiesState, DeviceCapabilitiesState>,
              DeviceCapabilitiesState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
