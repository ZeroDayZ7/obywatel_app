import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/design/border_radius.dart';
import 'package:obywatel_plus/core/design/layout_tokens.dart';
import 'package:obywatel_plus/core/design/margins/screen_margins.dart';
import 'package:obywatel_plus/core/design/spacing.dart';
import 'package:obywatel_plus/core/widgets/ui/button.dart';
import 'package:obywatel_plus/core/widgets/ui/text_field.dart';

class PinSetupDialog extends StatefulWidget {
  const PinSetupDialog({super.key});

  @override
  State<PinSetupDialog> createState() => _PinSetupDialogState();
}

class _PinSetupDialogState extends State<PinSetupDialog> {
  final _formKey = GlobalKey<FormState>();
  final _pinController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _isConfirmStage = false;
  bool _isObscured = true;
  String _firstPin = '';

  @override
  void dispose() {
    _pinController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_formKey.currentState!.validate()) {
      if (!_isConfirmStage) {
        // Krok 1: Zapamiętaj pierwszy PIN i przejdź dalej
        setState(() {
          _firstPin = _pinController.text;
          _isConfirmStage = true;
        });
      } else {
        // Krok 2: Piny są identyczne (walidator to sprawdził), wyjdź z sukcesem
        context.pop(_confirmController.text);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.xl),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: Layout.maxWidth,
          ), // Max 420px
          child: Material(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(Corners.xl),
            elevation: 12,
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: ScreenMargins.all,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: Spacing.sm),
                    Text(
                      _isConfirmStage
                          ? LocaleKeys.pin_dialog_repeat_pin_title.tr()
                          : LocaleKeys.pin_dialog_set_pin_title.tr(),
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: Spacing.xxl),

                    AppTextField(
                      controller: _isConfirmStage
                          ? _confirmController
                          : _pinController,
                      // Używamy ValueKey, aby Flutter wiedział, że to "nowe" pole przy zmianie etapu
                      key: ValueKey(_isConfirmStage ? 'confirm' : 'setup'),
                      labelText: _isConfirmStage
                          ? LocaleKeys.pin_dialog_repeat_4_digits.tr()
                          : LocaleKeys.pin_dialog_enter_4_digits.tr(),
                      keyboardType: TextInputType.number,
                      obscureText: _isObscured,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      validator: (value) {
                        if (value == null || value.length < 4) {
                          return LocaleKeys.pin_dialog_pin_must_be_4_digits
                              .tr();
                        }
                        if (_isConfirmStage && value != _firstPin) {
                          return LocaleKeys.pin_dialog_pin_not_identical.tr();
                        }
                        return null;
                      },
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscured ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () =>
                            setState(() => _isObscured = !_isObscured),
                      ),
                    ),

                    const SizedBox(height: Spacing.xxxl),

                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            labelKey: LocaleKeys.common_cancel,
                            variant: AppButtonVariant.text,
                            onPressed: () {
                              if (_isConfirmStage) {
                                setState(() {
                                  _isConfirmStage = false;
                                  _confirmController.clear();
                                });
                              } else {
                                context.pop();
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: Spacing.lg),
                        Expanded(
                          child: AppButton(
                            labelKey: _isConfirmStage
                                ? LocaleKeys.common_save
                                : LocaleKeys.common_next,
                            variant: AppButtonVariant.primary,
                            onPressed: _onNext,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Spacing.sm),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
