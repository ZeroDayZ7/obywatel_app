import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_failure.freezed.dart';

@freezed
sealed class AppFailure with _$AppFailure {
  /// brak internetu, timeouty, DNS
  const factory AppFailure.network() = NetworkFailure;

  /// 5xx, backend down
  const factory AppFailure.server({int? statusCode}) = ServerFailure;

  /// 4xx, błędy biznesowe
  const factory AppFailure.validation({required String messageKey}) =
      ValidationFailure;

  /// cache / storage / secure storage
  const factory AppFailure.cache() = CacheFailure;

  /// fallback
  const factory AppFailure.unknown() = UnknownFailure;
}
