// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(chatE2eeSessionStatus)
final chatE2eeSessionStatusProvider = ChatE2eeSessionStatusFamily._();

final class ChatE2eeSessionStatusProvider
    extends
        $FunctionalProvider<
          AsyncValue<E2eeSessionUiStatus>,
          E2eeSessionUiStatus,
          FutureOr<E2eeSessionUiStatus>
        >
    with
        $FutureModifier<E2eeSessionUiStatus>,
        $FutureProvider<E2eeSessionUiStatus> {
  ChatE2eeSessionStatusProvider._({
    required ChatE2eeSessionStatusFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'chatE2eeSessionStatusProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chatE2eeSessionStatusHash();

  @override
  String toString() {
    return r'chatE2eeSessionStatusProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<E2eeSessionUiStatus> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<E2eeSessionUiStatus> create(Ref ref) {
    final argument = this.argument as String;
    return chatE2eeSessionStatus(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatE2eeSessionStatusProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chatE2eeSessionStatusHash() =>
    r'35ee275d2c1c480473952c7ccb577670e935e850';

final class ChatE2eeSessionStatusFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<E2eeSessionUiStatus>, String> {
  ChatE2eeSessionStatusFamily._()
    : super(
        retry: null,
        name: r'chatE2eeSessionStatusProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ChatE2eeSessionStatusProvider call(String conversationId) =>
      ChatE2eeSessionStatusProvider._(argument: conversationId, from: this);

  @override
  String toString() => r'chatE2eeSessionStatusProvider';
}

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

String _$activeChatHash() => r'3fdbd1d99e5a331d4ca98cd72542289fd95aaf90';

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
