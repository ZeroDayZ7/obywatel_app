


class ChatException implements Exception {
  final String message;
  ChatException([this.message = 'Wystąpił błąd w czacie']);

  @override
  String toString() => 'ChatException: $message';
}


class ChatNetworkException extends ChatException {
  ChatNetworkException([super.message = 'Błąd sieci']);
}


class ChatApiException extends ChatException {
  final int? statusCode;
  ChatApiException(this.statusCode, [String message = 'Błąd API'])
    : super(message);
}


class ChatStorageException extends ChatException {
  ChatStorageException([super.message = 'Błąd lokalnego storage']);
}


class ChatEncryptionException extends ChatException {
  ChatEncryptionException([super.message = 'Błąd szyfrowania']);
}
