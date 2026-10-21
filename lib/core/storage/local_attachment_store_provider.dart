import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/storage/local_attachment_store.dart';

final localAttachmentStoreProvider = Provider<LocalAttachmentStore>((ref) {
  return LocalAttachmentStore();
});
