// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_sessions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ActiveSessions)
final activeSessionsProvider = ActiveSessionsProvider._();

final class ActiveSessionsProvider
    extends $AsyncNotifierProvider<ActiveSessions, List<UserSession>> {
  ActiveSessionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeSessionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeSessionsHash();

  @$internal
  @override
  ActiveSessions create() => ActiveSessions();
}

String _$activeSessionsHash() => r'4d00a7367791d8cf5d4510866add7351f12c66d7';

abstract class _$ActiveSessions extends $AsyncNotifier<List<UserSession>> {
  FutureOr<List<UserSession>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<UserSession>>, List<UserSession>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<UserSession>>, List<UserSession>>,
              AsyncValue<List<UserSession>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
