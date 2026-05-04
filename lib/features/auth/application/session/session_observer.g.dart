// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_observer.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SessionObserver)
final sessionObserverProvider = SessionObserverProvider._();

final class SessionObserverProvider
    extends $NotifierProvider<SessionObserver, void> {
  SessionObserverProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionObserverProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionObserverHash();

  @$internal
  @override
  SessionObserver create() => SessionObserver();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$sessionObserverHash() => r'ca9ca572f95162f12ddd7085db2d53b10fb88073';

abstract class _$SessionObserver extends $Notifier<void> {
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
