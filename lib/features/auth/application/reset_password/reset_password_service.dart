import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/network/api_endpoints.dart';
import 'package:obywatel_plus/core/network/providers.dart';

Future<String?> sendResetCodeApi({
  required Ref ref,
  required String accountIdentifier,
  required String contactValue,
  required bool isEmail,
}) async {
  final api = ref.read(noAuthApiClientProvider);
  final response = await api.post(
    ApiEndpoints.reset,
    data: {
      'account_identifier': accountIdentifier,
      'method': isEmail ? 'email' : 'phone',
      'value': contactValue,
    },
  );
  return response.data['reset_token'] as String?;
}

Future<Map<String, dynamic>> verifyResetCodeApi({
  required Ref ref,
  required String code,
  String? token,
}) async {
  final api = ref.read(noAuthApiClientProvider);
  final response = await api.post(
    ApiEndpoints.verifyResetCode,
    data: {'code': code, if (token != null) 'token': token},
  );
  return response.data as Map<String, dynamic>;
}

Future<void> resetPasswordFinalApi({
  required Ref ref,
  required String code,
  required String token,
  required String newPassword,
  required String signature,
  required String fingerprint,
  required String deviceName,
  required String platform,
  String? publicKey,
}) async {
  final api = ref.read(noAuthApiClientProvider);
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
