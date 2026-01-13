import 'dart:convert';
import 'dart:io';

import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/database/database_provider.dart';
import 'package:obywatel_plus/core/errors/app_notification.dart';
import 'package:obywatel_plus/core/errors/global_error_provider.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/security/security/security_service_provider.dart';
import 'package:obywatel_plus/core/utils/device_info_service.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_service.dart';
import 'package:obywatel_plus/features/auth/application/session/pending_session_provider.dart';
import 'package:obywatel_plus/features/auth/application/session/pending_session_state.dart';
import 'package:obywatel_plus/features/auth/application/session/session_service.dart';
import 'package:obywatel_plus/features/auth/domain/auth_response.dart';
import 'package:obywatel_plus/features/auth/domain/auth_state.dart';
import 'package:obywatel_plus/features/notifications/domain/notifications_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  AuthService get _authService => ref.read(authServiceProvider);
  SessionService get _sessionService => ref.read(sessionServiceProvider);

  @override
  AuthState build() {
    _restoreSession();
    return const AuthState.initial();
  }

  Future<void> _restoreSession() async {
    final session = await _sessionService.getSessionDetails();

    if (session == null) {
      state = const AuthState.unauthenticated();
      return;
    }

    // Tutaj dostęp do:
    // session.userId
    // session.accessToken
    state = AuthState.authenticated(userId: session.userId);
  }

  Future<void> _handleAuthResponse(AuthResponse result, String email) async {
    await result.when(
      twoFaRequired: (token) {
        state = AuthState.twoFaRequired(email: email, tempToken: token);
      },
      preTrust: (setupToken, challenge, isTrusted, userId) async {
        state = AuthState.partiallyAuthenticated(
          setupToken: setupToken,
          challenge: challenge,
          userId: userId,
        );

        final pending = PendingSession(setupToken: setupToken, userId: userId);

        ref.read(appLoggerProvider).i('pending:  $pending');
        ref.read(pendingSessionProvider.notifier).update(pending);
      },
      fullSuccess: (accessToken, refreshToken, user, rbac) async {
        try {
          await _sessionService.saveSession(
            accessToken: accessToken,
            refreshToken: refreshToken,
            userId: user.userId,
          );

          state = AuthState.authenticated(
            userId: user.userId,
            accessToken: accessToken,
            refreshToken: refreshToken,
            isDeviceTrusted: true,
          );
        } catch (e) {
          _handleError(e);
          state = const AuthState.unauthenticated();
        }
      },
    );
  }

  Future<void> login(String email, List<int> passwordBytes) async {
    state = const AuthState.authenticating();
    try {
      final result = await _authService.login(email, passwordBytes);

      passwordBytes.fillRange(0, passwordBytes.length, 0);

      await _handleAuthResponse(result, email);
    } catch (e) {
      passwordBytes.fillRange(0, passwordBytes.length, 0);
      _handleError(e);
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> verifyTwoFa(String code) async {
    final currentEmail = state.maybeMap(
      twoFaRequired: (s) => s.email,
      orElse: () => null,
    );
    final currentToken = state.maybeMap(
      twoFaRequired: (s) => s.tempToken,
      orElse: () => null,
    );

    if (currentEmail == null || currentToken == null) {
      _showError(LocaleKeys.errors_SESSION_EXPIRED);
      return;
    }

    final List<int> codeBytes = code.codeUnits.toList();
    state = const AuthState.authenticating();

    try {
      final result = await _authService.verifyTwoFa(
        currentEmail,
        codeBytes,
        currentToken,
      );
      codeBytes.fillRange(0, codeBytes.length, 0);

      await _handleAuthResponse(result, currentEmail);
    } catch (e) {
      ref.read(globalNotificationProvider.notifier).showFromError(e);
      codeBytes.fillRange(0, codeBytes.length, 0);
      state = AuthState.twoFaRequired(
        email: currentEmail,
        tempToken: currentToken,
      );
      _handleError(e);
    }
  }

  Future<void> registerTrustedDevice(List<int> pinBytes) async {
    final pending = ref.read(pendingSessionProvider);
    final deviceService = ref.read(deviceInfoServiceProvider);
    final authService = ref.read(authServiceProvider);
    final userId = pending?.userId ?? "";

    final keyPair = await deviceService.generateDeviceKeyPair(
      pinBytes: pinBytes,
      userId: userId,
    );
    final publicKey = await keyPair.extractPublicKey();
    final fingerprint = await deviceService.getSecureFingerprint();
    final encryptedName = await deviceService.getEncryptedMarketingName();

    final challenge = state.maybeMap(
      partiallyAuthenticated: (s) => s.challenge,
      orElse: () => throw Exception('Brak challenge'),
    );

    final signature = await deviceService.signChallenge(challenge, keyPair);

    final response = await authService.registerTrustedDevice(
      fingerprint: fingerprint,
      publicKey: base64Encode(publicKey.bytes),
      encryptedName: encryptedName,
      platform: Platform.operatingSystem,
      signature: signature,
      accessToken: pending?.setupToken,
    );

    await _handleAuthResponse(response, "");
  }

  Future<void> logout() async {
    try {
      final refreshToken = await _sessionService.getRefreshToken();
      await _authService.logout(refreshToken);
    } finally {
      await _sessionService.clearSession();
      ref.invalidate(securityServiceProvider);
      ref.invalidate(appDatabaseProvider);
      ref.invalidate(notificationsControllerProvider);
      state = const AuthState.unauthenticated();
    }
  }

  void _handleError(Object e) {
    ref.read(globalNotificationProvider.notifier).showFromError(e);
  }

  void cancelTwoFa() {
    state = const AuthState.unauthenticated();
  }

  void _showError(String key) {
    ref
        .read(globalNotificationProvider.notifier)
        .show(AppNotification(messageKey: key, type: NotificationType.error));
  }

  void setUnauthenticated() {
    state = const AuthState.unauthenticated();
  }
}
