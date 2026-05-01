import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class InitialSpinnerScreen extends StatelessWidget {
  const InitialSpinnerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Center(
        child: SpinKitThreeBounce(color: theme.colorScheme.primary, size: 32.0),
      ),
    );
  }
}
