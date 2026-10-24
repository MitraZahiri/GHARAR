import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' show GoogleAuthProvider;
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gharar/models/auth_result.dart';
import 'package:gharar/models/user_model.dart';
import 'package:gharar/providers/app_state_provider.dart';
import 'package:gharar/services/auth_service.dart';
import 'package:gharar/services/cloud_sync_service.dart';
import 'package:gharar/services/storage_service.dart';

class _FailingCloudSync extends CloudSyncService {
  _FailingCloudSync({required super.firestore, required super.auth});

  @override
  Future<void> saveUser(UserModel user) async =>
      throw const CloudSyncException('permission-denied');
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeFirebaseFirestore db;
  late MockFirebaseAuth auth;
  late AppStateProvider provider;

  Future<AppStateProvider> buildProvider({
    CloudSyncService? cloud,
    AuthService? authService,
  }) async {
    SharedPreferences.setMockInitialValues({});
    return AppStateProvider(
      StorageService(await SharedPreferences.getInstance()),
      cloudSync: cloud ?? CloudSyncService(firestore: db, auth: auth),
      authService: authService,
    );
  }

  void onboard(AppStateProvider p) {
    p.completeOnboarding(
      name: 'Kerem',
      avatar: '🕊️',
      relationshipStage: 'married',
      goals: const ['deep_talks'],
      languageCode: 'tr',
    );
    p.linkPartner(partnerName: 'Elif', avatar: '🌸');
  }

  Future<Map<String, dynamic>?> docData(String path) async =>
      (await db.doc(path).get()).data();

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> children(
    String collection,
  ) async =>
      (await db.collection('couples/${provider.couple!.id}/$collection').get())
          .docs;

  setUp(() async {
    db = FakeFirebaseFirestore();
    auth = MockFirebaseAuth(
      signedIn: true,
      mockUser: MockUser(uid: 'uid_kerem', email: 'kerem@example.com'),
    );
    provider = await buildProvider();
  });

  test('onboarding writes the profile and the couple', () async {
    onboard(provider);
    await pumpEventQueue();

    expect((await docData('users/uid_kerem'))?['name'], 'Kerem');
    final couple = await docData('couples/${provider.couple!.id}');
    expect(couple?['memberUids'], ['uid_kerem']);
    expect(couple?['isLinked'], isTrue);
  });

  test('love notes are written, marked read and deleted', () async {
    onboard(provider);
    provider.postLoveNote(text: 'Good morning');
    await pumpEventQueue();

    final notes = await children('loveNotes');
    expect(notes.single.data()['text'], 'Good morning');

    final id = notes.single.id;
    provider.markLoveNoteAsRead(id);
    await pumpEventQueue();
    expect((await children('loveNotes')).single.data()['isRead'], isTrue);

    await provider.deleteLoveNote(id);
    await pumpEventQueue();
    expect(await children('loveNotes'), isEmpty);
  });

  test('answers, reactions, journal, special dates and moods sync', () async {
    onboard(provider);
    provider.submitAnswer(questionId: 'q_1', answerText: 'Sunsets');
    final answerId = provider.getAnswersForQuestion('q_1').single.id;
    provider.addReactionEmoji('q_1', answerId, '🥰');
    provider.addJournalEntry(title: 'Trip', notes: 'Lovely', moodEmoji: '😊');
    provider.addSpecialDate(
      titleEn: 'First date',
      titleTr: 'İlk buluşma',
      date: DateTime(2027, 2, 14),
      category: 'date',
      icon: '🌹',
    );
    provider.setMyMood('happy');
    await pumpEventQueue();

    final answer = (await children('answers')).single.data();
    expect(answer['answerText'], 'Sunsets');
    expect(answer['reactionEmoji'], '🥰');
    expect((await children('journal')).single.data()['title'], 'Trip');
    expect((await children('specialDates')).single.data()['icon'], '🌹');
    final couple = await docData('couples/${provider.couple!.id}');
    expect((couple?['moods'] as Map).values, contains('happy'));
  });

  test('demo partner simulations stay on the device', () async {
    onboard(provider);
    provider.simulatePartnerAnswer('q_1');
    provider.simulatePartnerLoveNote();
    await pumpEventQueue();

    expect(await children('answers'), isEmpty);
    expect(await children('loveNotes'), isEmpty);
  });

  test('Google sign-in uploads what was saved before it', () async {
    auth = MockFirebaseAuth(
      mockUser: MockUser(uid: 'uid_kerem', email: 'kerem@example.com'),
    );
    provider = await buildProvider(
      authService: AuthService(
        googleSignInOverride: () async {
          await auth.signInWithCredential(
            GoogleAuthProvider.credential(idToken: 'id', accessToken: 'at'),
          );
          return AuthResult.success(
            uid: 'uid_kerem',
            email: 'kerem@example.com',
            displayName: 'Kerem',
            authProvider: 'google',
          );
        },
      ),
    );
    onboard(provider);
    provider.postLoveNote(text: 'Before sign-in');
    await pumpEventQueue();
    expect((await db.collection('couples').get()).docs, isEmpty);

    await provider.signInWithGoogle();
    await pumpEventQueue();

    expect((await docData('users/uid_kerem'))?['name'], 'Kerem');
    expect(
      (await children('loveNotes')).single.data()['text'],
      'Before sign-in',
    );
    // Seed special dates are templates, not the couple's own data.
    expect(await children('specialDates'), isEmpty);
  });

  test('a rejected write is reported instead of swallowed', () async {
    provider = await buildProvider(
      cloud: _FailingCloudSync(firestore: db, auth: auth),
    );
    expect(provider.cloudSyncError, isNull);

    onboard(provider);
    await pumpEventQueue();

    expect(provider.cloudSyncError, 'permission-denied');
  });

  test('without cloud sync the app keeps working locally', () async {
    SharedPreferences.setMockInitialValues({});
    final local = AppStateProvider(
      StorageService(await SharedPreferences.getInstance()),
    );
    onboard(local);
    local.postLoveNote(text: 'Offline');

    expect(local.loveNotes.single.text, 'Offline');
    expect(local.cloudSyncError, isNull);
  });
}
