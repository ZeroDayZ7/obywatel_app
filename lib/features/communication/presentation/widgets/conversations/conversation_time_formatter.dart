class ConversationTimeFormatter {
  const ConversationTimeFormatter._();

  static String formatTime(DateTime? updatedAt) {
    if (updatedAt == null) {
      return '—';
    }

    final local = updatedAt.toLocal();
    return '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }
}
