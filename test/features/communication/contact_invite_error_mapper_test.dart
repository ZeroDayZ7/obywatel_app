import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/core/errors/exceptions/app_exception.dart';
import 'package:obywatel_plus/features/communication/application/contact_invite_error_mapper.dart';

void main() {
  group('mapContactInviteError', () {
    test('maps all supported direct AppException variants', () {
      final cases = <Object, String>{
        const NetworkException():
            'Nie udało się połączyć z serwerem. Sprawdź połączenie i spróbuj ponownie.',
        const TimeoutException():
            'Nie udało się wysłać zaproszenia. Spróbuj ponownie za chwilę.',
        const UnauthorizedException(): 'Sesja wygasła. Zaloguj się ponownie.',
        const ForbiddenException(): 'Nie masz uprawnień do tej operacji.',
        const BackendUnavailableException():
            'Nie udało się wysłać zaproszenia. Spróbuj ponownie za chwilę.',
        const UpstreamUnavailableException():
            'Nie udało się wysłać zaproszenia. Spróbuj ponownie za chwilę.',
        const ServerException(message: 'backend failed'):
            'Nie udało się wysłać zaproszenia. Spróbuj ponownie za chwilę.',
        const ValidationException(message: 'Invalid user identifier'):
            'Sprawdź identyfikator użytkownika.',
        const FormatException(): 'Sprawdź identyfikator użytkownika.',
      };

      for (final entry in cases.entries) {
        expect(mapContactInviteError(entry.key), entry.value);
      }
    });

    test('maps nested AppException inside DioException', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/contacts/request'),
        error: const UnauthorizedException(),
      );

      expect(
        mapContactInviteError(error),
        'Sesja wygasła. Zaloguj się ponownie.',
      );
    });

    test('maps connection and timeout DioException variants', () {
      final connection = DioException(
        requestOptions: RequestOptions(path: '/contacts/request'),
        type: DioExceptionType.connectionError,
      );
      final receiveTimeout = DioException(
        requestOptions: RequestOptions(path: '/contacts/request'),
        type: DioExceptionType.receiveTimeout,
      );
      final sendTimeout = DioException(
        requestOptions: RequestOptions(path: '/contacts/request'),
        type: DioExceptionType.sendTimeout,
      );

      expect(
        mapContactInviteError(connection),
        'Nie udało się połączyć z serwerem. Sprawdź połączenie i spróbuj ponownie.',
      );
      expect(
        mapContactInviteError(receiveTimeout),
        'Nie udało się wysłać zaproszenia. Spróbuj ponownie za chwilę.',
      );
      expect(
        mapContactInviteError(sendTimeout),
        'Nie udało się wysłać zaproszenia. Spróbuj ponownie za chwilę.',
      );
    });

    test(
      'maps validation responses from meta.detail, detail and message fields',
      () {
        final metaDetail = DioException(
          requestOptions: RequestOptions(path: '/contacts/request'),
          response: Response(
            requestOptions: RequestOptions(path: '/contacts/request'),
            statusCode: 400,
            data: {
              'meta': {'detail': 'Cannot send a contact request to yourself'},
            },
          ),
        );
        final directDetail = DioException(
          requestOptions: RequestOptions(path: '/contacts/request'),
          response: Response(
            requestOptions: RequestOptions(path: '/contacts/request'),
            statusCode: 400,
            data: {'detail': 'Contact relation already exists'},
          ),
        );
        final messageField = DioException(
          requestOptions: RequestOptions(path: '/contacts/request'),
          response: Response(
            requestOptions: RequestOptions(path: '/contacts/request'),
            statusCode: 400,
            data: {'message': 'Invalid user identifier'},
          ),
        );

        expect(
          mapContactInviteError(metaDetail),
          'Nie możesz dodać siebie do kontaktów.',
        );
        expect(
          mapContactInviteError(directDetail),
          'Zaproszenie lub kontakt już istnieje.',
        );
        expect(
          mapContactInviteError(messageField),
          'Sprawdź identyfikator użytkownika.',
        );
      },
    );

    test('returns safe generic validation for empty or invalid payloads', () {
      final emptyMeta = DioException(
        requestOptions: RequestOptions(path: '/contacts/request'),
        response: Response(
          requestOptions: RequestOptions(path: '/contacts/request'),
          statusCode: 400,
          data: {
            'meta': {'detail': ''},
          },
        ),
      );
      final invalidDetail = DioException(
        requestOptions: RequestOptions(path: '/contacts/request'),
        response: Response(
          requestOptions: RequestOptions(path: '/contacts/request'),
          statusCode: 400,
          data: {'detail': 123},
        ),
      );

      expect(
        mapContactInviteError(emptyMeta),
        'Sprawdź identyfikator użytkownika.',
      );
      expect(
        mapContactInviteError(invalidDetail),
        'Sprawdź poprawność danych i spróbuj ponownie.',
      );
    });

    test('covers the known validation categories without false positives', () {
      final cases = <String, String>{
        'cannot send a contact request to yourself':
            'Nie możesz dodać siebie do kontaktów.',
        'contact relation already exists':
            'Zaproszenie lub kontakt już istnieje.',
        'no active device identity for user':
            'Nie można wysłać zaproszenia. To konto nie ma aktywnego komunikatora lub nie jest jeszcze dostępne.',
        'invalid user identifier': 'Sprawdź identyfikator użytkownika.',
      };

      for (final entry in cases.entries) {
        expect(
          mapContactInviteError(ValidationException(message: entry.key)),
          entry.value,
        );
      }
    });

    test(
      'keeps unknown validation messages generic instead of misclassifying them',
      () {
        expect(
          mapContactInviteError(
            ValidationException(message: 'Unexpected backend validation state'),
          ),
          'Sprawdź poprawność danych i spróbuj ponownie.',
        );
      },
    );
  });
}
