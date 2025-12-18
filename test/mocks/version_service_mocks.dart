// test/mocks/version_service_mocks.dart

import 'package:mocktail/mocktail.dart';
import 'package:obywatel_plus/core/network/public_api_client.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';

// Mock dla PublicApiClient
class MockApiClient extends Mock implements PublicApiClient {}

// Mock dla AppLogger
class MockLogger extends Mock implements AppLogger {}
