// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_password_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ResetPasswordService)
final resetPasswordServiceProvider = ResetPasswordServiceProvider._();

final class ResetPasswordServiceProvider
    extends $NotifierProvider<ResetPasswordService, void> {
  ResetPasswordServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'resetPasswordServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$resetPasswordServiceHash();

  @$internal
  @override
  ResetPasswordService create() => ResetPasswordService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$resetPasswordServiceHash() =>
    r'e2e20581d2d3b4b4df9ac19e5f1d8bb24b99b532';

abstract class _$ResetPasswordService extends $Notifier<void> {
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

@ProviderFor(ResetPasswordNotifier)
final resetPasswordProvider = ResetPasswordNotifierProvider._();

final class ResetPasswordNotifierProvider
    extends $NotifierProvider<ResetPasswordNotifier, ResetPasswordState> {
  ResetPasswordNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'resetPasswordProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$resetPasswordNotifierHash();

  @$internal
  @override
  ResetPasswordNotifier create() => ResetPasswordNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ResetPasswordState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ResetPasswordState>(value),
    );
  }
}

String _$resetPasswordNotifierHash() =>
    r'67a75ca6d6d8fdd2cc7ad3b8cf6f854fe1c3172f';

abstract class _$ResetPasswordNotifier extends $Notifier<ResetPasswordState> {
  ResetPasswordState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ResetPasswordState, ResetPasswordState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ResetPasswordState, ResetPasswordState>,
              ResetPasswordState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
