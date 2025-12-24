// lib/app/router/routes/auth_routes.dart
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/app/router/extensions/go_router_extensions.dart';
import 'package:obywatel_plus/core/security/presentation/pin_verification_screen.dart';
import 'package:obywatel_plus/core/security/presentation/security_setup_screen.dart';
import 'package:obywatel_plus/features/auth/presentation/login/login_screen.dart';
import 'package:obywatel_plus/features/auth/presentation/login/two_fa_screen.dart';

final authRoutes = [
  AppRoutes.login.go(const LoginScreen()),
  AppRoutes.pin.go(const PinVerificationScreen()),
  AppRoutes.securitySetup.go(const SecuritySetupScreen()),
  AppRoutes.twoFaVerify.go(const TwoFaScreen()),
];
