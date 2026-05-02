

import 'package:obywatel_plus/app/config/services_config.dart'
    show ServicesConfig;








class ChatConfig {
  
  
  
  static String get baseUrl => ServicesConfig.chatRestBaseUrl;

  
  
  
  static String get wsBaseUrl => ServicesConfig.chatWsBaseUrl;

  
  
  
  static const int apiTimeout = 15;

  
  
  
  static const int pageSize = 20;
}
