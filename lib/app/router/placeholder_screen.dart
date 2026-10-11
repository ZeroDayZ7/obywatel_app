import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/theme/theme_extensions.dart';
import 'package:obywatel_plus/core/design/widgets/main/app_bar.dart';
import 'package:obywatel_plus/core/design/widgets/main/app_scaffold.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return AppScaffold(
      appBar: AppAppBar(
        title: title,
      ),

      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0),
          child: Text(
            '$title - w budowie',
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.8),
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
