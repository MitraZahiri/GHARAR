import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

/// Raised when a drawing or photo for a love note cannot be stored.
class NoteMediaException implements Exception {
  final String reason;

  const NoteMediaException(this.reason);

  @override
  String toString() => 'NoteMediaException: $reason';
}

/// Stores love-note drawings and photos in the app's private documents folder.
///
/// Files live in `<documents>/note_media/`, which is sandboxed per app but not
/// encrypted (see rules/dart/security.md §3 for the planned migration).
class NoteMediaService {
  static const _folderName = 'note_media';

  final Future<Directory> Function() _baseDirectory;

  NoteMediaService({Future<Directory> Function()? baseDirectory})
    : _baseDirectory = baseDirectory ?? getApplicationDocumentsDirectory;

  Future<Directory> _mediaDirectory() async {
    final base = await _baseDirectory();
    final dir = Directory('${base.path}${Platform.pathSeparator}$_folderName');
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  String _newFileName(String extension) =>
      'note_${DateTime.now().microsecondsSinceEpoch}.$extension';

  Future<String> saveBytes(Uint8List bytes, {required String extension}) async {
    try {
      final dir = await _mediaDirectory();
      final file = File(
        '${dir.path}${Platform.pathSeparator}${_newFileName(extension)}',
      );
      await file.writeAsBytes(bytes, flush: true);
      return file.path;
    } on FileSystemException catch (e) {
      throw NoteMediaException('write failed (${e.osError?.errorCode})');
    }
  }

  Future<String> importFile(String sourcePath) async {
    final source = File(sourcePath);
    if (!await source.exists()) {
      throw const NoteMediaException('source missing');
    }
    final dot = sourcePath.lastIndexOf('.');
    final extension =
        dot == -1 ? 'jpg' : sourcePath.substring(dot + 1).toLowerCase();
    try {
      final dir = await _mediaDirectory();
      final copy = await source.copy(
        '${dir.path}${Platform.pathSeparator}${_newFileName(extension)}',
      );
      return copy.path;
    } on FileSystemException catch (e) {
      throw NoteMediaException('copy failed (${e.osError?.errorCode})');
    }
  }

  /// Deletes [path] only when it belongs to the note_media folder.
  Future<void> delete(String path) async {
    final dir = await _mediaDirectory();
    if (!File(path).absolute.path.startsWith(dir.absolute.path)) return;
    final file = File(path);
    if (await file.exists()) await file.delete();
  }
}
