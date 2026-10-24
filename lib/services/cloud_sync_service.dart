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

  @override
  String toString() => 'CloudSyncException($code)';
}

/// Mirrors local data to Cloud Firestore for the signed-in Firebase user.
///
/// Layout:
/// - `users/{uid}`: the user's own profile
/// - `couples/{coupleId}`: couple fields, `memberUids` and `moods`
/// - `couples/{coupleId}/{answers|loveNotes|journal|specialDates}/{id}`
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
  bool get isActive => _uid != null;

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
