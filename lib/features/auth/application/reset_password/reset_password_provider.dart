import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/network/providers.dart';
import 'package:obywatel_plus/features/auth/application/reset_password/reset_password_service.dart';

final resetPasswordServiceProvider = Provider<ResetPasswordService>((ref) {
  final api = ref.read(resetApiClientProvider);
  return ResetPasswordService(api);
});
