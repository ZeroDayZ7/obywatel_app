import 'package:dio/dio.dart';
import 'package:obywatel_plus/core/errors/exceptions/app_exception.dart';

const String _connectionProblemMessage =
    'Nie udało się połączyć z serwerem. Sprawdź połączenie i spróbuj ponownie.';
const String _retryRequestMessage =
    'Nie udało się wysłać zaproszenia. Spróbuj ponownie za chwilę.';
const String _validationMessage = 'Sprawdź identyfikator użytkownika.';
const String _selfContactMessage = 'Nie możesz dodać siebie do kontaktów.';
const String _existingRelationMessage = 'Zaproszenie lub kontakt już istnieje.';
const String _inactiveDeviceMessage =
    'Nie można wysłać zaproszenia. To konto nie ma aktywnego komunikatora lub nie jest jeszcze dostępne.';
const String _genericValidationMessage =
    'Sprawdź poprawność danych i spróbuj ponownie.';
const String _sessionExpiredMessage = 'Sesja wygasła. Zaloguj się ponownie.';
const String _forbiddenMessage = 'Nie masz uprawnień do tej operacji.';

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
      return _validationMessage;
    }

    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout) {
      return _connectionProblemMessage;
    }

    if (error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return _retryRequestMessage;
    }

    return _retryRequestMessage;
  }

  if (error is ValidationException) {
    return _mapValidationDetail(error.message);
  }

  if (error is NetworkException) {
    return _connectionProblemMessage;
  }

  if (error is TimeoutException) {
    return _retryRequestMessage;
  }

  if (error is UnauthorizedException) {
    return _sessionExpiredMessage;
  }

  if (error is ForbiddenException) {
    return _forbiddenMessage;
  }

  if (error is BackendUnavailableException ||
      error is UpstreamUnavailableException ||
      error is ServerException) {
    return _retryRequestMessage;
  }

  if (error is FormatException) {
    return _validationMessage;
  }

  return _retryRequestMessage;
}

String? _validationDetailFrom(Map<dynamic, dynamic> data) {
  final meta = data['meta'];
  final directDetail = data['detail'];
  final responseMessage = data['message'];

  return _firstNonEmpty([
    _safeString(meta is Map ? meta['detail'] : null),
    _safeString(directDetail),
    _safeString(responseMessage),
  ]);
}

String? _firstNonEmpty(List<String?> values) {
  for (final value in values) {
    if (value != null && value.trim().isNotEmpty) {
      return value;
    }
  }
  return null;
}

String? _safeString(Object? value) {
  if (value is String) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  if (value is num || value is bool) {
    final text = value.toString();
    return text.trim().isEmpty ? null : text;
  }

  return null;
}

String _mapValidationDetail(String detail) {
  final normalized = detail.trim().toLowerCase();
  if (normalized.isEmpty) {
    return _genericValidationMessage;
  }

  if (_containsAny(normalized, ['cannot send a contact request to yourself'])) {
    return _selfContactMessage;
  }

  if (_containsAny(normalized, [
        'contact relation already exists',
        'contact already exists',
        'invite already exists',
        'request already exists',
        'already in contacts',
        'already invited',
        'already requested',
        'już istnieje',
        'kontakt już istnieje',
        'zaproszenie już istnieje',
        'prośba już istnieje',
      ]) ||
      ((_containsAny(normalized, ['already exists', 'already in contacts', 'już istnieje']) &&
              _containsAny(normalized, [
                'contact',
                'invite',
                'request',
                'relation',
                'kontakt',
                'zaproszenie',
                'prośba',
              ]))) ||
      (_containsAny(normalized, ['kontakt', 'zaproszenie', 'prośba', 'relacja']) &&
          _containsAny(normalized, ['już istnieje', 'istnieje']))) {
    return _existingRelationMessage;
  }

  if (_containsAny(normalized, [
        'no active device identity',
        'no active device',
        'device identity is not active',
        'device identity unavailable',
        'device identity not active',
      ]) ||
      (_containsAny(normalized, ['device identity', 'device']) &&
          _containsAny(normalized, [
            'not active',
            'inactive',
            'missing',
            'unavailable',
          ]))) {
    return _inactiveDeviceMessage;
  }

  if (_containsAny(normalized, [
        'invalid user identifier',
        'invalid user identifiers',
        'invalid user id',
        'invalid identifier',
        'invalid id',
        'validation failed',
        'request validation failed',
      ]) ||
      (normalized.contains('invalid') &&
          _containsAny(normalized, [
            'identifier',
            'user id',
            'user identifier',
            'contact id',
          ]))) {
    return _validationMessage;
  }

  if (_containsAny(normalized, [
    'not eligible',
    'target user is not eligible',
  ])) {
    return _inactiveDeviceMessage;
  }

  return _genericValidationMessage;
}

bool _containsAny(String value, List<String> needles) {
  return needles.any(value.contains);
}
