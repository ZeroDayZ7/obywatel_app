import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PinLoadingIndicator extends StatelessWidget {
  const PinLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF00f0ff);

    return Column(
      children: const [
        SizedBox(height: 24),
        SpinKitThreeBounce(color: accent, size: 18),
      ],
    );
  }
}
