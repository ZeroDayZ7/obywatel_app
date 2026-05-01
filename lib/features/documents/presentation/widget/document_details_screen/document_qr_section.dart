import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DocumentQrSection extends StatelessWidget {
  final String data;

  const DocumentQrSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(color: Colors.white10, height: 40),
        const Text(
          'KOD QR DO WERYFIKACJI',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 10,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: QrImageView(
            data: data,
            version: QrVersions.auto,
            size: 140.0,
            gapless: false,
            eyeStyle: const QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: Colors.black,
            ),
            dataModuleStyle: const QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
