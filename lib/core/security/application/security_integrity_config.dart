import 'package:flutter_root_jailbreak_checker/flutter_root_jailbreak_checker.dart';

class SecurityIntegrityConfig {
  const SecurityIntegrityConfig({
    this.blockRooted = true,
    this.blockEmulator = true,
    this.blockDeveloperMode = false,
  });

  final bool blockRooted;
  final bool blockEmulator;
  final bool blockDeveloperMode;

  IntegrityCheckConfig toPluginConfig() {
    return IntegrityCheckConfig(
      blockIfRootedOrJailbroken: blockRooted,
      blockIfEmulatorOrSimulator: blockEmulator,
      blockIfDeveloperMode: blockDeveloperMode,
    );
  }
}
