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
    r'977bcac98f153a9cf1832e07ec87d27b8c8a575c';
