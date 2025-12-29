// security_integrity_config.dart

import 'package:flutter_root_jailbreak_checker/flutter_root_jailbreak_checker.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'security_integrity_config.freezed.dart';

@freezed
sealed class SecurityIntegrityConfig with _$SecurityIntegrityConfig {
  // Używamy nazwy Config, bo to zestaw reguł sprawdzania
  const factory SecurityIntegrityConfig({
    @Default(true) bool blockRooted,
    @Default(true) bool blockEmulator,
    @Default(false) bool blockDeveloperMode,
  }) = _SecurityIntegrityConfig;

  const SecurityIntegrityConfig._();

  /// Mapowanie na zewnętrzny plugin (enkapsulacja)
  IntegrityCheckConfig toPluginConfig() {
    return IntegrityCheckConfig(
      blockIfRootedOrJailbroken: blockRooted,
      blockIfEmulatorOrSimulator: blockEmulator,
      blockIfDeveloperMode: blockDeveloperMode,
    );
  }
}
