import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/errors/app_notification.dart';
import 'package:obywatel_plus/core/errors/global_error_provider.dart';
import 'package:obywatel_plus/core/security/pin/pin_verification_notifier.dart';
import 'package:obywatel_plus/core/security/pin/pin_verification_state.dart';
import 'package:obywatel_plus/core/utils/duration_utils.dart';
import 'package:obywatel_plus/core/widgets/grid_painter.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../app/theme/app_colors.dart';

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

    // Listener stanu PIN
    ref.listenManual<PinVerificationState>(pinVerificationProvider, (
      previous,
      next,
    ) {
      if (!mounted) return;

      next.maybeWhen(
        locked: (remaining) {
          final lockText = formatDuration(remaining);
          ref
              .read(globalNotificationProvider.notifier)
              .show(
                LocaleKeys.pinVerification_errors_too_many_attempts,
                type: NotificationType.warning,
                namedArgs: {'time': lockText},
              );
          HapticFeedback.mediumImpact();
        },
        error: () {
          ref
              .read(globalNotificationProvider.notifier)
              .show(
                LocaleKeys.pinVerification_errors_invalid_pin,
                type: NotificationType.error,
              );
          HapticFeedback.vibrate();
          _errorController.add(ErrorAnimationType.shake);
          setState(() {
            _resetToken++;
          });
        },
        success: () {
          debugPrint("PIN poprawny, czekam na redirect routera...");
        },
        orElse: () {},
      );
    });
  }

  @override
  void dispose() {
    _errorController.close();
    super.dispose();
  }

  void _verifyPin(String pin) {
    ref.read(pinVerificationProvider.notifier).verifyPin(pin);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pinVerificationProvider);
    final size = MediaQuery.of(context).size;

    // Sprawdzanie loading/error
    final isLoading = state.maybeWhen(loading: () => true, orElse: () => false);

    final isError = state.maybeWhen(error: () => true, orElse: () => false);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0a0e27), Color(0xFF1a1a2e), Color(0xFF16213e)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            CustomPaint(
              size: Size(size.width, size.height),
              painter: CyberGridPainter(),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(30),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(
                                  0xFF00f0ff,
                                ).withValues(alpha: 0.5),
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.lock_outline,
                              size: 60,
                              color: Color(0xFF00f0ff),
                            ),
                          ),
                          const SizedBox(height: 40),
                          Text(
                            LocaleKeys.pinVerification_title.tr(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            LocaleKeys.pinVerification_subtitle.tr(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 3,
                              color: Colors.white.withValues(alpha: 0.5),
                            ),
                          ),
                          const SizedBox(height: 50),
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(
                                  0xFF00f0ff,
                                ).withValues(alpha: 0.3),
                                width: 1,
                              ),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withValues(alpha: 0.4),
                                  Colors.black.withValues(alpha: 0.2),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: PinCodeTextField(
                              key: ValueKey<int>(_resetToken),
                              appContext: context,
                              length: 4,
                              obscureText: true,
                              obscuringCharacter: '●',
                              keyboardType: TextInputType.number,
                              animationType: AnimationType.fade,
                              errorAnimationController: _errorController,
                              pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(12),
                                fieldHeight: 70,
                                fieldWidth: 60,
                                activeColor: const Color(0xFF00f0ff),
                                selectedColor: const Color(0xFFff00ff),
                                inactiveColor: isError
                                    ? AppColors.error
                                    : Colors.white.withValues(alpha: 0.2),
                                activeFillColor: Colors.black.withValues(
                                  alpha: 0.5,
                                ),
                                selectedFillColor: Colors.black.withValues(
                                  alpha: 0.6,
                                ),
                                inactiveFillColor: Colors.black.withValues(
                                  alpha: 0.3,
                                ),
                                borderWidth: 2,
                              ),
                              textStyle: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF00f0ff),
                              ),
                              animationDuration: const Duration(
                                milliseconds: 300,
                              ),
                              enableActiveFill: true,
                              onCompleted: _verifyPin,
                              onChanged: (_) {},
                            ),
                          ),
                          const SizedBox(height: 50),
                          ElevatedButton(
                            onPressed: isLoading ? null : () {},
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 60),
                              backgroundColor: isLoading
                                  ? Colors.grey
                                  : const Color(0xFF00f0ff),
                              foregroundColor: const Color(0xFF0a0e27),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF0a0e27),
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.lock_open, size: 24),
                                      const SizedBox(width: 12),
                                      Text(
                                        LocaleKeys.pinVerification_unlock_button
                                            .tr(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shield_outlined,
                                size: 16,
                                color: Colors.white.withValues(alpha: 0.3),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                LocaleKeys.pinVerification_secure_connection
                                    .tr(),
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  fontSize: 10,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
