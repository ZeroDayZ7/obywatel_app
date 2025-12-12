import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/config/env.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Static background
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF0a0e27),
                  Color(0xFF1a1a2e),
                  Color(0xFF16213e),
                  Color(0xFF0a0e27),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.0, 0.3, 0.7, 1.0],
              ),
            ),
          ),

          // Grid pattern overlay
          CustomPaint(
            size: Size(size.width, size.height),
            painter: CyberGridPainter(),
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Static logo
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer ring
                    Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF00f0ff).withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                    ),

                    // Middle ring
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFff00ff).withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                    ),

                    // Icon container
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const RadialGradient(
                          colors: [Color(0xFF00f0ff), Colors.transparent],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF00f0ff,
                            ).withValues(alpha: 0.4),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                          BoxShadow(
                            color: const Color(
                              0xFFff00ff,
                            ).withValues(alpha: 0.4),
                            blurRadius: 40,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      child: Center(
                        child: ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [
                              Color(0xFF00f0ff),
                              Color(0xFFff00ff),
                              Color(0xFF00f0ff),
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
                ),

                const SizedBox(height: 60),

                // App name
                Column(
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
                            Shadow(color: Color(0xFF00f0ff), blurRadius: 20),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    // Static underline
                    Container(
                      width: 200,
                      height: 2,
                      margin: const EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Colors.transparent,
                            Color(0xFF00f0ff),
                            Color(0xFFff00ff),
                            Colors.transparent,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF00f0ff,
                            ).withValues(alpha: 0.5),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Description
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    apiConstants.appDescription.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 14,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w600,
                      color: Colors
                          .white54, // Zamieniono withValues(alpha: 0.6) na Colors.white54
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 50),

                // Static loading indicator
                Column(
                  children: [
                    const SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF00f0ff),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      LocaleKeys.system_initialization,
                      style: TextStyle(
                        fontSize: 11,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF00f0ff),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Version info
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shield_outlined,
                  size: 14,
                  color: Colors
                      .white30, // Zamieniono withValues(alpha: 0.3) na Colors.white30
                ),
                const SizedBox(width: 8),
                const Text(
                  "SECURE CONNECTION v1.0.0",
                  style: TextStyle(
                    color: Colors
                        .white30, // Zamieniono withValues(alpha: 0.3) na Colors.white30
                    fontSize: 10,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCornerDecoration(bool isTop, bool isLeft) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        border: Border(
          top: isTop
              ? const BorderSide(color: Color(0xFF00f0ff), width: 2)
              : BorderSide.none,
          bottom: !isTop
              ? const BorderSide(color: Color(0xFF00f0ff), width: 2)
              : BorderSide.none,
          left: isLeft
              ? const BorderSide(color: Color(0xFF00f0ff), width: 2)
              : BorderSide.none,
          right: !isLeft
              ? const BorderSide(color: Color(0xFF00f0ff), width: 2)
              : BorderSide.none,
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
