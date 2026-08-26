import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';

part 'auth_response.freezed.dart';
part 'auth_response.g.dart';

@freezed
sealed class AuthResponse with _$AuthResponse {
  const factory AuthResponse.twoFaRequired({
    @Default('') String twoFaToken,
  }) = _TwoFaRequired;

  const factory AuthResponse.preTrust({
    required String userId,
    @Default('') String setupToken,
    @Default('') String challenge,
    @Default(false) bool isTrusted,
  }) = _PreTrust;

  /// Czysty sukces uwierzytelnienia – zwraca TYLKO tokeny dostępowe.
  /// Dane profilu, role i uprawnienia pobierane są osobnym strzałem hydratacyjnym (/auth/me).
  const factory AuthResponse.fullSuccess({
    @Default('') String accessToken,
    @Default('') String refreshToken,
  }) = _FullSuccess;

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  factory AuthResponse.fromMap(Map<String, dynamic> data) {
    final is2Fa = data[StorageKeys.twoFaRequired] == true ||
        data[StorageKeys.twoFaRequired]?.toString() == 'true';

    if (is2Fa) {
      return AuthResponse.twoFaRequired(
        twoFaToken: data[StorageKeys.twoFaToken]?.toString() ?? '',
      );
    }

    final isTrusted = data[StorageKeys.isTrusted] == true ||
        data[StorageKeys.isTrusted]?.toString() == 'true';
    final refreshToken = data[StorageKeys.refreshToken]?.toString();

    if (isTrusted && refreshToken != null && refreshToken.isNotEmpty) {
      return AuthResponse.fullSuccess(
        accessToken: data[StorageKeys.accessToken]?.toString() ?? '',
        refreshToken: refreshToken,
      );
    }

    return AuthResponse.preTrust(
      userId: data[StorageKeys.userId]?.toString() ?? '',
      setupToken: data[StorageKeys.setupToken]?.toString() ?? '',
      challenge: data[StorageKeys.challenge]?.toString() ?? '',
      isTrusted: isTrusted,
    );
  }
}