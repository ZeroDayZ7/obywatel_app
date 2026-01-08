import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/design/widgets/ui/button.dart';
import 'package:obywatel_plus/features/auth/application/reset_password/reset_password_notifier.dart';

class CodeInputWidget extends StatelessWidget {
  final TextEditingController codeController;
  final int resendTime;
  final bool canResend;
  final bool isLoading;
  final ResetPasswordNotifier notifier;

  const CodeInputWidget({
    super.key,
    required this.codeController,
    required this.resendTime,
    required this.canResend,
    required this.isLoading,
    required this.notifier,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: codeController,
          maxLength: 6,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 28, letterSpacing: 6),
          decoration: const InputDecoration(counterText: ""),
        ),
        const SizedBox(height: 16),
        AppButton(
          labelKey: canResend
              ? LocaleKeys.reset_password_resend.tr()
              : LocaleKeys.reset_password_resend_in.tr(
                  namedArgs: {'seconds': resendTime.toString()},
                ),
          onPressed: canResend ? () => notifier.sendResetCode() : null,
          variant: AppButtonVariant.text,
        ),
        const SizedBox(height: 16),
        AppButton(
          labelKey: LocaleKeys.common_confirm.tr(),
          isLoading: isLoading,
          onPressed: isLoading
              ? null
              : () async {
                  await notifier.verifyCode(codeController.text.trim());
                },
          variant: AppButtonVariant.primary,
        ),
      ],
    );
  }
}
