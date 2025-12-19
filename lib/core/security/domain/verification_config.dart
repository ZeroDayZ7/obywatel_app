class VerificationConfig {
  final int? length;
  final bool numericOnly;
  final bool obscure;
  final String title;

  const VerificationConfig({
    required this.length,
    required this.numericOnly,
    required this.obscure,
    required this.title,
  });
}
