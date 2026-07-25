import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/widgets/main/responsive_content_wrapper.dart';
import 'package:obywatel_plus/core/design/widgets/ui/app_loader.dart';
import 'package:obywatel_plus/core/security/local_auth_provider.dart';
import 'package:obywatel_plus/core/security/pin/pin_attempt_limiter.dart';
import 'package:obywatel_plus/core/security/pin/pin_verification_notifier.dart';
import 'package:obywatel_plus/core/security/pin/pin_verification_state.dart';
import 'package:obywatel_plus/core/security/pin/presentation/widget/lockout_overlay.dart';
import 'package:obywatel_plus/core/security/pin/presentation/widget/pin_input_view.dart';
import 'package:obywatel_plus/core/security/security/security_service_provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinVerificationScreen extends ConsumerStatefulWidget {
  const PinVerificationScreen({super.key});

  @override
  ConsumerState<PinVerificationScreen> createState() => _PinScreenState();
}

class _PinScreenState extends ConsumerState<PinVerificationScreen> {
  late StreamController<ErrorAnimationType> _errorController;
  int _resetToken = 0;
  bool _hasAttemptedAutoBiometrics = false;

  @override
  void initState() {
    super.initState();
    _errorController = StreamController<ErrorAnimationType>.broadcast();

    ref.listenManual(pinVerificationProvider, (prev, next) {
      next.maybeWhen(
        error: () {
          HapticFeedback.vibrate();
          _errorController.add(ErrorAnimationType.shake);
          setState(() => _resetToken++);
        },
        orElse: () {},
      );

      final wasLocked =
          prev?.maybeWhen(locked: (_) => true, orElse: () => false) ?? false;
      final isIdle = next.maybeWhen(idle: () => true, orElse: () => false);

      if (wasLocked && isIdle) {
        setState(() => _resetToken++);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _triggerBiometricAuthIfAvailable(isAutoPrompt: true);
    });
  }

  @override
  void dispose() {
    _errorController.close();
    super.dispose();
  }

  Future<void> _triggerBiometricAuthIfAvailable({
    bool isAutoPrompt = false,
  }) async {
    if (isAutoPrompt && _hasAttemptedAutoBiometrics) return;

    final securityState = ref.read(securityServiceProvider);

    if (!securityState.isBiometricEnabled || !securityState.canUseBiometrics) {
      return;
    }

    if (isAutoPrompt) {
      _hasAttemptedAutoBiometrics = true;
    }

    try {
      final localAuth = ref.read(localAuthProvider);
      final authenticated = await localAuth.authenticate(
        localizedReason: 'Zautoryzuj się, aby odblokować aplikację',
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );

      if (authenticated && mounted) {
        await ref.read(securityServiceProvider.notifier).unlockApp();
      }
    } catch (_) {
      // W przypadku anulowania lub błędu użytkownik odblokowuje aplikację kodem PIN
    }
  }

  @override
  Widget build(BuildContext context) {
    final limiterAsync = ref.watch(pinAttemptLimiterProvider);
    final securityState = ref.watch(securityServiceProvider);

    final isLockedUI = ref.watch(
      pinVerificationProvider.select(
        (s) => s.maybeWhen(locked: (_) => true, orElse: () => false),
      ),
    );

    final canShowBiometricButton =
        securityState.isBiometricEnabled && securityState.canUseBiometrics;

    return Scaffold(
      body: limiterAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (limiter) {
          final attempts = limiter.attempts;
          final remainingAttempts = ref
              .read(pinAttemptLimiterProvider.notifier)
              .remainingAttempts;

          final isLocked = isLockedUI || limiter.isLocked;
          final verificationState = ref.watch(pinVerificationProvider);

          final isLoading = verificationState.maybeWhen(
            loading: () => true,
            orElse: () => false,
          );

          final isError = verificationState.maybeWhen(
            error: () => true,
            orElse: () => false,
          );

          return Stack(
            children: [
              SafeArea(
                child: ResponsiveContainer(
                  size: ContainerSize.narrow,
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PinInputView(
                          isEnabled: !isLoading && !isLocked,
                          isError: isError,
                          resetToken: _resetToken,
                          errorController: _errorController,
                          remainingAttempts: attempts > 0
                              ? remainingAttempts
                              : null,
                          onCompleted: (pin) {
                            final codes = pin.split('').map(int.parse).toList();

                            ref
                                .read(pinVerificationProvider.notifier)
                                .verifyPin(codes);
                          },
                        ),

                        if (isLoading) const AppLoader(),

                        if (canShowBiometricButton && !isLocked) ...[
                          const SizedBox(height: 32),
                          IconButton(
                            onPressed: isLoading
                                ? null
                                : () => _triggerBiometricAuthIfAvailable(
                                    isAutoPrompt: false,
                                  ),
                            iconSize: 48,
                            style: IconButton.styleFrom(
                              foregroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              padding: const EdgeInsets.all(12),
                            ),
                            icon: const Icon(Icons.fingerprint_rounded),
                            tooltip: 'Odblokuj biometrią',
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),

              if (isLocked) const LockoutOverlay(),
            ],
          );
        },
      ),
    );
  }
}
