import 'package:flutter/material.dart';
import 'package:obywatel_plus/features/documents/domain/models/document_model.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DocumentDetailsScreen extends StatefulWidget {
  final DocumentModel document;

  const DocumentDetailsScreen({super.key, required this.document});

  @override
  State<DocumentDetailsScreen> createState() => _DocumentDetailsScreenState();
}

class _DocumentDetailsScreenState extends State<DocumentDetailsScreen> {
  bool _sensitiveVisible = false;

  void _verifyAndShow() {
    _showPinDialog();
  }

  void _showPinDialog() {
    final TextEditingController pinController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Weryfikacja dostępu',
          style: TextStyle(color: Colors.white, fontSize: 18),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Wprowadź kod PIN, aby wyświetlić dane wrażliwe.',
              style: TextStyle(color: Colors.grey, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: pinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 4,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                letterSpacing: 16,
              ),
              decoration: InputDecoration(
                counterText: '',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.indigo),
                ),
                filled: true,
                fillColor: Colors.black26,
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Anuluj', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              if (pinController.text == '1234') {
                setState(() {
                  _sensitiveVisible = true;
                });
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Niepoprawny PIN'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
            child: const Text(
              'Zatwierdź',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final doc = widget.document;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(doc.title),
        backgroundColor: const Color(0xFF1E1E2E),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [const Color(0xFF1E1E2E), const Color(0xFF2A2A3E)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: doc.themeColor.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _buildHeader(doc),
                  const SizedBox(height: 24),
                  _buildAvatar(doc),
                  const SizedBox(height: 24),

                  // Dynamiczna lista pól
                  ...doc.fields.map((field) {
                    if (field.isSensitive) {
                      return _buildSensitiveField(field);
                    }
                    return _buildInfoRow(field.icon, field.label, field.value);
                  }),

                  if (doc.expiryDate != null) ...[
                    const SizedBox(height: 16),
                    _buildExpiryBadge(doc.expiryDate!),
                  ],

                  const SizedBox(height: 24),
                  _buildQrCode(doc.qrData),
                ],
              ),
            ),
            // ... stopka
          ],
        ),
      ),
    );
  }

  Widget _buildSensitiveField(DocumentField field) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A3E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                field.label,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                _sensitiveVisible ? field.value : '•••••••••••',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: _sensitiveVisible ? 1 : 4,
                ),
              ),
            ],
          ),
          if (!_sensitiveVisible)
            IconButton(
              onPressed: _verifyAndShow,
              icon: const Icon(Icons.visibility_off, color: Colors.indigo),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(DocumentModel doc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: doc.themeColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: doc.themeColor.withValues(alpha: 0.5)),
          ),
          child: Row(
            children: [
              Icon(Icons.verified_user, size: 16, color: doc.themeColor),
              const SizedBox(width: 6),
              const Text(
                'DOKUMENT WAŻNY',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
        const Icon(Icons.more_vert, color: Colors.grey),
      ],
    );
  }

  Widget _buildAvatar(DocumentModel doc) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: doc.themeColor.withValues(alpha: 0.5),
              width: 2,
            ),
          ),
          child: const CircleAvatar(
            radius: 50,
            backgroundColor: Color(0xFF2A2A3E),
            child: Icon(Icons.person, size: 50, color: Colors.white24),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: doc.themeColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 8,
                ),
              ],
            ),
            child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: Colors.grey),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExpiryBadge(String date) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.event_available, size: 18, color: Colors.orange),
          const SizedBox(width: 8),
          Text(
            'Wygasa: $date',
            style: const TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrCode(String data) {
    return Column(
      children: [
        const Divider(color: Colors.white10, height: 40),
        const Text(
          'KOD QR DO WERYFIKACJI',
          style: TextStyle(color: Colors.grey, fontSize: 10, letterSpacing: 2),
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
          ),
        ),
      ],
    );
  }
}
