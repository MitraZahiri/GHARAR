import 'package:flutter_test/flutter_test.dart';
import 'package:gharar/models/love_note_model.dart';

void main() {
  final created = DateTime(2026, 10, 30, 12);
  final opens = DateTime(2026, 11, 29, 12);

  final capsule = LoveNoteModel(
    id: 'note_capsule',
    senderId: 'user_1',
    senderName: 'Kerem',
    receiverId: 'user_2',
    text: 'Open me in a month',
    createdAt: created,
    opensAt: opens,
  );

  test('a note with a future opening date is a sealed time capsule', () {
    expect(capsule.isTimeCapsule, isTrue);
    expect(capsule.isSealedAt(created), isTrue);
    expect(
      capsule.isSealedAt(opens.subtract(const Duration(seconds: 1))),
      isTrue,
    );
    expect(capsule.isSealedAt(opens), isFalse);
  });

  test('an ordinary note is never sealed', () {
    final note = capsule.copyWith(id: 'plain').withoutOpeningDate();
    expect(note.isTimeCapsule, isFalse);
    expect(note.isSealedAt(created), isFalse);
  });

  test('opening date survives JSON and takes part in equality', () {
    final restored = LoveNoteModel.fromJson(capsule.toJson());
    expect(restored, capsule);
    expect(restored.opensAt, opens);
    expect(capsule.copyWith(opensAt: created), isNot(capsule));
  });

  test('older notes without an opening date still load', () {
    final json = capsule.toJson()..remove('opensAt');
    expect(LoveNoteModel.fromJson(json).opensAt, isNull);
  });
}
