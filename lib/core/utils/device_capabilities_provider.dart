import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vibration/vibration.dart';

import 'device_capabilities_state.dart';

part 'device_capabilities_provider.g.dart';

@Riverpod(keepAlive: true)
class DeviceCapabilities extends _$DeviceCapabilities {
  @override
  DeviceCapabilitiesState build() {
    _init();
    return const DeviceCapabilitiesState();
  }

  Future<void> _init() async {
    // Usunięto ?? false, bo Vibration.hasVibrator() zwraca bool
    final hasVibrator = await Vibration.hasVibrator();

    if (!hasVibrator) {
      state = state.copyWith(initialized: true);
      return;
    }

    // Usunięto zbędne Future.value(false), bo metody zwracają bool
    final results = await Future.wait([
      Vibration.hasAmplitudeControl(),
      Vibration.hasCustomVibrationsSupport(),
    ]);

    state = DeviceCapabilitiesState(
      hasVibration: true,
      hasAmplitudeControl: results[0],
      hasCustomVibrations: results[1],
      initialized: true,
    );
  }
}
