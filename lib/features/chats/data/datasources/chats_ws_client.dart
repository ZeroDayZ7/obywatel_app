import 'package:obywatel_plus/app/config/services_config.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/network/api_endpoints.dart';
import 'package:obywatel_plus/core/network/clients/app_websocket_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chats_ws_client.g.dart';

class ChatsWsClient {
  final AppWebSocketClient _wsClient;

  ChatsWsClient(this._wsClient);

  Stream<Map<String, dynamic>> get rawMessagesStream => _wsClient.messageStream;
  Stream<WsConnectionStatus> get statusStream => _wsClient.statusStream;

  void connectWithToken(String accessToken) {
    final baseUrl = ServicesConfig.authBaseUrl.replaceFirst('http', 'ws');
    final wsUrl = '$baseUrl${ApiEndpoints.wsMessaging(accessToken)}';
    _wsClient.connect(wsUrl);
  }

  void sendPayload(Map<String, dynamic> payload) {
    _wsClient.send(payload);
  }

  void disconnect() {
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
  return ChatsWsClient(rawWsClient);
}
