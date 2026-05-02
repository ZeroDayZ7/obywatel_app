// lib/app/router/app_routes.dart
class AppRoutes {
  static const splash = '/splash';
  static const initial = '/initial';
  static const pin = '/pin';
  static const login = '/login';
  static const resetPassword = '/reset-password';
  static const twoFaVerify = '/2fa';
  static const home = '/home';
  static const error = '/error';
  static const test = '/test';
  static const update = '/update';

  // Nowe ścieżki dla Settings
  static const setPin = 'set_pin';

  static const patternLock = 'pattern_lock';
  static const fingerprint = 'fingerprint';

  static const securitySetup = '/security_setup';

  // Ścieżki dla HomeScreen dashboard
  static const profile = '/profile';

  static const documents = '/documents';
  static const idCard = 'id_card';

  static const notifications = '/notifications';
  static const notificationsTrash = 'trash';
  // Settings
  static const settings = '/settings';
  static const settingsSecurity = 'security';
  static const settingsNotifications = 'notifications';
  static const settingsActiveSession = 'active-session';
  static const settingsChangePin = 'change-pin';
 // chats
  static const chats = '/chats';
  static const chatGroups = '/chats/groups';
  static const chatSettings = '/chats/settings';
  static const chatDetail = '/chats/:username';
 // contacts
  static const contacts = '/contacts';
  static const contactsFavorites = '/contacts/favorites';
  static const contactsSettings = '/contacts/settings';

  static const explore = '/explore';
  static const payments = '/payments';
  static const store = '/store';
  static const health = '/health';
  static const education = '/education';
  static const games = '/games';
  static const videos = '/videos';
  static const favorites = '/favorites';
  static const help = '/help';
  // work_and_career
  static const workAndCareer = '/work_and_career';
  static const workAndCareerJobOffers = 'job_offers';
  static const workAndCareerMyCV = 'my_cv';
  static const workAndCareerApplications = 'applications';
  static const workAndCareerCareerAdvice = 'career_advice';
  static const workInternships = 'internships';
  static const workGovernmentSupport = 'government_support';
  static const workEmploymentMap = 'employment_map';
}
