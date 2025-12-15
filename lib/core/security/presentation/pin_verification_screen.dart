import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:obywatel_plus/core/core_providers.dart';
import 'package:obywatel_plus/core/utils/duration_utils.dart';
import '../../../app/theme/app_colors.dart';

class PinVerificationScreen extends ConsumerStatefulWidget {
  const PinVerificationScreen({super.key});

  @override
  ConsumerState<PinVerificationScreen> createState() => _PinScreenState();
}

class _PinScreenState extends ConsumerState<PinVerificationScreen> {
  late StreamController<ErrorAnimationType> _errorController;

  // Zmiana tego pola wymusi przebudowanie PinCodeTextField (czyści wpis)
  int _resetToken = 0;

  @override
  void initState() {
    super.initState();
    _errorController = StreamController<ErrorAnimationType>();

    // Nasłuch stanu PIN (Riverpod). Gdy pojawi się błąd -> resetujemy pole.
    ref.listenManual<PinVerificationState>(pinVerificationProvider, (
      previous,
      next,
    ) {
      if (!mounted) return;

      if (next.lockRemaining != null) {
        final lockText = formatDuration(next.lockRemaining!);
        _showMessage(
          tr(
            LocaleKeys.pinVerification_errors_too_many_attempts,
            namedArgs: {'time': lockText},
          ),
        );

        HapticFeedback.mediumImpact();
      } else if (next.isError) {
        _showMessage(
          tr(LocaleKeys.pinVerification_errors_invalid_pin),
          isError: true,
        );

        HapticFeedback.vibrate();
        _errorController.add(ErrorAnimationType.shake);
        setState(() {
          _resetToken++; // reset pola i autofocus
        });
      } else if (next.isSuccess) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            ref.read(securityServiceProvider.notifier).confirmUnlock();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _errorController.close();
    super.dispose();
  }

  void _showMessage(String text, {bool isError = false}) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        backgroundColor: isError ? AppColors.error : Colors.blueAccent,
        content: Text(text, style: const TextStyle(color: Colors.white)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _verifyPin(String pin) {
    final state = ref.read(pinVerificationProvider);
    if (!state.isLoading) {
      ref.read(pinVerificationProvider.notifier).verifyPin(ref: ref, pin: pin);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pinVerificationProvider);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        // Stałe, proste tło bez animacji
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0a0e27), Color(0xFF1a1a2e), Color(0xFF16213e)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Statyczna siatka (bez animacji)
            CustomPaint(
              size: Size(size.width, size.height),
              painter: CyberGridPainter(),
            ),

            // Brak scan line, brak corner decorations, brak glowing logo
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Proste logo bez glow
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

                      // Tytuł bez glitch (zwykły kolor)
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

                      // Pole PIN – styl cyberpunk, ale bez dodatkowych animacji
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
                            inactiveColor: state.isError
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
                          animationDuration: const Duration(milliseconds: 300),
                          enableActiveFill: true,
                          onCompleted: (value) {
                            _verifyPin(value);
                          },
                          onChanged: (_) {},
                        ),
                      ),

                      const SizedBox(height: 50),

                      // Przycisk odblokowania – prosty, bez animowanego glow
                      ElevatedButton(
                        onPressed: state.isLoading
                            ? null
                            : () {
                                // onCompleted w PinCodeTextField już wywołuje weryfikację
                              },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 60),
                          backgroundColor: state.isLoading
                              ? Colors.grey
                              : const Color(0xFF00f0ff),
                          foregroundColor: const Color(0xFF0a0e27),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: state.isLoading
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
                                  Icon(Icons.lock_open, size: 24),
                                  SizedBox(width: 12),
                                  Text(
                                    LocaleKeys.pinVerification_unlock_button
                                        .tr(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                      ),

                      const SizedBox(height: 30),

                      // Info o szyfrowaniu
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
                            LocaleKeys.pinVerification_secure_connection.tr(),
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
          ],
        ),
      ),
    );
  }
}



class CyberGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00f0ff).withValues(alpha: 0.05)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const gridSize = 40.0;

    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
