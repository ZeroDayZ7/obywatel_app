import 'package:obywatel_plus/core/network/api_endpoints.dart';
import 'package:obywatel_plus/core/network/clients/api_client.dart';
import 'package:obywatel_plus/core/network/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'change_password_service.g.dart';

abstract interface class ChangePasswordService {
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}

class AuthenticatedChangePasswordService implements ChangePasswordService {
  final ApiClient _apiClient;

  const AuthenticatedChangePasswordService(this._apiClient);

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _apiClient.post(
      ApiEndpoints.changePassword,
      data: {
        'current_password': currentPassword,
        'new_password': newPassword,
      },
    );
  }
}

@riverpod
ChangePasswordService changePasswordService(Ref ref) {
  return AuthenticatedChangePasswordService(ref.watch(apiClientProvider));
}
