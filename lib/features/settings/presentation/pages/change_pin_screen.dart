import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/tokens/spacing.dart';
import 'package:obywatel_plus/core/design/widgets/main/app_scaffold.dart';
import 'package:obywatel_plus/core/design/widgets/ui/text_field.dart';
import 'package:obywatel_plus/core/errors/app_notification.dart';
import 'package:obywatel_plus/core/errors/global_notification_provider.dart';
import 'package:obywatel_plus/core/security/pin/change_pin_notifier.dart';
import 'package:obywatel_plus/core/security/pin/change_pin_state.dart';
import 'package:obywatel_plus/core/security/security/security_service_provider.dart';
import 'package:obywatel_plus/core/security/security_setup/security_setup_state.dart';

class ChangePinScreen extends ConsumerStatefulWidget {
  const ChangePinScreen({super.key});

  @override
  ConsumerState<ChangePinScreen> createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends ConsumerState<ChangePinScreen> {
  final PageController _pageController = PageController();

  final _oldPinController = TextEditingController();
  final _newPinController = TextEditingController();
  final _confirmPinController = TextEditingController();

  final _oldPinFocus = FocusNode();
  final _newPinFocus = FocusNode();
  final _confirmPinFocus = FocusNode();

  LocalSecurityMethod? _selectedTargetMethod;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isMethodSwitchMode) {
        _oldPinFocus.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _oldPinController.dispose();
    _newPinController.dispose();
    _confirmPinController.dispose();
    _oldPinFocus.dispose();
    _newPinFocus.dispose();
    _confirmPinFocus.dispose();
    super.dispose();
  }

  void _showError(String messageKey) {
    ref
        .read(globalNotificationProvider.notifier)
        .show(
          AppNotification(messageKey: messageKey, type: NotificationType.error),
        );
  }

  void _goTo(int page) {
    if (!_pageController.hasClients) return;

    FocusManager.instance.primaryFocus?.unfocus();

    _pageController
        .animateToPage(
          page,
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeInOutCubic,
        )
        .then((_) {
          if (!mounted) return;

          final List<FocusNode> nodes = [
            _oldPinFocus,
            _newPinFocus,
            _confirmPinFocus,
          ];

          if (page >= 0 && page < nodes.length) {
            nodes[page].requestFocus();
          }
        });
  }

  LocalSecurityMethod? _parseRouteMethod(String? rawMethod) {
    if (rawMethod == null || rawMethod.isEmpty) {
      return null;
    }

    for (final method in LocalSecurityMethod.values) {
      if (method.name == rawMethod) {
        return method;
      }
    }

    return null;
  }

  LocalSecurityMethod? get _method {
    final securityState = ref.watch(securityServiceProvider);
    final query = GoRouter.of(
      context,
    ).routeInformationProvider.value.uri.queryParameters;
    final routeMethod = _parseRouteMethod(query['method']);

    if (!securityState.initialized) {
      return null;
    }

    if (securityState.localSecurityMethod == LocalSecurityMethod.none) {
      return null;
    }

    if (routeMethod != null && routeMethod != securityState.localSecurityMethod) {
      return null;
    }

    return securityState.localSecurityMethod;
  }

  String get _mode {
    final query = GoRouter.of(
      context,
    ).routeInformationProvider.value.uri.queryParameters;
    final rawMode = query['mode']?.trim().toLowerCase();
    if (rawMode == 'change_method') {
      return 'change_method';
    }
    if (rawMode == 'change_secret') {
      return 'change_secret';
    }
    return 'change_secret';
  }

  bool get _isMethodSwitchMode => _mode == 'change_method';

  List<int> _secretBytesFrom(String value, LocalSecurityMethod method) {
    return method == LocalSecurityMethod.password
        ? utf8.encode(value)
        : value.codeUnits.toList();
  }

  void _handleMethodSelection(LocalSecurityMethod target) {
    final current = ref.read(securityServiceProvider).localSecurityMethod;

    if (target == current) {
      return;
    }

    setState(() {
      _selectedTargetMethod = target;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _goTo(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final securityState = ref.watch(securityServiceProvider);
    final method = _method;
    final isPasswordMode = method == LocalSecurityMethod.password;

    ref.listen<ChangePinState>(changePinProvider, (prev, next) {
      next.maybeWhen(
        enterOld: () => _goTo(_isMethodSwitchMode ? 2 : 0),
        enterNew: () => _goTo(1),
        confirmNew: () => _goTo(_isMethodSwitchMode ? 1 : 2),
        success: () {
          ref
              .read(globalNotificationProvider.notifier)
              .show(
                AppNotification(
                  messageKey: LocaleKeys.pin_dialog_changed_success,
                  type: NotificationType.success,
                ),
              );
          Navigator.pop(context);
        },
        error: (key) => _showError(key),
        orElse: () {},
      );
    });

    final state = ref.watch(changePinProvider);
    final isLoading = state.maybeWhen(loading: () => true, orElse: () => false);

    if (!securityState.initialized || method == null) {
      return AppScaffold(
        size: ContainerSize.compact,
        alignment: Alignment.center,
        appBar: AppBar(
          title: const Text('Zmień lokalne odblokowanie'),
          centerTitle: true,
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final targetMethod = _isMethodSwitchMode
        ? (_selectedTargetMethod ?? method)
        : method;
    final targetIsPassword = targetMethod == LocalSecurityMethod.password;

    final pages = _isMethodSwitchMode
        ? (
            _selectedTargetMethod == null
                ? <Widget>[_buildMethodSelectionStep(activeMethod: method)]
                : <Widget>[
                    _buildStep(
                      title: targetIsPassword
                          ? 'Ustaw nowe hasło lokalne'
                          : LocaleKeys.pin_dialog_set_pin_title.tr(),
                      controller: _newPinController,
                      focusNode: _newPinFocus,
                      isLoading: isLoading,
                      isPasswordMode: targetIsPassword,
                      submitLabel: 'Dalej',
                      onCompleted: (pin) {
                        ref
                            .read(changePinProvider.notifier)
                            .setNewPin(
                              _secretBytesFrom(pin, targetMethod),
                              targetMethod: targetMethod,
                            );
                      },
                    ),
                    _buildStep(
                      title: targetIsPassword
                          ? 'Powtórz nowe hasło lokalne'
                          : LocaleKeys.pin_dialog_repeat_pin_title.tr(),
                      controller: _confirmPinController,
                      focusNode: _confirmPinFocus,
                      isLoading: isLoading,
                      isPasswordMode: targetIsPassword,
                      submitLabel: 'Dalej',
                      onCompleted: (pin) {
                        ref
                            .read(changePinProvider.notifier)
                            .confirmNewSecret(
                              _secretBytesFrom(pin, targetMethod),
                              targetMethod: targetMethod,
                            );
                      },
                    ),
                    _buildStep(
                      title: method == LocalSecurityMethod.password
                          ? 'Podaj aktualny PIN'
                          : 'Podaj aktualne hasło lokalne',
                      controller: _oldPinController,
                      focusNode: _oldPinFocus,
                      isLoading: isLoading,
                      isPasswordMode: method == LocalSecurityMethod.password,
                      submitLabel: 'Zapisz',
                      onCompleted: (pin) {
                        ref
                            .read(changePinProvider.notifier)
                            .verifyCurrentSecretAndSave(
                              _secretBytesFrom(pin, method),
                              currentMethod: method,
                            );
                      },
                    ),
                  ]
          )
        : <Widget>[
            _buildStep(
              title: isPasswordMode
                  ? 'Podaj obecne hasło lokalne'
                  : LocaleKeys.pin_dialog_enter_old_pin.tr(),
              controller: _oldPinController,
              focusNode: _oldPinFocus,
              isLoading: isLoading,
              isPasswordMode: isPasswordMode,
              submitLabel: 'Dalej',
              onCompleted: (pin) {
                ref.read(changePinProvider.notifier).verifyOldPin(
                  _secretBytesFrom(pin, method),
                  method: method,
                );
              },
            ),
            _buildStep(
              title: isPasswordMode
                  ? 'Ustaw nowe hasło lokalne'
                  : LocaleKeys.pin_dialog_set_pin_title.tr(),
              controller: _newPinController,
              focusNode: _newPinFocus,
              isLoading: isLoading,
              isPasswordMode: isPasswordMode,
              submitLabel: 'Dalej',
              onCompleted: (pin) {
                ref.read(changePinProvider.notifier).setNewPin(
                  _secretBytesFrom(pin, method),
                  targetMethod: method,
                );
              },
            ),
            _buildStep(
              title: isPasswordMode
                  ? 'Powtórz nowe hasło lokalne'
                  : LocaleKeys.pin_dialog_repeat_pin_title.tr(),
              controller: _confirmPinController,
              focusNode: _confirmPinFocus,
              isLoading: isLoading,
              isPasswordMode: isPasswordMode,
              submitLabel: 'Zapisz',
              onCompleted: (pin) {
                Future.microtask(() async {
                  await ref.read(changePinProvider.notifier).confirmAndSave(
                    _secretBytesFrom(pin, method),
                    method: method,
                  );
                });
              },
            ),
          ];

    return AppScaffold(
      size: ContainerSize.compact,
      alignment: Alignment.center,
      appBar: AppBar(
        title: Text(
          _isMethodSwitchMode
              ? 'Aktywna metoda'
              : (isPasswordMode
                    ? 'Hasło lokalne'
                    : LocaleKeys.settings_common_change_pin.tr()),
        ),
        centerTitle: true,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 520),
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: pages,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodSelectionStep({
    required LocalSecurityMethod activeMethod,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Wybierz aktywną metodę lokalnego odblokowania',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: Spacing.xxl),
          _buildMethodOption(
            title: 'PIN',
            subtitle: 'Numerowy kod lokalnego odblokowania',
            selected: activeMethod == LocalSecurityMethod.pin,
            onTap: () => _handleMethodSelection(LocalSecurityMethod.pin),
          ),
          const SizedBox(height: Spacing.md),
          _buildMethodOption(
            title: 'Hasło lokalne',
            subtitle: 'Własne hasło do lokalnego odblokowania',
            selected: activeMethod == LocalSecurityMethod.password,
            onTap: () => _handleMethodSelection(LocalSecurityMethod.password),
          ),
        ],
      ),
    );
  }

  Widget _buildMethodOption({
    required String title,
    required String subtitle,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Material(
      color: selected
          ? theme.colorScheme.primaryContainer.withValues(alpha: 0.25)
          : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline,
                    width: 2,
                  ),
                  color: selected ? theme.colorScheme.primary : Colors.transparent,
                ),
                child: selected
                    ? Icon(Icons.check, size: 18, color: theme.colorScheme.onPrimary)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep({
    required String title,
    required TextEditingController controller,
    required FocusNode focusNode,
    required void Function(String) onCompleted,
    required String submitLabel,
    bool isLoading = false,
    bool isPasswordMode = false,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          const Padding(
            padding: EdgeInsets.only(bottom: Spacing.xl),
            child: CircularProgressIndicator(),
          ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: Spacing.xxl),
        AppTextField(
          controller: controller,
          focusNode: focusNode,
          autofocus: false,
          labelText: isPasswordMode
              ? 'Hasło lokalne'
              : LocaleKeys.pin_dialog_enter_4_digits.tr(),
          obscureText: true,
          enabled: !isLoading,
          keyboardType: isPasswordMode
              ? TextInputType.visiblePassword
              : TextInputType.number,
          inputFormatters: isPasswordMode
              ? [LengthLimitingTextInputFormatter(64)]
              : [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
          onChanged: (val) {
            if (!isPasswordMode && !isLoading && val.length == 4) {
              onCompleted(val);
            }
          },
        ),
        const SizedBox(height: Spacing.xl),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading ? null : () => onCompleted(controller.text),
            child: Text(submitLabel),
          ),
        ),
      ],
    );
  }
}
