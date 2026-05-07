import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/widgets/main/app_scaffold.dart';
import 'package:obywatel_plus/core/design/widgets/ui/button.dart';
import 'package:obywatel_plus/features/auth/presentation/login/widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      size: ContainerSize.narrow,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                24,
                0,
                24,
                0,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      LocaleKeys.login_welcome_message.tr(),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 32),

                    const LoginForm(),

                    const SizedBox(height: 12),

                    AppButton(
                      labelKey: LocaleKeys.login_no_account,
                      variant: AppButtonVariant.text,
                      onPressed: () {},
                      fullWidth: false,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
