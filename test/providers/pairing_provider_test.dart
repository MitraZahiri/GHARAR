import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gharar/models/couple_model.dart';
import 'package:gharar/models/love_note_model.dart';
import 'package:gharar/models/user_model.dart';
import 'package:gharar/providers/app_state_provider.dart';
import 'package:gharar/services/cloud_sync_service.dart';
import 'package:gharar/services/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeFirebaseFirestore db;

  CloudSyncService cloudFor(String uid) => CloudSyncService(
    firestore: db,
    auth: MockFirebaseAuth(signedIn: true, mockUser: MockUser(uid: uid)),
  );

  // Each phone gets its own preferences, like two real devices.
  Future<AppStateProvider> phone({
    CloudSyncService? cloud,
    Map<String, Object> prefs = const {},
  }) async {
    SharedPreferences.setMockInitialValues(Map.of(prefs));
    final provider = AppStateProvider(
      StorageService(await SharedPreferences.getInstance()),
      cloudSync: cloud,
    );
    addTearDown(provider.dispose);
    return provider;
  }

  void onboard(AppStateProvider p, String name) {
    p.completeOnboarding(
      name: name,
      avatar: '🌸',
      relationshipStage: 'married',
      goals: const [],
      languageCode: 'en',
    );
  }

  setUp(() => db = FakeFirebaseFirestore());

  group('owner', () {
    test('onboarding publishes a strong invite code', () async {
      final kerem = await phone(cloud: cloudFor('uid_kerem'));
      onboard(kerem, 'Kerem');
      await pumpEventQueue();

      final code = kerem.couple!.inviteCode;
      expect(CloudSyncService.isStrongInviteCode(code), isTrue);
      final invite = await db.doc('invites/$code').get();
      expect(invite.data()?['coupleId'], kerem.couple!.id);
      expect(kerem.currentUser?.id, 'uid_kerem');
      expect(kerem.canPairOnline, isTrue);
    });

    test('a legacy guessable code is replaced before publishing', () async {
      final legacy = CoupleModel(
        id: 'couple_old',
        partner1: UserModel(
          id: 'user_1',
          name: 'Kerem',
          avatar: '🌸',
          preferredLanguage: 'en',
          relationshipStage: 'married',
          selectedGoals: const [],
          joinedAt: DateTime(2026, 1, 1),
        ),
        inviteCode: 'GHARAR-1234-LOVE',
        anniversaryDate: DateTime(2020, 1, 1),
        connectionStreak: 1,
        isLinked: false,
      );
      SharedPreferences.setMockInitialValues({});
      final storage = StorageService(await SharedPreferences.getInstance());
      await storage.saveCouple(legacy);
      await storage.setHasOnboarded(true);
      final kerem = AppStateProvider(storage, cloudSync: cloudFor('uid_kerem'));
      addTearDown(kerem.dispose);
      await pumpEventQueue();

      final code = kerem.couple!.inviteCode;
      expect(CloudSyncService.isStrongInviteCode(code), isTrue);
      expect((await db.doc('invites/$code').get()).exists, isTrue);
      expect((await db.doc('invites/GHARAR-1234-LOVE').get()).exists, isFalse);
    });
  });

  group('partner joining with a code', () {
    late AppStateProvider kerem;
    late AppStateProvider elif;

    setUp(() async {
      kerem = await phone(cloud: cloudFor('uid_kerem'));
      onboard(kerem, 'Kerem');
      await pumpEventQueue();
      elif = await phone(cloud: cloudFor('uid_elif'));
      onboard(elif, 'Elif');
      await pumpEventQueue();
    });

    test('links both phones to the same couple', () async {
      final result = await elif.joinPartnerWithCode(
        kerem.couple!.inviteCode.toLowerCase(),
      );
      await pumpEventQueue();

      expect(result, PairingResult.joined);
      expect(elif.couple!.id, kerem.couple!.id);
      expect(elif.isPartnerLinked, isTrue);
      expect(elif.activePartner.id, 'uid_elif');
      expect(elif.otherPartnerName, 'Kerem');
      // Kerem's phone hears about it live.
      expect(kerem.isPartnerLinked, isTrue);
      expect(kerem.otherPartnerName, 'Elif');
      expect(kerem.otherPartner.id, 'uid_elif');
    });

    test('notes, answers and moods reach the other phone', () async {
      await elif.joinPartnerWithCode(kerem.couple!.inviteCode);
      await pumpEventQueue();

      elif.postLoveNote(text: 'Miss you');
      kerem.submitAnswer(questionId: 'q_1', answerText: 'Sunsets');
      kerem.setMyMood('happy');
      await pumpEventQueue();

      expect(kerem.latestNoteForActivePartner?.text, 'Miss you');
      expect(elif.getAnswerForOtherPartner('q_1')?.answerText, 'Sunsets');
      expect(elif.otherPartnerMood, 'happy');
    });

    test('a wrong code is reported', () async {
      expect(
        await elif.joinPartnerWithCode('GHARAR-ZZZZZZ'),
        PairingResult.invalidCode,
      );
      expect(elif.couple!.id, isNot(kerem.couple!.id));
    });

    test('your own code is reported', () async {
      expect(
        await kerem.joinPartnerWithCode(kerem.couple!.inviteCode),
        PairingResult.ownCode,
      );
    });
  });

  test('without Google sign-in pairing asks to sign in', () async {
    final offline = await phone();
    onboard(offline, 'Kerem');

    expect(offline.canPairOnline, isFalse);
    expect(
      await offline.joinPartnerWithCode('GHARAR-7K3QX9'),
      PairingResult.needsSignIn,
    );
  });

  test('photo notes keep their local image after a remote update', () async {
    final kerem = await phone(cloud: cloudFor('uid_kerem'));
    onboard(kerem, 'Kerem');
    await pumpEventQueue();
    final coupleId = kerem.couple!.id;

    // A photo note this phone already has, with its image on disk.
    final note = LoveNoteModel(
      id: 'note_photo',
      senderId: 'uid_kerem',
      senderName: 'Kerem',
      receiverId: 'user_2',
      text: '',
      paperColor: 'rose',
      emoji: '📷',
      createdAt: DateTime(2026, 10, 24),
      kind: LoveNoteKind.photo,
      imagePath: '/local/photo.png',
    );
    SharedPreferences.setMockInitialValues({});
    final storage = StorageService(await SharedPreferences.getInstance());
    await storage.setHasOnboarded(true);
    await storage.saveCouple(kerem.couple!);
    await storage.saveLoveNotes([note]);
    final reopened = AppStateProvider(
      storage,
      cloudSync: cloudFor('uid_kerem'),
    );
    addTearDown(reopened.dispose);
    await pumpEventQueue();

    // The cloud copy has no image path; the partner marks it read.
    final remote = await db.doc('couples/$coupleId/loveNotes/note_photo').get();
    expect(remote.data()?.containsKey('imagePath'), isFalse);
    await db.doc('couples/$coupleId/loveNotes/note_photo').update({
      'isRead': true,
    });
    await pumpEventQueue();

    expect(reopened.loveNotes.single.isRead, isTrue);
    expect(reopened.loveNotes.single.imagePath, '/local/photo.png');
  });

  test('local data is not replaced when the first upload fails', () async {
    final kerem = await phone(cloud: _RejectingCloud(db));
    onboard(kerem, 'Kerem');
    kerem.postLoveNote(text: 'Keep me');
    await pumpEventQueue();

    expect(kerem.cloudSyncError, 'permission-denied');
    expect(kerem.loveNotes.single.text, 'Keep me');
  });
}

class _RejectingCloud extends CloudSyncService {
  _RejectingCloud(FakeFirebaseFirestore db)
    : super(
        firestore: db,
        auth: MockFirebaseAuth(
          signedIn: true,
          mockUser: MockUser(uid: 'uid_kerem'),
        ),
      );

  @override
  Future<void> saveCouple(CoupleModel couple) async =>
      throw const CloudSyncException('permission-denied');
}
