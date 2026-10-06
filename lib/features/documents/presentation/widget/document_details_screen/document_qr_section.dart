import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/theme/theme_extensions.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DocumentQrSection extends StatelessWidget {
  final String data;

  const DocumentQrSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Column(
      children: [
        Divider(color: colorScheme.outlineVariant, height: 40),
        Text(
          'KOD QR DO WERYFIKACJI',
          style: TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontSize: 10,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: QrImageView(
            data: data,
            version: QrVersions.auto,
            size: 140.0,
            gapless: false,
            eyeStyle: QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: colorScheme.onSurface,
            ),
            dataModuleStyle: QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
