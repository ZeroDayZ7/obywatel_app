// lib/app/router/routes/auth_routes.dart
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/app/router/extensions/go_router_extensions.dart';
import 'package:obywatel_plus/core/security/pin/presentation/pin_verification_screen.dart';
import 'package:obywatel_plus/core/security/security_setup/presentation/security_setup_screen.dart';
import 'package:obywatel_plus/features/auth/presentation/login/pages/login_screen.dart';
import 'package:obywatel_plus/features/auth/presentation/login/pages/two_fa_screen.dart';
import 'package:obywatel_plus/features/auth/presentation/reset_password/pages/reset_password_screen.dart';

final authRoutes = [
  AppRoutes.login.go(const LoginScreen()),
  AppRoutes.pin.go(const PinVerificationScreen()),
  AppRoutes.securitySetup.go(const SecuritySetupScreen()),
  AppRoutes.twoFaVerify.go(const TwoFaScreen()),
  AppRoutes.resetPassword.go(const ResetPasswordScreen()),
];
