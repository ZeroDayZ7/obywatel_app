// lib/core/security/device_integrity/security_integrity_config.dart

import 'package:flutter_root_jailbreak_checker/flutter_root_jailbreak_checker.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'security_integrity_config.freezed.dart';

@freezed
sealed class SecurityIntegrityConfig with _$SecurityIntegrityConfig {
  const factory SecurityIntegrityConfig({
    @Default(true) bool blockRooted,
    @Default(true) bool blockEmulator,
    @Default(false) bool blockDeveloperMode,
    @Default(true) bool blockDangerousApps,
  }) = _SecurityIntegrityConfig;

  const SecurityIntegrityConfig._();

  IntegrityCheckConfig toPluginConfig() {
    return IntegrityCheckConfig(
      blockIfRootedOrJailbroken: blockRooted,
      blockIfEmulatorOrSimulator: blockEmulator,
      blockIfDeveloperMode: blockDeveloperMode,
      // W wersji 2.1.5 nie ma pola 'blockIfExternalTools' w Configu,
      // ale wynik 'check' zawiera te informacje.
    );
  }
}
