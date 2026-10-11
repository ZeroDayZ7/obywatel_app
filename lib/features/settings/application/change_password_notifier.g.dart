// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_password_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ChangePasswordNotifier)
final changePasswordProvider = ChangePasswordNotifierProvider._();

final class ChangePasswordNotifierProvider
    extends $NotifierProvider<ChangePasswordNotifier, ChangePasswordState> {
  ChangePasswordNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'changePasswordProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$changePasswordNotifierHash();

  @$internal
  @override
  ChangePasswordNotifier create() => ChangePasswordNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChangePasswordState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChangePasswordState>(value),
    );
  }
}

String _$changePasswordNotifierHash() =>
    r'9c53dde481fc1bc136f8366b9be3b2dba384da51';

abstract class _$ChangePasswordNotifier extends $Notifier<ChangePasswordState> {
  ChangePasswordState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ChangePasswordState, ChangePasswordState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ChangePasswordState, ChangePasswordState>,
              ChangePasswordState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
