// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chats_ws_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appWebSocketClient)
final appWebSocketClientProvider = AppWebSocketClientProvider._();

final class AppWebSocketClientProvider
    extends
        $FunctionalProvider<
          AppWebSocketClient,
          AppWebSocketClient,
          AppWebSocketClient
        >
    with $Provider<AppWebSocketClient> {
  AppWebSocketClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appWebSocketClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appWebSocketClientHash();

  @$internal
  @override
  $ProviderElement<AppWebSocketClient> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AppWebSocketClient create(Ref ref) {
    return appWebSocketClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppWebSocketClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppWebSocketClient>(value),
    );
  }
}

String _$appWebSocketClientHash() =>
    r'f15a3fd596125b412a7915e83a6d148362f65f85';

@ProviderFor(chatsWsClient)
final chatsWsClientProvider = ChatsWsClientProvider._();

final class ChatsWsClientProvider
    extends $FunctionalProvider<ChatsWsClient, ChatsWsClient, ChatsWsClient>
    with $Provider<ChatsWsClient> {
  ChatsWsClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatsWsClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatsWsClientHash();

  @$internal
  @override
  $ProviderElement<ChatsWsClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ChatsWsClient create(Ref ref) {
    return chatsWsClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatsWsClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatsWsClient>(value),
    );
  }
}

String _$chatsWsClientHash() => r'cdb15a1b86bcf3cb664440220c0bcee1abf54bf9';

@ProviderFor(chatsWsStatus)
final chatsWsStatusProvider = ChatsWsStatusProvider._();

final class ChatsWsStatusProvider
    extends
        $FunctionalProvider<
          AsyncValue<WsConnectionStatus>,
          WsConnectionStatus,
          Stream<WsConnectionStatus>
        >
    with
        $FutureModifier<WsConnectionStatus>,
        $StreamProvider<WsConnectionStatus> {
  ChatsWsStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatsWsStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatsWsStatusHash();

  @$internal
  @override
  $StreamProviderElement<WsConnectionStatus> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<WsConnectionStatus> create(Ref ref) {
    return chatsWsStatus(ref);
  }
}

String _$chatsWsStatusHash() => r'10e24a2b7095857edd6766b2556d05ec57928764';
