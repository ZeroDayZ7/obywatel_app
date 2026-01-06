import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/bootstrap/presentation/widgets/animated_logo.dart';
import 'package:obywatel_plus/app/bootstrap/presentation/widgets/app_name_section.dart';
import 'package:obywatel_plus/app/bootstrap/presentation/widgets/loading_section.dart';
import 'package:obywatel_plus/app/bootstrap/presentation/widgets/version_info.dart';
import 'package:obywatel_plus/core/design/widgets/grid_painter.dart'; // Upewnij się, że tu jest CyberBackground

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CyberBackground(
      // showCorners jest domyślnie true w CyberBackground,
      // więc narożniki narysują się same.
      child: Stack(
        children: [
          // Główna treść na środku
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
          // Informacja o wersji na dole
          Positioned(bottom: 30, left: 0, right: 0, child: VersionInfo()),
        ],
      ),
    );
  }
}
