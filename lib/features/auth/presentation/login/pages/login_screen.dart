import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/widgets/app_scaffold.dart';
import 'package:obywatel_plus/core/design/widgets/ui/button.dart';
import 'package:obywatel_plus/features/auth/presentation/login/widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppScaffold(
      size: ContainerSize.narrow,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
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
            ],
          ),

          // Formularz z marginesem sekcji
          const LoginForm(),

          const SizedBox(height: 8),

          // Przycisk "Nie masz konta"
          AppButton(
            labelKey: LocaleKeys.login_no_account,
            variant: AppButtonVariant.text,
            onPressed: () {
              // Akcja rejestracji
            },
            fullWidth: false,
          ),
        ],
      ),
    );
  }
}
