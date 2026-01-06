import 'package:flutter/material.dart';

class CyberGridPainter extends CustomPainter {
  // Dodajemy const konstruktor, aby umożliwić optymalizację
  const CyberGridPainter();

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

class CyberBackground extends StatelessWidget {
  final Widget child;
  final bool showCorners;

  const CyberBackground({
    super.key,
    required this.child,
    this.showCorners = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // 1. Warstwa gradientu
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0a0e27), Color(0xFF1a1a2e)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          // 2. Warstwa siatki - TUTAJ USUNIĘTO 'const' spod Positioned.fill
          Positioned.fill(
            child: RepaintBoundary(
              child: CustomPaint(painter: const CyberGridPainter()),
            ),
          ),
          // 3. Narożniki
          if (showCorners) ...[
            const Positioned(
              top: 40,
              left: 20,
              child: _Corner(isTop: true, isLeft: true),
            ),
            const Positioned(
              top: 40,
              right: 20,
              child: _Corner(isTop: true, isLeft: false),
            ),
            const Positioned(
              bottom: 40,
              left: 20,
              child: _Corner(isTop: false, isLeft: true),
            ),
            const Positioned(
              bottom: 40,
              right: 20,
              child: _Corner(isTop: false, isLeft: false),
            ),
          ],
          // 4. Treść właściwa
          child,
        ],
      ),
    );
  }
}

class _Corner extends StatelessWidget {
  final bool isTop;
  final bool isLeft;

  // Dodano const tutaj dla lepszej wydajności
  const _Corner({required this.isTop, required this.isLeft});

  @override
  Widget build(BuildContext context) {
    const color = Color(0xFF00f0ff);
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        border: Border(
          top: isTop
              ? const BorderSide(color: color, width: 2)
              : BorderSide.none,
          bottom: !isTop
              ? const BorderSide(color: color, width: 2)
              : BorderSide.none,
          left: isLeft
              ? const BorderSide(color: color, width: 2)
              : BorderSide.none,
          right: !isLeft
              ? const BorderSide(color: color, width: 2)
              : BorderSide.none,
        ),
      ),
    );
  }
}
