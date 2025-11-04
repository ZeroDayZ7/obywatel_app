import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/config/env.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late AnimationController _scanLineController;
  late AnimationController _fadeController;
  late AnimationController _particleController;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _scanLineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    _scanLineController.dispose();
    _fadeController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Animated background
          AnimatedBuilder(
            animation: _rotationController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: const [
                      Color(0xFF0a0e27),
                      Color(0xFF1a1a2e),
                      Color(0xFF16213e),
                      Color(0xFF0a0e27),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [
                      0.0,
                      0.3 +
                          math.sin(_rotationController.value * 2 * math.pi) *
                              0.1,
                      0.7 +
                          math.cos(_rotationController.value * 2 * math.pi) *
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

          // Animated particles
          AnimatedBuilder(
            animation: _particleController,
            builder: (context, child) {
              return CustomPaint(
                size: Size(size.width, size.height),
                painter: ParticlePainter(_particleController.value),
              );
            },
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
                        const Color(0xFF00f0ff).withValues(alpha: 0.6),
                        Colors.transparent,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00f0ff).withValues(alpha: 0.4),
                        blurRadius: 15,
                        spreadRadius: 3,
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
          Center(
            child: FadeTransition(
              opacity: _fadeController,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animated logo with glow effect
                  AnimatedBuilder(
                    animation: Listenable.merge([
                      _pulseController,
                      _rotationController,
                    ]),
                    builder: (context, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outer rotating ring
                          Transform.rotate(
                            angle: _rotationController.value * 2 * math.pi,
                            child: Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(
                                    0xFF00f0ff,
                                  ).withValues(alpha: 0.3),
                                  width: 2,
                                ),
                              ),
                            ),
                          ),

                          // Middle ring
                          Transform.rotate(
                            angle: -_rotationController.value * 1.5 * math.pi,
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(
                                    0xFFff00ff,
                                  ).withValues(alpha: 0.3),
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),

                          // Glowing icon container
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  const Color(
                                    0xFF00f0ff,
                                  ).withValues(alpha: 0.2),
                                  Colors.transparent,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF00f0ff).withValues(
                                    alpha: 0.4 + _pulseController.value * 0.3,
                                  ),
                                  blurRadius: 30 + _pulseController.value * 20,
                                  spreadRadius: 5 + _pulseController.value * 5,
                                ),
                                BoxShadow(
                                  color: const Color(0xFFff00ff).withValues(
                                    alpha: 0.3 + _pulseController.value * 0.2,
                                  ),
                                  blurRadius: 40 + _pulseController.value * 15,
                                  spreadRadius: 3 + _pulseController.value * 3,
                                ),
                              ],
                            ),
                            child: Center(
                              child: ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  colors: const [
                                    Color(0xFF00f0ff),
                                    Color(0xFFff00ff),
                                    Color(0xFF00f0ff),
                                  ],
                                  stops: [
                                    0.0,
                                    0.5 +
                                        math.sin(
                                              _rotationController.value *
                                                  4 *
                                                  math.pi,
                                            ) *
                                            0.3,
                                    1.0,
                                  ],
                                ).createShader(bounds),
                                child: const Icon(
                                  Icons.account_circle,
                                  size: 80,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 60),

                  // App name with glitch effect
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Column(
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [
                                Color(0xFF00f0ff),
                                Color(0xFFff00ff),
                                Color(0xFF00f0ff),
                              ],
                            ).createShader(bounds),
                            child: Text(
                              apiConstants.appName.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 4,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Color(0xFF00f0ff),
                                    blurRadius: 20,
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          // Animated underline
                          SizedBox(
                            width: 200,
                            child: AnimatedBuilder(
                              animation: _pulseController,
                              builder: (context, child) {
                                return Container(
                                  height: 2,
                                  margin: const EdgeInsets.only(top: 10),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        const Color(0xFF00f0ff).withValues(
                                          alpha:
                                              0.5 +
                                              _pulseController.value * 0.5,
                                        ),
                                        const Color(0xFFff00ff).withValues(
                                          alpha:
                                              0.5 +
                                              _pulseController.value * 0.5,
                                        ),
                                        Colors.transparent,
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF00f0ff)
                                            .withValues(
                                              alpha:
                                                  0.5 +
                                                  _pulseController.value * 0.3,
                                            ),
                                        blurRadius: 10,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 30),

                  // Description
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      apiConstants.appDescription.toUpperCase(),
                      style: TextStyle(
                        fontSize: 14,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 50),

                  // Loading indicator
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Column(
                        children: [
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                const Color(0xFF00f0ff).withValues(
                                  alpha: 0.5 + _pulseController.value * 0.5,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "INICJALIZACJA SYSTEMU",
                            style: TextStyle(
                              fontSize: 11,
                              letterSpacing: 2,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF00f0ff).withValues(
                                alpha: 0.4 + _pulseController.value * 0.4,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Version info
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeController,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shield_outlined,
                    size: 14,
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "SECURE CONNECTION v1.0.0",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.3),
                      fontSize: 10,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCornerDecoration(bool isTop, bool isLeft) {
    return AnimatedBuilder(
      animation: _pulseController,
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
                      ).withValues(alpha: 0.3 + _pulseController.value * 0.2),
                      width: 2,
                    )
                  : BorderSide.none,
              bottom: !isTop
                  ? BorderSide(
                      color: const Color(
                        0xFF00f0ff,
                      ).withValues(alpha: 0.3 + _pulseController.value * 0.2),
                      width: 2,
                    )
                  : BorderSide.none,
              left: isLeft
                  ? BorderSide(
                      color: const Color(
                        0xFF00f0ff,
                      ).withValues(alpha: 0.3 + _pulseController.value * 0.2),
                      width: 2,
                    )
                  : BorderSide.none,
              right: !isLeft
                  ? BorderSide(
                      color: const Color(
                        0xFF00f0ff,
                      ).withValues(alpha: 0.3 + _pulseController.value * 0.2),
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

class ParticlePainter extends CustomPainter {
  final double animationValue;

  ParticlePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    final random = math.Random(42);

    for (int i = 0; i < 30; i++) {
      final x = random.nextDouble() * size.width;
      final baseY = random.nextDouble() * size.height;
      final y = (baseY + (animationValue * size.height * 0.5)) % size.height;
      final radius = random.nextDouble() * 2 + 1;

      paint.color =
          (i % 2 == 0 ? const Color(0xFF00f0ff) : const Color(0xFFff00ff))
              .withValues(alpha: 0.3 + random.nextDouble() * 0.3);

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}
