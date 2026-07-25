import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/widgets/main/app_scaffold.dart';
import 'package:obywatel_plus/core/design/widgets/ui/button.dart';
import 'package:obywatel_plus/core/utils/validators.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_controller.dart';
import 'package:obywatel_plus/features/auth/presentation/login/widgets/app_text_field.dart';

class TwoFaScreen extends ConsumerStatefulWidget {
  const TwoFaScreen({super.key});

  @override
  ConsumerState<TwoFaScreen> createState() => _TwoFaScreenState();
}

class _TwoFaScreenState extends ConsumerState<TwoFaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  static const int _cooldownSeconds = 60;
  Timer? _timer;
  int _resendTime = _cooldownSeconds;
  bool _canResend = false;
  bool _isResending = false;

  @override
  void initState() {
    super.initState();
    _startCooldown();
  }

  void _startCooldown() {
    setState(() {
      _resendTime = _cooldownSeconds;
      _canResend = false;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTime > 1) {
        setState(() {
          _resendTime--;
        });
      } else {
        timer.cancel();
        setState(() {
          _canResend = true;
        });
      }
    });
  }

  Future<void> _handleResendCode() async {
    if (!_canResend || _isResending) return;

    setState(() {
      _isResending = true;
    });

    final success = await ref
        .read(authControllerProvider.notifier)
        .resendTwoFaCode();

    if (mounted) {
      setState(() {
        _isResending = false;
      });
      if (success) {
        _startCooldown();
      }
    }
  }

  Future<void> _submitCode() async {
    if (!_formKey.currentState!.validate()) return;
    final code = _codeController.text.trim();
    _codeController.clear();
    await ref.read(authControllerProvider.notifier).verifyTwoFa(code);
  }

  void _onCodeChanged(String value) {
    if (value.length == 6) {
      _submitCode();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;
    final iconColor = Colors.green.shade700;

    final isBusy = isLoading || _isResending;

    return AppScaffold(
      size: ContainerSize.narrow,
      alignment: Alignment.center,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              LocaleKeys.login_2fa_subtitle.tr(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            AppTextField(
              controller: _codeController,
              labelKey: LocaleKeys.login_2fa_code,
              autofocus: true,
              enabled: !isBusy,
              onChanged: _onCodeChanged,
              textAlign: TextAlign.center,
              prefixIcon: Icon(Icons.security, color: iconColor),
              validator: Validators.validateTwoFaCode,
              keyboardType: TextInputType.number,
              autofillHints: AutofillHints.oneTimeCode,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submitCode(),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
            ),
            const SizedBox(height: 24),
            AppButton(
              label: LocaleKeys.login_2fa_submit.tr(),
              onPressed: isBusy ? null : _submitCode,
              variant: AppButtonVariant.primary,
              fullWidth: true,
              isLoading: isLoading,
            ),
            const SizedBox(height: 12),
            AppButton(
              label: _canResend
                  ? LocaleKeys.login_2fa_resend_code.tr()
                  : '${LocaleKeys.login_2fa_resend_code.tr()} (${_resendTime}s)',
              onPressed: (_canResend && !isBusy) ? _handleResendCode : null,
              variant: AppButtonVariant.secondary,
              fullWidth: true,
              isLoading: _isResending,
            ),
            const SizedBox(height: 12),
            AppButton(
              label: LocaleKeys.common_cancel.tr(),
              onPressed: isBusy
                  ? null
                  : () =>
                        ref.read(authControllerProvider.notifier).cancelTwoFa(),
              variant: AppButtonVariant.text,
              fullWidth: true,
            ),
          ],
        ),
      ),
    );
  }
}
