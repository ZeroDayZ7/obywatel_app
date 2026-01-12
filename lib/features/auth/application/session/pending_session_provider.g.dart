// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_session_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PendingSessionNotifier)
final pendingSessionProvider = PendingSessionNotifierProvider._();

final class PendingSessionNotifierProvider
    extends $NotifierProvider<PendingSessionNotifier, PendingSession?> {
  PendingSessionNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingSessionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingSessionNotifierHash();

  @$internal
  @override
  PendingSessionNotifier create() => PendingSessionNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PendingSession? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PendingSession?>(value),
    );
  }
}

String _$pendingSessionNotifierHash() =>
    r'5acc508e7319d7ba833717556a76c45d59477de0';

abstract class _$PendingSessionNotifier extends $Notifier<PendingSession?> {
  PendingSession? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PendingSession?, PendingSession?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PendingSession?, PendingSession?>,
              PendingSession?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
