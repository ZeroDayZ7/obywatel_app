import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_capabilities_state.freezed.dart';

@freezed
sealed class DeviceCapabilitiesState with _$DeviceCapabilitiesState {
  const factory DeviceCapabilitiesState({
    @Default(false) bool hasVibration,
    @Default(false) bool hasAmplitudeControl,
    @Default(false) bool hasCustomVibrations,
    @Default(false) bool initialized,
  }) = _DeviceCapabilitiesState;

  // Dodajemy custom getter do klasy Freezed (wymaga prywatnego konstruktora)
  const DeviceCapabilitiesState._();

  bool get supportsAdvancedVibration =>
      hasVibration && (hasAmplitudeControl || hasCustomVibrations);
}
