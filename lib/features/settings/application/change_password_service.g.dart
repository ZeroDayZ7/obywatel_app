// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_password_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(changePasswordService)
final changePasswordServiceProvider = ChangePasswordServiceProvider._();

final class ChangePasswordServiceProvider
    extends
        $FunctionalProvider<
          ChangePasswordService,
          ChangePasswordService,
          ChangePasswordService
        >
    with $Provider<ChangePasswordService> {
  ChangePasswordServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'changePasswordServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$changePasswordServiceHash();

  @$internal
  @override
  $ProviderElement<ChangePasswordService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ChangePasswordService create(Ref ref) {
    return changePasswordService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChangePasswordService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChangePasswordService>(value),
    );
  }
}

String _$changePasswordServiceHash() =>
    r'fa64cbd57b78099b80c97690739011f7ce8957f0';
