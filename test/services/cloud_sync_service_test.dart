import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gharar/models/couple_model.dart';
import 'package:gharar/models/journal_entry_model.dart';
import 'package:gharar/models/love_note_model.dart';
import 'package:gharar/models/question_model.dart';
import 'package:gharar/models/special_date_model.dart';
import 'package:gharar/models/user_model.dart';
import 'package:gharar/services/cloud_sync_service.dart';

void main() {
  late FakeFirebaseFirestore db;
  late MockFirebaseAuth auth;
  late CloudSyncService sync;

  final user = UserModel(
    id: 'user_1',
    name: 'Kerem',
    avatar: '🕊️',
    preferredLanguage: 'tr',
    relationshipStage: 'married',
    selectedGoals: const ['deep_talks'],
    joinedAt: DateTime(2026, 10, 1),
    email: 'kerem@example.com',
    authProvider: 'google',
  );
  final couple = CoupleModel(
    id: 'couple_1',
    partner1: user,
    inviteCode: 'GHARAR-1234-LOVE',
    anniversaryDate: DateTime(2020, 5, 1),
    connectionStreak: 3,
    isLinked: false,
  );

  setUp(() {
    db = FakeFirebaseFirestore();
    auth = MockFirebaseAuth(
      signedIn: true,
      mockUser: MockUser(uid: 'uid_kerem', email: 'kerem@example.com'),
    );
    sync = CloudSyncService(firestore: db, auth: auth);
  });

  test('is inactive without a signed-in Firebase user', () async {
    final signedOut = CloudSyncService(firestore: db, auth: MockFirebaseAuth());
    expect(signedOut.isActive, isFalse);

    await signedOut.saveUser(user);
    expect((await db.collection('users').get()).docs, isEmpty);
  });

  test('saveUser writes the profile under the auth uid', () async {
    expect(sync.isActive, isTrue);
    await sync.saveUser(user);

    final doc = await db.doc('users/uid_kerem').get();
    expect(doc.data()?['name'], 'Kerem');
    expect(doc.data()?['email'], 'kerem@example.com');
    expect(doc.data()?['updatedAt'], isNotNull);
  });

  test('saveCouple adds the signed-in uid to memberUids once', () async {
    await sync.saveCouple(couple);
    await sync.saveCouple(couple.copyWith(connectionStreak: 4));

    final doc = await db.doc('couples/couple_1').get();
    expect(doc.data()?['memberUids'], ['uid_kerem']);
    expect(doc.data()?['connectionStreak'], 4);
    expect(doc.data()?['inviteCode'], 'GHARAR-1234-LOVE');
  });

  test('saveLoveNote stores the note without its local image path', () async {
    final note = LoveNoteModel(
      id: 'note_1',
      senderId: 'user_1',
      senderName: 'Kerem',
      receiverId: 'user_2',
      text: 'Hi',
      paperColor: 'rose',
      emoji: '💌',
      createdAt: DateTime(2026, 10, 24),
      kind: LoveNoteKind.photo,
      imagePath: '/data/user/0/com.gharar.gharar/files/notes/a.png',
    );
    await sync.saveLoveNote('couple_1', note);

    final doc = await db.doc('couples/couple_1/loveNotes/note_1').get();
    expect(doc.data()?['text'], 'Hi');
    expect(doc.data()?.containsKey('imagePath'), isFalse);

    await sync.deleteLoveNote('couple_1', 'note_1');
    expect(
      (await db.doc('couples/couple_1/loveNotes/note_1').get()).exists,
      isFalse,
    );
  });

  test('saves answers, journal entries, special dates and moods', () async {
    await sync.saveAnswer(
      'couple_1',
      AnswerModel(
        id: 'ans_1',
        questionId: 'q_1',
        authorId: 'user_1',
        authorName: 'Kerem',
        answerText: 'Sunsets',
        answeredAt: DateTime(2026, 10, 24),
      ),
    );
    await sync.saveJournalEntry(
      'couple_1',
      JournalEntryModel(
        id: 'journal_1',
        title: 'Trip',
        notes: 'Lovely',
        authorId: 'user_1',
        authorName: 'Kerem',
        date: DateTime(2026, 10, 24),
        moodEmoji: '😊',
      ),
    );
    await sync.saveSpecialDate(
      'couple_1',
      SpecialDateModel(
        id: 'sd_1',
        titleEn: 'Anniversary',
        titleTr: 'Yıldönümü',
        date: DateTime(2027, 5, 1),
        category: 'anniversary',
        icon: '💍',
      ),
    );
    await sync.saveMoods('couple_1', {'user_1': 'happy'});

    expect(
      (await db.doc('couples/couple_1/answers/ans_1').get())
          .data()?['questionId'],
      'q_1',
    );
    expect(
      (await db.doc('couples/couple_1/journal/journal_1').get())
          .data()?['title'],
      'Trip',
    );
    expect(
      (await db.doc('couples/couple_1/specialDates/sd_1').get())
          .data()?['icon'],
      '💍',
    );
    expect((await db.doc('couples/couple_1').get()).data()?['moods'], {
      'user_1': 'happy',
    });
  });
}
