import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:obywatel_plus/app/config/storage_keys.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../auth/presentation/login_screen.dart';
import '../../../app/theme/app_colors.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({super.key});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> with TickerProviderStateMixin {
  final TextEditingController _pinController = TextEditingController();
  final _storage = const FlutterSecureStorage();
  late StreamController<ErrorAnimationType> _errorController;
  late AnimationController _glowController;
  late AnimationController _scanLineController;
  late AnimationController _backgroundController;

  String _correctPin = '';

  @override
  void initState() {
    super.initState();
    _errorController = StreamController<ErrorAnimationType>();

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scanLineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _loadPin();
  }

  Future<void> _loadPin() async {
    final pin = await _storage.read(key: StorageKeys.pinHash);
    if (!mounted) return;
    setState(() => _correctPin = pin ?? '');
  }

  @override
  void dispose() {
    _errorController.close();
    _pinController.dispose();
    _glowController.dispose();
    _scanLineController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  void _verifyPin() {
    if (_pinController.text == _correctPin && _correctPin.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } else {
      _errorController.add(ErrorAnimationType.shake);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Niepoprawny PIN"),
          backgroundColor: AppColors.error,
        ),
      );
      _pinController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Animated cyberpunk background
          AnimatedBuilder(
            animation: _backgroundController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF0a0e27),
                      const Color(0xFF1a1a2e),
                      const Color(0xFF16213e),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [
                      0.0,
                      0.5 +
                          math.sin(_backgroundController.value * 2 * math.pi) *
                              0.1,
                      1.0,
                    ],
                  ),
                ),
              );
            },
          ),

          // Grid pattern overlay
          CustomPaint(
            size: Size(size.width, size.height),
            painter: CyberGridPainter(),
          ),

          // Scan line effect
          AnimatedBuilder(
            animation: _scanLineController,
            builder: (context, child) {
              return Positioned(
                top: size.height * _scanLineController.value,
                left: 0,
                right: 0,
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        const Color(0xFF00f0ff).withValues(alpha: 0.5),
                        Colors.transparent,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00f0ff).withValues(alpha: 0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Corner decorations
          Positioned(
            top: 40,
            left: 20,
            child: _buildCornerDecoration(true, true),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: _buildCornerDecoration(true, false),
          ),
          Positioned(
            bottom: 40,
            left: 20,
            child: _buildCornerDecoration(false, true),
          ),
          Positioned(
            bottom: 40,
            right: 20,
            child: _buildCornerDecoration(false, false),
          ),

          // Main content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Glowing logo/icon
                    AnimatedBuilder(
                      animation: _glowController,
                      builder: (context, child) {
                        return Container(
                          padding: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(
                                0xFF00f0ff,
                              ).withValues(alpha: 0.5),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF00f0ff).withValues(
                                  alpha: 0.3 + _glowController.value * 0.3,
                                ),
                                blurRadius: 20 + _glowController.value * 20,
                                spreadRadius: 5 + _glowController.value * 5,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.lock_outline,
                            size: 60,
                            color: Color(0xFF00f0ff),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 40),

                    // Title with glitch effect
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFF00f0ff), Color(0xFFff00ff)],
                      ).createShader(bounds),
                      child: const Text(
                        "AUTORYZACJA WYMAGANA",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "WPROWADŹ KOD DOSTĘPU",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 3,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),

                    const SizedBox(height: 50),

                    // PIN input with cyberpunk styling
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF00f0ff).withValues(alpha: 0.3),
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
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF00f0ff,
                            ).withValues(alpha: 0.1),
                            blurRadius: 20,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: PinCodeTextField(
                        appContext: context,
                        length: 4,
                        controller: _pinController,
                        keyboardType: TextInputType.number,
                        animationType: AnimationType.fade,
                        errorAnimationController: _errorController,
                        obscureText: true,
                        obscuringCharacter: '●',
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(12),
                          fieldHeight: 70,
                          fieldWidth: 60,
                          activeColor: const Color(0xFF00f0ff),
                          selectedColor: const Color(0xFFff00ff),
                          inactiveColor: Colors.white.withValues(alpha: 0.2),
                          activeFillColor: Colors.black.withValues(alpha: 0.5),
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
                        onChanged: (_) {},
                      ),
                    ),

                    const SizedBox(height: 50),

                    // Unlock button
                    AnimatedBuilder(
                      animation: _glowController,
                      builder: (context, child) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF00f0ff).withValues(
                                  alpha: 0.2 + _glowController.value * 0.2,
                                ),
                                blurRadius: 15 + _glowController.value * 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: _verifyPin,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 60),
                              backgroundColor: const Color(0xFF00f0ff),
                              foregroundColor: const Color(0xFF0a0e27),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.lock_open, size: 24),
                                SizedBox(width: 12),
                                Text(
                                  "ODBLOKUJ DOSTĘP",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 30),

                    // Cancel button
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                      ),
                      child: Text(
                        "ANULUJ",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                          fontSize: 14,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Security info
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
                          "POŁĄCZENIE ZASZYFROWANE",
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
    );
  }

  Widget _buildCornerDecoration(bool isTop, bool isLeft) {
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        return Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            border: Border(
              top: isTop
                  ? BorderSide(
                      color: const Color(
                        0xFF00f0ff,
                      ).withValues(alpha: 0.3 + _glowController.value * 0.2),
                      width: 2,
                    )
                  : BorderSide.none,
              bottom: !isTop
                  ? BorderSide(
                      color: const Color(
                        0xFF00f0ff,
                      ).withValues(alpha: 0.3 + _glowController.value * 0.2),
                      width: 2,
                    )
                  : BorderSide.none,
              left: isLeft
                  ? BorderSide(
                      color: const Color(
                        0xFF00f0ff,
                      ).withValues(alpha: 0.3 + _glowController.value * 0.2),
                      width: 2,
                    )
                  : BorderSide.none,
              right: !isLeft
                  ? BorderSide(
                      color: const Color(
                        0xFF00f0ff,
                      ).withValues(alpha: 0.3 + _glowController.value * 0.2),
                      width: 2,
                    )
                  : BorderSide.none,
            ),
          ),
        );
      },
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

    // Vertical lines
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Horizontal lines
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
