import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/database/database.dart';
import 'package:obywatel_plus/core/database/database_provider.dart';
import 'package:obywatel_plus/core/utils/device_info_service.dart';
import 'package:obywatel_plus/features/auth/application/session/session_service.dart';
import 'package:obywatel_plus/features/communication/application/e2ee_crypto_service.dart';
import 'package:obywatel_plus/features/communication/data/datasources/messaging_activation_api_client.dart';
import 'package:obywatel_plus/features/communication/data/dtos/messaging_activation_dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'messaging_activation_controller.g.dart';

class MessagingActivationState {
  const MessagingActivationState({this.status, this.terms, this.errorMessage});

  final MessagingActivationDto? status;
  final MessagingTermsDto? terms;
  final String? errorMessage;

  MessagingActivationState copyWith({
    MessagingActivationDto? status,
    MessagingTermsDto? terms,
    String? errorMessage,
    bool clearError = false,
  }) {
    return MessagingActivationState(
      status: status ?? this.status,
      terms: terms ?? this.terms,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  bool get isActive =>
      status != null &&
      status!.status == 'active' &&
      status!.consentAccepted == true;

  bool get shouldShowOnboarding {
    if (errorMessage != null && status == null && terms == null) {
      return false;
    }
    if (status == null && terms == null) {
      return true;
    }
    if (isActive) {
      return false;
    }

    final currentTermsVersion =
        status?.currentTermsVersion ?? terms?.version ?? '';
    final acceptedVersion = status?.termsVersion ?? '';
    return status == null ||
        status!.status == 'not_started' ||
        status!.requiresTermsAcceptance ||
        acceptedVersion != currentTermsVersion;
  }
}

@riverpod
class MessagingActivationController extends _$MessagingActivationController {
  int _requestVersion = 0;

  Future<String?> _currentUserId() async {
    final cachedUser = await ref.read(sessionServiceProvider).getCachedUser();
    return cachedUser?.id;
  }

  Future<String> _currentDeviceId() async {
    return ref.read(deviceInfoServiceProvider).getOrCreateDeviceId();
  }

  Future<void> _persistState(MessagingActivationState nextState) async {
    final userId = await _currentUserId();
    final deviceId = await _currentDeviceId();

    if (userId == null || userId.trim().isEmpty) {
      return;
    }

    final db = ref.read(appDatabaseProvider);
    final row = MessagingActivationStateRow(
      userId: userId,
      deviceId: deviceId,
      consentAccepted: nextState.status?.consentAccepted ?? false,
      status: nextState.status?.status ?? 'not_started',
      termsVersion:
          nextState.status?.termsVersion ?? nextState.terms?.version ?? '',
      currentTermsVersion:
          nextState.status?.currentTermsVersion ??
          nextState.terms?.version ??
          '',
      requiresTermsAcceptance:
          nextState.status?.requiresTermsAcceptance ?? false,
      keyRegistrationStatus: 'not_started',
      lastError: nextState.errorMessage,
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
    );

    await db.transaction(() async {
      await db
          .into(db.messagingActivationStates)
          .insert(row, mode: InsertMode.insertOrReplace);
    });
  }

  Future<MessagingActivationState?> _readPersistedState() async {
    final userId = await _currentUserId();
    final deviceId = await _currentDeviceId();

    if (userId == null || userId.trim().isEmpty) {
      return null;
    }

    final row =
        await (ref
                .read(appDatabaseProvider)
                .select(ref.read(appDatabaseProvider).messagingActivationStates)
              ..where(
                (tbl) =>
                    tbl.userId.equals(userId) & tbl.deviceId.equals(deviceId),
              ))
            .getSingleOrNull();

    if (row == null) {
      return null;
    }

    return MessagingActivationState(
      status: MessagingActivationDto(
        userId: row.userId,
        status: row.status,
        consentAccepted: row.consentAccepted,
        termsVersion: row.termsVersion,
        currentTermsVersion: row.currentTermsVersion,
        requiresTermsAcceptance: row.requiresTermsAcceptance,
        deviceId: row.deviceId,
      ),
      terms: row.termsVersion.isEmpty
          ? null
          : MessagingTermsDto(version: row.termsVersion, text: ''),
      errorMessage: row.lastError,
    );
  }

  Future<void> _clearPersistedState() async {
    final userId = await _currentUserId();
    final deviceId = await _currentDeviceId();
    if (userId == null || userId.trim().isEmpty) {
      return;
    }

    final db = ref.read(appDatabaseProvider);
    await (db.delete(db.messagingActivationStates)..where(
          (tbl) => tbl.userId.equals(userId) & tbl.deviceId.equals(deviceId),
        ))
        .go();
  }

  Future<MessagingActivationState> _loadStatus() async {
    final apiClient = ref.read(messagingActivationApiClientProvider);
    final status = await apiClient.getActivationStatus();
    final terms = await apiClient.getCurrentTerms();
    return MessagingActivationState(status: status, terms: terms);
  }

  Future<MessagingActivationState> _ensureDeviceIdentityReady({
    required MessagingActivationState nextState,
  }) async {
    if (!nextState.isActive) {
      return nextState;
    }

    try {
      final cryptoService = ref.read(e2eeCryptoServiceProvider);
      await cryptoService.registerDeviceIdentity();
      return nextState.copyWith(errorMessage: null);
    } on Exception catch (error) {
      return nextState.copyWith(
        errorMessage:
            'Regulamin został zaakceptowany, ale rejestracja kluczy E2EE nie została zakończona. Spróbuj ponownie.',
      );
    }
  }

  Future<void> _executeWithRequestGuard(
    Future<void> Function(int requestId) action,
  ) async {
    final requestId = ++_requestVersion;
    await action(requestId);
  }

  @override
  FutureOr<MessagingActivationState> build() async {
    final persisted = await _readPersistedState();
    if (persisted != null) {
      unawaited(_refreshInBackground());
      return persisted;
    }

    final nextState = await _loadStatus();
    await _persistState(nextState);
    return nextState;
  }

  Future<void> _refreshInBackground() async {
    final requestId = ++_requestVersion;
    try {
      final nextState = await _loadStatus();
      if (requestId != _requestVersion) {
        return;
      }
      final persistedState = await _ensureDeviceIdentityReady(
        nextState: nextState,
      );
      await _persistState(persistedState);
      state = AsyncData(persistedState);
    } catch (_) {
      // Offline or backend unavailable: keep the last persisted state.
    }
  }

  Future<void> load() async {
    await _executeWithRequestGuard((requestId) async {
      final currentState =
          state.value ??
          await _readPersistedState() ??
          const MessagingActivationState();
      state = const AsyncLoading();

      try {
        final nextState = await _loadStatus();
        final resolvedState = await _ensureDeviceIdentityReady(
          nextState: nextState,
        );
        await _persistState(resolvedState);
        if (requestId == _requestVersion) {
          state = AsyncData(resolvedState);
        }
      } on Exception catch (_) {
        final fallbackState = await _readPersistedState() ?? currentState;
        if (requestId == _requestVersion) {
          state = AsyncData(
            fallbackState.copyWith(
              errorMessage:
                  fallbackState.errorMessage ??
                  'Nie udało się pobrać stanu komunikatora. Został odczytany lokalny stan aplikacji.',
            ),
          );
        }
      }
    });
  }

  Future<void> acceptCurrentTerms() async {
    await _executeWithRequestGuard((requestId) async {
      final currentState =
          state.value ??
          await _readPersistedState() ??
          const MessagingActivationState();
      state = const AsyncLoading();

      try {
        final apiClient = ref.read(messagingActivationApiClientProvider);
        final terms = currentState.terms ?? await apiClient.getCurrentTerms();
        final deviceId = await _currentDeviceId();
        final updatedStatus = await apiClient.acceptTerms(
          deviceId: deviceId,
          termsVersion: terms.version,
        );

        final nextState = currentState.copyWith(
          status: updatedStatus,
          terms: terms,
          errorMessage: null,
        );
        final resolvedState = await _ensureDeviceIdentityReady(
          nextState: nextState,
        );
        await _persistState(resolvedState);
        if (requestId == _requestVersion) {
          state = AsyncData(resolvedState);
        }
      } on Exception catch (_) {
        if (requestId == _requestVersion) {
          state = AsyncData(
            currentState.copyWith(
              errorMessage:
                  'Nie można aktywować komunikatora bez dostępności serwera.',
            ),
          );
        }
      }
    });
  }

  Future<void> declineTerms() async {
    await _executeWithRequestGuard((requestId) async {
      final currentState =
          state.value ??
          await _readPersistedState() ??
          const MessagingActivationState();
      await _clearPersistedState();
      if (requestId == _requestVersion) {
        state = AsyncData(
          currentState.copyWith(
            status: null,
            errorMessage:
                'Akceptacja regulaminu jest wymagana do korzystania z komunikatora.',
            clearError: false,
          ),
        );
      }
    });
  }
}
