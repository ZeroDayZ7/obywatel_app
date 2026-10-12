import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/config/services_config.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/network/api_endpoints.dart';
import 'package:obywatel_plus/core/network/clients/app_websocket_client.dart';
import 'package:obywatel_plus/core/utils/device_info_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chats_ws_client.g.dart';

class ChatsWsClient {
  ChatsWsClient(this._wsClient, this._logger, this._deviceInfoService);

  final AppWebSocketClient _wsClient;
  final AppLogger _logger;
  final DeviceInfoService _deviceInfoService;

  Stream<Map<String, dynamic>> get rawMessagesStream => _wsClient.messageStream;
  Stream<WsConnectionStatus> get statusStream => _wsClient.statusStream;
  bool get isConnected => _wsClient.isConnected;

  Future<void> connectWithToken(String accessToken) async {
    final token = accessToken.trim();
    if (token.isEmpty) {
      _logger.w(
        '[ChatsWsClient] Brak access tokenu; pomijam otwarcie połączenia WS.',
      );
      await _wsClient.disconnect();
      return;
    }

    final deviceFingerprint = await _deviceInfoService.getFingerprint();
    final normalizedBaseUrl = ServicesConfig.apiBaseUrl
        .replaceFirst('https://', 'wss://')
        .replaceFirst('http://', 'ws://')
        .replaceAll(RegExp(r'/+$'), '');
    final wsUrl = '$normalizedBaseUrl${ApiEndpoints.wsMessaging}';

    _logger.i('[ChatsWsClient] Inicjalizacja połączenia WS pod adres: $wsUrl');

    await _wsClient.connect(
      wsUrl,
      headers: {
        'Authorization': 'Bearer $token',
        'X-Device-Fingerprint': deviceFingerprint,
      },
    );
  }

  void sendPayload(Map<String, dynamic> payload) {
    _logger.i('[ChatsWsClient] Wysyłanie wiadomości WS: $payload');
    _wsClient.send(payload);
  }

  Future<void> disconnect() async {
    _logger.i('[ChatsWsClient] Ręczne rozłączanie sesji WS');
    await _wsClient.disconnect();
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
  final deviceInfoService = ref.watch(deviceInfoServiceProvider);

  return ChatsWsClient(rawWsClient, logger, deviceInfoService);
}

final chatsWsStatusProvider = StreamProvider<WsConnectionStatus>((ref) {
  final wsClient = ref.watch(chatsWsClientProvider);
  return wsClient.statusStream;
});
