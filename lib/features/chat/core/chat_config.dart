// lib/config/config.dart

import 'package:obywatel_plus/app/config/services_config.dart'
    show ServicesConfig;

/// ============================================================
/// ChatConfig
/// ============================================================
/// Central configuration for Chat service endpoints, both
/// REST API and WebSocket. Pulls URLs from ServicesConfig
/// depending on environment (dev/prod).
/// ============================================================
class ChatConfig {
  // ==========================================================
  // REST API Base URL
  // ==========================================================
  static String get baseUrl => ServicesConfig.chatRestBaseUrl;

  // ==========================================================
  // WebSocket Base URL
  // ==========================================================
  static String get wsBaseUrl => ServicesConfig.chatWsBaseUrl;

  // ==========================================================
  // Timeout for API requests (seconds)
  // ==========================================================
  static const int apiTimeout = 15;

  // ==========================================================
  // Other global constants
  // ==========================================================
  static const int pageSize = 20;
}
