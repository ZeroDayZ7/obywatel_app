// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_sessions_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(activeSessionsService)
final activeSessionsServiceProvider = ActiveSessionsServiceProvider._();

final class ActiveSessionsServiceProvider
    extends
        $FunctionalProvider<
          ActiveSessionsService,
          ActiveSessionsService,
          ActiveSessionsService
        >
    with $Provider<ActiveSessionsService> {
  ActiveSessionsServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeSessionsServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeSessionsServiceHash();

  @$internal
  @override
  $ProviderElement<ActiveSessionsService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ActiveSessionsService create(Ref ref) {
    return activeSessionsService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ActiveSessionsService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ActiveSessionsService>(value),
    );
  }
}

String _$activeSessionsServiceHash() =>
    r'03d4ab1873cd0da839f531c1757755ae0072b580';
