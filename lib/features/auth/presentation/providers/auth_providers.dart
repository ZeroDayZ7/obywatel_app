import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/utils/device_info_service.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_controller.dart';
import 'package:obywatel_plus/features/auth/domain/auth_state.dart';
import 'package:obywatel_plus/features/auth/domain/auth_user.dart';

final currentAuthUserProvider = Provider<AuthUser?>((ref) {
  final authState = ref.watch(authControllerProvider);

  return authState.maybeMap(
    authenticated: (state) => state.user,
    orElse: () => null,
  );
});

final currentUserIdProvider = Provider<String>((ref) {
  final user = ref.watch(currentAuthUserProvider);
  if (user == null) {
    throw StateError('Brak uwierzytelnionego użytkownika');
  }
  return user.id;
});

final currentDeviceIdProvider = FutureProvider<String>((ref) async {
  final deviceInfoService = ref.watch(deviceInfoServiceProvider);
  return deviceInfoService.getOrCreateDeviceId();
});
