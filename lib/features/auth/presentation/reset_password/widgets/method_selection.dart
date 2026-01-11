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
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  bool _isEmail = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SegmentedButton<bool>(
            segments: [
              ButtonSegment(
                value: true,
                label: Text(LocaleKeys.common_email.tr()),
              ),
              ButtonSegment(
                value: false,
                label: Text(LocaleKeys.common_phone.tr()),
              ),
            ],
            selected: {_isEmail},
            onSelectionChanged: (v) => setState(() => _isEmail = v.first),
          ),
          const SizedBox(height: 16),
          if (_isEmail)
            TextFormField(
              controller: _emailCtrl,
              decoration: InputDecoration(
                labelText: LocaleKeys.common_email.tr(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                border: const UnderlineInputBorder(),
              ),
              validator: Validators.validateEmail,
              keyboardType: TextInputType.emailAddress,
            )
          else
            TextFormField(
              controller: _phoneCtrl,
              decoration: InputDecoration(
                labelText: LocaleKeys.common_phone.tr(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                border: const UnderlineInputBorder(),
              ),
              validator: Validators.validatePhone,
              keyboardType: TextInputType.phone,
            ),
          const SizedBox(height: 24),
          AppButton(
            labelKey: LocaleKeys.common_send_code.tr(),
            isLoading: widget.isLoading,
            onPressed: widget.isLoading
                ? null
                : () async {
                    if (!_formKey.currentState!.validate()) return;
                    final input = _isEmail
                        ? _emailCtrl.text.trim()
                        : _phoneCtrl.text.trim();
                    widget.notifier.setMethod(input, _isEmail);
                    await widget.notifier.sendResetCode();
                  },
            variant: AppButtonVariant.primary,
          ),
        ],
      ),
    );
  }
}
