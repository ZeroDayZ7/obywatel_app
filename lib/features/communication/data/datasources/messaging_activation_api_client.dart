import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/network/api_endpoints.dart';
import 'package:obywatel_plus/core/network/clients/api_client.dart';
import 'package:obywatel_plus/core/network/providers.dart';
import 'package:obywatel_plus/features/communication/data/dtos/messaging_activation_dto.dart';

class MessagingActivationApiClient {
  const MessagingActivationApiClient(this._apiClient);

  final ApiClient _apiClient;

  Future<MessagingActivationDto> getActivationStatus() async {
    final response = await _apiClient.get(ApiEndpoints.messagingActivationStatus);
    final data = response.data as Map<String, dynamic>;
    return MessagingActivationDto.fromJson(data);
  }

  Future<MessagingActivationDto> activateMessaging({
    required String deviceId,
    required String termsVersion,
    bool consent = true,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.messagingActivation,
      data: {
        'device_id': deviceId,
        'terms_version': termsVersion,
        'consent': consent,
      },
    );
    final data = response.data as Map<String, dynamic>;
    return MessagingActivationDto.fromJson(data);
  }

  Future<MessagingActivationDto> acceptTerms({
    required String deviceId,
    required String termsVersion,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.messagingAcceptTerms,
      data: {
        'device_id': deviceId,
        'terms_version': termsVersion,
      },
    );
    final data = response.data as Map<String, dynamic>;
    return MessagingActivationDto.fromJson(data);
  }

  Future<MessagingTermsDto> getCurrentTerms() async {
    final response = await _apiClient.get(ApiEndpoints.messagingTerms);
    final data = response.data as Map<String, dynamic>;
    return MessagingTermsDto.fromJson(data);
  }
}

final messagingActivationApiClientProvider =
    Provider<MessagingActivationApiClient>((ref) {
  return MessagingActivationApiClient(ref.watch(apiClientProvider));
});
