// lib/core/network/api_endpoints.dart

abstract class ApiEndpoints {
  // --- AUTH ---
  static String get login => '/auth/login';
  static String get authMe => '/auth/me';
  static String get unpairDevice => '/auth/unpair-device';
  static String get register => '/auth/register';
  static String get registerDevice => '/auth/register-device';
  static String get verifyDevice => '/auth/verify-device';
  static String get logout => '/auth/logout';
  static String get userProfile => '/user/profile';
  static String get fetchConfig => '/app/config';
  static String get refresh => '/auth/refresh';
  static String get reset => '/auth/reset/send';
  static String get verifyResetCode => '/auth/reset/verify';
  static String get resetFinal => '/auth/reset/final';
  static String get createTemporarySession => '/auth/temporary-session';

  // --- 2FA ---
  static String get twoFaVerify => '/auth/2fa-verify';
  static String get twoFaResend => '/auth/2fa-resend';

  // --- PUBLIC ---
  static String get checkVersion => '/version';

  // --- SESSION ---
  static String get userSessions => '/user/sessions';
  static String get terminateSession => '/user/sessions/terminate';

  // --- NOTIFICATIONS ---
  static String get notifications => '/notifications';
  static String markAsRead(String id) => '/notifications/$id/read';
  static String get markAllNotificationsAsRead => '/notifications/read-all';
  static String moveToTrash(String id) => '/notifications/$id/trash';
  static String get clearTrash => '/notifications/trash';
  static String restoreFromTrash(String id) => '/notifications/$id/restore';
  static String deleteNotification(String id) => '/notifications/$id';

  // --- DOCUMENTS ---
  static String get documentsMe => '/documents/me';
  static String get documents => '/documents';
  static String documentById(String id) => '/documents/$id';

  // ===========================================================================
  // --- CONTACTS ---
  // ===========================================================================
  static String get contacts => '/contacts';
  static String get contactsSearch => '/contacts/search';
  static String contactById(String id) => '/contacts/$id';
  static String acceptContact(String id) => '/contacts/$id/accept';
  static String blockContact(String id) => '/contacts/$id/block';

  // ===========================================================================
  // --- CHATS & MESSAGES ---
  // ===========================================================================
  static String get conversations => '/conversations';
  static String conversationById(String id) => '/conversations/$id';
  static String conversationMessages(String id) =>
      '/conversations/$id/messages';
  static String markConversationAsRead(String id) => '/conversations/$id/read';

  // ===========================================================================
  // --- DELTA SYNC & OUTBOX (Offline-First) ---
  // ===========================================================================
  static String get syncDelta => '/sync/delta';
  static String get syncOutbox => '/sync/outbox';

  // ===========================================================================
  // --- E2EE CRYPTO KEYS EXCHANGE (Signal Protocol / X3DH) ---
  // ===========================================================================
  static String get cryptoDeviceKeys => '/crypto/keys/device';
  static String userPreKeys(String userId) => '/crypto/keys/prekeys/$userId';

  // ===========================================================================
  // --- REAL-TIME WEBSOCKET ---
  // ===========================================================================
  static String wsMessaging(String token) => '/ws/messaging?token=$token';
}
