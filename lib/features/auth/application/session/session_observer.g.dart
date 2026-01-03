// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_observer.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(sessionObserver)
final sessionObserverProvider = SessionObserverProvider._();

final class SessionObserverProvider
    extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
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
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    return sessionObserver(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$sessionObserverHash() => r'3cded3fa996e84fd62cfdf1786908eac6a109d1c';
