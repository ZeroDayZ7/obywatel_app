import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';

part 'app_failure.freezed.dart';

@freezed
sealed class AppFailure with _$AppFailure {
  const AppFailure._();
  const factory AppFailure.network() = _Network;
  const factory AppFailure.server({int? statusCode}) = _Server;
  const factory AppFailure.validation({required String messageKey}) =
      _Validation;
  const factory AppFailure.cache() = _Cache;
  const factory AppFailure.unknown() = _Unknown;

  // Helper do pobierania klucza tłumaczenia bezpośrednio z modelu
  String get messageKey => when(
    network: () => LocaleKeys.errors_CONNECTION_ERROR,
    server: (_) => LocaleKeys.errors_SERVER_ERROR,
    validation: (key) => key,
    cache: () => LocaleKeys.errors_cache,
    unknown: () => LocaleKeys.errors_unexpected_error,
  );
}
