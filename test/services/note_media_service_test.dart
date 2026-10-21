import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:gharar/services/note_media_service.dart';

void main() {
  late Directory tempDir;
  late NoteMediaService service;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('gharar_media_test');
    service = NoteMediaService(baseDirectory: () async => tempDir);
  });

  tearDown(() async {
    if (await tempDir.exists()) await tempDir.delete(recursive: true);
  });

  test('saveBytes writes inside the note_media folder', () async {
    final path = await service.saveBytes(
      Uint8List.fromList([1, 2, 3]),
      extension: 'png',
    );

    expect(path, contains('note_media'));
    expect(path, endsWith('.png'));
    expect(await File(path).readAsBytes(), [1, 2, 3]);
  });

  test('importFile copies the picked photo', () async {
    final source = File('${tempDir.path}/picked.jpg')..writeAsBytesSync([7, 7]);

    final path = await service.importFile(source.path);

    expect(path, isNot(source.path));
    expect(path, endsWith('.jpg'));
    expect(await File(path).readAsBytes(), [7, 7]);
  });

  test('importFile reports a missing source as a domain error', () async {
    expect(
      () => service.importFile('${tempDir.path}/missing.jpg'),
      throwsA(isA<NoteMediaException>()),
    );
  });

  test('delete removes owned files and ignores paths outside', () async {
    final owned = await service.saveBytes(
      Uint8List.fromList([1]),
      extension: 'png',
    );
    final outside = File('${tempDir.path}/keep.txt')..writeAsStringSync('x');

    await service.delete(owned);
    await service.delete(outside.path);

    expect(File(owned).existsSync(), isFalse);
    expect(outside.existsSync(), isTrue);
  });
}
