sealed class AppException implements Exception {
  final String message;
  final int? statusCode;

  AppException(this.message, {this.statusCode});
}

class NetworkException extends AppException {
  NetworkException(super.message);
}

class TimeoutException extends AppException {
  TimeoutException(super.message);
}

class ServerException extends AppException {
  ServerException(super.message, {super.statusCode});
}

class UnknownAppException extends AppException {
  UnknownAppException(super.message);
}
