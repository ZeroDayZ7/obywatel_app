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
  WsConnectionStatus _currentStatus = WsConnectionStatus.disconnected;

  Timer? _pingTimer;
  Timer? _reconnectTimer;

  int _reconnectAttempts = 0;
  int _connectGeneration = 0;
  bool _isExplicitlyClosed = false;
  bool _isConnecting = false;
  bool _disposed = false;
  Map<String, String> _connectionHeaders = const {};
  String? _currentUrl;
  String? _sessionKey;

  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;
  WsConnectionStatus get currentStatus => _currentStatus;
  Stream<WsConnectionStatus> get statusStream => Stream.multi((controller) {
        controller.add(_currentStatus);
        final subscription = _statusController.stream.listen(
          (status) {
            controller.add(status);
          },
          onDone: () => controller.close(),
          onError: (Object error, StackTrace stackTrace) {
            controller.addError(error, stackTrace);
          },
        );

        controller.onCancel = () async {
          await subscription.cancel();
        };
      });

  bool get isConnected => !_disposed && _socket != null && !_isExplicitlyClosed;

  Future<void> connect(
    String url, {
    Map<String, String>? headers,
    String? sessionKey,
  }) async {
    final normalizedHeaders = headers ?? const <String, String>{};
    final generation = ++_connectGeneration;

    _logger.d(
      '[WS][0] connect() called url=$url sessionKeyPresent=${sessionKey != null && sessionKey.isNotEmpty} headers=${normalizedHeaders.keys.toList()}',
      module: 'WS',
    );

    if (_isConnecting && _currentUrl == url && _sessionKey == sessionKey) {
      _logger.d('[WS][1] connect() skipped because same socket is already connecting', module: 'WS');
      return;
    }

    if (_socket != null && _currentUrl == url && _sessionKey == sessionKey) {
      _logger.d('[WS][2] connect() skipped because socket already exists for same session', module: 'WS');
      return;
    }

    _currentUrl = url;
    _connectionHeaders = normalizedHeaders;
    _sessionKey = sessionKey;
    _isExplicitlyClosed = false;

    if (_socket != null) {
      await disconnect();
    }

    _isConnecting = true;
    _setStatus(WsConnectionStatus.connecting);

    _logger.i('[WS] Łączenie z URL: $url (Android/Windows)');
    _logger.d('[WS][3] about to call io.WebSocket.connect()', module: 'WS');

    try {
      final socket = await io.WebSocket.connect(
        url,
        headers: _connectionHeaders,
      );

      if (generation != _connectGeneration || _disposed) {
        await socket.close();
        return;
      }

      _socket = socket;
      _reconnectAttempts = 0;
      _setStatus(WsConnectionStatus.connected);
      _logger.i('[WS] Stan połączenia ustawiony na CONNECTED.');
      _startPingTimer();

      _socketSubscription = socket.listen(
        _handleIncomingMessage,
        onError: (Object error, StackTrace stackTrace) {
          _logger.e('[WS] Błąd połączenia: $error', stackTrace: stackTrace);
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
      if (!_disposed && !_isExplicitlyClosed) {
        _handleDisconnect();
      }
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
    } catch (e, stack) {
      _logger.e(
        '[WS] Błąd parsowania ramki JSON: $rawData',
        error: e,
        stackTrace: stack,
      );
    }
  }

  void send(Map<String, dynamic> data) {
    final socket = _socket;
    if (socket == null) {
      _logger.w('[WS] Próba wysłania wiadomości przy braku połączenia!');
      return;
    }

    try {
      socket.add(jsonEncode(data));
    } catch (e, stack) {
      _logger.e(
        '[WS] Błąd wysyłania wiadomości',
        error: e,
        stackTrace: stack,
      );
      _handleDisconnect();
    }
  }

  void _startPingTimer() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(const Duration(seconds: 25), (_) {
      final socket = _socket;
      if (socket == null) {
        return;
      }

      try {
        socket.add('ping');
      } catch (e, stack) {
        _logger.e(
          '[WS] Błąd heartbeat',
          error: e,
          stackTrace: stack,
        );
        _handleDisconnect();
      }
    });
  }

  void _setStatus(WsConnectionStatus status) {
    _currentStatus = status;
    _statusController.add(status);
  }

  void _handleDisconnect() {
    _stopPingTimer();
    _socketSubscription?.cancel();
    _socketSubscription = null;
    _socket = null;
    _setStatus(WsConnectionStatus.disconnected);

    if (_disposed || _isExplicitlyClosed || _currentUrl == null) {
      return;
    }

    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    if (_reconnectTimer != null || _isExplicitlyClosed || _currentUrl == null) {
      return;
    }

    _reconnectAttempts++;
    final delaySeconds = (_reconnectAttempts * 2).clamp(2, 30);
    _logger.i('[WS] Rekonstrukcja połączenia za $delaySeconds sek...');

    _reconnectTimer = Timer(Duration(seconds: delaySeconds), () {
      _reconnectTimer = null;
      if (_disposed || _isExplicitlyClosed || _currentUrl == null) {
        return;
      }

      unawaited(
        connect(
          _currentUrl!,
          headers: _connectionHeaders,
          sessionKey: _sessionKey,
        ),
      );
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
    _reconnectTimer = null;

    final socket = _socket;
    _socket = null;
    _currentUrl = null;
    _sessionKey = null;

    if (socket != null) {
      await socket.close();
    }

    _socketSubscription?.cancel();
    _socketSubscription = null;
    _setStatus(WsConnectionStatus.disconnected);
    _logger.i('[WS] Połączenie rozłączone na żądanie.');
  }

  Future<void> dispose() async {
    _disposed = true;
    _connectGeneration++;
    await disconnect();
    await _messageController.close();
    await _statusController.close();
  }
}