import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/utils/device_info_service.dart';
import 'package:obywatel_plus/features/communication/application/e2ee_crypto_service.dart';
import 'package:obywatel_plus/features/communication/data/datasources/messaging_activation_api_client.dart';
import 'package:obywatel_plus/features/communication/data/dtos/messaging_activation_dto.dart';

class MessagingActivationState {
  const MessagingActivationState({
    this.status,
    this.terms,
    this.errorMessage,
  });

  static const Object _sentinel = Object();

  final MessagingActivationDto? status;
  final MessagingTermsDto? terms;
  final String? errorMessage;

  MessagingActivationState copyWith({
    Object? status = _sentinel,
    Object? terms = _sentinel,
    Object? errorMessage = _sentinel,
  }) {
    return MessagingActivationState(
      status: status == _sentinel ? this.status : status as MessagingActivationDto?,
      terms: terms == _sentinel ? this.terms : terms as MessagingTermsDto?,
      errorMessage: errorMessage == _sentinel
          ? this.errorMessage
          : errorMessage as String?,
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

    final currentTermsVersion = status?.currentTermsVersion ?? terms?.version ?? '';
    final acceptedVersion = status?.termsVersion ?? '';
    return status == null ||
        status!.status == 'not_started' ||
        status!.requiresTermsAcceptance ||
        acceptedVersion != currentTermsVersion;
  }
}

class MessagingActivationController extends AsyncNotifier<MessagingActivationState> {
  @override
  FutureOr<MessagingActivationState> build() async {
    return const MessagingActivationState();
  }

  Future<MessagingActivationState> _loadStatus() async {
    final apiClient = ref.read(messagingActivationApiClientProvider);
    final status = await apiClient.getActivationStatus();
    final terms = await apiClient.getCurrentTerms();
    return MessagingActivationState(status: status, terms: terms);
  }

  Future<MessagingActivationState> _ensureDeviceIdentityReady({
    MessagingActivationState? nextState,
  }) async {
    final activationState = nextState ?? state.value;
    if (activationState == null || !activationState.isActive) {
      return activationState ?? const MessagingActivationState();
    }

    try {
      final cryptoService = ref.read(e2eeCryptoServiceProvider);
      await cryptoService.registerDeviceIdentity();
      return activationState;
    } catch (error) {
      return activationState.copyWith(
        errorMessage:
            'Regulamin został zaakceptowany, ale nie udała się rejestracja kluczy E2EE. Spróbuj ponownie.',
      );
    }
  }

  Future<void> load() async {
    final currentState = state.value ?? const MessagingActivationState();
    state = const AsyncLoading();

    try {
      final nextState = await _loadStatus();
      final resolvedState = await _ensureDeviceIdentityReady(nextState: nextState);
      state = AsyncData(resolvedState);
    } catch (error) {
      state = AsyncData(
        currentState.copyWith(
          errorMessage: 'Nie udało się pobrać stanu komunikatora. Został odczytany lokalny stan aplikacji.',
        ),
      );
    }
  }

  Future<void> acceptCurrentTerms() async {
    final currentState = state.value ?? const MessagingActivationState();
    state = const AsyncLoading();
    try {
      final apiClient = ref.read(messagingActivationApiClientProvider);
      final deviceInfoService = ref.read(deviceInfoServiceProvider);
      final terms = currentState.terms ?? await apiClient.getCurrentTerms();
      final deviceId = await deviceInfoService.getOrCreateDeviceId();
      final updatedStatus = await apiClient.acceptTerms(
        deviceId: deviceId,
        termsVersion: terms.version,
      );
      final nextState = currentState.copyWith(
        status: updatedStatus,
        terms: terms,
        errorMessage: null,
      );
      final resolvedState = await _ensureDeviceIdentityReady(nextState: nextState);
      state = AsyncData(resolvedState);
    } catch (error) {
      state = AsyncData(
        currentState.copyWith(
          errorMessage: 'Nie można aktywować komunikatora bez dostępności serwera.',
        ),
      );
    }
  }

  Future<void> declineTerms() async {
    final currentState = state.value ?? const MessagingActivationState();
    state = AsyncData(
      currentState.copyWith(
        status: null,
        errorMessage: 'Akceptacja regulaminu jest wymagana do korzystania z komunikatora.',
      ),
    );
  }
}

final messagingActivationControllerProvider =
    AsyncNotifierProvider<MessagingActivationController, MessagingActivationState>(
  MessagingActivationController.new,
);
