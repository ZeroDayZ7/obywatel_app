// test/bootstrap/version_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:obywatel_plus/app/bootstrap/version_service.dart';
import '../mocks/version_service_mocks.dart';

// Prosty mock odpowiedzi API
class ResponseMock {
  final int statusCode;
  final dynamic data;
  ResponseMock(this.statusCode, this.data);
}

void main() {
  late VersionService service;
  late MockApiClient api;
  late MockLogger logger;

  setUp(() {
    api = MockApiClient();
    logger = MockLogger();
    service = VersionService(api, logger);
  });

  test('fetchMinimumSupportedVersion returns correct version', () async {
    // Mówimy mockowi, co ma zwrócić
    when(() => api.get(any())).thenAnswer(
      (_) async => Response(
        data: '{"minimum_supported": "1.2.3"}',
        statusCode: 200,
        requestOptions: RequestOptions(path: ''),
      ),
    );

    final minVersion = await service.fetchMinimumSupportedVersion();
    expect(minVersion, '1.2.3');

    // Sprawdzenie, czy metoda API została wywołana
    verify(() => api.get(any())).called(1);
  });

  test('isBelowMinimum correctly compares versions', () {
    expect(service.isBelowMinimum('1.0.0', '1.2.0'), true);
    expect(service.isBelowMinimum('1.2.3', '1.2.3'), false);
    expect(service.isBelowMinimum('2.0.0', '1.2.0'), false);
  });
}
