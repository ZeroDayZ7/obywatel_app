import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;

import 'package:obywatel_plus/core/logger/app_logger.dart';

enum WsConnectionStatus { disconnected, connecting, connected }

class AppWebSocketClient {
  AppWebSocketClient({required AppLogger logger}) : _logger = logger {
    _messageController = StreamController<Map<String, dynamic>>.broadcast();
    _statusController = StreamController<WsConnectionStatus>.broadcast();
    _statusController.add(WsConnectionStatus.disconnected);
  }

  final AppLogger _logger;

  io.WebSocket? _socket;
  StreamSubscription<dynamic>? _socketSubscription;
  late final StreamController<Map<String, dynamic>> _messageController;
  late final StreamController<WsConnectionStatus> _statusController;

  Timer? _pingTimer;
  Timer? _reconnectTimer;

  int _reconnectAttempts = 0;
  bool _isExplicitlyClosed = false;
  bool _isConnecting = false;
  Map<String, String> _connectionHeaders = const {};
  String? _currentUrl;

  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;
  Stream<WsConnectionStatus> get statusStream => _statusController.stream;
  bool get isConnected => _socket != null;

  Future<void> connect(String url, {Map<String, String>? headers}) async {
    final normalizedHeaders = headers ?? const <String, String>{};

    if (_isConnecting && _currentUrl == url) {
      return;
    }

    if (_socket != null && _currentUrl == url) {
      return;
    }

    if (_socket != null) {
      await disconnect();
    }

    _currentUrl = url;
    _connectionHeaders = normalizedHeaders;
    _isExplicitlyClosed = false;
    _isConnecting = true;
    _statusController.add(WsConnectionStatus.connecting);

    _logger.i('[WS] Łączenie z URL: $url (Android/Windows)');

    try {
      // Dart:io WebSocket natywnie wspiera nagłówki na Androidzie i Windowsie
      final socket = await io.WebSocket.connect(
        url,
        headers: _connectionHeaders,
      );
      
      _socket = socket;
      _reconnectAttempts = 0;
      _statusController.add(WsConnectionStatus.connected);
      _startPingTimer();

      _socketSubscription = socket.listen(
        _handleIncomingMessage,
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
      _logger.e(
        '[WS] Nie udało się nawiązać połączenia',
        error: e,
        stackTrace: stack,
      );
      _handleDisconnect();
    } finally {
      _isConnecting = false;
    }
  }

  void _handleIncomingMessage(dynamic rawData) {
    try {
      if (rawData is String) {
        if (rawData == 'pong') return;
        final decoded = jsonDecode(rawData);
        if (decoded is Map<String, dynamic>) {
          _messageController.add(decoded);
          return;
        }
        if (decoded is Map) {
          _messageController.add(Map<String, dynamic>.from(decoded));
          return;
        }
      }
    } catch (e) {
      _logger.e('[WS] Błąd parsowania ramki JSON: $rawData', error: e);
    }
  }

  void send(Map<String, dynamic> data) {
    final encoded = jsonEncode(data);
    if (_socket != null) {
      _socket!.add(encoded);
      return;
    }
    _logger.w('[WS] Próba wysłania wiadomości przy braku połączenia!');
  }

  void _startPingTimer() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(const Duration(seconds: 25), (_) {
      if (_socket != null) {
        _socket!.add('ping');
      }
    });
  }

  void _handleDisconnect() {
    _stopPingTimer();
    _statusController.add(WsConnectionStatus.disconnected);

    if (!_isExplicitlyClosed) {
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    _reconnectTimer?.cancel();
    _reconnectAttempts++;

    final delaySeconds = (_reconnectAttempts * 2).clamp(2, 30);
    _logger.i('[WS] Rekonstrukcja połączenia za $delaySeconds sek...');

    _reconnectTimer = Timer(Duration(seconds: delaySeconds), () {
      if (_currentUrl == null) return;
      unawaited(connect(_currentUrl!, headers: _connectionHeaders));
    });
  }

  void _stopPingTimer() {
    _pingTimer?.cancel();
    _pingTimer = null;
  }

  Future<void> disconnect() async {
    _isExplicitlyClosed = true;
    _stopPingTimer();
    _reconnectTimer?.cancel();

    if (_socket != null) {
      await _socket!.close();
      _socket = null;
    }

    _socketSubscription?.cancel();
    _socketSubscription = null;
    _statusController.add(WsConnectionStatus.disconnected);
    _logger.i('[WS] Połączenie rozłączone na żądanie.');
  }

  Future<void> dispose() async {
    await disconnect();
    await _messageController.close();
    await _statusController.close();
  }
}