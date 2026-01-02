import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/widgets/app_scaffold.dart';
import 'package:obywatel_plus/core/design/widgets/ui/button.dart';
import 'package:obywatel_plus/core/errors/app_notification.dart';
import 'package:obywatel_plus/core/errors/global_error_provider.dart';
import 'package:obywatel_plus/core/utils/validators.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_controller.dart';
import 'package:obywatel_plus/features/auth/domain/auth_state.dart';

class TwoFaScreen extends ConsumerStatefulWidget {
  const TwoFaScreen({super.key});

  @override
  ConsumerState<TwoFaScreen> createState() => _TwoFaScreenState();
}

class _TwoFaScreenState extends ConsumerState<TwoFaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  Future<void> _submitCode() async {
    if (!_formKey.currentState!.validate()) return;
    final code = _codeController.text.trim();
    _codeController.clear();
    await ref.read(authControllerProvider.notifier).verifyTwoFa(code);
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    ref.listen<AuthState>(authControllerProvider, (prev, next) {
      final error = next.errorCode;
      if (error != null) {
        ref
            .read(globalNotificationProvider.notifier)
            .show(
              AppNotification(messageKey: error, type: NotificationType.error),
            );
      }
    });

    return AppScaffold(
      size: ContainerSize.narrow,
      alignment: Alignment.center,
      appBar: AppBar(title: Text(LocaleKeys.login_2fa_title.tr())),
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
              enabled: !isLoading,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: LocaleKeys.login_2fa_code.tr(),
              ),
              validator: Validators.validateTwoFaCode,
            ),
            const SizedBox(height: 24),
            AppButton(
              labelKey: LocaleKeys.login_2fa_submit,
              onPressed: isLoading ? null : _submitCode,
              variant: AppButtonVariant.primary,
              fullWidth: true,
              isLoading: isLoading,
            ),
            const SizedBox(height: 16),
            AppButton(
              labelKey: LocaleKeys.common_cancel,
              onPressed: isLoading
                  ? null
                  : () => ref.read(authControllerProvider.notifier).logout(),
              variant: AppButtonVariant.text,
              fullWidth: true,
            ),
          ],
        ),
      ),
    );
  }
}
