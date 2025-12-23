import 'package:flutter_root_jailbreak_checker/flutter_root_jailbreak_checker.dart';
import 'package:obywatel_plus/core/security/application/security_integrity_config.dart';
import 'package:obywatel_plus/core/security/domain/security_exceptions.dart';

class DeviceIntegrityService {
  DeviceIntegrityService({FlutterRootJailbreakChecker? checker})
    : _checker = checker ?? FlutterRootJailbreakChecker();

  final FlutterRootJailbreakChecker _checker;

  Future<void> verify(SecurityIntegrityConfig config) async {
    final result = await _checker.checkIntegrity();

    final secure = result.isSecure(config.toPluginConfig());

    if (!secure) {
      throw const DeviceNotSecureException();
    }
  }
}
