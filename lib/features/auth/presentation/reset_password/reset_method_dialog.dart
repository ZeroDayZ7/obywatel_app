import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/utils/validators.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/widgets/ui/button.dart';
import 'package:obywatel_plus/features/auth/application/reset_password/reset_password_provider.dart';
import 'package:obywatel_plus/features/auth/domain/reset_state.dart';

class ResetMethodDialog extends ConsumerStatefulWidget {
  const ResetMethodDialog({super.key});

  @override
  ConsumerState<ResetMethodDialog> createState() => _ResetMethodDialogState();
}

class _ResetMethodDialogState extends ConsumerState<ResetMethodDialog> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _codeController = TextEditingController();
  bool _isEmail = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _sendResetCode() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final input = _isEmail ? _emailCtrl.text.trim() : _phoneCtrl.text.trim();
    final notifier = ref.read(resetServiceProvider.notifier);

    notifier.setMethod(input, _isEmail);

    final success = await notifier.sendResetCode();

    if (mounted) setState(() => _isLoading = false);

    if (success && mounted) {
      // Zmieniamy stan w tym samym dialogu, nie otwieramy nowego
      // Możesz też tu odświeżyć UI dzięki ref.watch
    } else if (mounted) {
      final state = ref.read(resetServiceProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.errorMessage ?? 'Błąd wysyłki')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final resetState = ref.watch(resetServiceProvider);
    final notifier = ref.read(resetServiceProvider.notifier);

    return AlertDialog(
      title: Text(
        resetState.status == ResetStatus.codeSent
            ? LocaleKeys.common_enter_code.tr()
            : LocaleKeys.common_reset_password.tr(),
      ),
      content: resetState.status == ResetStatus.codeSent
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _codeController,
                  maxLength: 6,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 28, letterSpacing: 6),
                  decoration: const InputDecoration(counterText: ""),
                ),
                const SizedBox(height: 16),
                AppButton(
                  labelKey: resetState.canResend
                      ? 'Wyślij ponownie'
                      : 'Wyślij ponownie za ${resetState.resendTime}s',
                  onPressed: resetState.canResend
                      ? () => notifier.sendResetCode()
                      : null,
                  variant: AppButtonVariant.text,
                ),
              ],
            )
          : Form(
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
                    onSelectionChanged: (v) =>
                        setState(() => _isEmail = v.first),
                  ),
                  const SizedBox(height: 20),
                  if (_isEmail)
                    TextFormField(
                      controller: _emailCtrl,
                      decoration: InputDecoration(
                        labelText: LocaleKeys.common_email.tr(),
                        border: const UnderlineInputBorder(),
                      ),
                      validator: Validators.validateEmail,
                      keyboardType: TextInputType.emailAddress,
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
                    ),
                ],
              ),
            ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        AppButton(
          labelKey: LocaleKeys.common_cancel.tr(),
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          variant: AppButtonVariant.text,
          fullWidth: false,
        ),
        AppButton(
          labelKey: resetState.status == ResetStatus.codeSent
              ? LocaleKeys.common_confirm.tr()
              : LocaleKeys.common_send_code.tr(),
          onPressed: _isLoading
              ? null
              : () {
                  if (resetState.status == ResetStatus.codeSent) {
                    notifier.verifyCode(_codeController.text);
                  } else {
                    _sendResetCode();
                  }
                },
          variant: AppButtonVariant.primary,
          isLoading: _isLoading,
          fullWidth: false,
        ),
      ],
    );
  }
}
