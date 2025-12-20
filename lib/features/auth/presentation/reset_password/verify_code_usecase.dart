class VerifyResetCodeUseCase {
  Future<bool> call(String code) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return code == "123456";
  }
}
