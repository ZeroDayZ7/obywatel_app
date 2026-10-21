import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/theme/theme_extensions.dart';
import 'package:obywatel_plus/features/communication/presentation/providers/add_contact_form_provider.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/contacts_screen/add_contact_qr_view.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/contacts_screen/qr_scanner_screen.dart';

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
    await ref.read(addContactFormProvider.notifier).loadCurrentUserId();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
    final succeeded = await ref
        .read(addContactFormProvider.notifier)
        .submit(userId);

    if (!mounted) return;
    if (!succeeded) return;

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

  Future<void> _openQrScanner() async {
    final scannedCode = await Navigator.of(
      context,
    ).push<String>(MaterialPageRoute(builder: (_) => const QrScannerScreen()));

    if (scannedCode != null && scannedCode.isNotEmpty) {
      _controller.text = scannedCode;
      _submitRequest(scannedCode);
    }
  }

  Future<void> _copyMyUserId(String userId) async {
    if (userId.isEmpty) return;

    await Clipboard.setData(ClipboardData(text: userId));
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Skopiowano Twoje ID do schowka!'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final formState = ref.watch(addContactFormProvider);
    final maxHeight = MediaQuery.of(context).size.height * 0.85;
    final isLoading = formState.isSubmitting;
    final inlineError = formState.error;
    final myUserId = formState.currentUserId;

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
                        enabled: !isLoading,
                        onChanged: (_) {
                          ref
                              .read(addContactFormProvider.notifier)
                              .clearError();
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
                      if (inlineError != null)
                        _buildErrorBox(context, inlineError),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: isLoading
                            ? null
                            : () => _submitRequest(_controller.text),
                        icon: isLoading
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
                        onPressed: (isLoading || !_isMobilePlatform)
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
                      AddContactQrView(
                        myUserId: myUserId,
                        onCopy: () => _copyMyUserId(myUserId),
                      ),
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
