import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:obywatel_plus/core/widgets/ui/button.dart';
import 'package:obywatel_plus/features/auth/presentation/login/login_form.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  LocaleKeys.login_welcome_back.tr(),
                  style: textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                Text(
                  LocaleKeys.login_welcome_message.tr(),
                  style: textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                const LoginForm(),

                const SizedBox(height: 24),

                AppButton(
                  labelKey: LocaleKeys.login_no_account,
                  variant: AppButtonVariant.text,
                  onPressed: () {
                    // ignore: todo
                    // TODO: akcja przejścia do rejestracji
                  },
                  fullWidth: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
