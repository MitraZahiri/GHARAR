import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gharar/providers/app_state_provider.dart';
import 'package:gharar/services/cloud_sync_service.dart';
import 'package:gharar/services/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeFirebaseFirestore db;
  late AppStateProvider kerem;
  late AppStateProvider elif;

  CloudSyncService cloudFor(String uid) => CloudSyncService(
    firestore: db,
    auth: MockFirebaseAuth(signedIn: true, mockUser: MockUser(uid: uid)),
  );

  Future<AppStateProvider> phone(String uid, String name) async {
    SharedPreferences.setMockInitialValues({});
    final provider = AppStateProvider(
      StorageService(await SharedPreferences.getInstance()),
      cloudSync: cloudFor(uid),
    );
    addTearDown(provider.dispose);
    provider.completeOnboarding(
      name: name,
      avatar: '🌸',
      relationshipStage: 'married',
      goals: const [],
      languageCode: 'en',
    );
    await pumpEventQueue();
    return provider;
  }

  Future<void> pair() async {
    expect(
      await elif.joinPartnerWithCode(kerem.couple!.inviteCode),
      PairingResult.joined,
    );
    await pumpEventQueue();
  }

  setUp(() async {
    db = FakeFirebaseFirestore();
    kerem = await phone('uid_kerem', 'Kerem');
    elif = await phone('uid_elif', 'Elif');
  });

  group('joining', () {
    test('brings the joiner\'s own data into the shared couple', () async {
      elif.postLoveNote(text: 'Written before we paired');
      elif.submitAnswer(questionId: 'q_1', answerText: 'Mountains');
      elif.addJournalEntry(title: 'Solo day', notes: 'Nice', moodEmoji: '🙂');
      elif.setMyMood('calm');
      elif.simulatePartnerLoveNote(customMessage: 'demo only');
      await pumpEventQueue();
      final soloCoupleId = elif.couple!.id;
      final soloCode = elif.couple!.inviteCode;

      await pair();

      expect(
        kerem.latestNoteForActivePartner?.text,
        'Written before we paired',
      );
      expect(kerem.getAnswerForOtherPartner('q_1')?.answerText, 'Mountains');
      expect(kerem.journalEntries.map((e) => e.title), contains('Solo day'));
      expect(kerem.otherPartnerMood, 'calm');
      // Demo notes are not carried over.
      expect(kerem.loveNotes.map((n) => n.text), isNot(contains('demo only')));
      expect(elif.loveNotes.map((n) => n.text), ['Written before we paired']);

      // The joiner's old single-person couple is cleaned up.
      expect((await db.doc('couples/$soloCoupleId').get()).exists, isFalse);
      expect((await db.doc('invites/$soloCode').get()).exists, isFalse);
    });
  });

  group('unlinking', () {
    test('the owner removes the partner; both keep their history', () async {
      await pair();
      elif.postLoveNote(text: 'Shared memory');
      await pumpEventQueue();
      final sharedId = kerem.couple!.id;
      final oldCode = kerem.couple!.inviteCode;

      await kerem.unlinkPartner();
      await pumpEventQueue();

      // Kerem keeps the couple with a fresh code nobody has seen.
      expect(kerem.isPartnerLinked, isFalse);
      expect(kerem.couple!.id, sharedId);
      expect(kerem.couple!.inviteCode, isNot(oldCode));
      expect((await db.doc('couples/$sharedId').get()).data()?['memberUids'], [
        'uid_kerem',
      ]);
      expect(
        (await db.doc('invites/${kerem.couple!.inviteCode}').get()).exists,
        isTrue,
      );

      // Elif's phone notices, keeps the history and starts its own couple.
      expect(elif.isPartnerLinked, isFalse);
      expect(elif.couple!.id, isNot(sharedId));
      expect(elif.couple!.partner1.id, 'uid_elif');
      expect(elif.loveNotes.map((n) => n.text), contains('Shared memory'));
      final elifDoc = await db.doc('couples/${elif.couple!.id}').get();
      expect(elifDoc.data()?['memberUids'], ['uid_elif']);
    });

    test('the joiner can unlink too and keeps the shared couple', () async {
      await pair();
      final sharedId = elif.couple!.id;

      await elif.unlinkPartner();
      await pumpEventQueue();

      expect(elif.couple!.id, sharedId);
      expect(elif.couple!.partner1.id, 'uid_elif');
      expect(elif.isPartnerLinked, isFalse);
      expect(kerem.couple!.id, isNot(sharedId));
      expect(kerem.isPartnerLinked, isFalse);
    });

    test('the old invite code stops working', () async {
      final oldCode = kerem.couple!.inviteCode;
      await pair();
      await kerem.unlinkPartner();
      await pumpEventQueue();

      final mallory = await phone('uid_mallory', 'Mallory');
      expect(
        await mallory.joinPartnerWithCode(oldCode),
        PairingResult.invalidCode,
      );
    });
  });

  group('demo tools', () {
    test('are available before pairing', () {
      expect(kerem.isPairedOnline, isFalse);
      expect(kerem.demoToolsEnabled, isTrue);
    });

    test('are switched off once a real partner joined', () async {
      await pair();

      expect(kerem.isPairedOnline, isTrue);
      expect(kerem.demoToolsEnabled, isFalse);

      final me = kerem.activePartner.id;
      kerem.switchActivePartner();
      expect(kerem.activePartner.id, me);

      final notes = kerem.loveNotes.length;
      kerem.simulatePartnerLoveNote(customMessage: 'fake');
      kerem.simulatePartnerAnswer('q_9');
      await pumpEventQueue();
      expect(kerem.loveNotes.length, notes);
      expect(kerem.getAnswersForQuestion('q_9'), isEmpty);
    });
  });
}
