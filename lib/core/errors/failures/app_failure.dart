import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';

part 'app_failure.freezed.dart';

@freezed
sealed class AppFailure with _$AppFailure {
  const AppFailure._();

  /// Brak internetu / problem z siecią
  const factory AppFailure.network() = _Network;

  /// Timeout
  const factory AppFailure.timeout() = _Timeout;

  /// Backend zwrócił błąd 5xx
  const factory AppFailure.server({int? statusCode}) = _Server;

  /// Gateway nie może połączyć się z mikroserwisem
  const factory AppFailure.upstream({int? statusCode}) = _Upstream;

  /// Brak sesji / token wygasł
  const factory AppFailure.unauthorized() = _Unauthorized;

  /// Brak uprawnień
  const factory AppFailure.forbidden() = _Forbidden;

  /// Błąd walidacji danych
  const factory AppFailure.validation({required String messageKey}) =
      _Validation;

  /// Problem z parsowaniem JSON
  const factory AppFailure.parse() = _Parse;

  /// Cache lokalny
  const factory AppFailure.cache() = _Cache;

  /// Nieznany błąd
  const factory AppFailure.unknown() = _Unknown;

  String get messageKey => when(
    network: () => LocaleKeys.errors_CONNECTION_ERROR,

    timeout: () => LocaleKeys.errors_CONNECTION_ERROR,

    server: (_) => LocaleKeys.errors_SERVER_ERROR,

    upstream: (_) => LocaleKeys.errors_SERVER_ERROR,

    unauthorized: () => LocaleKeys.errors_UNAUTHORIZED,

    forbidden: () => LocaleKeys.errors_FORBIDDEN,

    validation: (key) => key,

    parse: () => LocaleKeys.errors_unexpected_error,

    cache: () => LocaleKeys.errors_cache,

    unknown: () => LocaleKeys.errors_unexpected_error,
  );
}
