import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:obywatel_plus/app/theme/theme_extensions.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final MobileScannerController _controller = MobileScannerController();
  bool _isScanned = false;
  bool _isTorchToggling = false;
  String? _lastScanErrorMessage;
  DateTime? _lastScanErrorAt;
  String? _lastCameraInitErrorMessage;
  DateTime? _lastCameraInitErrorAt;

  bool _shouldReportError({
    required bool isScanError,
    required String message,
  }) {
    final lastMessage = isScanError
        ? _lastScanErrorMessage
        : _lastCameraInitErrorMessage;
    final lastAt = isScanError ? _lastScanErrorAt : _lastCameraInitErrorAt;
    final now = DateTime.now();

    if (lastMessage == message && lastAt != null) {
      final elapsed = now.difference(lastAt);
      if (elapsed < const Duration(seconds: 6)) {
        return false;
      }
    }

    if (isScanError) {
      _lastScanErrorMessage = message;
      _lastScanErrorAt = now;
    } else {
      _lastCameraInitErrorMessage = message;
      _lastCameraInitErrorAt = now;
    }
    return true;
  }

  void _resetErrorTracking() {
    _lastScanErrorMessage = null;
    _lastScanErrorAt = null;
    _lastCameraInitErrorMessage = null;
    _lastCameraInitErrorAt = null;
  }

  void _showUserMessage(String message) {
    if (!mounted) {
      return;
    }

    final colorScheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _retryScannerStart() async {
    if (!mounted) {
      return;
    }

    try {
      if (_controller.value.isRunning) {
        await _controller.stop();
      }
      await _controller.start();
      _resetErrorTracking();
    } on MobileScannerException catch (error) {
      if (!mounted) {
        return;
      }

      final message = error.errorCode == MobileScannerErrorCode.permissionDenied
          ? 'Brak dostępu do kamery. Włącz dostęp do kamery w ustawieniach urządzenia i spróbuj ponownie.'
          : 'Nie udało się uruchomić kamery. Spróbuj ponownie.';

      if (_shouldReportError(isScanError: false, message: message)) {
        _showUserMessage(message);
      }
    } on Object catch (_) {
      if (!mounted) {
        return;
      }
      const message = 'Nie udało się uruchomić kamery. Spróbuj ponownie.';
      if (_shouldReportError(isScanError: false, message: message)) {
        _showUserMessage(message);
      }
    }
  }

  Future<void> _handleTorchToggle() async {
    if (!mounted || _isTorchToggling) {
      return;
    }

    final state = _controller.value;
    if (!state.isRunning || state.torchState == TorchState.unavailable) {
      return;
    }

    if (!mounted) {
      return;
    }
    setState(() {
      _isTorchToggling = true;
    });

    try {
      await _controller.toggleTorch();
    } on Object catch (_) {
      if (!mounted) {
        return;
      }
      _showUserMessage('Nie udało się zmienić stanu latarki.');
    } finally {
      if (mounted) {
        setState(() {
          _isTorchToggling = false;
        });
      }
    }
  }

  void _handleSuccessfulScan(String code) {
    if (!mounted || _isScanned) {
      return;
    }

    _isScanned = true;
    _resetErrorTracking();
    if (mounted) {
      Navigator.of(context).pop(code);
    }
  }

  @override
  void dispose() {
    _isTorchToggling = false;
    _resetErrorTracking();
    try {
      _controller.dispose();
    } on Object catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'QrScannerScreen',
          context: ErrorDescription('during QR scanner disposal'),
        ),
      );
    }
    super.dispose();
  }

  Widget _buildCameraError(BuildContext context, MobileScannerException error) {
    final colorScheme = Theme.of(context).colorScheme;
    final isPermissionDenied =
        error.errorCode == MobileScannerErrorCode.permissionDenied;
    final message = isPermissionDenied
        ? 'Brak dostępu do kamery. Włącz dostęp do kamery w ustawieniach urządzenia i spróbuj ponownie.'
        : 'Nie udało się uruchomić kamery. Spróbuj ponownie.';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Card(
          color: colorScheme.surfaceContainerHighest,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isPermissionDenied
                      ? Icons.camera_alt_outlined
                      : Icons.error_outline_rounded,
                  size: 42,
                  color: colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Skaner QR',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: _retryScannerStart,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Spróbuj ponownie'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Zeskanuj kod QR'),
        actions: [
          ValueListenableBuilder<MobileScannerState>(
            valueListenable: _controller,
            builder: (context, state, child) {
              final isTorchUnavailable =
                  state.torchState == TorchState.unavailable ||
                  !state.isRunning;

              return IconButton(
                icon: Icon(
                  state.torchState == TorchState.on
                      ? Icons.flash_on
                      : Icons.flash_off,
                ),
                color: isTorchUnavailable ? colorScheme.onSurfaceVariant : null,
                tooltip: isTorchUnavailable
                    ? 'Latarka niedostępna'
                    : 'Włącz/Wyłącz latarkę',
                onPressed: isTorchUnavailable || _isTorchToggling
                    ? null
                    : _handleTorchToggle,
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                final code = barcode.rawValue;
                if (code != null && code.isNotEmpty) {
                  _handleSuccessfulScan(code);
                  break;
                }
              }
            },
            onDetectError: (error, stackTrace) {
              if (_isScanned || !mounted) {
                return;
              }

              const message =
                  'Nie udało się odczytać kodu QR. Spróbuj ponownie.';
              if (_shouldReportError(isScanError: true, message: message)) {
                _showUserMessage(message);
              }
            },
            errorBuilder: (context, error) => _buildCameraError(context, error),
          ),
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: colorScheme.primary, width: 3),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
