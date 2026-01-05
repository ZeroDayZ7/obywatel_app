import 'package:obywatel_plus/core/network/api_endpoints.dart';
import 'package:obywatel_plus/core/network/clients/public_client.dart';

class ResetPasswordService {
  ResetPasswordService(this._api);

  final PublicApiClient _api;

  Future<void> sendCode({required bool isEmail, required String value}) {
    return _api.post(
      ApiEndpoints.reset,
      data: {'method': isEmail ? 'email' : 'phone', 'value': value},
    );
  }

  Future<void> verifyCode(String code) {
    return _api.post(ApiEndpoints.verifyResetCode, data: {'code': code});
  }

  Future<void> resetPassword(String password) {
    return _api.post(ApiEndpoints.resetFinal, data: {'password': password});
  }
}
