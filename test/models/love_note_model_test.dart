import 'package:flutter_test/flutter_test.dart';
import 'package:gharar/models/love_note_model.dart';

void main() {
  group('LoveNoteModel Strict Equality, copyWith, and JSON Tests', () {
    final now = DateTime(2026, 10, 20, 9, 30);

    final note1 = LoveNoteModel(
      id: 'note_1',
      senderId: 'user_1',
      senderName: 'Kerem',
      receiverId: 'user_2',
      text: 'Bugün toplantın harika geçecek, aklımdasın! 💖',
      paperColor: 'rose',
      emoji: '💌',
      createdAt: now,
      isRead: false,
    );

    final note2 = LoveNoteModel(
      id: 'note_1',
      senderId: 'user_1',
      senderName: 'Kerem',
      receiverId: 'user_2',
      text: 'Bugün toplantın harika geçecek, aklımdasın! 💖',
      paperColor: 'rose',
      emoji: '💌',
      createdAt: now,
      isRead: false,
    );

    test('Strict value equality and hashCode consistency', () {
      expect(note1, equals(note2));
      expect(note1.hashCode, equals(note2.hashCode));
    });

    test('copyWith produces expected updated immutable object', () {
      final readNote = note1.copyWith(isRead: true, readAt: now);
      expect(readNote, isNot(equals(note1)));
      expect(readNote.isRead, isTrue);
      expect(readNote.readAt, equals(now));
      expect(note1.isRead, isFalse); // immutability intact
    });

    test('toJson and fromJson bidirectional fidelity', () {
      final json = note1.toJson();
      final revived = LoveNoteModel.fromJson(json);
      expect(revived, equals(note1));
      expect(revived.text, 'Bugün toplantın harika geçecek, aklımdasın! 💖');
      expect(revived.paperColor, 'rose');
    });

    test('text notes default to text kind without an image', () {
      expect(note1.kind, LoveNoteKind.text);
      expect(note1.imagePath, isNull);
      expect(note1.hasImage, isFalse);
    });

    test('drawing and photo notes survive a JSON round trip', () {
      final drawing = note1.copyWith(
        kind: LoveNoteKind.drawing,
        imagePath: '/data/note_media/n1.png',
        text: '',
      );
      final revived = LoveNoteModel.fromJson(drawing.toJson());
      expect(revived, equals(drawing));
      expect(revived.kind, LoveNoteKind.drawing);
      expect(revived.imagePath, '/data/note_media/n1.png');
      expect(revived.hasImage, isTrue);
      expect(revived, isNot(equals(note1)));
    });

    test('legacy JSON without kind falls back to a text note', () {
      final legacy =
          note1.toJson()
            ..remove('kind')
            ..remove('imagePath');
      final revived = LoveNoteModel.fromJson(legacy);
      expect(revived.kind, LoveNoteKind.text);
      expect(revived.imagePath, isNull);
    });

    test('unknown kind string falls back to text', () {
      final json = note1.toJson()..['kind'] = 'hologram';
      expect(LoveNoteModel.fromJson(json).kind, LoveNoteKind.text);
    });
  });
}
