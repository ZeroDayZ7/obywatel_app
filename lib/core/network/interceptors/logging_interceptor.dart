import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';

class LoggingInterceptor extends Interceptor {
  final AppLogger logger;

  LoggingInterceptor({required this.logger});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final summary = _summarizeRequestBody(options.data);
    final requestId = _readHeader(options.headers, 'x-request-id');
    final operationId = _readHeader(options.headers, 'x-operation-id');

    logger.i(
      'HTTP request stage=request endpoint=${options.uri.path} method=${options.method} '
      'request_id=${requestId ?? 'n/a'} operation_id=${operationId ?? 'n/a'} '
      'body_summary=$summary',
    );
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    final requestId = _readHeader(response.requestOptions.headers, 'x-request-id') ??
        response.headers.value('x-request-id');
    final operationId = _readHeader(response.requestOptions.headers, 'x-operation-id') ??
        response.headers.value('x-operation-id');
    final errorType = _statusToErrorType(response.statusCode);

    logger.i(
      'HTTP response stage=response endpoint=${response.requestOptions.uri.path} '
      'status=${response.statusCode} error_type=$errorType '
      'request_id=${requestId ?? 'n/a'} operation_id=${operationId ?? 'n/a'}',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final requestId = _readHeader(err.requestOptions.headers, 'x-request-id');
    final operationId = _readHeader(err.requestOptions.headers, 'x-operation-id');
    final responseStatus = err.response?.statusCode;
    final errorType = _statusToErrorType(responseStatus);

    logger.e(
      'HTTP error stage=error endpoint=${err.requestOptions.uri.path} '
      'status=${responseStatus ?? 'n/a'} error_type=$errorType '
      'request_id=${requestId ?? 'n/a'} operation_id=${operationId ?? 'n/a'}',
    );
    handler.next(err);
  }

  String _summarizeRequestBody(dynamic data) {
    if (data is Map<String, dynamic>) {
      final e2eeFields = <String>[];
      final identityPublicKeyLength = _lengthFromBase64(data['identity_public_key']);
      final signedPreKeyLength = _lengthFromBase64(data['signed_pre_key']);
      final signedPreKeySigLength = _lengthFromBase64(data['signed_pre_key_sig']);
      final oneTimePreKeyCount = (data['one_time_pre_keys'] is List)
          ? (data['one_time_pre_keys'] as List).length
          : 0;

      if (data.containsKey('identity_public_key')) e2eeFields.add('identity_public_key');
      if (data.containsKey('signed_pre_key')) e2eeFields.add('signed_pre_key');
      if (data.containsKey('signed_pre_key_sig')) e2eeFields.add('signed_pre_key_sig');
      if (data.containsKey('one_time_pre_keys')) e2eeFields.add('one_time_pre_keys');

      return {
        'e2ee_fields': e2eeFields,
        'identity_public_key_present': data.containsKey('identity_public_key'),
        'identity_public_key_length': identityPublicKeyLength,
        'signed_pre_key_present': data.containsKey('signed_pre_key'),
        'signed_pre_key_length': signedPreKeyLength,
        'signed_pre_key_sig_present': data.containsKey('signed_pre_key_sig'),
        'signed_pre_key_sig_length': signedPreKeySigLength,
        'one_time_pre_keys_count': oneTimePreKeyCount,
      }.toString();
    }

    if (data is List) {
      return 'list_items=${data.length}';
    }

    return 'non-map-body';
  }

  int? _lengthFromBase64(dynamic value) {
    if (value is! String || value.isEmpty) {
      return null;
    }
    try {
      return base64Decode(value).length;
    } catch (_) {
      return null;
    }
  }

  String _statusToErrorType(int? statusCode) {
    if (statusCode == null) return 'unknown';
    if (statusCode >= 500) return 'server_error';
    if (statusCode >= 400) return 'client_error';
    return 'success';
  }

  String? _readHeader(Map<String, dynamic>? headers, String key) {
    if (headers == null) return null;
    final normalizedKey = key.toLowerCase();
    for (final entry in headers.entries) {
      if (entry.key.toLowerCase() == normalizedKey) {
        return entry.value?.toString();
      }
    }
    return null;
  }
}
