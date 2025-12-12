import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/theme/app_colors.dart';
import 'package:obywatel_plus/app/theme/app_text_styles.dart';
import 'package:obywatel_plus/core/core_providers.dart';
import 'package:obywatel_plus/core/utils/validators.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';

class ProfessionalLoginWidget extends ConsumerStatefulWidget {
  const ProfessionalLoginWidget({super.key});

  @override
  ConsumerState<ProfessionalLoginWidget> createState() => _ProfessionalLoginWidgetState();
}

class _ProfessionalLoginWidgetState extends ConsumerState<ProfessionalLoginWidget> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final state = ref.read(loginStateProvider);

    Future.microtask(() {
      ref.read(loginStateProvider.notifier).clearError();
    });
    _emailController = TextEditingController(text: state.email);
    _passwordController = TextEditingController(text: state.password);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) => Validators.validateEmail(value);
  String? _validatePassword(String? value) => Validators.validatePassword(value);

  void _handleLogin() async {
    // Walidacja formularza
    if (_formKey.currentState?.validate() ?? false) {
      // Pobranie wartości z lokalnych kontrolerów
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      // Wywołanie logowania w notifierze z argumentami nazwanymi
      await ref.read(loginStateProvider.notifier).onLogin(email: email, password: password);
    }
  }

  void _handleForgotPassword() {
    // Tutaj możesz dodać logikę resetowania hasła
    showDialog(context: context, builder: (context) => const ForgotPasswordDialog());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginStateProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 60),
                  Text(
                    LocaleKeys.login_title.tr(),
                    style: AppTextStyles.subtitle.copyWith(
                      color: isDark ? const Color.fromARGB(179, 211, 211, 211) : AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // Email field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: isDark ? Colors.white : AppColors.textPrimary),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'twoj@email.com',
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: isDark ? AppColors.accent : AppColors.textSecondary,
                      ),
                      filled: true,
                      fillColor: isDark ? AppColors.primaryDark.withValues(alpha: 0.3) : Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: isDark ? AppColors.primaryDark : Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: isDark ? AppColors.primary : AppColors.accent, width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.error),
                      ),
                      labelStyle: TextStyle(color: isDark ? Colors.white70 : AppColors.textSecondary),
                    ),
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: 20),

                  // Password field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: TextStyle(color: isDark ? Colors.white : AppColors.textPrimary),
                    decoration: InputDecoration(
                      labelText: LocaleKeys.login_password.tr(),
                      hintText: '••••••••',
                      prefixIcon: Icon(Icons.lock_outline, color: isDark ? AppColors.accent : AppColors.textSecondary),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          color: isDark ? AppColors.accent : AppColors.textSecondary,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: isDark ? AppColors.primaryDark.withValues(alpha: 0.3) : Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: isDark ? AppColors.primaryDark : Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: isDark ? AppColors.primary : AppColors.accent, width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.error),
                      ),
                      labelStyle: TextStyle(color: isDark ? Colors.white70 : AppColors.textSecondary),
                    ),
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: 12),

                  // Forgot password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: state.isLoading ? null : _handleForgotPassword,
                      child: Text(
                        LocaleKeys.login_forgot_password.tr(),
                        style: TextStyle(
                          color: isDark ? AppColors.primary : AppColors.accent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Login button
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: state.isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? AppColors.primary : AppColors.primaryDark,
                        foregroundColor: const Color.fromARGB(255, 29, 29, 29),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                        disabledBackgroundColor: isDark
                            ? AppColors.accent.withValues(alpha: 0.3)
                            : Colors.grey.shade300,
                      ),
                      child: state.isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Color.fromARGB(255, 221, 221, 221),
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text('Zaloguj się', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),

                  // Error message
                  if (state.error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline, color: AppColors.error, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(state.error!, style: const TextStyle(color: AppColors.error, fontSize: 14)),
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 24),

                  // Register link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        LocaleKeys.login_no_account.tr(),
                        style: TextStyle(color: isDark ? Colors.white70 : AppColors.textSecondary),
                      ),
                      TextButton(
                        onPressed: () {
                          // Nawigacja do ekranu rejestracji
                        },
                        child: Text(
                          LocaleKeys.login_register.tr(),
                          style: TextStyle(
                            color: isDark ? AppColors.primary : AppColors.accent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Dialog resetowania hasła
class ForgotPasswordDialog extends StatefulWidget {
  const ForgotPasswordDialog({super.key});

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) => Validators.validateEmail(value);

  Future<void> _handleResetPassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      // Tutaj dodaj logikę resetowania hasła
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.of(context).pop();

        // Pokaż komunikat sukcesu
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Link resetujący hasło został wysłany na email'), backgroundColor: Colors.green),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      backgroundColor: isDark ? AppColors.backgroundDark : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(Icons.lock_reset, color: isDark ? AppColors.primary : AppColors.accent),
          const SizedBox(width: 12),
          Text('Resetuj hasło', style: TextStyle(color: isDark ? Colors.white : AppColors.textPrimary)),
        ],
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Podaj adres email powiązany z Twoim kontem. Wyślemy Ci link do resetowania hasła.',
              style: TextStyle(color: isDark ? Colors.white70 : AppColors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: isDark ? Colors.white : AppColors.textPrimary),
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'twoj@email.com',
                prefixIcon: Icon(Icons.email_outlined, color: isDark ? AppColors.accent : AppColors.textSecondary),
                filled: true,
                fillColor: isDark ? AppColors.primaryDark.withValues(alpha: 0.3) : AppColors.backgroundLight,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: isDark ? AppColors.primaryDark : Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: isDark ? AppColors.primary : AppColors.accent, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.error),
                ),
                labelStyle: TextStyle(color: isDark ? Colors.white70 : AppColors.textSecondary),
              ),
              validator: _validateEmail,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: Text('Anuluj', style: TextStyle(color: isDark ? Colors.white70 : AppColors.textSecondary)),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleResetPassword,
          style: ElevatedButton.styleFrom(
            backgroundColor: isDark ? AppColors.primary : AppColors.primaryDark,
            foregroundColor: const Color.fromARGB(255, 14, 14, 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: _isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
              : Text(LocaleKeys.login_reset_link_sent.tr()),
        ),
      ],
    );
  }
}
