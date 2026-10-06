import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/widgets/main/app_scaffold.dart';
import 'package:obywatel_plus/core/design/widgets/ui/button.dart';
import 'package:obywatel_plus/core/utils/validators.dart';
import 'package:obywatel_plus/features/auth/presentation/login/widgets/app_text_field.dart';
import 'package:obywatel_plus/features/settings/application/change_password_notifier.dart';
import 'package:obywatel_plus/features/settings/domain/change_password_state.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool get _isFormValid {
    final current = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text;
    final confirmation = _confirmPasswordController.text;

    final hasValidCurrent = current.isNotEmpty && Validators.validatePassword(current, minLength: 8) == null;
    final hasValidNew = newPassword.length >= 8 &&
        Validators.validatePassword(newPassword, minLength: 8) == null;
    final matches = newPassword == confirmation && confirmation.isNotEmpty;

    return hasValidCurrent && hasValidNew && matches;
  }

  @override
  void initState() {
    super.initState();
    _currentPasswordController.addListener(_rebuild);
    _newPasswordController.addListener(_rebuild);
    _confirmPasswordController.addListener(_rebuild);
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _rebuild() => setState(() {});

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(changePasswordProvider.notifier).submit(
      currentPassword: _currentPasswordController.text,
      newPassword: _newPasswordController.text,
      confirmation: _confirmPasswordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(changePasswordProvider);

    ref.listen<ChangePasswordState>(changePasswordProvider, (
      previous,
      next,
    ) {
      if (next.status == ChangePasswordStatus.error && next.messageKey != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.messageKey!.tr()),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    final isSubmitting = state.status == ChangePasswordStatus.submitting;

    return AppScaffold(
      size: ContainerSize.medium,
      appBar: AppBar(
        title: Text(LocaleKeys.settings_security_change_password.tr()),
      ),
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: AutofillGroup(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    LocaleKeys.settings_security_change_password.tr(),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    LocaleKeys.settings_security_change_password_description.tr(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  AppTextField(
                    controller: _currentPasswordController,
                    labelKey: LocaleKeys.settings_change_password_current,
                    isPassword: true,
                    enabled: !isSubmitting,
                    keyboardType: TextInputType.visiblePassword,
                    autofillHints: AutofillHints.password,
                    validator: (value) => Validators.validatePassword(value, minLength: 8),
                    inputFormatters: [LengthLimitingTextInputFormatter(128)],
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _newPasswordController,
                    labelKey: LocaleKeys.settings_change_password_new,
                    isPassword: true,
                    enabled: !isSubmitting,
                    keyboardType: TextInputType.visiblePassword,
                    autofillHints: AutofillHints.newPassword,
                    validator: (value) => Validators.validatePassword(value, minLength: 8),
                    inputFormatters: [LengthLimitingTextInputFormatter(128)],
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _confirmPasswordController,
                    labelKey: LocaleKeys.settings_change_password_confirm,
                    isPassword: true,
                    enabled: !isSubmitting,
                    keyboardType: TextInputType.visiblePassword,
                    autofillHints: AutofillHints.newPassword,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return LocaleKeys.validators_required_password.tr();
                      }
                      if (value != _newPasswordController.text) {
                        return LocaleKeys.validators_passwords_not_match.tr();
                      }
                      return null;
                    },
                    inputFormatters: [LengthLimitingTextInputFormatter(128)],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    LocaleKeys.settings_change_password_requirements.tr(),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  _PasswordRequirementsList(password: _newPasswordController.text),
                  const SizedBox(height: 24),
                  AppButton(
                    label: LocaleKeys.settings_change_password_submit.tr(),
                    fullWidth: true,
                    isLoading: isSubmitting,
                    onPressed: _isFormValid && !isSubmitting ? _submit : null,
                    variant: AppButtonVariant.primary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PasswordRequirementsList extends StatelessWidget {
  const _PasswordRequirementsList({required this.password});

  final String password;

  @override
  Widget build(BuildContext context) {
    final requirements = [
      (LocaleKeys.validators_req_min_chars, password.length >= 8),
      (LocaleKeys.validators_req_at_least_letter, RegExp(r'[A-Za-z]').hasMatch(password)),
      (LocaleKeys.validators_req_at_least_digit, RegExp(r'\d').hasMatch(password)),
      (LocaleKeys.validators_req_special_char, RegExp(r'[!@#\$&*~]').hasMatch(password)),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final entry in requirements)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                Icon(
                  entry.$2 ? Icons.check_circle : Icons.circle_outlined,
                  size: 16,
                  color: entry.$2
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outline,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    entry.$1.tr(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: entry.$2
                          ? Theme.of(context).colorScheme.onSurface
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
