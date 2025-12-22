abstract class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Brak połączenia z internetem']);
}

class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure(super.message, {this.statusCode});
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Wystąpił nieoczekiwany błąd']);
}
