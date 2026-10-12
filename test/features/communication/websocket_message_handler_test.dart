import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/network/clients/app_websocket_client.dart';
import 'package:obywatel_plus/core/utils/device_info_service.dart';
import 'package:obywatel_plus/features/communication/application/websocket_message_handler.dart';
import 'package:obywatel_plus/features/communication/data/datasources/chats_ws_client.dart';

ChatsWsClient _buildWsClient() => ChatsWsClient(
  AppWebSocketClient(logger: AppLogger()),
  AppLogger(),
  DeviceInfoService(AppLogger()),
);

void main() {
  test('new_message trigggeruje synchronizację czatów', () async {
    final triggered = <String>[];
    final handler = WebSocketMessageHandler(
      _buildWsClient(),
      AppLogger(),
      (type) async {
        triggered.add(type);
      },
    );

    handler.handleIncomingMessage({'type': 'new_message'});
    await Future<void>.delayed(Duration.zero);

    expect(triggered, ['new_message']);
  });

  test('contact_updated trigggeruje synchronizację kontaktów', () async {
    final triggered = <String>[];
    final handler = WebSocketMessageHandler(
      _buildWsClient(),
      AppLogger(),
      (type) async {
        triggered.add(type);
      },
    );

    handler.handleIncomingMessage({'type': 'contact_updated'});
    await Future<void>.delayed(Duration.zero);

    expect(triggered, ['contact_updated']);
  });
}
