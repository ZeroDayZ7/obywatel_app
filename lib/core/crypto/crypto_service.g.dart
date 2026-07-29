// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crypto_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CryptoService)
final cryptoServiceProvider = CryptoServiceProvider._();

final class CryptoServiceProvider
    extends $NotifierProvider<CryptoService, void> {
  CryptoServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cryptoServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cryptoServiceHash();

  @$internal
  @override
  CryptoService create() => CryptoService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$cryptoServiceHash() => r'1da3a1b199c550ffc12cb4a4d52a53dce0cd3b61';

abstract class _$CryptoService extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
