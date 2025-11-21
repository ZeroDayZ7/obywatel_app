// lib/features/chat/config/chat_endpoints.dart
import 'package:obywatel_plus/features/chat/config/chat_config.dart';

class ChatEndpoints {
  static String messages(String chatId) =>
      '${ChatConfig.baseUrl}/chat/$chatId/messages';

  static String sendMessage(String chatId) =>
      '${ChatConfig.baseUrl}/chat/$chatId/send';

  static String ws(String chatId) =>
      '${ChatConfig.wsBaseUrl}/chat/$chatId';
}
