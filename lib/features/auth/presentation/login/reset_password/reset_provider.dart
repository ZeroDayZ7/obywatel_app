import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'reset_state.dart';

final resetPasswordProvider = NotifierProvider<ResetNotifier, ResetState>(
  ResetNotifier.new,
);

class ResetNotifier extends Notifier<ResetState> {
  @override
  ResetState build() => const ResetState();

  Future<void> chooseMethod(String method) async {
    state = state.copyWith(status: ResetStatus.methodChosen);
    await sendResetCode(method);
  }

  Future<void> sendResetCode(String target) async {
    // ignore: todo
    // TODO backend: wysyłka kodu email/sms
    state = state.copyWith(status: ResetStatus.codeSent);
  }

  Future<void> verifyCode(String code) async {
    // ignore: todo
    // TODO backend: weryfikacja
    final success = code == "123456"; // placeholder
    if (success) {
      state = state.copyWith(status: ResetStatus.codeVerified);
    } else {
      state = state.copyWith(
        status: ResetStatus.error,
        errorMessage: "Niepoprawny kod",
      );
    }
  }
}
