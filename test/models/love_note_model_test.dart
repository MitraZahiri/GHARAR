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
  });
}
