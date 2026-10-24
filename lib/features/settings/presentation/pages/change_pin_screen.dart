import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
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
  const ChangePinScreen({
    super.key,
    this.initialMode,
    this.initialMethod,
  });

  final String? initialMode;
  final LocalSecurityMethod? initialMethod;

  static ChangePinOperationType resolveRouteOperation(String? rawMode) {
    final normalized = rawMode?.trim().toLowerCase();
    if (normalized == 'change_method') {
      return ChangePinOperationType.changeMethod;
    }
    return ChangePinOperationType.changeSecret;
  }

  static LocalSecurityMethod? parseRouteMethod(String? rawMethod) {
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

  String? _lastRouteSignature;

  ChangePinOperationType _resolveRouteOperation() {
    final query = GoRouter.of(
      context,
    ).routeInformationProvider.value.uri.queryParameters;
    return ChangePinScreen.resolveRouteOperation(
      widget.initialMode ?? query['mode'],
    );
  }

  LocalSecurityMethod? _parseRouteMethod(String? rawMethod) {
    return widget.initialMethod ?? ChangePinScreen.parseRouteMethod(rawMethod);
  }

  void _logScreenEntry() {
    final route = GoRouter.of(context).routeInformationProvider.value.uri;
    final query = route.queryParameters;
    final securityState = ref.read(securityServiceProvider);
    final logger = ref.read(appLoggerProvider);

    final effectiveMode = widget.initialMode ?? query['mode'];
    final effectiveMethod = widget.initialMethod?.name ?? query['method'];

    final message =
        '[ChangePinScreen._logScreenEntry 1] routeMode=$effectiveMode routeMethod=$effectiveMethod localSecurityMethod=${securityState.localSecurityMethod.name} isInitialized=${securityState.initialized}';
    logger.d(message, module: 'LocalUnlock');
    debugPrint(message);
  }

  void _syncInitializationIfNeeded() {
    final securityState = ref.read(securityServiceProvider);
    final currentState = ref.read(changePinProvider);
    final routeOperation = _resolveRouteOperation();
    final explicitRouteMethod = _parseRouteMethod(
      widget.initialMethod?.name ??
          GoRouter.of(context).routeInformationProvider.value.uri.queryParameters['method'],
    );
    final effectiveRouteMethod = explicitRouteMethod ?? securityState.localSecurityMethod;

    final message =
        '[ChangePinScreen._syncInitializationIfNeeded 1] routeOperation=${routeOperation.name} routeMethod=${explicitRouteMethod?.name ?? 'none'} effectiveMethod=${effectiveRouteMethod.name} activeMethod=${securityState.localSecurityMethod.name} initialized=${securityState.initialized}';
    debugPrint(message);
    ref.read(appLoggerProvider).d(message, module: 'LocalUnlock');

    if (!securityState.initialized ||
        securityState.localSecurityMethod == LocalSecurityMethod.none) {
      debugPrint('[ChangePinScreen._syncInitializationIfNeeded 2] skip because security not initialized or method is none');
      return;
    }

    final hasExplicitMismatch = explicitRouteMethod != null &&
        explicitRouteMethod != securityState.localSecurityMethod;
    if (hasExplicitMismatch) {
      debugPrint(
        '[ChangePinScreen._syncInitializationIfNeeded 3] route mismatch: routeMethod=${explicitRouteMethod.name} activeMethod=${securityState.localSecurityMethod.name}; skipping init',
      );
      return;
    }

    final isActiveSameOperationFlow = currentState.operationType == routeOperation &&
        currentState.currentMethod == securityState.localSecurityMethod &&
        currentState.step != ChangePinStep.idle &&
        currentState.step != ChangePinStep.success &&
        currentState.step != ChangePinStep.error &&
        currentState.step != ChangePinStep.selectMethod;
    if (isActiveSameOperationFlow) {
      debugPrint(
        '[ChangePinScreen._syncInitializationIfNeeded 4] active same operation flow already in progress; preserving current step=${currentState.step.name}',
      );
      return;
    }

    final isProviderAlreadyAligned = currentState.currentMethod == securityState.localSecurityMethod &&
        currentState.operationType == routeOperation &&
        (explicitRouteMethod != null || currentState.targetMethod == securityState.localSecurityMethod);
    if (isProviderAlreadyAligned) {
      debugPrint('[ChangePinScreen._syncInitializationIfNeeded 4b] provider already aligned with active method; skipping re-init');
      return;
    }

    final routeSignature = '${routeOperation.name}|${effectiveRouteMethod.name}|${securityState.localSecurityMethod.name}';
    if (_lastRouteSignature == routeSignature &&
        currentState.currentMethod == securityState.localSecurityMethod) {
      debugPrint('[ChangePinScreen._syncInitializationIfNeeded 5] already initialized for same signature');
      return;
    }

    _lastRouteSignature = routeSignature;
    debugPrint(
      '[ChangePinScreen._syncInitializationIfNeeded 6] initializing provider state signature=$routeSignature',
    );
    ref.read(changePinProvider.notifier).initialize(
      currentMethod: securityState.localSecurityMethod,
      operationType: routeOperation,
      targetMethod: routeOperation == ChangePinOperationType.changeMethod
          ? null
          : securityState.localSecurityMethod,
    );
  }

  List<int> _secretBytesFrom(String value, LocalSecurityMethod method) {
    final logger = ref.read(appLoggerProvider);
    final startMessage =
        '[ChangePinScreen._secretBytesFrom 1] method=${method.name} inputLength=${value.length}';
    logger.d(startMessage, module: 'LocalUnlock');
    debugPrint(startMessage);

    final bytes = method == LocalSecurityMethod.password
        ? utf8.encode(value)
        : value.split('').where((char) => char.isNotEmpty).toList().map((digit) => int.parse(digit)).toList();

    final finalMessage =
        '[ChangePinScreen._secretBytesFrom 2] method=${method.name} byteCount=${bytes.length}';
    logger.d(finalMessage, module: 'LocalUnlock');
    debugPrint(finalMessage);

    return bytes;
  }

  void _showError(String messageKey) {
    ref.read(globalNotificationProvider.notifier).show(
      AppNotification(messageKey: messageKey, type: NotificationType.error),
    );
  }

  void _goToPage(int page) {
    if (!_pageController.hasClients) return;

    final currentPage = _pageController.page?.round();
    if (currentPage == page) return;

    FocusManager.instance.primaryFocus?.unfocus();
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOutCubic,
    );
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
        return 2;
      case ChangePinStep.error:
        return _pageController.hasClients
            ? (_pageController.page?.round() ?? 0)
            : 0;
      case ChangePinStep.success:
      case ChangePinStep.idle:
        return 0;
    }
  }

  void _handleMethodSelection(LocalSecurityMethod target) {
    final current = ref.read(securityServiceProvider).localSecurityMethod;
    debugPrint(
      '[ChangePinScreen._handleMethodSelection 1] selectedTarget=${target.name} current=${current.name}',
    );
    if (target == current) {
      debugPrint('[ChangePinScreen._handleMethodSelection 2] target equals current, no-op');
      return;
    }

    ref.read(changePinProvider.notifier).beginMethodSwitch(target);
    debugPrint(
      '[ChangePinScreen._handleMethodSelection 3] delegated method switch to notifier for target=${target.name}',
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _logScreenEntry();
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

  @override
  Widget build(BuildContext context) {
    final securityState = ref.watch(securityServiceProvider);
    final changePinState = ref.watch(changePinProvider);

    ref.listen(securityServiceProvider, (previous, next) {
      if (!next.initialized || previous?.initialized == true) return;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _syncInitializationIfNeeded();
      });
    });

    final routeMethod = _parseRouteMethod(
      GoRouter.of(context).routeInformationProvider.value.uri.queryParameters['method'],
    );
    final hasRouteMismatch = routeMethod != null &&
        routeMethod != securityState.localSecurityMethod;

    debugPrint(
      '[ChangePinScreen.build 1] securityInitialized=${securityState.initialized} localMethod=${securityState.localSecurityMethod.name} routeMethod=${routeMethod?.name ?? 'none'} hasRouteMismatch=$hasRouteMismatch step=${changePinState.step.name} operation=${changePinState.operationType.name}',
    );

    ref.listen<ChangePinState>(changePinProvider, (previous, next) {
      if (previous == next) return;

      final stateMessage =
          '[ChangePinScreen.build 2] previousStep=${previous?.step.name ?? 'none'} nextStep=${next.step.name} operation=${next.operationType.name} current=${next.currentMethod.name} target=${next.targetMethod.name}';
      debugPrint(stateMessage);
      ref.read(appLoggerProvider).d(stateMessage, module: 'LocalUnlock');

      if (next.step == ChangePinStep.success) {
        ref.read(globalNotificationProvider.notifier).show(
          AppNotification(
            messageKey: next.operationType == ChangePinOperationType.changeMethod
                ? 'Metoda odblokowania została zmieniona.'
                : 'Sekret lokalnego odblokowania został zmieniony.',
            type: NotificationType.success,
          ),
        );

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('${AppRoutes.settings}/${AppRoutes.settingsSecurity}');
          }
        });
        return;
      }

      if (next.step == ChangePinStep.error && next.errorMessageKey != null) {
        _showError(next.errorMessageKey!);
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_pageController.hasClients) {
          final targetPage = _pageIndexForStep(next.step);
          if ((_pageController.page?.round() ?? 0) != targetPage) {
            _goToPage(targetPage);
          }
        }
      });
    });

    final blockedByRouteMismatch = hasRouteMismatch &&
        changePinState.step != ChangePinStep.success;

    if (!securityState.initialized ||
        securityState.localSecurityMethod == LocalSecurityMethod.none ||
        blockedByRouteMismatch) {
      return AppScaffold(
        size: ContainerSize.compact,
        alignment: Alignment.center,
        appBar: AppBar(title: const Text('Zmień lokalne odblokowanie')),
        child: const Center(child: CircularProgressIndicator()),
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

    final pages = changePinState.requiresTargetSelection
        ? <Widget>[
            _buildMethodSelectionStep(activeMethod: currentMethod),
          ]
        : <Widget>[
            _buildStep(
              title: targetIsPassword
                  ? 'Ustaw nowe hasło lokalne'
                  : 'Ustaw nowy PIN',
              controller: _newPinController,
              focusNode: _newPinFocus,
              isLoading: isLoading,
              isPasswordMode: targetIsPassword,
              submitLabel: 'Dalej',
              onCompleted: (value) {
                ref.read(changePinProvider.notifier).setNewSecret(
                  _secretBytesFrom(value, effectiveTargetMethod),
                  targetMethod: effectiveTargetMethod,
                );
              },
            ),
            _buildStep(
              title: targetIsPassword
                  ? 'Powtórz nowe hasło lokalne'
                  : 'Powtórz nowy PIN',
              controller: _confirmPinController,
              focusNode: _confirmPinFocus,
              isLoading: isLoading,
              isPasswordMode: targetIsPassword,
              submitLabel: 'Dalej',
              onCompleted: (value) {
                ref.read(changePinProvider.notifier).confirmNewSecret(
                  _secretBytesFrom(value, effectiveTargetMethod),
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
              onCompleted: (value) {
                ref.read(changePinProvider.notifier).verifyCurrentSecretAndSave(
                  _secretBytesFrom(value, currentMethod),
                  currentMethod: currentMethod,
                );
              },
            ),
          ];

    return AppScaffold(
      size: ContainerSize.compact,
      alignment: Alignment.center,
      appBar: AppBar(
        title: Text(
          isMethodSwitchMode ? 'Aktywna metoda' : (isPasswordMode ? 'Hasło lokalne' : 'Zmiana PIN'),
        ),
        centerTitle: true,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 520),
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: pages,
          ),
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
          labelText: isPasswordMode ? 'Hasło lokalne' : '4 cyfry PIN',
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
