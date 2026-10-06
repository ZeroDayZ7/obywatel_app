// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outbox_processor.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(OutboxProcessor)
final outboxProcessorProvider = OutboxProcessorProvider._();

final class OutboxProcessorProvider
    extends $AsyncNotifierProvider<OutboxProcessor, void> {
  OutboxProcessorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'outboxProcessorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$outboxProcessorHash();

  @$internal
  @override
  OutboxProcessor create() => OutboxProcessor();
}

String _$outboxProcessorHash() => r'56054dfb4b3d45eed02e842b27b4eb55c99bbe47';

abstract class _$OutboxProcessor extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
