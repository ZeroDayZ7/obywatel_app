// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_password_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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
    r'349b89d042155bbb146a8e34f69d08e3bf8a867d';

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
