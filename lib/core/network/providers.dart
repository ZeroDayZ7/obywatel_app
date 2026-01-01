import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/network/api_client.dart';
import 'package:obywatel_plus/core/network/dio_factory.dart';
import 'package:obywatel_plus/core/network/public_client.dart';
import 'package:obywatel_plus/core/storage/secure_storage_service.dart';
import 'package:obywatel_plus/features/auth/application/session/session_service.dart';

// ============================================================
// 1. INSTANCJE DIO (WARSTWA NISKOKOPOZIOMOWA)
// ============================================================

/// Klient służący WYŁĄCZNIE do odświeżania tokena
final refreshDioProvider = Provider<Dio>((ref) {
  return DioFactory.create(
    profile: DioProfile.refreshToken,
    logger: ref.watch(appLoggerProvider),
    ref: ref, // DODANE
  );
});

/// Klient publiczny - nie wymaga logowania
final publicDioProvider = Provider<Dio>((ref) {
  return DioFactory.create(
    profile: DioProfile.public,
    logger: ref.watch(appLoggerProvider),
    ref: ref, // DODANE
  );
});

/// Klient do operacji związanych z resetem hasła
final resetDioProvider = Provider<Dio>((ref) {
  return DioFactory.create(
    profile: DioProfile.noAuthAuth,
    logger: ref.watch(appLoggerProvider),
    ref: ref, // DODANE
  );
});

/// GŁÓWNY KLIENT AUTORYZOWANY - posiada interceptory Auth i Refresh (Mutex)
final authDioProvider = Provider<Dio>((ref) {
  final refreshDio = ref.watch(refreshDioProvider);

  return DioFactory.create(
    profile: DioProfile.authenticated,
    logger: ref.watch(appLoggerProvider),
    ref: ref, // DODANE
    storage: ref.watch(secureStorageProvider),
    sessionService: ref.watch(sessionServiceProvider),
    refreshClient: refreshDio,
  );
});

// ============================================================
// 2. API CLIENTS (WARSTWA ABSTRAKCJI)
// ============================================================

/// Klient API dla endpointów publicznych
final publicApiClientProvider = Provider<PublicApiClient>((ref) {
  return PublicApiClient(
    dio: ref.watch(publicDioProvider),
    logger: ref.watch(appLoggerProvider),
  );
});

/// Klient API dla endpointów wymagających autoryzacji (JWT)
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    dio: ref.watch(authDioProvider),
    storage: ref.watch(secureStorageProvider),
    logger: ref.watch(appLoggerProvider),
  );
});

/// Klient API specyficzny dla procesów resetowania/odzyskiwania konta
final resetApiClientProvider = Provider<PublicApiClient>((ref) {
  return PublicApiClient(
    dio: ref.watch(resetDioProvider),
    logger: ref.watch(appLoggerProvider),
  );
});
