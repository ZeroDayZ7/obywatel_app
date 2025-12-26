import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:obywatel_plus/core/utils/validators.dart';
import 'package:obywatel_plus/core/widgets/ui/button.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/features/auth/application/login/login_provider.dart';
import 'package:obywatel_plus/features/auth/presentation/reset_password/reset_method_dialog.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    final loginAsync = ref.read(loginNotifierProvider);
    final email = loginAsync.value?.login.email ?? '';
    _emailController = TextEditingController(text: email);
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    await ref
        .read(loginNotifierProvider.notifier)
        .login(
          email: _emailController.text,
          password: _passwordController.text,
        );

    _passwordController.clear();
  }

  void handleForgotPassword() {
    showDialog(context: context, builder: (_) => const ResetMethodDialog());
  }

  @override
  Widget build(BuildContext context) {
    final loginAsync = ref.watch(loginNotifierProvider);

    // Określenie stanu ładowania
    final isLoading = loginAsync.isLoading;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            enabled: !isLoading,
            decoration: InputDecoration(
              labelText: LocaleKeys.common_email.tr(),
            ),
            validator: Validators.validateEmail,
            keyboardType: TextInputType.emailAddress,
            inputFormatters: [LengthLimitingTextInputFormatter(40)],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            enabled: !isLoading,
            keyboardType: TextInputType.visiblePassword,
            autocorrect: false,
            enableSuggestions: false,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: LocaleKeys.common_password.tr(),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  color: Theme.of(context).iconTheme.color,
                ),
                onPressed: () => setState(() {
                  _obscurePassword = !_obscurePassword;
                }),
              ),
            ),
            validator: Validators.validatePassword,
            inputFormatters: [LengthLimitingTextInputFormatter(40)],
          ),
          const SizedBox(height: 24),
          AppButton(
            labelKey: LocaleKeys.login_submit,
            onPressed: isLoading ? null : handleLogin,
            variant: AppButtonVariant.primary,
            fullWidth: true,
            isLoading: isLoading,
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: AppButton(
              labelKey: LocaleKeys.login_forgot_password,
              onPressed: handleForgotPassword,
              variant: AppButtonVariant.text,
              fullWidth: false,
            ),
          ),
        ],
      ),
    );
  }
}
