import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/features/auth/presentation/login/reset_password/reset_state.dart';
import 'login_fields.dart';
import 'reset_password/reset_provider.dart';
import 'reset_password/reset_method_dialog.dart';
import 'reset_password/enter_reset_code_dialog.dart';
import 'reset_password/new_password_screen.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  Future<void> _handleForgotPassword() async {
    // 1. KROK: Wybór metody (Email/SMS)
    final method = await showDialog<String>(
      context: context,
      builder: (_) => const ResetMethodDialog(),
    );

    // Jeśli anulowano lub widget nie istnieje - przerywamy
    if (method == null || !mounted) return;

    // Logika (mock) - wysyłanie kodu
    await ref.read(resetPasswordProvider.notifier).chooseMethod(method);

    // Ponowne sprawdzenie mounted po operacji async
    if (!mounted) return;

    // 2. KROK: Wprowadzenie kodu
    final code = await showDialog<String>(
      context: context,
      builder: (_) => const EnterResetCodeDialog(),
    );

    if (code == null || !mounted) return;

    // Logika (mock) - weryfikacja kodu
    await ref.read(resetPasswordProvider.notifier).verifyCode(code);

    // Po weryfikacji sprawdzamy stan
    final state = ref.read(resetPasswordProvider);

    if (!mounted) return; // Ostatnie sprawdzenie przed nawigacją/snackbar

    if (state.status == ResetStatus.codeVerified) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const NewPasswordScreen()));
    } else if (state.status == ResetStatus.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.errorMessage ?? "Wystąpił nieoczekiwany błąd"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const LoginEmailField(),
          const SizedBox(height: 20),
          const LoginPasswordField(),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _handleForgotPassword,
              child: const Text('Zapomniałeś hasła?'),
            ),
          ),
        ],
      ),
    );
  }
}
