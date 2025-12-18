import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/app/theme/app_colors.dart';
import 'package:obywatel_plus/core/utils/validators.dart';

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
          const SnackBar(
            content: Text('Link resetujący hasło został wysłany na email'),
            backgroundColor: Colors.green,
          ),
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
          Icon(
            Icons.lock_reset,
            color: isDark ? AppColors.primary : AppColors.accent,
          ),
          const SizedBox(width: 12),
          Text(
            'Resetuj hasło',
            style: TextStyle(
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
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
              style: TextStyle(
                color: isDark ? Colors.white70 : AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'twoj@email.com',
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: isDark ? AppColors.accent : AppColors.textSecondary,
                ),
                filled: true,
                fillColor: isDark
                    ? AppColors.primaryDark.withValues(alpha: 0.3)
                    : AppColors.backgroundLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark
                        ? AppColors.primaryDark
                        : Colors.grey.shade300,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark ? AppColors.primary : AppColors.accent,
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.error),
                ),
                labelStyle: TextStyle(
                  color: isDark ? Colors.white70 : AppColors.textSecondary,
                ),
              ),
              validator: _validateEmail,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: Text(
            'Anuluj',
            style: TextStyle(
              color: isDark ? Colors.white70 : AppColors.textSecondary,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleResetPassword,
          style: ElevatedButton.styleFrom(
            backgroundColor: isDark ? AppColors.primary : AppColors.primaryDark,
            foregroundColor: const Color.fromARGB(255, 14, 14, 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(LocaleKeys.login_reset_link_sent.tr()),
        ),
      ],
    );
  }
}
