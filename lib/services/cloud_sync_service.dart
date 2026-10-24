import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/couple_model.dart';
import '../models/journal_entry_model.dart';
import '../models/love_note_model.dart';
import '../models/question_model.dart';
import '../models/special_date_model.dart';
import '../models/user_model.dart';

/// Thrown when a write to Firestore is rejected (rules, network, quota).
class CloudSyncException implements Exception {
  final String code;
  const CloudSyncException(this.code);

  static const notSignedIn = 'not-signed-in';
  static const inviteNotFound = 'invite-not-found';
  static const ownInvite = 'own-invite';
  static const coupleFull = 'couple-full';

  @override
  String toString() => 'CloudSyncException($code)';
}

/// The couple document as stored in Firestore.
class RemoteCouple {
  final CoupleModel couple;
  final List<String> memberUids;
  final Map<String, String> moods;

  const RemoteCouple({
    required this.couple,
    required this.memberUids,
    required this.moods,
  });

  int get memberCount => memberUids.length;
}

/// Mirrors local data to Cloud Firestore for the signed-in Firebase user.
///
/// Layout:
/// - `users/{uid}`: the user's own profile
/// - `couples/{coupleId}`: couple fields, `memberUids` and `moods`
/// - `couples/{coupleId}/{answers|loveNotes|journal|specialDates}/{id}`
/// - `invites/{code}`: points a partner's invite code at a couple
///
/// Every write is a no-op while no Firebase user is signed in.
class CloudSyncService {
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  CloudSyncService({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  }) : _db = firestore,
       _auth = auth;

  String? get _uid => _auth.currentUser?.uid;
  String? get uid => _uid;
  bool get isActive => _uid != null;

  // No 0/O or 1/I, so codes survive being read aloud or retyped.
  static const _codeAlphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  static final _strongCode = RegExp(r'^GHARAR-[A-HJ-NP-Z2-9]{6}$');

  /// A fresh invite code such as `GHARAR-7K3QX9` (32^6 combinations).
  static String newInviteCode() {
    final random = Random.secure();
    final suffix =
        List.generate(
          6,
          (_) => _codeAlphabet[random.nextInt(_codeAlphabet.length)],
        ).join();
    return 'GHARAR-$suffix';
  }

  /// False for the old guessable `GHARAR-1234-LOVE` codes.
  static bool isStrongInviteCode(String code) => _strongCode.hasMatch(code);

  /// Accepts `gharar-7k3qx9`, `GHARAR 7K3 QX9` or just `7k3qx9`.
  static String normalizeInviteCode(String input) {
    var body = input.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
    if (body.startsWith('GHARAR')) body = body.substring('GHARAR'.length);
    return 'GHARAR-$body';
  }

  DocumentReference<Map<String, dynamic>> _couple(String coupleId) =>
      _db.collection('couples').doc(coupleId);

  Future<void> saveUser(UserModel user) async {
    final uid = _uid;
    if (uid == null) return;
    await _write(
      () => _db.collection('users').doc(uid).set({
        ...user.toJson(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true)),
    );
  }

  Future<void> saveCouple(CoupleModel couple) async {
    final uid = _uid;
    if (uid == null) return;
    await _write(
      () => _couple(couple.id).set({
        ...couple.toJson(),
        'memberUids': FieldValue.arrayUnion([uid]),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true)),
    );
  }

  Future<void> saveMoods(String coupleId, Map<String, String> moods) async {
    if (!isActive) return;
    await _write(
      () => _couple(coupleId).set({'moods': moods}, SetOptions(merge: true)),
    );
  }

  Future<void> saveLoveNote(String coupleId, LoveNoteModel note) {
    // The image lives on this device only; its file path means nothing remotely.
    final json = note.toJson()..remove('imagePath');
    return _saveChild(coupleId, 'loveNotes', note.id, json);
  }

  Future<void> deleteLoveNote(String coupleId, String noteId) async {
    if (!isActive) return;
    await _write(
      () => _couple(coupleId).collection('loveNotes').doc(noteId).delete(),
    );
  }

  Future<void> saveAnswer(String coupleId, AnswerModel answer) =>
      _saveChild(coupleId, 'answers', answer.id, answer.toJson());

  Future<void> saveJournalEntry(String coupleId, JournalEntryModel entry) =>
      _saveChild(coupleId, 'journal', entry.id, entry.toJson());

  Future<void> saveSpecialDate(String coupleId, SpecialDateModel date) =>
      _saveChild(coupleId, 'specialDates', date.id, date.toJson());

  /// Saves [couple] and publishes its invite code so a partner can join.
  Future<void> registerInvite(CoupleModel couple) async {
    final uid = _uid;
    if (uid == null) return;
    await saveCouple(couple);
    await _write(
      () => _db.collection('invites').doc(couple.inviteCode).set({
        'coupleId': couple.id,
        'ownerUid': uid,
        'createdAt': FieldValue.serverTimestamp(),
      }),
    );
  }

  /// Joins the couple behind [code] as its second member, with [me] as
  /// partner2, and returns the shared couple.
  Future<CoupleModel> joinCouple(String code, UserModel me) async {
    final uid = _uid;
    if (uid == null) {
      throw const CloudSyncException(CloudSyncException.notSignedIn);
    }
    final normalized = normalizeInviteCode(code);
    try {
      final invite = await _db.collection('invites').doc(normalized).get();
      final coupleId = invite.data()?['coupleId'] as String?;
      if (coupleId == null) {
        throw const CloudSyncException(CloudSyncException.inviteNotFound);
      }
      if (invite.data()?['ownerUid'] == uid) {
        throw const CloudSyncException(CloudSyncException.ownInvite);
      }
      try {
        await _couple(coupleId).update({
          'memberUids': FieldValue.arrayUnion([uid]),
          'joinCode': normalized,
          'partner2': me.toJson(),
          'isLinked': true,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } on FirebaseException catch (e) {
        // The rules only let a newcomer in while the couple has one member.
        if (e.code == 'permission-denied') {
          throw const CloudSyncException(CloudSyncException.coupleFull);
        }
        rethrow;
      }
      await invite.reference.delete();
      final joined = await _couple(coupleId).get();
      return CoupleModel.fromJson(joined.data()!);
    } on FirebaseException catch (e) {
      throw CloudSyncException(e.code);
    }
  }

  /// Removes the other partner: afterwards only the caller is a member and
  /// [updated] (caller as partner1, a fresh invite code) is the couple.
  Future<void> removePartner(CoupleModel updated) async {
    final uid = _uid;
    if (uid == null) return;
    await _write(
      () => _couple(updated.id).update({
        ...updated.toJson(),
        'memberUids': [uid],
        'updatedAt': FieldValue.serverTimestamp(),
      }),
    );
  }

  /// Deletes a couple only the caller belongs to, with its data and invite,
  /// e.g. the single-person couple left behind after joining a partner.
  Future<void> deleteSoloCouple(String coupleId, String inviteCode) async {
    if (!isActive) return;
    await _write(() async {
      final couple = _couple(coupleId);
      for (final collection in _coupleCollections) {
        final docs = await couple.collection(collection).get();
        await Future.wait(docs.docs.map((doc) => doc.reference.delete()));
      }
      final invite = _db.collection('invites').doc(inviteCode);
      if ((await invite.get()).exists) await invite.delete();
      await couple.delete();
    });
  }

  static const _coupleCollections = [
    'answers',
    'loveNotes',
    'journal',
    'specialDates',
  ];

  Stream<RemoteCouple?> watchCouple(String coupleId) => _couple(coupleId)
      .snapshots()
      .map((snapshot) {
        final data = snapshot.data();
        if (data == null) return null;
        return RemoteCouple(
          couple: CoupleModel.fromJson(data),
          memberUids: List<String>.from(
            data['memberUids'] as List? ?? const [],
          ),
          moods: Map<String, String>.from(data['moods'] as Map? ?? const {}),
        );
      })
      .transform(_cloudErrors());

  Stream<List<LoveNoteModel>> watchLoveNotes(String coupleId) =>
      _watchChildren(coupleId, 'loveNotes', LoveNoteModel.fromJson);

  Stream<List<AnswerModel>> watchAnswers(String coupleId) =>
      _watchChildren(coupleId, 'answers', AnswerModel.fromJson);

  Stream<List<JournalEntryModel>> watchJournal(String coupleId) =>
      _watchChildren(coupleId, 'journal', JournalEntryModel.fromJson);

  Stream<List<SpecialDateModel>> watchSpecialDates(String coupleId) =>
      _watchChildren(coupleId, 'specialDates', SpecialDateModel.fromJson);

  Stream<List<T>> _watchChildren<T>(
    String coupleId,
    String collection,
    T Function(Map<String, dynamic> json) fromJson,
  ) => _couple(coupleId)
      .collection(collection)
      .snapshots()
      .map((query) => [for (final doc in query.docs) fromJson(doc.data())])
      .transform(_cloudErrors());

  static StreamTransformer<T, T> _cloudErrors<T>() =>
      StreamTransformer.fromHandlers(
        handleError: (error, stackTrace, sink) {
          sink.addError(
            error is FirebaseException ? CloudSyncException(error.code) : error,
            stackTrace,
          );
        },
      );

  Future<void> _saveChild(
    String coupleId,
    String collection,
    String id,
    Map<String, dynamic> json,
  ) async {
    if (!isActive) return;
    await _write(
      () => _couple(coupleId).collection(collection).doc(id).set(json),
    );
  }

  Future<void> _write(Future<void> Function() op) async {
    try {
      await op();
    } on FirebaseException catch (e) {
      throw CloudSyncException(e.code);
    }
  }
}
