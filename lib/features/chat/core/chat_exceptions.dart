// Wszystkie wyjątki związane z modułem czatu
// ignore_for_file: use_super_parameters
/// Bazowy wyjątek czatu
class ChatException implements Exception {
  final String message;
  ChatException([this.message = "Wystąpił błąd w czacie"]);

  @override
  String toString() => "ChatException: $message";
}

/// Wyjątek przy problemach z siecią / WebSocket
class ChatNetworkException extends ChatException {
  ChatNetworkException([String message = "Błąd sieci"]) : super(message);
}

/// Wyjątek przy błędach REST API
class ChatApiException extends ChatException {
  final int? statusCode;
  ChatApiException(this.statusCode, [String message = "Błąd API"])
    : super(message);
}

/// Wyjątek przy problemach z lokalnym storage
class ChatStorageException extends ChatException {
  ChatStorageException([String message = "Błąd lokalnego storage"])
    : super(message);
}

/// Wyjątek przy problemach z szyfrowaniem wiadomości
class ChatEncryptionException extends ChatException {
  ChatEncryptionException([String message = "Błąd szyfrowania"])
    : super(message);
}
