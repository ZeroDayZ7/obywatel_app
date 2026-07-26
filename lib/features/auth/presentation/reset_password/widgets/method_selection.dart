import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/design/widgets/ui/button.dart';
import 'package:obywatel_plus/core/utils/validators.dart';
import 'package:obywatel_plus/features/auth/application/reset_password/reset_password_notifier.dart';

class MethodSelectionWidget extends StatefulWidget {
  final ResetPasswordNotifier notifier;
  final bool isLoading;

  const MethodSelectionWidget({
    required this.notifier,
    required this.isLoading,
    super.key,
  });

  @override
  State<MethodSelectionWidget> createState() => _MethodSelectionWidgetState();
}

class _MethodSelectionWidgetState extends State<MethodSelectionWidget> {
  final _formKey = GlobalKey<FormState>();
  final _accountIdentifierCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  bool _isEmail = true;

  @override
  void dispose() {
    _accountIdentifierCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectionColor = Colors.green.withValues(alpha: 0.1);
    final activeColor = Colors.green.shade700;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Pole Identyfikatora Konta (Wymagane niezależnie od metody)
          TextFormField(
            controller: _accountIdentifierCtrl,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.badge_outlined, color: activeColor),
              labelText: 'Identyfikator konta / Umowa',
              hintText: 'Wpisz e-mail lub numer umowy',
              border: const UnderlineInputBorder(),
            ),
            validator: (val) => (val == null || val.trim().isEmpty)
                ? 'Identyfikator jest wymagany'
                : null,
          ),
          const SizedBox(height: 24),

          // 2. Przełącznik wyboru dostarczenia kodu
          SegmentedButton<bool>(
            style: SegmentedButton.styleFrom(
              backgroundColor: theme.colorScheme.surface,
              selectedBackgroundColor: selectionColor,
              selectedForegroundColor: activeColor,
              side: BorderSide(color: theme.dividerColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            segments: [
              ButtonSegment(
                value: true,
                label: Text(LocaleKeys.common_email.tr()),
                icon: const Icon(Icons.email_outlined),
              ),
              ButtonSegment(
                value: false,
                label: Text(LocaleKeys.common_phone.tr()),
                icon: const Icon(Icons.phone_android_outlined),
              ),
            ],
            selected: {_isEmail},
            onSelectionChanged: (v) => setState(() => _isEmail = v.first),
          ),
          const SizedBox(height: 16),

          // 3. Dynamiczne pole kontaktowe
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: SizedBox(
              key: ValueKey(_isEmail),
              height: 80,
              child: _isEmail
                  ? TextFormField(
                      controller: _emailCtrl,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email, color: activeColor),
                        labelText: LocaleKeys.common_email.tr(),
                        border: const UnderlineInputBorder(),
                      ),
                      validator: Validators.validateEmail,
                      keyboardType: TextInputType.emailAddress,
                    )
                  : TextFormField(
                      controller: _phoneCtrl,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.phone_android,
                          color: activeColor,
                        ),
                        labelText: LocaleKeys.common_phone.tr(),
                        border: const UnderlineInputBorder(),
                      ),
                      validator: Validators.validatePhone,
                      keyboardType: TextInputType.phone,
                    ),
            ),
          ),
          const SizedBox(height: 24),

          AppButton(
            label: LocaleKeys.common_send_code.tr(),
            isLoading: widget.isLoading,
            onPressed: widget.isLoading
                ? null
                : () async {
                    if (!_formKey.currentState!.validate()) return;

                    final accountId = _accountIdentifierCtrl.text.trim();
                    final contactVal = _isEmail
                        ? _emailCtrl.text.trim()
                        : _phoneCtrl.text.trim();

                    widget.notifier.setMethod(
                      accountIdentifier: accountId,
                      contactValue: contactVal,
                      isEmail: _isEmail,
                    );
                    await widget.notifier.sendResetCode();
                  },
            variant: AppButtonVariant.primary,
          ),
        ],
      ),
    );
  }
}
