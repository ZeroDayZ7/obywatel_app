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

String _$chatsWsClientHash() => r'a3f0930142483939fe83c961ad32927838d93eec';
