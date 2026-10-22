// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'security_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SecurityService)
final securityServiceProvider = SecurityServiceProvider._();

final class SecurityServiceProvider
    extends $NotifierProvider<SecurityService, SecurityState> {
  SecurityServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'securityServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$securityServiceHash();

  @$internal
  @override
  SecurityService create() => SecurityService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SecurityState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SecurityState>(value),
    );
  }
}

String _$securityServiceHash() => r'712a72b955e2c04de16edcfb112e5e6384a5326d';

abstract class _$SecurityService extends $Notifier<SecurityState> {
  SecurityState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SecurityState, SecurityState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SecurityState, SecurityState>,
              SecurityState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
