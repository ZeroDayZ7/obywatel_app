import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class LocalAttachmentStore {
  static const String _previewDirectoryName =
      'communication/attachments/previews';

  Future<Directory> _previewDirectory() async {
    final applicationDir = await getApplicationSupportDirectory();
    final directory = Directory(
      p.join(applicationDir.path, _previewDirectoryName),
    );
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return directory;
  }

  Future<String> previewPathForAttachment(String attachmentId) async {
    final normalized = attachmentId.trim();
    if (normalized.isEmpty) {
      throw ArgumentError.value(attachmentId, 'attachmentId');
    }

    final directory = await _previewDirectory();
    final sanitizedName = normalized.replaceAll(
      RegExp(r'[^A-Za-z0-9_.-]'),
      '_',
    );
    return p.join(directory.path, '$sanitizedName.bin');
  }

  Future<void> savePreview(String attachmentId, Uint8List bytes) async {
    final file = File(await previewPathForAttachment(attachmentId));
    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes, flush: true);
  }

  Future<Uint8List?> readPreview(String attachmentId) async {
    final file = File(await previewPathForAttachment(attachmentId));
    if (!await file.exists()) {
      return null;
    }

    try {
      return await file.readAsBytes();
    } catch (_) {
      return null;
    }
  }

  Future<void> deletePreview(String attachmentId) async {
    final file = File(await previewPathForAttachment(attachmentId));
    if (await file.exists()) {
      await file.delete();
    }
  }
}
