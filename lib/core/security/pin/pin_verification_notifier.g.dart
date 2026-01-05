// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pin_verification_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PinVerificationNotifier)
final pinVerificationProvider = PinVerificationNotifierProvider._();

final class PinVerificationNotifierProvider
    extends $NotifierProvider<PinVerificationNotifier, PinVerificationState> {
  PinVerificationNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pinVerificationProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pinVerificationNotifierHash();

  @$internal
  @override
  PinVerificationNotifier create() => PinVerificationNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PinVerificationState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PinVerificationState>(value),
    );
  }
}

String _$pinVerificationNotifierHash() =>
    r'ea157e3dee6d90a623bfaf96904ad43cb855f15a';

abstract class _$PinVerificationNotifier
    extends $Notifier<PinVerificationState> {
  PinVerificationState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PinVerificationState, PinVerificationState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PinVerificationState, PinVerificationState>,
              PinVerificationState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
