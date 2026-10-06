import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'change_password_service.g.dart';

abstract interface class ChangePasswordService {
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}

class PendingBackendChangePasswordService implements ChangePasswordService {
  const PendingBackendChangePasswordService();

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    throw UnimplementedError(
      'Password change backend integration is pending.',
    );
  }
}

@riverpod
ChangePasswordService changePasswordService(Ref ref) {
  return const PendingBackendChangePasswordService();
}
