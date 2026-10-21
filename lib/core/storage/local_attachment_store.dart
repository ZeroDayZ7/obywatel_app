import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class LocalAttachmentStore {
  static const String _attachmentRootSegment = 'communication/attachments';
  static const String _thumbnailRootSegment = 'communication/thumbnails';
  static const String _temporaryUploadSegment = 'communication/uploads';

  Future<Directory> _privateAttachmentsDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final directory = Directory(
      p.join(appDir.path, _attachmentRootSegment),
    );
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return directory;
  }

  Future<Directory> _thumbnailCacheDirectory() async {
    final tempDir = await getTemporaryDirectory();
    final directory = Directory(
      p.join(tempDir.path, _thumbnailRootSegment),
    );
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return directory;
  }

  Future<Directory> _temporaryUploadDirectory() async {
    final tempDir = await getTemporaryDirectory();
    final directory = Directory(
      p.join(tempDir.path, _temporaryUploadSegment),
    );
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return directory;
  }

  String _storageFileName(String attachmentId, String mimeType) {
    final normalizedId = attachmentId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError.value(attachmentId, 'attachmentId');
    }

    final sanitizedId = normalizedId.replaceAll(RegExp(r'[^A-Za-z0-9_.-]'), '_');
    final extension = _extensionForMime(mimeType);
    if (extension.isEmpty) {
      return sanitizedId;
    }

    return '$sanitizedId$extension';
  }

  String _extensionForMime(String mimeType) {
    final normalized = mimeType.toLowerCase();
    final extensionMap = {
      'image/jpeg': '.jpg',
      'image/png': '.png',
      'image/webp': '.webp',
      'image/gif': '.gif',
      'video/mp4': '.mp4',
      'video/quicktime': '.mov',
      'application/pdf': '.pdf',
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document':
          '.docx',
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet':
          '.xlsx',
      'application/vnd.openxmlformats-officedocument.presentationml.presentation':
          '.pptx',
      'text/plain': '.txt',
    };

    return extensionMap[normalized] ?? '';
  }

  Future<String> temporaryAttachmentPath(
    String attachmentId, {
    required String mimeType,
    String? fileName,
  }) async {
    final directory = await _temporaryUploadDirectory();
    final basename = _storageFileName(attachmentId, mimeType);
    return p.join(directory.path, basename);
  }

  Future<String> pathForAttachment(
    String attachmentId, {
    required String mimeType,
    String? fileName,
  }) async {
    final directory = await _privateAttachmentsDirectory();
    final basename = _storageFileName(attachmentId, mimeType);
    return p.join(directory.path, basename);
  }

  Future<String> thumbnailPathForAttachment(String attachmentId) async {
    final normalized = attachmentId.trim();
    if (normalized.isEmpty) {
      throw ArgumentError.value(attachmentId, 'attachmentId');
    }

    final directory = await _thumbnailCacheDirectory();
    final sanitized = normalized.replaceAll(RegExp(r'[^A-Za-z0-9_.-]'), '_');
    return p.join(directory.path, '$sanitized.thumb');
  }

  Future<String> saveAttachment({
    required String attachmentId,
    required Uint8List bytes,
    required String mimeType,
    String? fileName,
  }) async {
    if (bytes.isEmpty) {
      throw ArgumentError.value(bytes, 'bytes', 'Attachment bytes cannot be empty');
    }

    final file = File(
      await pathForAttachment(
        attachmentId,
        mimeType: mimeType,
        fileName: fileName,
      ),
    );
    await file.parent.create(recursive: true);

    final tempFile = File(
      p.join(
        file.parent.path,
        '.${p.basenameWithoutExtension(file.path)}.${DateTime.now().microsecondsSinceEpoch}.tmp',
      ),
    );

    await tempFile.writeAsBytes(bytes, flush: true);
    if (await file.exists()) {
      await file.delete();
    }
    await tempFile.rename(file.path);
    return file.path;
  }

  Future<Uint8List> _generateThumbnailBytes(
    Uint8List bytes, {
    int maxWidth = 240,
    int maxHeight = 260,
  }) async {
    try {
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final image = frame.image;

      if (image.width <= 0 || image.height <= 0) {
        return bytes;
      }

      final imageWidth = image.width.toDouble();
      final imageHeight = image.height.toDouble();
      final scale = (maxWidth / imageWidth).clamp(0.0, 1.0) <
              (maxHeight / imageHeight).clamp(0.0, 1.0)
          ? (maxWidth / imageWidth).clamp(0.0, 1.0)
          : (maxHeight / imageHeight).clamp(0.0, 1.0);

      final targetWidth = (imageWidth * scale).round();
      final targetHeight = (imageHeight * scale).round();
      final recorder = ui.PictureRecorder();
      final canvas = ui.Canvas(recorder);
      final srcRect = ui.Rect.fromLTWH(
        0,
        0,
        imageWidth,
        imageHeight,
      );
      final dstRect = ui.Rect.fromLTWH(
        0,
        0,
        targetWidth.toDouble(),
        targetHeight.toDouble(),
      );

      canvas.drawImageRect(image, srcRect, dstRect, ui.Paint());

      final picture = recorder.endRecording();
      final resized = await picture.toImage(targetWidth, targetHeight);
      final pngBytes = await resized.toByteData(format: ui.ImageByteFormat.png);
      if (pngBytes != null && pngBytes.lengthInBytes > 0) {
        return pngBytes.buffer.asUint8List();
      }
    } catch (_) {
      // Fallback to the original bytes only when the payload is not a valid image.
    }

    return bytes;
  }

  Future<void> saveThumbnail({
    required String attachmentId,
    required Uint8List bytes,
  }) async {
    final file = File(await thumbnailPathForAttachment(attachmentId));
    await file.parent.create(recursive: true);

    final tempFile = File(
      p.join(
        file.parent.path,
        '.${p.basenameWithoutExtension(file.path)}.${DateTime.now().microsecondsSinceEpoch}.tmp',
      ),
    );

    final thumbnailBytes = await _generateThumbnailBytes(bytes);
    await tempFile.writeAsBytes(thumbnailBytes, flush: true);
    if (await file.exists()) {
      await file.delete();
    }
    await tempFile.rename(file.path);
  }

  Future<Uint8List?> readAttachment({
    required String attachmentId,
    required String mimeType,
    String? fileName,
  }) async {
    final file = File(
      await pathForAttachment(
        attachmentId,
        mimeType: mimeType,
        fileName: fileName,
      ),
    );
    if (!await file.exists()) {
      return null;
    }

    try {
      return await file.readAsBytes();
    } catch (_) {
      return null;
    }
  }

  Future<Uint8List?> readThumbnail(String attachmentId) async {
    final file = File(await thumbnailPathForAttachment(attachmentId));
    if (!await file.exists()) {
      return null;
    }

    try {
      return await file.readAsBytes();
    } catch (_) {
      return null;
    }
  }

  Future<void> deleteAttachment({
    required String attachmentId,
    required String mimeType,
    String? fileName,
  }) async {
    final file = File(
      await pathForAttachment(
        attachmentId,
        mimeType: mimeType,
        fileName: fileName,
      ),
    );
    if (await file.exists()) {
      await file.delete();
    }

    final thumbnail = File(await thumbnailPathForAttachment(attachmentId));
    if (await thumbnail.exists()) {
      await thumbnail.delete();
    }
  }
}
