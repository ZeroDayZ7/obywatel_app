import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';

class AppLoader extends StatelessWidget {
  final bool withLabel;

  const AppLoader({super.key, this.withLabel = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = theme.colorScheme.primary;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SpinKitThreeBounce(color: accentColor, size: 24.0),

          if (withLabel) ...[
            const SizedBox(height: 24),
            Text(
              LocaleKeys.system_initialization.tr().toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 2,
                fontWeight: FontWeight.w700,
                color: accentColor.withValues(alpha: 0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
