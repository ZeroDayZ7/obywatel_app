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
import 'package:obywatel_plus/core/logger/logger_provider.dart';
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

  bool _didSyncInitialization = false;

  void _syncInitializationIfNeeded() {
    if (_didSyncInitialization) return;

    final securityState = ref.read(securityServiceProvider);
    final processState = ref.read(changePinProvider);
    final routeOperation = _resolveRouteOperation();
    final routeMethod = _parseRouteMethod(
      GoRouter.of(context).routeInformationProvider.value.uri.queryParameters['method'],
    );

    final shouldInitialize = securityState.initialized &&
        securityState.localSecurityMethod != LocalSecurityMethod.none &&
        processState.currentMethod == LocalSecurityMethod.none &&
        (routeMethod == null || routeMethod == securityState.localSecurityMethod);

    if (!shouldInitialize) {
      return;
    }

    _didSyncInitialization = true;
    ref.read(changePinProvider.notifier).initialize(
      currentMethod: securityState.localSecurityMethod,
      operationType: routeOperation,
      targetMethod: routeOperation == ChangePinOperationType.changeMethod
          ? null
          : securityState.localSecurityMethod,
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final processState = ref.read(changePinProvider);
      if (processState.step == ChangePinStep.enterOld &&
          processState.operationType != ChangePinOperationType.changeMethod) {
        _oldPinFocus.requestFocus();
      }
      _syncInitializationIfNeeded();
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

  ChangePinOperationType _resolveRouteOperation() {
    final query = GoRouter.of(
      context,
    ).routeInformationProvider.value.uri.queryParameters;
    final rawMode = query['mode']?.trim().toLowerCase();

    if (rawMode == 'change_method') {
      return ChangePinOperationType.changeMethod;
    }

    return ChangePinOperationType.changeSecret;
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

  List<int> _secretBytesFrom(String value, LocalSecurityMethod method) {
    return method == LocalSecurityMethod.password
        ? utf8.encode(value)
        : value.codeUnits.toList();
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

          final nodes = <FocusNode>[_newPinFocus, _confirmPinFocus, _oldPinFocus];
          if (page >= 0 && page < nodes.length) {
            nodes[page].requestFocus();
          }
        });
  }

  int _pageIndexForStep(ChangePinStep step) {
    switch (step) {
      case ChangePinStep.selectMethod:
        return 0;
      case ChangePinStep.enterNew:
        return 0;
      case ChangePinStep.confirmNew:
        return 1;
      case ChangePinStep.enterOld:
      case ChangePinStep.loading:
      case ChangePinStep.error:
        return 2;
      case ChangePinStep.success:
      case ChangePinStep.idle:
        return 0;
    }
  }

  void _handleMethodSelection(LocalSecurityMethod target) {
    final current = ref.read(securityServiceProvider).localSecurityMethod;

    if (target == current) {
      return;
    }

    ref.read(changePinProvider.notifier).beginMethodSwitch(target);
    WidgetsBinding.instance.addPostFrameCallback((_) => _goTo(0));
  }

  @override
  Widget build(BuildContext context) {
    final securityState = ref.watch(securityServiceProvider);
    final changePinState = ref.watch(changePinProvider);
    final routeMethod = _parseRouteMethod(
      GoRouter.of(context).routeInformationProvider.value.uri.queryParameters['method'],
    );

    ref.listen<ChangePinState>(changePinProvider, (previous, next) {
      ref.read(appLoggerProvider).d(
        '[LOCAL-UNLOCK-02][STEP] step=${next.step.name} operation=${next.operationType.name} current=${next.currentMethod.name} target=${next.targetMethod.name}',
        module: 'LocalUnlock',
      );

      if (next.step == ChangePinStep.selectMethod) {
        _goTo(0);
      } else if (next.step == ChangePinStep.enterNew) {
        _goTo(0);
      } else if (next.step == ChangePinStep.confirmNew) {
        _goTo(1);
      } else if (next.step == ChangePinStep.enterOld) {
        _goTo(2);
      } else if (next.step == ChangePinStep.success) {
        ref.read(globalNotificationProvider.notifier).show(
          AppNotification(
            messageKey: LocaleKeys.pin_dialog_changed_success,
            type: NotificationType.success,
          ),
        );
        Navigator.pop(context);
      } else if (next.step == ChangePinStep.error &&
          next.errorMessageKey != null) {
        _showError(next.errorMessageKey!);
      }
    });

    if (routeMethod != null && routeMethod != securityState.localSecurityMethod) {
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

    if (!securityState.initialized ||
        securityState.localSecurityMethod == LocalSecurityMethod.none) {
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

    final currentMethod = changePinState.currentMethod == LocalSecurityMethod.none
        ? securityState.localSecurityMethod
        : changePinState.currentMethod;
    final effectiveTargetMethod = changePinState.targetMethod == LocalSecurityMethod.none
        ? currentMethod
        : changePinState.targetMethod;
    final isMethodSwitchMode = changePinState.isMethodSwitch;
    final isPasswordMode = currentMethod == LocalSecurityMethod.password;
    final targetIsPassword = effectiveTargetMethod == LocalSecurityMethod.password;
    final isLoading = changePinState.isSubmitting ||
        changePinState.step == ChangePinStep.loading;

    final pages = isMethodSwitchMode && changePinState.step == ChangePinStep.selectMethod
        ? <Widget>[
            _buildMethodSelectionStep(activeMethod: currentMethod),
          ]
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
                ref.read(changePinProvider.notifier).setNewSecret(
                  _secretBytesFrom(pin, effectiveTargetMethod),
                  targetMethod: effectiveTargetMethod,
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
                ref.read(changePinProvider.notifier).confirmNewSecret(
                  _secretBytesFrom(pin, effectiveTargetMethod),
                  targetMethod: effectiveTargetMethod,
                );
              },
            ),
            _buildStep(
              title: currentMethod == LocalSecurityMethod.password
                  ? 'Podaj aktualne hasło lokalne'
                  : 'Podaj aktualny PIN',
              controller: _oldPinController,
              focusNode: _oldPinFocus,
              isLoading: isLoading,
              isPasswordMode: currentMethod == LocalSecurityMethod.password,
              submitLabel: 'Zapisz',
              onCompleted: (pin) {
                ref.read(changePinProvider.notifier).verifyCurrentSecretAndSave(
                  _secretBytesFrom(pin, currentMethod),
                  currentMethod: currentMethod,
                );
              },
            ),
          ];

    if (changePinState.step != ChangePinStep.idle &&
        changePinState.step != ChangePinStep.error) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_pageController.hasClients) {
          final targetPage = _pageIndexForStep(changePinState.step);
          if (_pageController.page?.round() != targetPage) {
            _goTo(targetPage);
          }
        }
      });
    }

    return AppScaffold(
      size: ContainerSize.compact,
      alignment: Alignment.center,
      appBar: AppBar(
        title: Text(
          isMethodSwitchMode
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
