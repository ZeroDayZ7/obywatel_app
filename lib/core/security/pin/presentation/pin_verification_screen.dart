import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      // Obsługa błędu (shake) - używamy maybeWhen zamiast 'is _Error'
      next.maybeWhen(
        error: () {
          HapticFeedback.vibrate();
          _errorController.add(ErrorAnimationType.shake);
          setState(() => _resetToken++);
        },
        orElse: () {},
      );

      // NOWOŚĆ: Czyszczenie po odblokowaniu
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
      loading: () => const Scaffold(
        backgroundColor: Color(0xFF0a0e27),
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => Scaffold(body: Center(child: Text("Błąd: $err"))),
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

        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0a0e27), Color(0xFF1a1a2e)],
              ),
            ),
            child: Stack(
              children: [
                CustomPaint(
                  size: MediaQuery.of(context).size,
                  painter: CyberGridPainter(),
                ),
                SafeArea(
                  child: ResponsiveContentWrapper(
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
                            onCompleted: (pin) => ref
                                .read(pinVerificationProvider.notifier)
                                .verifyPin(pin),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (isLocked) const LockoutOverlay(),
              ],
            ),
          ),
        );
      },
    );
  }
}
