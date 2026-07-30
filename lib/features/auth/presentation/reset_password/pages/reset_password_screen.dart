import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/widgets/main/app_scaffold.dart';
import 'package:obywatel_plus/features/auth/application/reset_password/reset_password_notifier.dart';
import 'package:obywatel_plus/features/auth/application/reset_password/reset_password_state.dart';
import 'package:obywatel_plus/features/auth/presentation/reset_password/widgets/code_input.dart';
import 'package:obywatel_plus/features/auth/presentation/reset_password/widgets/method_selection.dart';
import 'package:obywatel_plus/features/auth/presentation/reset_password/widgets/password_input.dart';
import 'package:obywatel_plus/features/auth/presentation/reset_password/widgets/success_widget.dart';

class ResetPasswordScreen extends ConsumerWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(resetPasswordProvider);
    final notifier = ref.read(resetPasswordProvider.notifier);

    return AppScaffold(
      size: ContainerSize.narrow,
      alignment: Alignment.center,
      appBar: AppBar(title: Text(LocaleKeys.common_reset_password.tr())),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: _ResetPasswordBody(state: state, notifier: notifier),
          ),
        ),
      ),
    );
  }
}

class _ResetPasswordBody extends StatefulWidget {
  final ResetPasswordState state;
  final ResetPasswordNotifier notifier;

  const _ResetPasswordBody({required this.state, required this.notifier});

  @override
  State<_ResetPasswordBody> createState() => _ResetPasswordBodyState();
}

class _ResetPasswordBodyState extends State<_ResetPasswordBody> {
  final TextEditingController codeController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    codeController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoading = widget.state.maybeMap(
      loading: (_) => true,
      orElse: () => false,
    );

    return widget.state.when(
      initial: () => MethodSelectionWidget(
        notifier: widget.notifier,
        isLoading: isLoading,
      ),
      methodChosen: (accountIdentifier, contactValue, method) =>
          MethodSelectionWidget(
            notifier: widget.notifier,
            isLoading: isLoading,
          ),
      loading: () => const Center(child: CircularProgressIndicator()),
      codeSent:
          (
            accountIdentifier,
            contactValue,
            method,
            resendTime,
            canResend,
            token,
          ) => CodeInputWidget(
            notifier: widget.notifier,
            codeController: codeController,
            resendTime: resendTime,
            canResend: canResend,
            isLoading: isLoading,
          ),
      codeVerified: (token, challenge) => PasswordInputWidget(
        notifier: widget.notifier,
        code: codeController.text,
        isLoading: isLoading,
      ),
      completed: () => const SuccessWidget(),
    );
  }
}
