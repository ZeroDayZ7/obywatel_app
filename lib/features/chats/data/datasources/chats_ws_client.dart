import 'package:obywatel_plus/app/config/services_config.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart'; // importuj swój model loggera
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/network/api_endpoints.dart';
import 'package:obywatel_plus/core/network/clients/app_websocket_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chats_ws_client.g.dart';

class ChatsWsClient {
  final AppWebSocketClient _wsClient;
  final AppLogger _logger;

  ChatsWsClient(this._wsClient, this._logger);

  Stream<Map<String, dynamic>> get rawMessagesStream => _wsClient.messageStream;
  Stream<WsConnectionStatus> get statusStream => _wsClient.statusStream;

  void connectWithToken(String accessToken) {
    final baseUrl = ServicesConfig.authBaseUrl.replaceFirst('http', 'ws');
    final wsUrl = '$baseUrl${ApiEndpoints.wsMessaging(accessToken)}';

    _logger.i(
      '[ChatsWsClient] Inicjalizacja połączenia WS pod adres: $wsUrl',
    );

    _wsClient.connect(wsUrl);
  }

  void sendPayload(Map<String, dynamic> payload) {
    _logger.i('[ChatsWsClient] Wysyłanie wiadomości WS: $payload');
    _wsClient.send(payload);
  }

  void disconnect() {
    _logger.i('[ChatsWsClient] Ręczne rozłączanie sesji WS');
    _wsClient.disconnect();
  }
}

@riverpod
AppWebSocketClient appWebSocketClient(Ref ref) {
  final logger = ref.watch(appLoggerProvider);
  final client = AppWebSocketClient(logger: logger);

  ref.onDispose(() => client.dispose());
  return client;
}

@riverpod
ChatsWsClient chatsWsClient(Ref ref) {
  final rawWsClient = ref.watch(appWebSocketClientProvider);
  final logger = ref.watch(appLoggerProvider);

  return ChatsWsClient(rawWsClient, logger);
}
