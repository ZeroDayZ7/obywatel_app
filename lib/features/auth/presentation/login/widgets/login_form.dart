import 'dart:convert';

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
import 'package:obywatel_plus/features/auth/presentation/login/widgets/app_text_field.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: apiConstants.defaultEmail);
    _passwordController = TextEditingController(
      text: apiConstants.defaultPassword,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final passwordStr = _passwordController.text.trim();
    final passwordBytes = utf8.encode(passwordStr);

    await ref.read(authControllerProvider.notifier).login(email, passwordBytes);

    _passwordController.clear();
    passwordBytes.fillRange(0, passwordBytes.length, 0);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.maybeWhen(
      authenticating: () => true,
      orElse: () => false,
    );

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          
          const SizedBox(height: 16),
          
          AppTextField(
            controller: _emailController,
            labelKey: LocaleKeys.common_email,
            enabled: !isLoading,
            validator: Validators.validateEmail,
            keyboardType: TextInputType.emailAddress,
            autofillHints: AutofillHints.email,
            inputFormatters: [LengthLimitingTextInputFormatter(40)],
          ),

          const SizedBox(height: 16),

          AppTextField(
            controller: _passwordController,
            labelKey: LocaleKeys.common_password,
            enabled: !isLoading,
            isPassword: true,
            validator: Validators.validatePassword,
            autofillHints: AutofillHints.password,
            inputFormatters: [LengthLimitingTextInputFormatter(40)],
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _handleLogin(),
          ),

          const SizedBox(height: 24),

          AppButton(
            labelKey: LocaleKeys.login_submit,
            onPressed: isLoading ? null : _handleLogin,
            variant: AppButtonVariant.primary,
            fullWidth: true,
            isLoading: isLoading,
          ),

          const SizedBox(height: 16),

          Align(
            alignment: Alignment.centerRight,
            child: AppButton(
              labelKey: LocaleKeys.login_forgot_password,
              onPressed: isLoading
                  ? null
                  : () => context.push(AppRoutes.resetPassword),
              variant: AppButtonVariant.text,
              fullWidth: false,
            ),
          ),
        ],
      ),
    );
  }
}
