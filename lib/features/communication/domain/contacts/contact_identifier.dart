class ContactIdentifier {
  const ContactIdentifier({
    required this.raw,
    required this.normalized,
    required this.kind,
  });

  final String raw;
  final String normalized;
  final ContactIdentifierKind kind;

  bool get isUuid => kind == ContactIdentifierKind.uuid;
  bool get isHandle => kind == ContactIdentifierKind.handle;
  bool get isQrPayload => kind == ContactIdentifierKind.qrPayload;

  static ContactIdentifier parse(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) {
      throw const FormatException('Identyfikator kontaktu nie może być pusty.');
    }

    final withScheme = _stripKnownPrefixes(trimmed);
    final normalized = withScheme.trim();

    if (_isUuid(normalized)) {
      return ContactIdentifier(
        raw: input,
        normalized: normalized.toLowerCase(),
        kind: ContactIdentifierKind.uuid,
      );
    }

    if (_isHandle(normalized)) {
      return ContactIdentifier(
        raw: input,
        normalized: normalized,
        kind: ContactIdentifierKind.handle,
      );
    }

    if (_isQrPayload(normalized)) {
      return ContactIdentifier(
        raw: input,
        normalized: _extractQrValue(normalized),
        kind: ContactIdentifierKind.qrPayload,
      );
    }

    throw const FormatException(
      'Nieprawidłowy identyfikator kontaktu. Akceptowane są UUID, tag lub kod QR.',
    );
  }

  static String normalizeAlias(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return '';
    }

    if (trimmed.length > 40) {
      return trimmed.substring(0, 40).trim();
    }

    return trimmed;
  }

  static String _stripKnownPrefixes(String value) {
    final lower = value.toLowerCase();

    final candidates = <String>[
      'obywatel://contact/',
      'obywatel://user/',
      'user:',
      'contact:',
    ];

    for (final prefix in candidates) {
      if (lower.startsWith(prefix)) {
        return value.substring(prefix.length);
      }
    }

    return value;
  }

  static bool _isUuid(String value) {
    final uuidRegExp = RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$',
    );
    return uuidRegExp.hasMatch(value);
  }

  static bool _isHandle(String value) {
    final handleRegExp = RegExp(r'^[a-zA-Z0-9._-]{3,24}$');
    return handleRegExp.hasMatch(value);
  }

  static bool _isQrPayload(String value) {
    final lower = value.toLowerCase();
    return lower.contains('uuid=') || lower.contains('user_id=') || lower.contains('contact_id=');
  }

  static String _extractQrValue(String value) {
    final encoded = value.replaceAll(RegExp(r'^(?:obywatel://contact/|obywatel://user/|user:|contact:)'), '');
    final uuidMatch = RegExp(r'uuid=([0-9a-fA-F-]{36})').firstMatch(encoded);
    if (uuidMatch != null) {
      return uuidMatch.group(1)!.toLowerCase();
    }

    final userMatch = RegExp(r'user[_-]?id=([^&]+)').firstMatch(encoded);
    if (userMatch != null) {
      return userMatch.group(1)!.trim();
    }

    return encoded.trim();
  }
}

enum ContactIdentifierKind {
  uuid,
  handle,
  qrPayload,
}
