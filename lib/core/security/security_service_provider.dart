import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/security/security_service.dart';

/// Zamiast void -> SecurityState
final securityServiceProvider =
    NotifierProvider<SecurityNotifier, SecurityState>(SecurityNotifier.new);
