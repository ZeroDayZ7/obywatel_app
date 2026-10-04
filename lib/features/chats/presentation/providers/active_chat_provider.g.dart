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
    extends $StreamNotifierProvider<ActiveChat, List<Message>> {
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

String _$activeChatHash() => r'afea37ab8f071d6acc4bf1dcb9ce3a3e329337f2';

final class ActiveChatFamily extends $Family
    with
        $ClassFamilyOverride<
          ActiveChat,
          AsyncValue<List<Message>>,
          List<Message>,
          Stream<List<Message>>,
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

abstract class _$ActiveChat extends $StreamNotifier<List<Message>> {
  late final _$args = ref.$arg as String;
  String get conversationId => _$args;

  Stream<List<Message>> build(String conversationId);
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
