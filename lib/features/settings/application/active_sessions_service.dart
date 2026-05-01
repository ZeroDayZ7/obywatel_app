import 'package:obywatel_plus/core/network/api_endpoints.dart';
import 'package:obywatel_plus/core/network/clients/api_client.dart';
import 'package:obywatel_plus/core/network/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:obywatel_plus/features/settings/application/user_session.dart';

part 'active_sessions_service.g.dart';

class ActiveSessionsService {
  final ApiClient _apiClient;
  ActiveSessionsService(this._apiClient);

  Future<List<UserSession>> getActiveSessions() async {
    final response = await _apiClient.get(ApiEndpoints.userSessions);

    // Używamy bezpiecznego rzutowania i mapowania Freezed
    if (response.data is List) {
      return (response.data as List)
          .map((json) => UserSession.fromJson(json as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<void> terminateSession(int sessionId) async {
    await _apiClient.post(
      ApiEndpoints.terminateSession,
      data: {'session_id': sessionId},
    );
  }
}

@riverpod
ActiveSessionsService activeSessionsService(Ref ref) {
  return ActiveSessionsService(ref.watch(apiClientProvider));
}
