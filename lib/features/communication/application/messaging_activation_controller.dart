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

  final MessagingActivationDto? status;
  final MessagingTermsDto? terms;
  final String? errorMessage;

  MessagingActivationState copyWith({
    MessagingActivationDto? status,
    MessagingTermsDto? terms,
    String? errorMessage,
  }) {
    return MessagingActivationState(
      status: status ?? this.status,
      terms: terms ?? this.terms,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get isActive =>
      status != null &&
      status!.status == 'active' &&
      status!.consentAccepted == true;

  bool get shouldShowOnboarding {
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
  late final MessagingActivationApiClient _apiClient;
  late final DeviceInfoService _deviceInfoService;
  late final E2eeCryptoService _cryptoService;

  @override
  FutureOr<MessagingActivationState> build() async {
    _apiClient = ref.read(messagingActivationApiClientProvider);
    _deviceInfoService = ref.read(deviceInfoServiceProvider);
    _cryptoService = ref.read(e2eeCryptoServiceProvider);
    return await _loadStatus();
  }

  Future<MessagingActivationState> _loadStatus() async {
    final status = await _apiClient.getActivationStatus();
    final terms = await _apiClient.getCurrentTerms();
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
      await _cryptoService.registerDeviceIdentity();
      return activationState;
    } catch (error) {
      return activationState.copyWith(
        errorMessage:
            'Regulamin został zaakceptowany, ale nie udała się rejestracja kluczy E2EE. Spróbuj ponownie.',
      );
    }
  }

  Future<void> load() async {
    state = const AsyncLoading();
    try {
      final nextState = await _loadStatus();
      final resolvedState = await _ensureDeviceIdentityReady(nextState: nextState);
      state = AsyncData(resolvedState);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> acceptCurrentTerms() async {
    try {
      final currentState = state.value ?? const MessagingActivationState();
      final terms = currentState.terms ?? await _apiClient.getCurrentTerms();
      final deviceId = await _deviceInfoService.getOrCreateDeviceId();
      final updatedStatus = await _apiClient.acceptTerms(
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
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
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
