// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'version_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(versionService)
final versionServiceProvider = VersionServiceProvider._();

final class VersionServiceProvider
    extends $FunctionalProvider<VersionService, VersionService, VersionService>
    with $Provider<VersionService> {
  VersionServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'versionServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$versionServiceHash();

  @$internal
  @override
  $ProviderElement<VersionService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  VersionService create(Ref ref) {
    return versionService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VersionService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VersionService>(value),
    );
  }
}

String _$versionServiceHash() => r'62574e24a8d5401b9d1abefab200e9d48532eb68';

/// Notifier implementujący interfejs fasady

@ProviderFor(VersionNotifier)
final versionProvider = VersionNotifierProvider._();

/// Notifier implementujący interfejs fasady
final class VersionNotifierProvider
    extends $NotifierProvider<VersionNotifier, VersionState> {
  /// Notifier implementujący interfejs fasady
  VersionNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'versionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$versionNotifierHash();

  @$internal
  @override
  VersionNotifier create() => VersionNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VersionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VersionState>(value),
    );
  }
}

String _$versionNotifierHash() => r'1b3a7cbcbc00ee5d43023ef0518bacdbf529c233';

/// Notifier implementujący interfejs fasady

abstract class _$VersionNotifier extends $Notifier<VersionState> {
  VersionState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<VersionState, VersionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<VersionState, VersionState>,
              VersionState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
