import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/widgets/app_scaffold.dart';
import 'package:obywatel_plus/features/auth/application/reset_password/reset_password_notifier.dart';
import 'package:obywatel_plus/features/auth/domain/reset_password_state.dart';
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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _ResetPasswordBody(state: state, notifier: notifier),
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

  bool _isButtonLoading() {
    return widget.state.maybeWhen(
      sendingCode: (_, _) => true,
      verifyingCode: () => true,
      resettingPassword: () => true,
      orElse: () => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = _isButtonLoading();

    return widget.state.when(
      initial: () => MethodSelectionWidget(
        notifier: widget.notifier,
        isLoading: isLoading,
      ),
      methodChosen: (_, _) => MethodSelectionWidget(
        notifier: widget.notifier,
        isLoading: isLoading,
      ),
      sendingCode: (_, _) => MethodSelectionWidget(
        notifier: widget.notifier,
        isLoading: isLoading,
      ),
      codeSent: (_, _, resendTime, canResend) => CodeInputWidget(
        notifier: widget.notifier,
        codeController: codeController,
        resendTime: resendTime,
        canResend: canResend,
        isLoading: isLoading,
      ),
      verifyingCode: () => CodeInputWidget(
        notifier: widget.notifier,
        codeController: codeController,
        resendTime: 0,
        canResend: false,
        isLoading: isLoading,
      ),
      codeVerified: () => PasswordInputWidget(
        notifier: widget.notifier,
        passwordController: passwordController,
        isLoading: isLoading,
      ),
      resettingPassword: () => PasswordInputWidget(
        notifier: widget.notifier,
        passwordController: passwordController,
        isLoading: isLoading,
      ),
      completed: () => SuccessWidget(),
      error: (message) => Center(
        child: Text(message, style: const TextStyle(color: Colors.red)),
      ),
    );
  }
}
