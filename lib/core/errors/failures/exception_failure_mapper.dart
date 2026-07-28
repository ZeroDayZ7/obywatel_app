import 'package:obywatel_plus/core/errors/exceptions/app_exception.dart';
import 'package:obywatel_plus/core/errors/failures/app_failure.dart';

AppFailure mapExceptionToFailure(Object exception) {
  if (exception is NetworkException) {
    return const AppFailure.network();
  }

  if (exception is TimeoutException) {
    return const AppFailure.network();
  }

  if (exception is UpstreamUnavailableException) {
    return AppFailure.server(statusCode: exception.statusCode);
  }

  if (exception is UnauthorizedException) {
    return const AppFailure.unauthorized();
  }

  if (exception is ForbiddenException) {
    return const AppFailure.forbidden();
  }

  if (exception is ValidationException) {
    return AppFailure.validation(
      messageKey: 'errors.${exception.code ?? 'VALIDATION_ERROR'}',
    );
  }

  if (exception is ServerException) {
    return AppFailure.server(statusCode: exception.statusCode);
  }

  if (exception is ParseException) {
    return const AppFailure.parse();
  }

  if (exception is UnknownException) {
    return const AppFailure.unknown();
  }

  return const AppFailure.unknown();
}
