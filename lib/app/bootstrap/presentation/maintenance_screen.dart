import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/config/generated/assets.gen.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';

class MaintenanceScreen extends StatelessWidget {
  final String? message;
  final DateTime? endTime;

  const MaintenanceScreen({super.key, this.message, this.endTime});

  @override
  Widget build(BuildContext context) {
    final String? formattedTime = endTime != null
        ? DateFormat('HH:mm').format(endTime!)
        : null;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 32),
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [Colors.blueGrey.withValues(alpha: 0.15), Colors.black],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.images.logo.image(
              height: 80,
              color: Colors.blueAccent.withValues(alpha: 0.8),
            ),

            const SizedBox(height: 48),

            Text(
              LocaleKeys.maintenance_title.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              message ?? LocaleKeys.maintenance_default_msg.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 16,
                height: 1.5,
              ),
            ),

            if (formattedTime != null) ...[
              const SizedBox(height: 32),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.blueAccent.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      LocaleKeys.maintenance_eta.tr(),
                      style: TextStyle(
                        color: Colors.blueAccent.withValues(alpha: 0.7),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formattedTime,
                      style: const TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 64),

            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.refresh, size: 20),
              label: Text(LocaleKeys.maintenance_retry.tr()),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
