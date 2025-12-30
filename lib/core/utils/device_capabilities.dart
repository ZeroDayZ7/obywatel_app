import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibration/vibration.dart';

/// Snapshot możliwości urządzenia
class DeviceCapabilities {
  final bool hasVibration;
  final bool hasAmplitudeControl;
  final bool hasCustomVibrations;

  const DeviceCapabilities({
    required this.hasVibration,
    required this.hasAmplitudeControl,
    required this.hasCustomVibrations,
  });

  /// Helpers – żeby UI było czytelne
  bool get supportsAdvancedVibration =>
      hasVibration && (hasAmplitudeControl || hasCustomVibrations);
}

/// Provider wykrywający capabilities urządzenia (wywoływany raz)
final deviceCapabilitiesProvider = FutureProvider<DeviceCapabilities>((
  ref,
) async {
  final hasVibration = await Vibration.hasVibrator();

  // Bezpieczne – wywołujemy tylko jeśli ma wibrator
  final hasAmplitudeControl =
      hasVibration && await Vibration.hasAmplitudeControl();

  final hasCustomVibrations =
      hasVibration && await Vibration.hasCustomVibrationsSupport();

  return DeviceCapabilities(
    hasVibration: hasVibration,
    hasAmplitudeControl: hasAmplitudeControl,
    hasCustomVibrations: hasCustomVibrations,
  );
});
