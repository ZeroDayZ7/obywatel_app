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
  final _contractNumberCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  bool _isEmail = true;

  @override
  void dispose() {
    _contractNumberCtrl.dispose();
    _emailCtrl.dispose();
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
          // 1. Input: Nr umowy
          TextFormField(
            controller: _contractNumberCtrl,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.description_outlined, color: activeColor),
              labelText: LocaleKeys.reset_password_account_identifier_label
                  .tr(),
              hintText: LocaleKeys.reset_password_account_identifier_hint.tr(),
              border: const UnderlineInputBorder(),
            ),
            validator: (val) => (val == null || val.trim().isEmpty)
                ? LocaleKeys.validators_required_account_identifier.tr()
                : null,
          ),
          const SizedBox(height: 16),

          // 2. Input: Identyfikator (E-mail)
          TextFormField(
            controller: _emailCtrl,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email_outlined, color: activeColor),
              labelText: LocaleKeys.common_identifier.tr(),
              hintText: 'Wpisz e-mail przypisany do konta',
              border: const UnderlineInputBorder(),
            ),
            validator: Validators.validateIdentifier,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 24),

          // Wybór kanału 2FA (email / SMS)
          Text(
            LocaleKeys.reset_password_where_to_send_code.tr(),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

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
          const SizedBox(height: 24),

          AppButton(
            label: LocaleKeys.common_send_code.tr(),
            isLoading: widget.isLoading,
            onPressed: widget.isLoading
                ? null
                : () async {
                    if (!_formKey.currentState!.validate()) return;

                    final contractNo = _contractNumberCtrl.text.trim();
                    final emailVal = _emailCtrl.text.trim();

                    widget.notifier.setMethod(
                      accountIdentifier: contractNo,
                      contactValue: emailVal,
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
