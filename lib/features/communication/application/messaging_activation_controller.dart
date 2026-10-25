import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:obywatel_plus/core/utils/device_info_service.dart';
import 'package:obywatel_plus/features/auth/application/session/session_service.dart';
import 'package:obywatel_plus/features/communication/application/e2ee_crypto_service.dart';
import 'package:obywatel_plus/features/communication/data/datasources/messaging_activation_api_client.dart';
import 'package:obywatel_plus/features/communication/data/repositories/messaging_activation_repository.dart';
import 'package:obywatel_plus/features/communication/domain/models/messaging_activation_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'messaging_activation_controller.g.dart';

class _ActivationContext {
  const _ActivationContext({required this.userId, required this.deviceId});

  final String userId;
  final String deviceId;
}

@riverpod
class MessagingActivationController extends _$MessagingActivationController {
  int _requestVersion = 0;

  Future<_ActivationContext?> _resolveContext() async {
    final user = await ref.read(sessionServiceProvider).getCachedUser();
    final userId = user?.id;
    if (userId == null || userId.trim().isEmpty) {
      return null;
    }

    final deviceId = await ref.read(deviceInfoServiceProvider).getOrCreateDeviceId();
    return _ActivationContext(userId: userId, deviceId: deviceId);
  }

  Future<MessagingActivationState> _loadStatusForContext(
    _ActivationContext context,
  ) async {
    final apiClient = ref.read(messagingActivationApiClientProvider);
    final persisted = await _readPersistedState(context);
    final status = await apiClient.getActivationStatus();
    final terms = await apiClient.getCurrentTerms();
    final normalizedText = terms.text.trim();
    final normalizedCurrentVersion = terms.version.trim();
    final normalizedAcceptedVersion = status.termsVersion.trim();
    final hasUsableTerms =
        normalizedText.isNotEmpty && normalizedCurrentVersion.isNotEmpty;
    final hasConfirmedActivation =
        status.status == 'active' &&
        status.consentAccepted == true &&
        hasUsableTerms;

    final nextState = MessagingActivationState(
      userId: context.userId,
      deviceId: context.deviceId,
      status: hasConfirmedActivation ? status.status : status.status,
      consentAccepted: status.consentAccepted,
      termsVersion: normalizedAcceptedVersion.isNotEmpty
          ? normalizedAcceptedVersion
          : null,
      currentTermsVersion: normalizedCurrentVersion.isNotEmpty
          ? normalizedCurrentVersion
          : status.currentTermsVersion.trim().isNotEmpty
              ? status.currentTermsVersion.trim()
              : null,
      requiresTermsAcceptance: status.requiresTermsAcceptance,
      termsText: normalizedText.isNotEmpty ? normalizedText : null,
      hasLocalActivation: hasConfirmedActivation,
      keyRegistrationStatus:
          persisted?.keyRegistrationStatus ?? 'not_started',
      errorMessage: !hasUsableTerms
          ? 'Problem z siecią. Regulamin nie jest dostępny. Spróbuj ponownie za chwilę.'
          : null,
    );

    if (hasConfirmedActivation) {
      final confirmedState = await _ensureDeviceIdentityReady(
        nextState: nextState,
        context: context,
      );
      await _saveState(context, confirmedState);
      return confirmedState;
    }

    return nextState;
  }

  Future<void> _saveState(
    _ActivationContext context,
    MessagingActivationState state,
  ) async {
    final repo = ref.read(messagingActivationRepositoryProvider);
    await repo.saveState(
      userId: context.userId,
      deviceId: context.deviceId,
      state: state,
    );
  }

  Future<MessagingActivationState?> _readPersistedState(
    _ActivationContext context,
  ) async {
    final repo = ref.read(messagingActivationRepositoryProvider);
    return repo.readForContext(
      userId: context.userId,
      deviceId: context.deviceId,
    );
  }

  Future<void> _clearPersistedState(_ActivationContext context) async {
    final repo = ref.read(messagingActivationRepositoryProvider);
    await repo.clearForContext(
      userId: context.userId,
      deviceId: context.deviceId,
    );
  }

  Future<bool> _isCurrentContext(_ActivationContext context) async {
    final current = await _resolveContext();
    return current != null &&
        current.userId == context.userId &&
        current.deviceId == context.deviceId;
  }

  Future<MessagingActivationState> _ensureDeviceIdentityReady({
    required MessagingActivationState nextState,
    required _ActivationContext context,
  }) async {
    if (!nextState.isActive) {
      return nextState;
    }

    if (nextState.keyRegistrationStatus == 'completed') {
      return nextState;
    }

    try {
      final cryptoService = ref.read(e2eeCryptoServiceProvider);
      await cryptoService.registerDeviceIdentity();
      final persisted = nextState.copyWith(
        keyRegistrationStatus: 'completed',
        errorMessage: null,
      );
      await _saveState(context, persisted);
      return persisted;
    } on Exception catch (_) {
      final failedState = nextState.copyWith(
        keyRegistrationStatus: 'failed',
        errorMessage:
            'Rejestracja kluczy E2EE nie została zakończona. Spróbuj ponownie.',
      );
      await _saveState(context, failedState);
      return failedState;
    }
  }

  Future<void> _runExclusive(
    Future<void> Function(int requestId, _ActivationContext context) action,
  ) async {
    final context = await _resolveContext();
    if (context == null) {
      state = const AsyncData(
        MessagingActivationState(
          status: null,
          keyRegistrationStatus: 'not_started',
          errorMessage: 'Brak aktywnej sesji użytkownika.',
        ),
      );
      return;
    }

    final requestId = ++_requestVersion;
    await action(requestId, context);
  }

  @override
  FutureOr<MessagingActivationState> build() async {
    final context = await _resolveContext();
    if (context == null) {
      return const MessagingActivationState(
        status: null,
        keyRegistrationStatus: 'not_started',
        errorMessage: 'Brak aktywnej sesji użytkownika.',
      );
    }

    final persisted = await _readPersistedState(context);
    if (persisted != null) {
      if (persisted.isActive && persisted.keyRegistrationStatus != 'completed') {
        return _ensureDeviceIdentityReady(
          nextState: persisted,
          context: context,
        );
      }
      return persisted;
    }

    try {
      return await _loadStatusForContext(context);
    } on Exception {
      return const MessagingActivationState(
        status: null,
        keyRegistrationStatus: 'not_started',
        errorMessage: 'Brak dostępu do sieci. Stan aktywacji jest niekompletny.',
      );
    }
  }

  Future<void> load() async {
    await _runExclusive((requestId, context) async {
      final persisted = await _readPersistedState(context);
      final currentState = state.value ?? persisted ?? const MessagingActivationState();

      if (persisted != null && persisted.isActive) {
        final resolved = persisted.keyRegistrationStatus == 'completed'
            ? persisted
            : await _ensureDeviceIdentityReady(
                nextState: persisted,
                context: context,
              );

        if (requestId == _requestVersion) {
          state = AsyncData(resolved);
        }
        return;
      }

      state = const AsyncLoading();

      try {
        final nextState = await _loadStatusForContext(context);
        if (requestId == _requestVersion) {
          state = AsyncData(nextState);
        }
      } on Exception {
        final fallback = persisted ?? currentState;
        if (requestId == _requestVersion) {
          state = AsyncData(
            fallback.copyWith(
              errorMessage: fallback.errorMessage ??
                  'Nie udało się pobrać stanu komunikatora.',
            ),
          );
        }
      }
    });
  }

  Future<void> acceptCurrentTerms() async {
    await _runExclusive((requestId, context) async {
      final currentState =
          state.value ?? await _readPersistedState(context) ?? const MessagingActivationState();
      state = const AsyncLoading();

      try {
        if (!await _isCurrentContext(context)) {
          return;
        }

        final apiClient = ref.read(messagingActivationApiClientProvider);
        final terms = await apiClient.getCurrentTerms();
        final normalizedText = terms.text.trim();
        final normalizedVersion = terms.version.trim();

        if (normalizedText.isEmpty || normalizedVersion.isEmpty) {
          if (requestId == _requestVersion) {
            state = AsyncData(
              currentState.copyWith(
                userId: context.userId,
                deviceId: context.deviceId,
                termsText: null,
                currentTermsVersion: null,
                errorMessage:
                    'Akceptacja regulaminu jest wymagana do korzystania z komunikatora.',
              ),
            );
          }
          return;
        }

        final updatedStatus = await apiClient.acceptTerms(
          deviceId: context.deviceId,
          termsVersion: normalizedVersion,
        );

        final isConfirmed =
            updatedStatus.status == 'active' && updatedStatus.consentAccepted;

        if (!isConfirmed) {
          if (requestId == _requestVersion) {
            state = AsyncData(
              currentState.copyWith(
                userId: context.userId,
                deviceId: context.deviceId,
                termsText: normalizedText,
                currentTermsVersion: normalizedVersion,
                errorMessage:
                    'Backend nie potwierdził akceptacji regulaminu. Spróbuj ponownie później.',
              ),
            );
          }
          return;
        }

        final nextState = currentState.copyWith(
          userId: context.userId,
          deviceId: context.deviceId,
          status: updatedStatus.status,
          consentAccepted: true,
          termsVersion: updatedStatus.termsVersion.trim().isNotEmpty
              ? updatedStatus.termsVersion.trim()
              : normalizedVersion,
          currentTermsVersion: normalizedVersion,
          requiresTermsAcceptance: false,
          termsText: normalizedText,
          hasLocalActivation: true,
          errorMessage: null,
          keyRegistrationStatus: currentState.keyRegistrationStatus == 'completed'
              ? 'completed'
              : currentState.keyRegistrationStatus == 'failed'
                  ? 'failed'
                  : 'not_started',
        );

        if (!await _isCurrentContext(context)) {
          return;
        }

        await _saveState(context, nextState);
        final resolved = await _ensureDeviceIdentityReady(
          nextState: nextState,
          context: context,
        );

        if (requestId == _requestVersion && await _isCurrentContext(context)) {
          state = AsyncData(resolved);
        }
      } catch (error, stackTrace) {
        if (requestId == _requestVersion) {
          state = AsyncData(
            currentState.copyWith(
              userId: context.userId,
              deviceId: context.deviceId,
              errorMessage: 'Nie można aktywować komunikatora bez dostępu do sieci lub bez prawidłowego regulaminu.',
            ),
          );
        }
        // ignore stack trace here; controller error state is surfaced to UI
        debugPrintStack(stackTrace: stackTrace, label: error.toString());
      }
    });
  }

  Future<void> declineTerms() async {
    await _runExclusive((requestId, context) async {
      final persisted = await _readPersistedState(context);
      if (persisted != null && persisted.isActive) {
        if (requestId == _requestVersion) {
          state = AsyncData(
            persisted.copyWith(
              errorMessage: 'Aktywacja komunikatora jest już potwierdzona.',
            ),
          );
        }
        return;
      }

      await _clearPersistedState(context);

      final clearedState = const MessagingActivationState(
        status: null,
        keyRegistrationStatus: 'not_started',
        errorMessage: null,
      );

      if (requestId == _requestVersion) {
        state = AsyncData(clearedState);
      }
    });
  }
}
