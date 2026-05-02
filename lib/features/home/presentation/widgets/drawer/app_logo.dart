import 'package:flutter/material.dart';
import 'package:obywatel_plus/core/design/tokens/border_radius.dart';

class AppLogo extends StatelessWidget {
  final double? width;
  final double? height;
  final bool useClip;

  const AppLogo({
    super.key,
    this.width = 180,
    this.height = 130,
    this.useClip = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget image = Image.asset(
      'assets/images/logo.png',
      width: width,
      height: height,
      fit: BoxFit.contain,
    );

    if (!useClip) return image;

    return ClipRRect(borderRadius: AppRadius.radiusLg, child: image);
  }
}
