import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gharar/models/couple_model.dart';
import 'package:gharar/models/love_note_model.dart';
import 'package:gharar/models/question_model.dart';
import 'package:gharar/models/user_model.dart';
import 'package:gharar/services/cloud_sync_service.dart';

UserModel person(String id, String name) => UserModel(
  id: id,
  name: name,
  avatar: '🌸',
  preferredLanguage: 'en',
  relationshipStage: 'married',
  selectedGoals: const [],
  joinedAt: DateTime(2026, 10, 1),
);

void main() {
  late FakeFirebaseFirestore db;
  late CloudSyncService owner;
  late CloudSyncService joiner;

  final couple = CoupleModel(
    id: 'couple_1',
    partner1: person('uid_kerem', 'Kerem'),
    inviteCode: 'GHARAR-7K3QX9',
    anniversaryDate: DateTime(2020, 5, 1),
    connectionStreak: 1,
    isLinked: false,
  );

  CloudSyncService serviceFor(String uid) => CloudSyncService(
    firestore: db,
    auth: MockFirebaseAuth(signedIn: true, mockUser: MockUser(uid: uid)),
  );

  setUp(() {
    db = FakeFirebaseFirestore();
    owner = serviceFor('uid_kerem');
    joiner = serviceFor('uid_elif');
  });

  group('invite codes', () {
    test('generated codes are long and unambiguous', () {
      final codes = List.generate(50, (_) => CloudSyncService.newInviteCode());
      for (final code in codes) {
        expect(code, matches(RegExp(r'^GHARAR-[A-HJ-NP-Z2-9]{6}$')));
        expect(CloudSyncService.isStrongInviteCode(code), isTrue);
      }
      expect(codes.toSet().length, greaterThan(45));
    });

    test('legacy 4-digit codes are not strong', () {
      expect(CloudSyncService.isStrongInviteCode('GHARAR-1234-LOVE'), isFalse);
    });

    test('normalizes what people type or paste', () {
      expect(
        CloudSyncService.normalizeInviteCode('  gharar-7k3qx9 '),
        'GHARAR-7K3QX9',
      );
      expect(
        CloudSyncService.normalizeInviteCode('GHARAR 7K3 QX9'),
        'GHARAR-7K3QX9',
      );
      expect(CloudSyncService.normalizeInviteCode('7k3qx9'), 'GHARAR-7K3QX9');
    });
  });

  group('registerInvite', () {
    test('stores the couple and an invite pointing to it', () async {
      await owner.registerInvite(couple);

      final invite = await db.doc('invites/GHARAR-7K3QX9').get();
      expect(invite.data()?['coupleId'], 'couple_1');
      expect(invite.data()?['ownerUid'], 'uid_kerem');
      expect((await db.doc('couples/couple_1').get()).exists, isTrue);
    });
  });

  group('joinCouple', () {
    test('adds the joiner as the second member and partner', () async {
      await owner.registerInvite(couple);

      final joined = await joiner.joinCouple(
        'gharar-7k3qx9',
        person('uid_elif', 'Elif'),
      );

      expect(joined.id, 'couple_1');
      expect(joined.isLinked, isTrue);
      expect(joined.partner1.name, 'Kerem');
      expect(joined.partner2?.id, 'uid_elif');
      final doc = (await db.doc('couples/couple_1').get()).data();
      expect(doc?['memberUids'], ['uid_kerem', 'uid_elif']);
      expect(doc?['joinCode'], 'GHARAR-7K3QX9');
      // The used invite is removed.
      expect((await db.doc('invites/GHARAR-7K3QX9').get()).exists, isFalse);
    });

    test('an unknown code fails with invite-not-found', () async {
      expect(
        () => joiner.joinCouple('GHARAR-AAAAAA', person('uid_elif', 'Elif')),
        throwsA(
          isA<CloudSyncException>().having(
            (e) => e.code,
            'code',
            CloudSyncException.inviteNotFound,
          ),
        ),
      );
    });

    test('your own code fails with own-invite', () async {
      await owner.registerInvite(couple);
      expect(
        () => owner.joinCouple('GHARAR-7K3QX9', person('uid_kerem', 'Kerem')),
        throwsA(
          isA<CloudSyncException>().having(
            (e) => e.code,
            'code',
            CloudSyncException.ownInvite,
          ),
        ),
      );
    });

    // A third person joining a full couple is refused by the security rules
    // (see firestore-tests/rules.test.js); here the used invite is gone.
    test('a used invite cannot be used again', () async {
      await owner.registerInvite(couple);
      await joiner.joinCouple('GHARAR-7K3QX9', person('uid_elif', 'Elif'));

      expect(
        () => serviceFor(
          'uid_mallory',
        ).joinCouple('GHARAR-7K3QX9', person('uid_mallory', 'M')),
        throwsA(
          isA<CloudSyncException>().having(
            (e) => e.code,
            'code',
            CloudSyncException.inviteNotFound,
          ),
        ),
      );
    });

    test('requires a signed-in user', () async {
      final signedOut = CloudSyncService(
        firestore: db,
        auth: MockFirebaseAuth(),
      );
      expect(
        () => signedOut.joinCouple('GHARAR-7K3QX9', person('x', 'X')),
        throwsA(
          isA<CloudSyncException>().having(
            (e) => e.code,
            'code',
            CloudSyncException.notSignedIn,
          ),
        ),
      );
    });
  });

  group('watching', () {
    test('watchCouple emits the couple, member count and moods', () async {
      await owner.registerInvite(couple);
      await owner.saveMoods('couple_1', {'uid_kerem': 'happy'});

      final remote = await owner.watchCouple('couple_1').first;

      expect(remote?.couple.partner1.name, 'Kerem');
      expect(remote?.memberCount, 1);
      expect(remote?.moods, {'uid_kerem': 'happy'});
    });

    test('a partner sees notes and answers written by the other', () async {
      await owner.registerInvite(couple);
      await joiner.joinCouple('GHARAR-7K3QX9', person('uid_elif', 'Elif'));

      final notes = owner.watchLoveNotes('couple_1');
      final answers = owner.watchAnswers('couple_1');
      await joiner.saveLoveNote(
        'couple_1',
        LoveNoteModel(
          id: 'note_1',
          senderId: 'uid_elif',
          senderName: 'Elif',
          receiverId: 'uid_kerem',
          text: 'Miss you',
          paperColor: 'rose',
          emoji: '💌',
          createdAt: DateTime(2026, 10, 24),
        ),
      );
      await joiner.saveAnswer(
        'couple_1',
        AnswerModel(
          id: 'ans_1',
          questionId: 'q_1',
          authorId: 'uid_elif',
          authorName: 'Elif',
          answerText: 'Sunsets',
          answeredAt: DateTime(2026, 10, 24),
        ),
      );

      expect((await notes.first).single.text, 'Miss you');
      expect((await answers.first).single.answerText, 'Sunsets');
      expect(await owner.watchJournal('couple_1').first, isEmpty);
      expect(await owner.watchSpecialDates('couple_1').first, isEmpty);
    });
  });

  group('leaving and cleanup', () {
    test('watchCouple lists the member uids', () async {
      await owner.registerInvite(couple);
      await joiner.joinCouple('GHARAR-7K3QX9', person('uid_elif', 'Elif'));

      final remote = await owner.watchCouple('couple_1').first;

      expect(remote?.memberUids, ['uid_kerem', 'uid_elif']);
    });

    test('removePartner leaves only the caller in the couple', () async {
      await owner.registerInvite(couple);
      await joiner.joinCouple('GHARAR-7K3QX9', person('uid_elif', 'Elif'));

      await joiner.removePartner(
        CoupleModel(
          id: 'couple_1',
          partner1: person('uid_elif', 'Elif'),
          inviteCode: 'GHARAR-NEW222',
          anniversaryDate: DateTime(2020, 5, 1),
          connectionStreak: 1,
          isLinked: false,
        ),
      );

      final doc = (await db.doc('couples/couple_1').get()).data();
      expect(doc?['memberUids'], ['uid_elif']);
      expect(doc?['partner1']['id'], 'uid_elif');
      expect(doc?['partner2'], isNull);
      expect(doc?['isLinked'], isFalse);
      expect(doc?['inviteCode'], 'GHARAR-NEW222');
    });

    test('deleteSoloCouple removes the couple, its data and invite', () async {
      await owner.registerInvite(couple);
      await owner.saveLoveNote(
        'couple_1',
        LoveNoteModel(
          id: 'note_1',
          senderId: 'uid_kerem',
          senderName: 'Kerem',
          receiverId: 'user_2',
          text: 'Hi',
          paperColor: 'rose',
          emoji: '💌',
          createdAt: DateTime(2026, 10, 24),
        ),
      );

      await owner.deleteSoloCouple('couple_1', 'GHARAR-7K3QX9');

      expect((await db.doc('couples/couple_1').get()).exists, isFalse);
      expect(
        (await db.collection('couples/couple_1/loveNotes').get()).docs,
        isEmpty,
      );
      expect((await db.doc('invites/GHARAR-7K3QX9').get()).exists, isFalse);
    });
  });
}
