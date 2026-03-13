import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/widgets/grid_painter.dart';
import 'package:obywatel_plus/core/design/widgets/responsive_content_wrapper.dart';
import 'package:obywatel_plus/core/security/pin/pin_attempt_limiter.dart';
import 'package:obywatel_plus/core/security/pin/pin_verification_notifier.dart';
import 'package:obywatel_plus/core/security/pin/pin_verification_state.dart';
import 'package:obywatel_plus/core/security/pin/presentation/widget/lockout_overlay.dart';
import 'package:obywatel_plus/core/security/pin/presentation/widget/pin_input_view.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinVerificationScreen extends ConsumerStatefulWidget {
  const PinVerificationScreen({super.key});

  @override
  ConsumerState<PinVerificationScreen> createState() => _PinScreenState();
}

class _PinScreenState extends ConsumerState<PinVerificationScreen> {
  late StreamController<ErrorAnimationType> _errorController;
  int _resetToken = 0;

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
  }

  @override
  void dispose() {
    _errorController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final limiterAsync = ref.watch(pinAttemptLimiterProvider);

    final isLockedUI = ref.watch(
      pinVerificationProvider.select(
        (s) => s.maybeWhen(locked: (_) => true, orElse: () => false),
      ),
    );

    return limiterAsync.when(
      loading: () => const CyberBackground(
        showCorners: false,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => CyberBackground(
        child: Center(
          child: Text(
            "Błąd: $err",
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
      data: (limiter) {
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

        return CyberBackground(
          showCorners: true,
          child: Stack(
            children: [
              SafeArea(
                child: ResponsiveContainer(
                  size: ContainerSize.narrow,
                  alignment: Alignment.center,
                  child: AbsorbPointer(
                    absorbing: isLocked,
                    child: Opacity(
                      opacity: isLocked ? 0.3 : 1.0,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: PinInputView(
                          isLoading: isLoading,
                          isError: isError,
                          resetToken: _resetToken,
                          errorController: _errorController,
                          onCompleted: (pin) {
                            final codes = pin
                                .split('')
                                .map((e) => int.parse(e))
                                .toList();
                            ref
                                .read(pinVerificationProvider.notifier)
                                .verifyPin(codes);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (isLocked) const LockoutOverlay(),
            ],
          ),
        );
      },
    );
  }
}
