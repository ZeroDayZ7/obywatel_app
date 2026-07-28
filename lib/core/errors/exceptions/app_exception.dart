sealed class AppException implements Exception {
  final String message;
  final String? code;
  final int? statusCode;

  const AppException({required this.message, this.code, this.statusCode});

  @override
  String toString() {
    return '$runtimeType [$code] $message ($statusCode)';
  }
}

/// Brak internetu / problem z połączeniem klient -> gateway
final class NetworkException extends AppException {
  const NetworkException({
    super.message = 'Brak połączenia z serwerem.',
    super.code = 'NETWORK_ERROR',
  });
}

/// Timeout połączenia
final class TimeoutException extends AppException {
  const TimeoutException({
    super.message = 'Przekroczono czas oczekiwania na serwer.',
    super.code = 'TIMEOUT',
  });
}

/// Gateway działa, ale mikroserwis za nim nie odpowiada
final class UpstreamUnavailableException extends AppException {
  const UpstreamUnavailableException({
    super.message = 'Usługa jest chwilowo niedostępna.',
    super.code = 'UPSTREAM_UNAVAILABLE',
    super.statusCode = 503,
  });
}

/// Błąd 500 z backendu
final class ServerException extends AppException {
  const ServerException({
    required super.message,
    super.code = 'SERVER_ERROR',
    super.statusCode,
  });
}

/// Brak autoryzacji
final class UnauthorizedException extends AppException {
  const UnauthorizedException({
    super.message = 'Sesja wygasła.',
    super.code = 'UNAUTHORIZED',
    super.statusCode = 401,
  });
}

/// Brak uprawnień
final class ForbiddenException extends AppException {
  const ForbiddenException({
    super.message = 'Brak wymaganych uprawnień.',
    super.code = 'FORBIDDEN',
    super.statusCode = 403,
  });
}

/// Błąd walidacji danych
final class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.code = 'VALIDATION_ERROR',
    super.statusCode = 400,
  });
}

/// Błąd mapowania JSON -> Model
final class ParseException extends AppException {
  const ParseException({
    super.message = 'Nie można przetworzyć danych.',
    super.code = 'PARSE_ERROR',
  });
}

/// Nieznany błąd
final class UnknownException extends AppException {
  const UnknownException({
    super.message = 'Wystąpił nieoczekiwany błąd.',
    super.code = 'UNKNOWN_ERROR',
  });
}
