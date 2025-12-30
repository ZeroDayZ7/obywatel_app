import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/design/widgets/ui/button.dart';
import 'package:obywatel_plus/core/utils/validators.dart';
import 'package:obywatel_plus/features/auth/application/reset_password/reset_password_notifier.dart';
import 'package:obywatel_plus/features/auth/domain/reset_password_state.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _isEmail = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _codeCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(resetPasswordProvider);
    final maxWidth = MediaQuery.of(context).size.width > 600
        ? 400.0
        : double.infinity;

    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.common_reset_password.tr())),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: buildBody(state),
          ),
        ),
      ),
    );
  }

  bool _isButtonLoading(ResetPasswordState state) {
    return state.maybeWhen(
      sendingCode: (_, _) => true,
      verifyingCode: () => true,
      resettingPassword: () => true,
      orElse: () => false,
    );
  }

  Widget buildBody(ResetPasswordState state) {
    final notifier = ref.read(resetPasswordProvider.notifier);
    final isLoading = _isButtonLoading(state);

    return state.when(
      initial: () => buildMethodSelection(notifier, isLoading),
      methodChosen: (input, method) =>
          buildMethodSelection(notifier, isLoading),
      sendingCode: (input, method) => buildMethodSelection(notifier, isLoading),
      codeSent: (input, method, resendTime, canResend) =>
          buildCodeInput(resendTime, canResend, notifier, isLoading),
      verifyingCode: () => buildCodeInput(0, false, notifier, isLoading),
      codeVerified: () => buildPasswordInput(notifier, isLoading),
      resettingPassword: () => buildPasswordInput(notifier, isLoading),
      completed: () => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              LocaleKeys.reset_password_success_message.tr(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            AppButton(
              labelKey: LocaleKeys.common_confirm.tr(),
              onPressed: () => Navigator.pop(context),
              variant: AppButtonVariant.primary,
            ),
          ],
        ),
      ),
      error: (message) => Center(
        child: Text(message, style: const TextStyle(color: Colors.red)),
      ),
    );
  }

  Widget buildMethodSelection(ResetPasswordNotifier notifier, bool isLoading) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SegmentedButton<bool>(
            segments: [
              ButtonSegment(
                value: true,
                label: Text(LocaleKeys.common_email.tr()),
              ),
              ButtonSegment(
                value: false,
                label: Text(LocaleKeys.common_phone.tr()),
              ),
            ],
            selected: {_isEmail},
            onSelectionChanged: (v) => setState(() => _isEmail = v.first),
          ),
          const SizedBox(height: 16),
          if (_isEmail)
            TextFormField(
              controller: _emailCtrl,
              decoration: InputDecoration(
                labelText: LocaleKeys.common_email.tr(),
                border: const UnderlineInputBorder(),
              ),
              validator: Validators.validateEmail,
              keyboardType: TextInputType.emailAddress,
              inputFormatters: [LengthLimitingTextInputFormatter(40)],
            )
          else
            TextFormField(
              controller: _phoneCtrl,
              decoration: InputDecoration(
                labelText: LocaleKeys.common_phone.tr(),
                border: const UnderlineInputBorder(),
              ),
              validator: Validators.validatePhone,
              keyboardType: TextInputType.phone,
              inputFormatters: [LengthLimitingTextInputFormatter(12)],
            ),
          const SizedBox(height: 24),
          AppButton(
            labelKey: LocaleKeys.common_send_code.tr(),
            isLoading: isLoading,
            onPressed: isLoading
                ? null
                : () async {
                    if (!_formKey.currentState!.validate()) return;
                    final input = _isEmail
                        ? _emailCtrl.text.trim()
                        : _phoneCtrl.text.trim();
                    notifier.setMethod(input, _isEmail);
                    await notifier.sendResetCode();
                  },
            variant: AppButtonVariant.primary,
          ),
        ],
      ),
    );
  }

  Widget buildCodeInput(
    int resendTime,
    bool canResend,
    ResetPasswordNotifier notifier,
    bool isLoading,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _codeCtrl,
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
                  await notifier.verifyCode(_codeCtrl.text.trim());
                },
          variant: AppButtonVariant.primary,
        ),
      ],
    );
  }

  Widget buildPasswordInput(ResetPasswordNotifier notifier, bool isLoading) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: _passwordCtrl,
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
                  await notifier.resetPassword(_passwordCtrl.text.trim());
                },
          variant: AppButtonVariant.primary,
        ),
      ],
    );
  }
}
