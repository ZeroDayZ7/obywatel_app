import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/theme/theme_extensions.dart';
import 'package:obywatel_plus/features/auth/application/session/session_service.dart';
import 'package:obywatel_plus/features/communication/application/contact_invite_error_mapper.dart';
import 'package:obywatel_plus/features/communication/application/contacts_service.dart';
import 'package:obywatel_plus/features/communication/domain/contacts/contact_identifier.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/contacts_screen/qr_scanner_screen.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AddContactModal extends ConsumerStatefulWidget {
  const AddContactModal({super.key});

  @override
  ConsumerState<AddContactModal> createState() => _AddContactModalState();
}

enum _AddContactTab { sendRequest, myQr }

class _AddContactModalState extends ConsumerState<AddContactModal> {
  _AddContactTab _selectedTab = _AddContactTab.sendRequest;
  final _controller = TextEditingController(
    text: 'a2f6b8c9-1122-4a55-8822-b98765432101',
  );
  bool _isLoading = false;
  String _myUserId = '';
  String? _inlineError;

  bool get _isMobilePlatform =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  @override
  void initState() {
    super.initState();
    _loadCurrentUserId();
  }

  Future<void> _loadCurrentUserId() async {
    final cachedUser = await ref.read(sessionServiceProvider).getCachedUser();
    if (!mounted) return;

    setState(() {
      _myUserId = cachedUser?.id ?? '';
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showFormError(String message) {
    if (!mounted) return;
    setState(() => _inlineError = message);
  }

  Widget _buildErrorBox(BuildContext context, String message) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: double.infinity,
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.error.withValues(alpha: 0.45),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 20,
            color: colorScheme.onErrorContainer,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onErrorContainer,
                height: 1.4,
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitRequest(String userId) async {
    final trimmed = userId.trim();
    if (trimmed.isEmpty) return;

    late final ContactIdentifier identifier;
    try {
      identifier = ContactIdentifier.parse(trimmed);
    } on FormatException {
      _showFormError('Sprawdź identyfikator użytkownika.');
      return;
    }

    setState(() {
      _inlineError = null;
      _isLoading = true;
    });

    try {
      await ref.read(contactsServiceProvider).addContact(identifier.normalized);
      if (mounted) {
        final statusColors = context.statusColors;
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Zaproszenie wysłane pomyślnie!'),
            backgroundColor: statusColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (error) {
      _showFormError(mapContactInviteError(error));
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
    final maxHeight = MediaQuery.of(context).size.height * 0.85;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      backgroundColor: colorScheme.surface,
      surfaceTintColor: colorScheme.surfaceTint,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: maxHeight),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Nagłówek
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Dodaj kontakt',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.of(context).pop(),
                          style: IconButton.styleFrom(
                            backgroundColor: colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Przełącznik zakładek
                    SegmentedButton<_AddContactTab>(
                      segments: const [
                        ButtonSegment<_AddContactTab>(
                          value: _AddContactTab.sendRequest,
                          label: Text('Wyślij ID'),
                          icon: Icon(Icons.person_add_alt_1_rounded, size: 18),
                        ),
                        ButtonSegment<_AddContactTab>(
                          value: _AddContactTab.myQr,
                          label: Text('Mój QR'),
                          icon: Icon(Icons.qr_code_rounded, size: 18),
                        ),
                      ],
                      selected: {_selectedTab},
                      onSelectionChanged: (newSelection) {
                        setState(() => _selectedTab = newSelection.first);
                      },
                    ),
                    const SizedBox(height: 24),

                    // Treść zakładki
                    if (_selectedTab == _AddContactTab.sendRequest) ...[
                      TextField(
                        controller: _controller,
                        enabled: !_isLoading,
                        onChanged: (_) {
                          if (_inlineError != null) {
                            setState(() => _inlineError = null);
                          }
                        },
                        minLines: 1,
                        maxLines: 2,
                        style: theme.textTheme.bodyLarge,
                        decoration: InputDecoration(
                          labelText: 'ID / tag / QR',
                          hintText: 'Wpisz identyfikator UUID...',
                          prefixIcon: const Icon(Icons.person_search_rounded),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          filled: true,
                          fillColor: colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.4),
                        ),
                      ),
                      if (_inlineError != null)
                        _buildErrorBox(context, _inlineError!),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: _isLoading
                            ? null
                            : () => _submitRequest(_controller.text),
                        icon: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.send_rounded),
                        label: const Text('Wyślij zaproszenie'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: (_isLoading || !_isMobilePlatform)
                            ? null
                            : _openQrScanner,
                        icon: const Icon(Icons.qr_code_scanner_rounded),
                        label: Text(
                          _isMobilePlatform
                              ? 'Zeskanuj kod QR aparatem'
                              : 'Skaner niedostępny na Windows',
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ] else ...[
                      Text(
                        'Zeskanuj ten kod na drugim urządzeniu, aby szybko nawiązać kontakt.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (_myUserId.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: colorScheme.primary,
                            ),
                          ),
                        )
                      else ...[
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              // WYMUSZONE BIAŁE TŁO DLA KODU QR, ABY BYŁ ZAWSZE CZYTELNY
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: colorScheme.shadow.withValues(
                                    alpha: 0.08,
                                  ),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: QrImageView(
                              data: _myUserId,
                              version: QrVersions.auto,
                              size: 190.0,
                              // Jawne ustawienie koloru elementów QR na smolistą czerń dla idealnego kontrastu
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
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: FilledButton.tonalIcon(
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: _myUserId));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Skopiowano Twoje ID do schowka!',
                                  ),
                                  duration: Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            icon: const Icon(Icons.copy_rounded, size: 18),
                            label: const Text('Kopiuj moje ID'),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
