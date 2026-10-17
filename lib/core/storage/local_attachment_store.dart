import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class LocalAttachmentStore {
  static const String _cacheDirectoryName = 'communication/attachments/thumbnails';
  static const String _publicAlbumName = 'ObywatelPlus';

  Future<String> _directoryForAttachmentKind(String mimeType) async {
    final normalized = mimeType.toLowerCase();

    if (Platform.isAndroid) {
      if (normalized.startsWith('image/')) {
        return _androidPublicDirectory('Pictures/$_publicAlbumName');
      }
      if (normalized.startsWith('video/')) {
        return _androidPublicDirectory('Movies/$_publicAlbumName');
      }
      return _androidPublicDirectory('Download/$_publicAlbumName');
    }

    if (Platform.isIOS) {
      final appSupportDir = await getApplicationDocumentsDirectory();
      final baseDir = Directory(
        p.join(appSupportDir.path, 'Attachments', _publicAlbumName),
      );
      if (!await baseDir.exists()) {
        await baseDir.create(recursive: true);
      }
      return baseDir.path;
    }

    if (Platform.isWindows) {
      final homeDrive = Platform.environment['HOMEDRIVE'] ?? '';
      final homePath = Platform.environment['HOMEPATH'] ?? '';
      final userProfile = Platform.environment['USERPROFILE'] ??
          '$homeDrive$homePath';
      final basePath = userProfile.isEmpty
          ? (await getDownloadsDirectory())?.path ??
              (await getApplicationDocumentsDirectory()).path
          : userProfile;
      final root = Directory(
        p.join(
          basePath,
          normalized.startsWith('image/')
              ? 'Pictures'
              : normalized.startsWith('video/')
                  ? 'Videos'
                  : 'Downloads',
          _publicAlbumName,
        ),
      );
      if (!await root.exists()) {
        await root.create(recursive: true);
      }
      return root.path;
    }

    final tempDir = await getTemporaryDirectory();
    final fallbackDir = Directory(
      p.join(tempDir.path, 'obywatel_plus', 'attachments'),
    );
    if (!await fallbackDir.exists()) {
      await fallbackDir.create(recursive: true);
    }
    return fallbackDir.path;
  }

  Future<String> _androidPublicDirectory(String relativePath) async {
    final basePath = '/storage/emulated/0';
    final directory = Directory(p.join(basePath, relativePath));
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return directory.path;
  }

  String _safeFileName(String attachmentId, String mimeType, {String? fileName}) {
    final raw = fileName?.trim().isNotEmpty == true ? fileName! : attachmentId;
    final sanitized = raw.replaceAll(RegExp(r'[^A-Za-z0-9_.-]'), '_');
    final extension = _extensionForMime(mimeType, fallback: sanitized);
    final baseName = sanitized.contains('.')
        ? sanitized
        : '$sanitized$extension';
    return baseName;
  }

  String _extensionForMime(String mimeType, {String? fallback}) {
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

    final extension = extensionMap[normalized];
    if (extension != null) {
      return extension;
    }

    if (fallback != null && fallback.contains('.')) {
      final dotIndex = fallback.lastIndexOf('.');
      if (dotIndex >= 0 && dotIndex < fallback.length - 1) {
        return fallback.substring(dotIndex);
      }
    }

    return '';
  }

  Future<String> pathForAttachment(
    String attachmentId, {
    required String mimeType,
    String? fileName,
  }) async {
    final normalized = attachmentId.trim();
    if (normalized.isEmpty) {
      throw ArgumentError.value(attachmentId, 'attachmentId');
    }

    final directoryPath = await _directoryForAttachmentKind(mimeType);
    final resolvedFileName = _safeFileName(
      normalized,
      mimeType,
      fileName: fileName,
    );
    return p.join(directoryPath, resolvedFileName);
  }

  Future<String> thumbnailPathForAttachment(String attachmentId) async {
    final normalized = attachmentId.trim();
    if (normalized.isEmpty) {
      throw ArgumentError.value(attachmentId, 'attachmentId');
    }

    final cacheDir = await getTemporaryDirectory();
    final directory = Directory(
      p.join(cacheDir.path, _cacheDirectoryName),
    );
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

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

    final tempFile = File('${file.path}.tmp');
    await tempFile.writeAsBytes(bytes, flush: true);
    await tempFile.rename(file.path);
    return file.path;
  }

  Future<void> saveThumbnail({
    required String attachmentId,
    required Uint8List bytes,
  }) async {
    final file = File(await thumbnailPathForAttachment(attachmentId));
    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes, flush: true);
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
