import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/bootstrap/presentation/widgets/animated_logo.dart';
import 'package:obywatel_plus/app/bootstrap/presentation/widgets/app_name_section.dart';
import 'package:obywatel_plus/app/bootstrap/presentation/widgets/loading_section.dart';
import 'package:obywatel_plus/app/bootstrap/presentation/widgets/version_info.dart';
import 'package:obywatel_plus/core/design/widgets/grid_painter.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CyberBackground(
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedLogo(),
                SizedBox(height: 60),
                AppNameSection(),
                SizedBox(height: 50),
                LoadingSection(),
              ],
            ),
          ),

          Positioned(bottom: 30, left: 0, right: 0, child: VersionInfo()),
        ],
      ),
    );
  }
}
