import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/utils/validators.dart';
import 'package:obywatel_plus/features/settings/application/change_password_service.dart';
import 'package:obywatel_plus/features/settings/domain/change_password_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'change_password_notifier.g.dart';

@riverpod
class ChangePasswordNotifier extends _$ChangePasswordNotifier {
  @override
  ChangePasswordState build() {
    return const ChangePasswordState();
  }

  Future<void> submit({
    required String currentPassword,
    required String newPassword,
    required String confirmation,
  }) async {
    final currentError = Validators.validatePassword(currentPassword, minLength: 8);
    final newError = Validators.validatePassword(newPassword, minLength: 8);

    if (currentPassword.trim().isEmpty) {
      state = const ChangePasswordState(
        status: ChangePasswordStatus.error,
        messageKey: LocaleKeys.validators_required_password,
      );
      return;
    }

    if (currentError != null) {
      state = ChangePasswordState(
        status: ChangePasswordStatus.error,
        messageKey: currentError,
      );
      return;
    }

    if (newError != null) {
      state = ChangePasswordState(
        status: ChangePasswordStatus.error,
        messageKey: newError,
      );
      return;
    }

    if (newPassword != confirmation) {
      state = ChangePasswordState(
        status: ChangePasswordStatus.error,
        messageKey: LocaleKeys.validators_passwords_not_match,
      );
      return;
    }

    state = state.copyWith(status: ChangePasswordStatus.submitting, messageKey: null);

    try {
      await ref.read(changePasswordServiceProvider).changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      state = const ChangePasswordState(
        status: ChangePasswordStatus.error,
        messageKey: LocaleKeys.settings_change_password_backend_pending,
      );
    } on UnimplementedError {
      state = const ChangePasswordState(
        status: ChangePasswordStatus.error,
        messageKey: LocaleKeys.settings_change_password_backend_pending,
      );
    } catch (error) {
      state = ChangePasswordState(
        status: ChangePasswordStatus.error,
        messageKey: error.toString(),
      );
    }
  }
}
