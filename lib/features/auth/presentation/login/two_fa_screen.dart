import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:obywatel_plus/core/errors/error_message.dart';
import 'package:obywatel_plus/core/utils/validators.dart';
import 'package:obywatel_plus/core/widgets/ui/button.dart';
import 'package:obywatel_plus/features/auth/application/login/login_provider.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/features/auth/application/login/two_fa_provider.dart';

class TwoFaScreen extends ConsumerStatefulWidget {
  const TwoFaScreen({super.key});

  @override
  ConsumerState<TwoFaScreen> createState() => _TwoFaScreenState();
}

class _TwoFaScreenState extends ConsumerState<TwoFaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  bool _isLoading = false;

  void _submitCode() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final code = _codeController.text;
    final email = ref.read(loginNotifierProvider).email;

    // Wywołanie logiki weryfikacji 2FA w LoginNotifier
    final result = await ref
        .read(loginNotifierProvider.notifier)
        .verifyTwoFa(email: email, code: code);

    setState(() => _isLoading = false);

    if (!result.success) {
      ref
          .read(twoFaProvider.notifier)
          .setError(result.error ?? 'Unknown error');
      return;
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final twoFaState = ref.watch(twoFaProvider);

    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.login_2fa_title.tr())),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(32),
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
                  TextFormField(
                    controller: _codeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: LocaleKeys.login_2fa_code.tr(),
                    ),
                    validator: Validators.validateTwoFaCode,
                  ),
                  // Tutaj pokazujemy błąd, jeśli istnieje
                  if (twoFaState.error != null) ...[
                    const SizedBox(height: 8),
                    ErrorMessage(message: twoFaState.error!),
                  ],
                  const SizedBox(height: 24),
                  AppButton(
                    labelKey: LocaleKeys.login_2fa_submit,
                    onPressed: _isLoading ? null : _submitCode,
                    variant: AppButtonVariant.primary,
                    fullWidth: true,
                    isLoading: _isLoading,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
