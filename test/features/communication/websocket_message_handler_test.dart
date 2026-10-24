import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/network/clients/app_websocket_client.dart';
import 'package:obywatel_plus/features/communication/application/websocket_message_handler.dart';

AppWebSocketClient _buildWsClient() => AppWebSocketClient(
  logger: AppLogger(),
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

  test('asynchroniczny błąd callbacka jest obsłużony i nie wywołuje crasha', () async {
    final handler = WebSocketMessageHandler(
      _buildWsClient(),
      AppLogger(),
      (type) async {
        await Future<void>.delayed(const Duration(milliseconds: 1));
        throw StateError('boom');
      },
    );

    expect(
      () => handler.handleIncomingMessage({'type': 'new_message'}),
      returnsNormally,
    );
    await Future<void>.delayed(const Duration(milliseconds: 20));
  });

  test('pusty i nieznany typ nie uruchamia callbacka', () async {
    final triggered = <String>[];
    final handler = WebSocketMessageHandler(
      _buildWsClient(),
      AppLogger(),
      (type) async {
        triggered.add(type);
      },
    );

    handler.handleIncomingMessage({'type': ''});
    handler.handleIncomingMessage({'type': 'unknown_type'});
    await Future<void>.delayed(Duration.zero);

    expect(triggered, isEmpty);
  });
}
