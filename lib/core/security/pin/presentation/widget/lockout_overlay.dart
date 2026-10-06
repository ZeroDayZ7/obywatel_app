import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/app/theme/extensions/status_colors_theme.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart'; // Import Twojego enuma
import 'package:obywatel_plus/core/design/widgets/main/responsive_content_wrapper.dart'; // Import Twojego ResponsiveContainer
import 'package:obywatel_plus/core/security/pin/presentation/widget/lock_timer_text.dart';

class LockoutOverlay extends StatelessWidget {
  const LockoutOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColors = theme.extension<StatusColorsTheme>() ??
        StatusColorsTheme.fromColorScheme(theme.colorScheme);

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: theme.colorScheme.surface.withValues(alpha: 0.92),
      child: ResponsiveContainer(
        size: ContainerSize.narrow,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.timer_off_outlined,
              color: theme.colorScheme.error,
              size: 80,
            ),
            const SizedBox(height: 32),
            Text(
              LocaleKeys.pinVerification_system_locked.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: LockReasonText(),
            ),
            const SizedBox(height: 48),
            const LockTimerText(),
            const SizedBox(height: 32),
            SizedBox(
              width: 180,
              child: LinearProgressIndicator(
                backgroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.12),
                color: statusColors.info,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
