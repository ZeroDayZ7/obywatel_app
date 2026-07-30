import 'dart:async';
import 'dart:convert';

import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

enum WsConnectionStatus { disconnected, connecting, connected }

class AppWebSocketClient {
  final AppLogger _logger;
  
  WebSocketChannel? _channel;
  StreamController<Map<String, dynamic>>? _messageController;
  StreamController<WsConnectionStatus>? _statusController;
  
  Timer? _pingTimer;
  Timer? _reconnectTimer;
  
  int _reconnectAttempts = 0;
  bool _isExplicitlyClosed = false;
  String? _currentUrl;

  AppWebSocketClient({required AppLogger logger}) : _logger = logger {
    _messageController = StreamController<Map<String, dynamic>>.broadcast();
    _statusController = StreamController<WsConnectionStatus>.broadcast();
  }

  Stream<Map<String, dynamic>> get messageStream => _messageController!.stream;
  Stream<WsConnectionStatus> get statusStream => _statusController!.stream;

  void connect(String url) {
    _currentUrl = url;
    _isExplicitlyClosed = false;
    _establishConnection();
  }

  void _establishConnection() {
    if (_currentUrl == null) return;

    _statusController?.add(WsConnectionStatus.connecting);
    _logger.i('[WS] Łączenie z URL: $_currentUrl');

    try {
      _channel = WebSocketChannel.connect(Uri.parse(_currentUrl!));
      _statusController?.add(WsConnectionStatus.connected);
      _reconnectAttempts = 0;
      _startPingTimer();

      _channel!.stream.listen(
        (dynamic rawData) {
          _handleIncomingMessage(rawData);
        },
        onError: (Object error) {
          _logger.e('[WS] Błąd połączenia: $error');
          _handleDisconnect();
        },
        onDone: () {
          _logger.w('[WS] Połączenie zamknięte przez serwer.');
          _handleDisconnect();
        },
        cancelOnError: true,
      );
    } catch (e, stack) {
      _logger.e('[WS] Nie udało się nawiązać połączenia', error: e, stackTrace: stack);
      _handleDisconnect();
    }
  }

  void _handleIncomingMessage(dynamic rawData) {
    try {
      if (rawData is String) {
        if (rawData == 'pong') return; // Heartbeat response
        final data = jsonDecode(rawData) as Map<String, dynamic>;
        _messageController?.add(data);
      }
    } catch (e) {
      _logger.e('[WS] Błąd parsowania ramki JSON: $rawData', error: e);
    }
  }

  void send(Map<String, dynamic> data) {
    if (_channel != null) {
      _channel!.sink.add(jsonEncode(data));
    } else {
      _logger.w('[WS] Próba wysłania wiadomości przy braku połączenia!');
    }
  }

  void _startPingTimer() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(const Duration(seconds: 25), (_) {
      if (_channel != null) {
        _channel!.sink.add('ping');
      }
    });
  }

  void _handleDisconnect() {
    _stopPingTimer();
    _statusController?.add(WsConnectionStatus.disconnected);

    if (!_isExplicitlyClosed) {
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    _reconnectTimer?.cancel();
    _reconnectAttempts++;
    
    // Exponential backoff: max 30 sekund
    final delaySeconds = (_reconnectAttempts * 2).clamp(2, 30);
    _logger.i('[WS] Rekonstrukcja połączenia za $delaySeconds sek...');

    _reconnectTimer = Timer(Duration(seconds: delaySeconds), () {
      _establishConnection();
    });
  }

  void _stopPingTimer() {
    _pingTimer?.cancel();
    _pingTimer = null;
  }

  void disconnect() {
    _isExplicitlyClosed = true;
    _stopPingTimer();
    _reconnectTimer?.cancel();
    _channel?.sink.close();
    _channel = null;
    _statusController?.add(WsConnectionStatus.disconnected);
    _logger.i('[WS] Połączenie rozłączone na żądanie.');
  }

  void dispose() {
    disconnect();
    _messageController?.close();
    _statusController?.close();
  }
}