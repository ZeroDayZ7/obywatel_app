import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/config/env.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/core/design/widgets/ui/button.dart';
import 'package:obywatel_plus/core/utils/validators.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_controller.dart';
import 'package:obywatel_plus/features/auth/domain/auth_state.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  // ✅ CHANGE: UI owns its controllers – NOT auth state
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();

    final defaultEmail = apiConstants.isProduction
        ? ''
        : apiConstants.defaultEmail;
    final defaultPassword = apiConstants.isProduction
        ? ''
        : apiConstants.defaultPassword;

    _emailController = TextEditingController(text: defaultEmail);
    _passwordController = TextEditingController(text: defaultPassword);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Wewnątrz _handleLogin w login_form.dart
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    // 1. Pobieramy tekst
    final email = _emailController.text.trim();
    final passwordStr = _passwordController.text.trim();

    // 2. Konwertujemy hasło na bajty (List<int>)
    final passwordBytes = utf8.encode(passwordStr);

    // 3. Wysyłamy do kontrolera
    await ref.read(authControllerProvider.notifier).login(email, passwordBytes);

    // 4. Czyścimy kontroler i lokalną listę bajtów
    _passwordController.clear();
    passwordBytes.fillRange(0, passwordBytes.length, 0);
  }

  void _handleForgotPassword() {
    context.push(AppRoutes.resetPassword);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    // ✅ CHANGE: loading wyciągany Z FLOW STATE, nie z helpera
    final isLoading = authState.maybeWhen(
      authenticating: () => true,
      orElse: () => false,
    );

    return Form(
      key: _formKey,
      child: Column(
        children: [
          /// EMAIL
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

          /// PASSWORD
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
                  color: Theme.of(
                    context,
                  ).iconTheme.color, // <- wymuszenie koloru
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

          /// LOGIN BUTTON
          AppButton(
            labelKey: LocaleKeys.login_submit,
            onPressed: isLoading ? null : _handleLogin,
            variant: AppButtonVariant.primary,
            fullWidth: true,
            isLoading: isLoading,
          ),

          const SizedBox(height: 16),

          /// FORGOT PASSWORD
          Align(
            alignment: Alignment.centerRight,
            child: AppButton(
              labelKey: LocaleKeys.login_forgot_password,
              onPressed: isLoading ? null : _handleForgotPassword,
              variant: AppButtonVariant.text,
              fullWidth: false,
            ),
          ),
        ],
      ),
    );
  }
}
