// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ActiveChat)
final activeChatProvider = ActiveChatFamily._();

final class ActiveChatProvider
    extends $AsyncNotifierProvider<ActiveChat, List<Message>> {
  ActiveChatProvider._({
    required ActiveChatFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'activeChatProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$activeChatHash();

  @override
  String toString() {
    return r'activeChatProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ActiveChat create() => ActiveChat();

  @override
  bool operator ==(Object other) {
    return other is ActiveChatProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$activeChatHash() => r'8e744fc0801877dec6fa2e8555464d29be49431f';

final class ActiveChatFamily extends $Family
    with
        $ClassFamilyOverride<
          ActiveChat,
          AsyncValue<List<Message>>,
          List<Message>,
          FutureOr<List<Message>>,
          String
        > {
  ActiveChatFamily._()
    : super(
        retry: null,
        name: r'activeChatProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ActiveChatProvider call(String conversationId) =>
      ActiveChatProvider._(argument: conversationId, from: this);

  @override
  String toString() => r'activeChatProvider';
}

abstract class _$ActiveChat extends $AsyncNotifier<List<Message>> {
  late final _$args = ref.$arg as String;
  String get conversationId => _$args;

  FutureOr<List<Message>> build(String conversationId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Message>>, List<Message>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Message>>, List<Message>>,
              AsyncValue<List<Message>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
