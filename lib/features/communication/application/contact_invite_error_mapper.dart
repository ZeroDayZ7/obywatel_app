import 'package:dio/dio.dart';
import 'package:obywatel_plus/core/errors/exceptions/app_exception.dart';

String mapContactInviteError(Object error) {
  if (error is DioException) {
    final nested = error.error;
    if (nested is AppException) {
      return mapContactInviteError(nested);
    }

    final responseData = error.response?.data;
    if (responseData is Map) {
      final validationMessage = _validationDetailFrom(responseData);
      if (validationMessage != null) {
        return _mapValidationDetail(validationMessage);
      }
    }

    if (error.response?.statusCode == 400) {
      return _fallbackValidationMessage();
    }

    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout) {
      return 'Nie udało się połączyć z serwerem. Sprawdź połączenie i spróbuj ponownie.';
    }

    if (error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return 'Nie udało się wysłać zaproszenia. Spróbuj ponownie za chwilę.';
    }

    return 'Nie udało się wysłać zaproszenia. Spróbuj ponownie za chwilę.';
  }

  if (error is ValidationException) {
    return _mapValidationDetail(error.message);
  }

  if (error is NetworkException) {
    return 'Nie udało się połączyć z serwerem. Sprawdź połączenie i spróbuj ponownie.';
  }

  if (error is TimeoutException) {
    return 'Nie udało się wysłać zaproszenia. Spróbuj ponownie za chwilę.';
  }

  if (error is UnauthorizedException) {
    return 'Sesja wygasła. Zaloguj się ponownie.';
  }

  if (error is ForbiddenException) {
    return 'Nie masz uprawnień do tej operacji.';
  }

  if (error is BackendUnavailableException ||
      error is UpstreamUnavailableException ||
      error is ServerException) {
    return 'Nie udało się wysłać zaproszenia. Spróbuj ponownie za chwilę.';
  }

  if (error is FormatException) {
    return 'Sprawdź identyfikator użytkownika.';
  }

  return 'Nie udało się wysłać zaproszenia. Spróbuj ponownie za chwilę.';
}

String _fallbackValidationMessage() => 'Sprawdź identyfikator użytkownika.';

String? _validationDetailFrom(Map<dynamic, dynamic> data) {
  final meta = data['meta'];
  if (meta is Map) {
    final detail = meta['detail'];
    if (detail != null && detail.toString().trim().isNotEmpty) {
      return detail.toString();
    }
  }

  final explicitDetail = data['detail'];
  if (explicitDetail != null && explicitDetail.toString().trim().isNotEmpty) {
    return explicitDetail.toString();
  }

  final message = data['message'];
  if (message != null && message.toString().trim().isNotEmpty) {
    return message.toString();
  }

  return null;
}

String _mapValidationDetail(String detail) {
  final normalized = detail.toLowerCase();

  if (normalized.contains('cannot send a contact request to yourself') ||
      (normalized.contains('self') && normalized.contains('contact'))) {
    return 'Nie możesz dodać siebie do kontaktów.';
  }

  if (normalized.contains('already exists') ||
      normalized.contains('contact relation already exists')) {
    return 'Zaproszenie lub kontakt już istnieje.';
  }

  if (normalized.contains('not eligible') ||
      normalized.contains('target user is not eligible') ||
      normalized.contains('no active device identity') ||
      normalized.contains('device identity') ||
      normalized.contains('not available')) {
    return 'Nie można wysłać zaproszenia. To konto nie ma aktywnego komunikatora lub nie jest jeszcze dostępne.';
  }

  if (normalized.contains('invalid user identifiers') ||
      normalized.contains('invalid identifier') ||
      normalized.contains('request validation failed') ||
      normalized.contains('validation failed')) {
    return 'Sprawdź identyfikator użytkownika.';
  }

  if (normalized.contains('identyfikator') || normalized.contains('uuid')) {
    return 'Sprawdź identyfikator użytkownika.';
  }

  return 'Sprawdź poprawność danych i spróbuj ponownie.';
}
