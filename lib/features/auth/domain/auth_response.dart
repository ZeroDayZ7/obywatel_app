import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';

import 'auth_models.dart';

part 'auth_response.freezed.dart';
part 'auth_response.g.dart';

@freezed
sealed class AuthResponse with _$AuthResponse {
  const factory AuthResponse.twoFaRequired({required String twoFaToken}) =
      _TwoFaRequired;

  const factory AuthResponse.preTrust({
    required String setupToken,
    required String challenge,
    @Default(false) bool isTrusted,
  }) = _PreTrust;

  const factory AuthResponse.fullSuccess({
    required String accessToken,
    required String refreshToken,
    required UserProfile user,
    required RbacData rbac,
  }) = _FullSuccess;

  // TA LINIA JEST KLUCZOWA - bez niej json_serializable ignoruje ten plik
  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  // Twoja własna logika mapowania
  factory AuthResponse.fromMap(Map<String, dynamic> data) {
    if (data[StorageKeys.twoFaRequired] == true) {
      return AuthResponse.twoFaRequired(
        twoFaToken: data[StorageKeys.twoFaToken]?.toString() ?? '',
      );
    }

    final isTrusted = data[StorageKeys.isTrusted] as bool? ?? false;
    final refreshToken = data[StorageKeys.refreshToken]?.toString();

    if (isTrusted && refreshToken != null && refreshToken.isNotEmpty) {
      return AuthResponse.fullSuccess(
        accessToken: data[StorageKeys.accessToken]?.toString() ?? '',
        refreshToken: refreshToken,
        user: UserProfile.fromJson(data['user'] as Map<String, dynamic>),
        rbac: data['rbac'] == null
            ? RbacData(permissions: [])
            : RbacData.fromJson(data['rbac']),
      );
    }

    return AuthResponse.preTrust(
      setupToken: data[StorageKeys.setupToken]?.toString() ?? '',
      challenge: data[StorageKeys.challenge]?.toString() ?? '',
      isTrusted: isTrusted,
    );
  }
}
