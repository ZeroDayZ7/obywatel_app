import 'package:freezed_annotation/freezed_annotation.dart';

part 'decrypted_message_content.freezed.dart';

@freezed
abstract class DecryptedMessageContent with _$DecryptedMessageContent {
  const factory DecryptedMessageContent({
    required String text,
    String? attachmentId,
    String? attachmentKey,
    String? fileName,
    String? contentType,
    int? size,
    String? sha256,
  }) = _DecryptedMessageContent;
}
