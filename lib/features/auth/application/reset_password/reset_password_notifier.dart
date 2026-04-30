import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:obywatel_plus/core/errors/global_error_provider.dart';
import 'package:obywatel_plus/core/network/api_endpoints.dart';
import 'package:obywatel_plus/core/network/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reset_password_notifier.freezed.dart';
part 'reset_password_notifier.g.dart';

enum ResetMethod { email, phone }

@freezed
class ResetPasswordState with _$ResetPasswordState {
  const factory ResetPasswordState.initial() = _Initial;
  const factory ResetPasswordState.methodChosen({
    required String input,
    required ResetMethod method,
  }) = _MethodChosen;
  const factory ResetPasswordState.loading() = _Loading;
  const factory ResetPasswordState.codeSent({
    required String input,
    required ResetMethod method,
    required int resendTime,
    required bool canResend,
    String? token,
  }) = _CodeSent;
  const factory ResetPasswordState.codeVerified({
    String? token,
    String? challenge,
  }) = _CodeVerified;
  const factory ResetPasswordState.completed() = _Completed;
}

@riverpod
class ResetPasswordService extends _$ResetPasswordService {
  @override
  void build() {}

  Future<String?> sendCode({
    required bool isEmail,
    required String value,
  }) async {
    final api = ref.read(resetApiClientProvider);
    final response = await api.post(
      ApiEndpoints.reset,
      data: {'method': isEmail ? 'email' : 'phone', 'value': value},
    );
    return response.data['reset_token'] as String?;
  }

  Future<Map<String, dynamic>> verifyCode(String code, String? token) async {
    final api = ref.read(resetApiClientProvider);
    final response = await api.post(
      ApiEndpoints.verifyResetCode,
      data: {'code': code, if (token != null) 'token': token},
    );
    return response.data as Map<String, dynamic>;
  }

  Future<void> resetPasswordFinal({
    required String code,
    required String token,
    required String newPassword,
    required String signature,
    required String fingerprint,
    required String deviceName,
    required String platform,
    String? publicKey,
  }) async {
    final api = ref.read(resetApiClientProvider);
    final Map<String, dynamic> requestData = {
      'code': code,
      'reset_token': token,
      'new_password': newPassword,
      'signature': signature,
      'fingerprint': fingerprint,
      'device_name': deviceName,
      'platform': platform,
    };

    if (publicKey != null) {
      requestData['public_key'] = publicKey;
    }

    await api.post(ApiEndpoints.resetFinal, data: requestData);
  }
}

@riverpod
class ResetPasswordNotifier extends _$ResetPasswordNotifier {
  Timer? _timer;
  Object? _keepAliveLink;

  @override
  ResetPasswordState build() {
    ref.onDispose(() {
      _timer?.cancel();
      if (_keepAliveLink != null) {
        (_keepAliveLink as dynamic).close();
      }
    });
    return const ResetPasswordState.initial();
  }

  void setMethod(String input, bool isEmail) {
    state = ResetPasswordState.methodChosen(
      input: input,
      method: isEmail ? ResetMethod.email : ResetMethod.phone,
    );
  }

  Future<void> sendResetCode() async {
    final currentState = state;
    _keepAliveLink ??= ref.keepAlive();

    if (currentState is! _MethodChosen) return;

    final input = currentState.input;
    final method = currentState.method;

    state = const ResetPasswordState.loading();

    try {
      final token = await ref
          .read(resetPasswordServiceProvider.notifier)
          .sendCode(isEmail: method == ResetMethod.email, value: input);

      state = ResetPasswordState.codeSent(
        input: input,
        method: method,
        resendTime: 30,
        canResend: false,
        token: token,
      );
      _startTimer();
    } catch (e) {
      ref.read(globalNotificationProvider.notifier).showFromError(e);
      state = ResetPasswordState.methodChosen(input: input, method: method);
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      state.maybeMap(
        codeSent: (s) {
          if (s.resendTime <= 1) {
            t.cancel();
            state = s.copyWith(resendTime: 0, canResend: true);
          } else {
            state = s.copyWith(resendTime: s.resendTime - 1);
          }
        },
        orElse: () => t.cancel(),
      );
    });
  }

  Future<void> verifyCode(String code) async {
    final previousState = state;
    String? token;

    if (state is _CodeSent) {
      token = (state as _CodeSent).token;
    }

    state = const ResetPasswordState.loading();
    try {
      final response = await ref
          .read(resetPasswordServiceProvider.notifier)
          .verifyCode(code, token);

      state = ResetPasswordState.codeVerified(
        token: (response['reset_token'] as String?) ?? token,
        challenge: response['challenge'] as String?,
      );
    } catch (e) {
      ref.read(globalNotificationProvider.notifier).showFromError(e);
      state = previousState;
    }
  }

  Future<void> confirmReset({
    required String code,
    required String newPassword,
  }) async {
    final currentState = state;
    String? resetToken;
    String? serverChallenge;

    currentState.maybeMap(
      codeVerified: (s) {
        resetToken = s.token;
        serverChallenge = s.challenge;
      },
      orElse: () {},
    );

    if (resetToken == null || serverChallenge == null) return;

    state = const ResetPasswordState.loading();

    try {
      // final deviceInfo = ref.read(deviceInfoServiceProvider);
      // SimpleKeyPair keyPair;
      // String? publicKeyToSent;

      // try {
      //   keyPair = await deviceInfo.getStoredKeyPair();
      // } catch (e) {
      //   keyPair = await deviceInfo.generateDeviceKeyPair();
      //   final pubKeyData = await keyPair.extractPublicKey();
      //   publicKeyToSent = base64Encode(pubKeyData.bytes);
      // }

      // final deviceName = await deviceInfo.getMarketingName();
      // final challengeToSign = '$serverChallenge|$code';
      // final signature = await deviceInfo.signChallenge(
      //   challengeToSign,
      //   keyPair,
      // );
      // final fingerprint = await deviceInfo.getSecureFingerprint();
      // final platform = await deviceInfo.getPlatformName();

      // await ref
      //     .read(resetPasswordServiceProvider.notifier)
      //     .resetPasswordFinal(
      //       code: code,
      //       token: resetToken!,
      //       newPassword: newPassword,
      //       signature: signature,
      //       fingerprint: fingerprint,
      //       deviceName: deviceName,
      //       publicKey: publicKeyToSent,
      //       platform: platform,
      //     );

      state = const ResetPasswordState.completed();

      if (_keepAliveLink != null) {
        (_keepAliveLink as dynamic).close();
        _keepAliveLink = null;
      }
    } catch (e) {
      ref.read(globalNotificationProvider.notifier).showFromError(e);
      state = currentState;
    }
  }
}
