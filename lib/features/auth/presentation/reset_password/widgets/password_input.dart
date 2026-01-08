import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // DODAJ TEN IMPORT
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/design/widgets/ui/button.dart';
import 'package:obywatel_plus/core/errors/app_notification.dart';
import 'package:obywatel_plus/core/errors/global_error_provider.dart';
import 'package:obywatel_plus/core/utils/validators.dart';
import 'package:obywatel_plus/features/auth/application/reset_password/reset_password_notifier.dart';

// 1. Zmiana na ConsumerStatefulWidget
class PasswordInputWidget extends ConsumerStatefulWidget {
  final String code;
  final bool isLoading;
  final ResetPasswordNotifier notifier;

  const PasswordInputWidget({
    super.key,
    required this.code,
    required this.isLoading,
    required this.notifier,
  });

  @override
  ConsumerState<PasswordInputWidget> createState() =>
      _PasswordInputWidgetState();
}

// 2. Zmiana na ConsumerState
class _PasswordInputWidgetState extends ConsumerState<PasswordInputWidget> {
  final _formKey = GlobalKey<FormState>();
  final _passController = TextEditingController();
  final _repeatController = TextEditingController();
  bool _isPassVisible = false;

  @override
  void dispose() {
    _passController.dispose();
    _repeatController.dispose();
    super.dispose();
  }

  void _generateStrongPassword() {
    const letters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numbers = '0123456789';
    const symbols = '!@#\$&*~';
    final rnd = Random.secure();

    String pass = "";
    pass += letters[rnd.nextInt(letters.length)];
    pass += numbers[rnd.nextInt(numbers.length)];
    pass += symbols[rnd.nextInt(symbols.length)];

    const all = letters + numbers + symbols;
    pass += String.fromCharCodes(
      Iterable.generate(13, (_) => all.codeUnitAt(rnd.nextInt(all.length))),
    );

    final shuffled = (pass.split('')..shuffle(rnd)).join();

    setState(() {
      _passController.text = shuffled;
      _repeatController.text = shuffled;
      _isPassVisible = true;
    });

    Clipboard.setData(ClipboardData(text: shuffled));

    // Teraz 'ref' będzie działać poprawnie
    ref
        .read(globalNotificationProvider.notifier)
        .show(
          AppNotification(
            messageKey: "Hasło wygenerowane i skopiowane",
            type: NotificationType.success,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Ustaw nowe hasło",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: _generateStrongPassword,
                icon: const Icon(Icons.auto_fix_high),
                tooltip: "Generuj silne hasło",
              ),
            ],
          ),
          const SizedBox(height: 32),
          TextFormField(
            controller: _passController,
            obscureText: !_isPassVisible,
            decoration: InputDecoration(
              labelText: LocaleKeys.common_password.tr(),
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPassVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () =>
                    setState(() => _isPassVisible = !_isPassVisible),
              ),
            ),
            validator: (val) => Validators.validatePassword(val, minLength: 8),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _repeatController,
            obscureText: !_isPassVisible,
            decoration: InputDecoration(
              labelText: LocaleKeys.common_repeat_password.tr(),
              prefixIcon: const Icon(Icons.lock_reset),
            ),
            validator: (val) =>
                val != _passController.text ? "Hasła nie są identyczne" : null,
          ),
          const SizedBox(height: 24),
          _PasswordRequirementsList(password: _passController.text),
          const SizedBox(height: 32),
          AppButton(
            labelKey: LocaleKeys.common_confirm,
            isLoading: widget.isLoading,
            onPressed: widget.isLoading
                ? null
                : () {
                    if (_formKey.currentState!.validate()) {
                      widget.notifier.confirmReset(
                        code: widget.code,
                        newPassword: _passController.text.trim(),
                      );
                    }
                  },
            variant: AppButtonVariant.primary,
          ),
        ],
      ),
    );
  }
}

// Lokalny helper dla listy wymagań
class _PasswordRequirementsList extends StatelessWidget {
  final String password;
  const _PasswordRequirementsList({required this.password});

  @override
  Widget build(BuildContext context) {
    // Pobieramy style tutaj, gdzie context jest dostępny
    final theme = Theme.of(context);
    final hintColor = theme.textTheme.bodySmall?.color ?? Colors.grey;

    return Column(
      children: [
        _buildReq(context, "Minimum 8 znaków", password.length >= 8, hintColor),
        _buildReq(
          context,
          "Przynajmniej jedna litera",
          RegExp(r'[A-Za-z]').hasMatch(password),
          hintColor,
        ),
        _buildReq(
          context,
          "Przynajmniej jedna cyfra",
          RegExp(r'\d').hasMatch(password),
          hintColor,
        ),
        _buildReq(
          context,
          "Znak specjalny (!@#\$&*~)",
          RegExp(r'[!@#\$&*~]').hasMatch(password),
          hintColor,
        ),
      ],
    );
  }

  // Dodajemy BuildContext i hintColor jako argumenty
  Widget _buildReq(
    BuildContext context,
    String text,
    bool isMet,
    Color hintColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.circle_outlined,
            size: 14,
            color: isMet ? Colors.green : hintColor.withValues(alpha: 0.5),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: isMet ? Colors.green : hintColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
