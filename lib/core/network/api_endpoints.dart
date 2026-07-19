// lib/core/network/api_endpoints.dart

class ApiEndpoints {
  // AUTH
  static String get login => '/auth/login';
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

  // 2FA
  static String get twoFaVerify => '/auth/2fa-verify';
  static String get twoFaResend => '/auth/2fa-resend';

  // PUBLIC
  static String get checkVersion => '/version';

  // SESSION
  static String get userSessions => '/user/sessions';
  static String get terminateSession => '/user/sessions/terminate';

  // NOTIFICATIONS
  static String get notifications => '/notifications';
  static String markAsRead(String id) => '/notifications/$id/read';
  static String get markAllNotificationsAsRead => '/notifications/read-all';
  static String moveToTrash(String id) => '/notifications/$id/trash';
  static String get clearTrash => '/notifications/trash';
  static String restoreFromTrash(String id) => '/notifications/$id/restore';
  static String deleteNotification(String id) => '/notifications/$id';
}
