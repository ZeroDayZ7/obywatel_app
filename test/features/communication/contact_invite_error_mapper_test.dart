import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/core/errors/exceptions/app_exception.dart';
import 'package:obywatel_plus/features/communication/application/contact_invite_error_mapper.dart';

void main() {
  group('mapContactInviteError', () {
    test('maps self-invite validation', () {
      const error = ValidationException(
        message: 'cannot send a contact request to yourself',
        code: 'VALIDATION_FAILED',
      );

      expect(
        mapContactInviteError(error),
        'Nie możesz dodać siebie do kontaktów.',
      );
    });

    test('maps duplicate contact validation', () {
      const error = ValidationException(
        message: 'contact relation already exists',
        code: 'VALIDATION_FAILED',
      );

      expect(
        mapContactInviteError(error),
        'Zaproszenie lub kontakt już istnieje.',
      );
    });

    test('maps network failures to connection message', () {
      expect(
        mapContactInviteError(const NetworkException()),
        'Nie udało się połączyć z serwerem. Sprawdź połączenie i spróbuj ponownie.',
      );
    });

    test('maps dio validation errors with backend meta detail', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/contacts/request'),
        response: Response(
          requestOptions: RequestOptions(path: '/contacts/request'),
          statusCode: 400,
          data: {
            'code': 'VALIDATION_FAILED',
            'message': 'Request validation failed',
            'meta': {
              'detail': 'target user is not eligible for contact requests',
            },
          },
        ),
      );

      expect(
        mapContactInviteError(error),
        'Nie można wysłać zaproszenia. To konto nie ma aktywnego komunikatora lub nie jest jeszcze dostępne.',
      );
    });
  });
}
