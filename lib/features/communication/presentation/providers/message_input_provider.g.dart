// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_input_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MessageInput)
final messageInputProvider = MessageInputFamily._();

final class MessageInputProvider
    extends $NotifierProvider<MessageInput, MessageInputState> {
  MessageInputProvider._({
    required MessageInputFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'messageInputProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$messageInputHash();

  @override
  String toString() {
    return r'messageInputProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  MessageInput create() => MessageInput();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MessageInputState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MessageInputState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MessageInputProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$messageInputHash() => r'673ad0e809aadcc59540fd94a49175b004c72bd6';

final class MessageInputFamily extends $Family
    with
        $ClassFamilyOverride<
          MessageInput,
          MessageInputState,
          MessageInputState,
          MessageInputState,
          String
        > {
  MessageInputFamily._()
    : super(
        retry: null,
        name: r'messageInputProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MessageInputProvider call(String conversationId) =>
      MessageInputProvider._(argument: conversationId, from: this);

  @override
  String toString() => r'messageInputProvider';
}

abstract class _$MessageInput extends $Notifier<MessageInputState> {
  late final _$args = ref.$arg as String;
  String get conversationId => _$args;

  MessageInputState build(String conversationId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<MessageInputState, MessageInputState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MessageInputState, MessageInputState>,
              MessageInputState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
