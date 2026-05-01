import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/design/tokens/border_radius.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/tokens/spacing.dart';
import 'package:obywatel_plus/core/design/widgets/responsive_content_wrapper.dart';
import 'package:obywatel_plus/core/design/widgets/ui/button.dart';
import 'package:obywatel_plus/core/design/widgets/ui/text_field.dart';
import 'package:obywatel_plus/core/utils/validators.dart';

class PinSetupDialog extends StatefulWidget {
  const PinSetupDialog({super.key});

  @override
  State<PinSetupDialog> createState() => _PinSetupDialogState();
}

class _PinSetupDialogState extends State<PinSetupDialog> {
  final PageController _pageController = PageController();
  final _formKeySetup = GlobalKey<FormState>();
  final _formKeyConfirm = GlobalKey<FormState>();

  final _pinController = TextEditingController();
  final _confirmController = TextEditingController();

  final _pinFocus = FocusNode();
  final _confirmFocus = FocusNode();

  bool _isObscured = true;
  String _firstPin = '';
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    _pinController.dispose();
    _confirmController.dispose();
    _pinFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  List<int> _mapStringToDigits(String value) {
    return value.split('').map(int.parse).toList();
  }

  void _onNext() {
    // Walidujemy aktualnie widoczną stronę
    final currentForm = _currentPage == 0 ? _formKeySetup : _formKeyConfirm;

    if (currentForm.currentState!.validate()) {
      if (_currentPage == 0) {
        _firstPin = _pinController.text;
        _goToPage(1);
      } else {
        context.pop(_confirmController.text);
      }
    }
  }

  void _goToPage(int page) {
    setState(() => _currentPage = page);
    _pageController
        .animateToPage(
          page,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOutCubic,
        )
        .then((_) {
          // Po zakończeniu animacji ustawiamy focus
          if (page == 1) {
            _confirmFocus.requestFocus();
          } else {
            _pinFocus.requestFocus();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(
      size: ContainerSize.narrow,
      alignment: Alignment.center,
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: AppRadius.radiusXl,
        elevation: 12,
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(Spacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Stała wysokość dla kontenera stron, aby dialog nie "skakał"
              ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 150),
                child: SizedBox(
                  height: 80,
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      // KROK 1: Ustawienie PIN
                      _buildStepPage(
                        formKey: _formKeySetup,
                        title: LocaleKeys.pin_dialog_set_pin_title.tr(),
                        controller: _pinController,
                        focusNode: _pinFocus,
                        label: LocaleKeys.pin_dialog_enter_4_digits.tr(),
                      ),
                      // KROK 2: Potwierdzenie PIN
                      _buildStepPage(
                        formKey: _formKeyConfirm,
                        title: LocaleKeys.pin_dialog_repeat_pin_title.tr(),
                        controller: _confirmController,
                        focusNode: _confirmFocus,
                        label: LocaleKeys.pin_dialog_repeat_4_digits.tr(),
                        isConfirm: true,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: Spacing.xl),
              // Przyciski akcji
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      labelKey: LocaleKeys.common_cancel,
                      variant: AppButtonVariant.text,
                      onPressed: () {
                        if (_currentPage == 1) {
                          _confirmController.clear();
                          _goToPage(0);
                        } else {
                          context.pop();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: Spacing.lg),
                  Expanded(
                    child: AppButton(
                      labelKey: _currentPage == 1
                          ? LocaleKeys.common_save
                          : LocaleKeys.common_next,
                      variant: AppButtonVariant.primary,
                      onPressed: _onNext,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepPage({
    required GlobalKey<FormState> formKey,
    required String title,
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    bool isConfirm = false,
  }) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Spacing.xxl),
          AppTextField(
            controller: controller,
            focusNode: focusNode,
            autofocus: true,
            labelText: label,
            keyboardType: TextInputType.number,
            obscureText: _isObscured,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(4),
            ],
            onChanged: (value) {
              if (value.length == 4) {
                _onNext();
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return LocaleKeys.validators_required_pin.tr();
              }
              final digits = _mapStringToDigits(value);
              final pinError = Validators.validatePinDigits(digits);
              if (pinError != null) return pinError;

              if (isConfirm && value != _firstPin) {
                return LocaleKeys.pin_dialog_pin_not_identical.tr();
              }
              return null;
            },
            suffixIcon: IconButton(
              icon: Icon(_isObscured ? Icons.visibility : Icons.visibility_off),
              onPressed: () => setState(() => _isObscured = !_isObscured),
            ),
          ),
        ],
      ),
    );
  }
}
