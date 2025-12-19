import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:obywatel_plus/core/widgets/ui/button.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/features/auth/application/login/login_provider.dart';
import 'reset_password/reset_state.dart';
import 'reset_password/reset_provider.dart';
import 'reset_password/reset_method_dialog.dart';
import 'reset_password/enter_reset_code_dialog.dart';
import 'reset_password/new_password_screen.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      // wywołanie logowania w Riverpod notifierze
      await ref
          .read(loginStateProvider.notifier)
          .onLogin(email: email, password: password);
    }
  }

  Future<void> _handleForgotPassword() async {
    final method = await showDialog<String>(
      context: context,
      builder: (_) => const ResetMethodDialog(),
    );

    if (method == null || !mounted) return;

    await ref.read(resetPasswordProvider.notifier).chooseMethod(method);
    if (!mounted) return;

    final code = await showDialog<String>(
      context: context,
      builder: (_) => const EnterResetCodeDialog(),
    );

    if (code == null || !mounted) return;

    await ref.read(resetPasswordProvider.notifier).verifyCode(code);
    final state = ref.read(resetPasswordProvider);

    if (!mounted) return;

    if (state.status == ResetStatus.codeVerified) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const NewPasswordScreen()));
    } else if (state.status == ResetStatus.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.errorMessage ?? "Wystąpił nieoczekiwany błąd"),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: LocaleKeys.common_email.tr(),
            ),
            validator: (v) => (v?.isEmpty ?? true) ? 'Wpisz email' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: LocaleKeys.common_password.tr(),
            ),
            obscureText: true,
            validator: (v) => (v?.isEmpty ?? true) ? 'Wpisz hasło' : null,
          ),
          const SizedBox(height: 24),
          AppButton(
            labelKey: LocaleKeys.login_submit,
            onPressed: _handleLogin,
            variant: AppButtonVariant.primary,
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _handleForgotPassword,
              child: Text(LocaleKeys.login_screen_forgot_password.tr()),
            ),
          ),

          // <-- TU DODAĆ ERROR MESSAGE
          Builder(
            builder: (_) {
              final state = ref.watch(loginStateProvider);
              if (state.error == null) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  state.error!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
