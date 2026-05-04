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
    return AppScaffold(
      size: ContainerSize.narrow,

      alignment: Alignment.topCenter,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Image.asset(
                'assets/images/logo.png',
                height: 120,
                fit: BoxFit.contain,
              ),
            ),
          ),

          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  LocaleKeys.login_welcome_message.tr(),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                const LoginForm(),
                const SizedBox(height: 8),
                AppButton(
                  labelKey: LocaleKeys.login_no_account,
                  variant: AppButtonVariant.text,
                  onPressed: () {},
                  fullWidth: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
