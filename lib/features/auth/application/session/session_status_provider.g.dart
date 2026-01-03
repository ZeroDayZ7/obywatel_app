// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_status_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SessionStatusNotifier)
final sessionStatusProvider = SessionStatusNotifierProvider._();

final class SessionStatusNotifierProvider
    extends $NotifierProvider<SessionStatusNotifier, SessionStatus> {
  SessionStatusNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionStatusNotifierHash();

  @$internal
  @override
  SessionStatusNotifier create() => SessionStatusNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SessionStatus value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SessionStatus>(value),
    );
  }
}

String _$sessionStatusNotifierHash() =>
    r'e75c500bd873157d75dec7fe1bb4a9024cf7c961';

abstract class _$SessionStatusNotifier extends $Notifier<SessionStatus> {
  SessionStatus build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SessionStatus, SessionStatus>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SessionStatus, SessionStatus>,
              SessionStatus,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
