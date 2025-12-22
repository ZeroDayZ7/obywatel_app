// lib/config/services_config.dart
import 'package:obywatel_plus/app/config/env.dart';

// ============================================================
// ServicesConfig
// ============================================================
// Centralized configuration for all microservice endpoints
// in the application. This includes both REST API and WebSocket
// URLs. Automatically switches between development and
// production environments based on `apiConstants.isProduction`.
// ============================================================
/// REST base URL for Chat microservice
class ServicesConfig {
  // ==========================================================
  // REST API Endpoints
  // ==========================================================

  /// Authentication service base URL
  /// Used for login, logout, token refresh, etc.
  static String get authBaseUrl => apiConstants.isProduction
      ? 'https://api-test.ct8.pl'
      : 'http://localhost:8081';

  /// Version service base URL
  static String get versionBaseUrl => apiConstants.isProduction
      ? 'https://api-test.ct8.pl'
      : 'http://localhost:8085';

  /// Chat service REST API base URL
  /// Used for fetching chat history, sending messages via REST, etc.
  static String get chatRestBaseUrl => apiConstants.isProduction
      ? 'https://chat.example.com/api'
      : 'http://localhost:8082';

  /// Payments service base URL
  /// Used for payment processing, transaction history, etc.
  static String get paymentsBaseUrl => apiConstants.isProduction
      ? 'https://payments.example.com/api'
      : 'http://localhost:8083';

  // ==========================================================
  // WebSocket Endpoints
  // ==========================================================

  /// Chat service WebSocket URL
  /// Used for real-time messaging and push updates
  static String get chatWsBaseUrl => apiConstants.isProduction
      ? 'wss://chat.example.com/ws'
      : 'ws://localhost:8082/ws';
}
