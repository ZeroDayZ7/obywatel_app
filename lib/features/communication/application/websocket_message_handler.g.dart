// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_message_handler.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(webSocketMessageHandler)
final webSocketMessageHandlerProvider = WebSocketMessageHandlerProvider._();

final class WebSocketMessageHandlerProvider
    extends
        $FunctionalProvider<
          WebSocketMessageHandler,
          WebSocketMessageHandler,
          WebSocketMessageHandler
        >
    with $Provider<WebSocketMessageHandler> {
  WebSocketMessageHandlerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'webSocketMessageHandlerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$webSocketMessageHandlerHash();

  @$internal
  @override
  $ProviderElement<WebSocketMessageHandler> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WebSocketMessageHandler create(Ref ref) {
    return webSocketMessageHandler(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WebSocketMessageHandler value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WebSocketMessageHandler>(value),
    );
  }
}

String _$webSocketMessageHandlerHash() =>
    r'591a88914db3a1e1dbc8d7e32e41a437542e7bf9';
