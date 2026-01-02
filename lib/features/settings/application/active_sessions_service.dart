import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/network/api_client.dart';
import 'package:obywatel_plus/core/network/api_endpoints.dart';
import 'package:obywatel_plus/core/network/providers.dart';

import 'user_session.dart';

class ActiveSessionsService {
  final ApiClient _apiClient;
  ActiveSessionsService(this._apiClient);

  Future<List<UserSession>> getActiveSessions() async {
    final response = await _apiClient.get(ApiEndpoints.userSessions);

    // Backend Go zwraca [] (listę), więc mapujemy ją bezpośrednio
    if (response.data is List) {
      final List<dynamic> data = response.data;
      return data.map((json) => UserSession.fromJson(json)).toList();
    }

    return [];
  }

  Future<bool> terminateSession(int sessionId) async {
    try {
      await _apiClient.post(
        ApiEndpoints.terminateSession,
        data: {'session_id': sessionId},
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}

final activeSessionsServiceProvider = Provider<ActiveSessionsService>((ref) {
  return ActiveSessionsService(ref.watch(apiClientProvider));
});
