import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'message_input_provider.g.dart';

@riverpod
class MessageInput extends _$MessageInput {
  @override
  String build(String conversationId) => '';

  void updateText(String text) {
    state = text;
  }

  void clear() {
    state = '';
  }
}