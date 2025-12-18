class SendResetCodeUseCase {
  Future<void> call(String target) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
