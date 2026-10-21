import 'package:obywatel_plus/core/network/api_endpoints.dart';
import 'package:obywatel_plus/core/network/clients/api_client.dart';
import 'package:obywatel_plus/core/network/providers.dart';
import 'package:obywatel_plus/features/communication/data/dtos/messaging_activation_dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'messaging_activation_api_client.g.dart';

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
        'deviceId': deviceId,
        'termsVersion': termsVersion,
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
        'deviceId': deviceId,
        'termsVersion': termsVersion,
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

@riverpod
MessagingActivationApiClient messagingActivationApiClient(Ref ref) {
  return MessagingActivationApiClient(ref.watch(apiClientProvider));
}
