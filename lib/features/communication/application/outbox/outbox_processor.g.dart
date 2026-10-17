// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outbox_processor.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(outboxProcessor)
final outboxProcessorProvider = OutboxProcessorProvider._();

final class OutboxProcessorProvider
    extends
        $FunctionalProvider<OutboxProcessor, OutboxProcessor, OutboxProcessor>
    with $Provider<OutboxProcessor> {
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
  $ProviderElement<OutboxProcessor> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OutboxProcessor create(Ref ref) {
    return outboxProcessor(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OutboxProcessor value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OutboxProcessor>(value),
    );
  }
}

String _$outboxProcessorHash() => r'2cf88d3144fab60ac5dd8e24be16b952ed3e762d';
