import 'dart:async';

import 'package:obywatel_plus/core/utils/device_info_service.dart';
import 'package:obywatel_plus/features/auth/application/session/session_service.dart';
import 'package:obywatel_plus/features/communication/application/e2ee_crypto_service.dart';
import 'package:obywatel_plus/features/communication/data/datasources/messaging_activation_api_client.dart';
import 'package:obywatel_plus/features/communication/data/dtos/messaging_activation_dto.dart';
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

  Future<MessagingActivationState> _loadStatus() async {
    final apiClient = ref.read(messagingActivationApiClientProvider);
    final status = await apiClient.getActivationStatus();
    final terms = await apiClient.getCurrentTerms();

    return MessagingActivationState(
      status: status.status,
      consentAccepted: status.consentAccepted,
      termsVersion: status.termsVersion,
      currentTermsVersion: status.currentTermsVersion,
      requiresTermsAcceptance: status.requiresTermsAcceptance,
      termsText: terms.text,
      hasLocalActivation: false,
    );
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
      return await _loadStatus();
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
        final nextState = await _loadStatus();
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
        final apiClient = ref.read(messagingActivationApiClientProvider);
        final terms = currentState.termsText == null
            ? await apiClient.getCurrentTerms()
            : MessagingTermsDto(
                version: currentState.termsVersion ?? currentState.currentTermsVersion ?? '',
                text: currentState.termsText ?? '',
              );

        final updatedStatus = await apiClient.acceptTerms(
          deviceId: context.deviceId,
          termsVersion: terms.version,
        );

        final nextState = currentState.copyWith(
          userId: context.userId,
          deviceId: context.deviceId,
          status: updatedStatus.status,
          consentAccepted: updatedStatus.consentAccepted,
          termsVersion: updatedStatus.termsVersion,
          currentTermsVersion: updatedStatus.currentTermsVersion,
          requiresTermsAcceptance: updatedStatus.requiresTermsAcceptance,
          termsText: terms.text,
          hasLocalActivation: true,
          errorMessage: null,
          keyRegistrationStatus: 'required',
        );

        await _saveState(context, nextState);
        final resolved = await _ensureDeviceIdentityReady(
          nextState: nextState,
          context: context,
        );

        if (requestId == _requestVersion) {
          state = AsyncData(resolved);
        }
      } on Exception {
        if (requestId == _requestVersion) {
          state = AsyncData(
            currentState.copyWith(
              errorMessage: 'Nie można aktywować komunikatora bez dostępu do sieci.',
            ),
          );
        }
      }
    });
  }

  Future<void> declineTerms() async {
    await _runExclusive((requestId, context) async {
      await _clearPersistedState(context);

      final clearedState = const MessagingActivationState(
        status: null,
        keyRegistrationStatus: 'not_started',
        errorMessage: 'Akceptacja regulaminu jest wymagana do korzystania z komunikatora.',
      );

      if (requestId == _requestVersion) {
        state = AsyncData(clearedState);
      }
    });
  }
}
