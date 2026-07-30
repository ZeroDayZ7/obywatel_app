import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/features/contacts/application/contacts_service.dart';
import 'package:obywatel_plus/features/contacts/presentation/widgets/contacts_screen/qr_scanner_screen.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AddContactModal extends ConsumerStatefulWidget {
  const AddContactModal({super.key});

  @override
  ConsumerState<AddContactModal> createState() => _AddContactModalState();
}

enum _AddContactTab { sendRequest, myQr }

class _AddContactModalState extends ConsumerState<AddContactModal> {
  _AddContactTab _selectedTab = _AddContactTab.sendRequest;
  final _controller = TextEditingController();
  bool _isLoading = false;

  // Sprawdzanie platformy (Android / iOS)
  bool get _isMobilePlatform =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  // Podmień na ID zalogowanego użytkownika (np. z authProvider)
  final String _myUserId = '707a8869-6867-4601-9337-e23fcb51b0ad';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submitRequest(String userId) async {
    final trimmed = userId.trim();
    if (trimmed.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(contactsServiceProvider).addContact(trimmed);
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Zaproszenie wysłane pomyślnie!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Błąd dodawania kontaktów: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _openQrScanner() async {
    final scannedCode = await Navigator.of(
      context,
    ).push<String>(MaterialPageRoute(builder: (_) => const QrScannerScreen()));

    if (scannedCode != null && scannedCode.isNotEmpty) {
      _controller.text = scannedCode;
      _submitRequest(scannedCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: colorScheme.surface,
      surfaceTintColor: colorScheme.surfaceTint,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Nagłówek z przyciskiem zamknięcia
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Dodaj kontakt',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Przełącznik Zakładek (SegmentedButton)
              SegmentedButton<_AddContactTab>(
                segments: const [
                  ButtonSegment<_AddContactTab>(
                    value: _AddContactTab.sendRequest,
                    label: Text('Wyślij ID'),
                    icon: Icon(Icons.person_add_alt_1),
                  ),
                  ButtonSegment<_AddContactTab>(
                    value: _AddContactTab.myQr,
                    label: Text('Mój Kod QR'),
                    icon: Icon(Icons.qr_code),
                  ),
                ],
                selected: {_selectedTab},
                onSelectionChanged: (newSelection) {
                  setState(() => _selectedTab = newSelection.first);
                },
              ),
              const SizedBox(height: 20),

              // Treść w zależności od wybranej zakładki
              if (_selectedTab == _AddContactTab.sendRequest) ...[
                TextField(
                  controller: _controller,
                  enabled: !_isLoading,
                  decoration: InputDecoration(
                    labelText: 'ID / Nick użytkownika',
                    hintText: 'Wpisz identyfikator...',
                    prefixIcon: const Icon(Icons.person_search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _isLoading
                      ? null
                      : () => _submitRequest(_controller.text),
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send),
                  label: const Text('Wyślij zaproszenie'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: (_isLoading || !_isMobilePlatform)
                      ? null
                      : _openQrScanner,
                  icon: const Icon(Icons.qr_code_scanner),
                  label: Text(
                    _isMobilePlatform
                        ? 'Zeskanuj kod QR aparatem'
                        : 'Skaner niedostępny na Windows',
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ] else ...[
                Text(
                  'Zeskanuj ten kod na drugim urządzeniu, aby szybko nawiązać kontakt.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: QrImageView(
                      data: _myUserId,
                      version: QrVersions.auto,
                      size: 180.0,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: _myUserId));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Skopiowano Twoje ID do schowka!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.copy, size: 18),
                  label: Text('Kopiuj moje ID'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
