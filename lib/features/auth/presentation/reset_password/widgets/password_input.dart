import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/design/widgets/ui/button.dart';
import 'package:obywatel_plus/core/utils/validators.dart';
import 'package:obywatel_plus/features/auth/application/reset_password/reset_password_notifier.dart';

class PasswordInputWidget extends StatelessWidget {
  final TextEditingController passwordController;
  final bool isLoading;
  final ResetPasswordNotifier notifier;

  const PasswordInputWidget({
    super.key,
    required this.passwordController,
    required this.isLoading,
    required this.notifier,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: passwordController,
          decoration: InputDecoration(
            labelText: LocaleKeys.reset_password_new_password.tr(),
            border: const UnderlineInputBorder(),
          ),
          validator: Validators.validatePassword,
          obscureText: true,
        ),
        const SizedBox(height: 24),
        AppButton(
          labelKey: LocaleKeys.common_confirm.tr(),
          isLoading: isLoading,
          onPressed: isLoading
              ? null
              : () async {
                  await notifier.resetPassword(passwordController.text.trim());
                },
          variant: AppButtonVariant.primary,
        ),
      ],
    );
  }
}
