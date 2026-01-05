// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pin_attempt_limiter.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PinAttemptLimiter)
final pinAttemptLimiterProvider = PinAttemptLimiterProvider._();

final class PinAttemptLimiterProvider
    extends $AsyncNotifierProvider<PinAttemptLimiter, PinAttemptState> {
  PinAttemptLimiterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pinAttemptLimiterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pinAttemptLimiterHash();

  @$internal
  @override
  PinAttemptLimiter create() => PinAttemptLimiter();
}

String _$pinAttemptLimiterHash() => r'b59e9b9f782fa6f19adbe39aaeaf28ce4449248f';

abstract class _$PinAttemptLimiter extends $AsyncNotifier<PinAttemptState> {
  FutureOr<PinAttemptState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<PinAttemptState>, PinAttemptState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PinAttemptState>, PinAttemptState>,
              AsyncValue<PinAttemptState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
