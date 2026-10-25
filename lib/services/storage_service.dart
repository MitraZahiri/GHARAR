import 'dart:convert';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/couple_model.dart';
import '../models/question_model.dart';
import '../models/activity_model.dart';
import '../models/challenge_model.dart';
import '../models/journal_entry_model.dart';
import '../models/special_date_model.dart';
import '../models/love_note_model.dart';
import 'data_cipher.dart';

class StorageService {
  static const _keyUser = 'gharar_user';
  static const _keyCouple = 'gharar_couple';
  static const _keyAnswers = 'gharar_answers';
  static const _keyActivities = 'gharar_activities';
  static const _keyLoveNotes = 'gharar_love_notes';
  static const _keyChallenges = 'gharar_challenges';
  static const _keyJournal = 'gharar_journal';
  static const _keySpecialDates = 'gharar_special_dates';
  static const _keyLegacyDarkTheme = 'gharar_theme_dark';
  static const _keyThemeMode = 'gharar_theme_mode';
  static const _keyLocale = 'gharar_locale';
  static const _keyCloudUploadedFor = 'gharar_cloud_uploaded_for';
  static const _keyPairedOnline = 'gharar_paired_online';
  static const _keyHasOnboarded = 'gharar_has_onboarded';
  static const _keyIsAuthenticated = 'gharar_is_authenticated';
  static const _keyUserEmail = 'gharar_user_email';
  static const _keyAuthProvider = 'gharar_auth_provider';
  static const _keyPartnerMoods = 'gharar_partner_moods';
  static const _keyLastNudgeTime = 'gharar_last_nudge_time';
  static const _keyLastNudgeSender = 'gharar_last_nudge_sender';
  static const _keyLastNudgeMessage = 'gharar_last_nudge_message';

  /// Personal data: encrypted at rest whenever a [DataCipher] is given.
  static const _sensitiveKeys = {
    _keyUser,
    _keyCouple,
    _keyAnswers,
    _keyLoveNotes,
    _keyJournal,
    _keySpecialDates,
    _keyUserEmail,
    _keyPartnerMoods,
    _keyLastNudgeMessage,
  };

  final SharedPreferences _prefs;
  final DataCipher? _cipher;

  StorageService(this._prefs, {DataCipher? cipher}) : _cipher = cipher;

  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    final cipher = await DataCipher.fromSecureStorage(
      const FlutterSecureStorage(),
    );
    final storage = StorageService(prefs, cipher: cipher);
    await storage.encryptLegacyValues();
    return storage;
  }

  /// Encrypts personal data that older versions stored as plain text.
  Future<void> encryptLegacyValues() async {
    final cipher = _cipher;
    if (cipher == null) return;
    for (final key in _sensitiveKeys) {
      final raw = _prefs.getString(key);
      if (raw != null && !DataCipher.isEncrypted(raw)) {
        await _prefs.setString(key, cipher.encrypt(raw));
      }
    }
  }

  /// Reads [key], decrypting personal data. Values that can't be decrypted
  /// (tampered, or the key was lost) read as missing.
  String? _read(String key) {
    final raw = _prefs.getString(key);
    final cipher = _cipher;
    if (raw == null || cipher == null || !DataCipher.isEncrypted(raw)) {
      return raw;
    }
    try {
      return cipher.decrypt(raw);
    } on DataCipherException {
      return null;
    }
  }

  Future<bool> _write(String key, String value) {
    final cipher = _cipher;
    final protect = cipher != null && _sensitiveKeys.contains(key);
    return _prefs.setString(key, protect ? cipher.encrypt(value) : value);
  }

  // Authentication status
  bool get isAuthenticated => _prefs.getBool(_keyIsAuthenticated) ?? false;
  Future<void> setIsAuthenticated(bool val) =>
      _prefs.setBool(_keyIsAuthenticated, val);

  String? get userEmail => _read(_keyUserEmail);
  Future<void> setUserEmail(String? email) =>
      email != null
          ? _write(_keyUserEmail, email)
          : _prefs.remove(_keyUserEmail);

  String? get authProvider => _prefs.getString(_keyAuthProvider);
  Future<void> setAuthProvider(String? provider) =>
      provider != null
          ? _prefs.setString(_keyAuthProvider, provider)
          : _prefs.remove(_keyAuthProvider);

  // Onboarding status
  bool get hasOnboarded => _prefs.getBool(_keyHasOnboarded) ?? false;
  Future<void> setHasOnboarded(bool val) =>
      _prefs.setBool(_keyHasOnboarded, val);

  // Theme & Locale
  ThemeMode get themeMode {
    final stored = _prefs.getString(_keyThemeMode);
    for (final mode in ThemeMode.values) {
      if (mode.name == stored) return mode;
    }
    // Migrate the old on/off switch; no value at all means follow the system.
    final legacyDark = _prefs.getBool(_keyLegacyDarkTheme);
    if (legacyDark == null) return ThemeMode.system;
    return legacyDark ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> setThemeMode(ThemeMode mode) =>
      _prefs.setString(_keyThemeMode, mode.name);

  /// `uid/coupleId` whose first full upload from this device succeeded.
  String? get cloudUploadedFor => _prefs.getString(_keyCloudUploadedFor);
  Future<void> setCloudUploadedFor(String key) =>
      _prefs.setString(_keyCloudUploadedFor, key);

  /// Whether a real partner shares the couple through Firestore.
  bool get isPairedOnline => _prefs.getBool(_keyPairedOnline) ?? false;
  Future<void> setPairedOnline(bool value) =>
      _prefs.setBool(_keyPairedOnline, value);

  String get localeCode => _prefs.getString(_keyLocale) ?? 'en';
  Future<void> setLocaleCode(String code) => _prefs.setString(_keyLocale, code);

  // User
  UserModel? getUser() {
    final raw = _read(_keyUser);
    if (raw == null) return null;
    try {
      return UserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveUser(UserModel user) =>
      _write(_keyUser, jsonEncode(user.toJson()));

  // Couple
  CoupleModel? getCouple() {
    final raw = _read(_keyCouple);
    if (raw == null) return null;
    try {
      return CoupleModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveCouple(CoupleModel couple) =>
      _write(_keyCouple, jsonEncode(couple.toJson()));

  // Answers Map: questionId -> List<AnswerModel>
  Map<String, List<AnswerModel>> getAnswers() {
    final raw = _read(_keyAnswers);
    if (raw == null) return {};
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final result = <String, List<AnswerModel>>{};
      decoded.forEach((qId, list) {
        if (list is List) {
          result[qId] =
              list
                  .map((e) => AnswerModel.fromJson(e as Map<String, dynamic>))
                  .toList();
        }
      });
      return result;
    } catch (_) {
      return {};
    }
  }

  Future<void> saveAnswers(Map<String, List<AnswerModel>> answers) {
    final mapped = <String, dynamic>{};
    answers.forEach((qId, list) {
      mapped[qId] = list.map((a) => a.toJson()).toList();
    });
    return _write(_keyAnswers, jsonEncode(mapped));
  }

  // Activities
  List<ActivityModel>? getActivities() {
    final raw = _prefs.getString(_keyActivities);
    if (raw == null) return null;
    try {
      final list = jsonDecode(raw) as List;
      return list
          .map((e) => ActivityModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> saveActivities(List<ActivityModel> activities) =>
      _prefs.setString(
        _keyActivities,
        jsonEncode(activities.map((a) => a.toJson()).toList()),
      );

  // Challenges
  List<ChallengeModel>? getChallenges() {
    final raw = _prefs.getString(_keyChallenges);
    if (raw == null) return null;
    try {
      final list = jsonDecode(raw) as List;
      return list
          .map((e) => ChallengeModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> saveChallenges(List<ChallengeModel> challenges) =>
      _prefs.setString(
        _keyChallenges,
        jsonEncode(challenges.map((c) => c.toJson()).toList()),
      );

  // Journal
  List<JournalEntryModel>? getJournal() {
    final raw = _read(_keyJournal);
    if (raw == null) return null;
    try {
      final list = jsonDecode(raw) as List;
      return list
          .map((e) => JournalEntryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> saveJournal(List<JournalEntryModel> journal) =>
      _write(_keyJournal, jsonEncode(journal.map((j) => j.toJson()).toList()));

  // Special Dates
  List<SpecialDateModel>? getSpecialDates() {
    final raw = _read(_keySpecialDates);
    if (raw == null) return null;
    try {
      final list = jsonDecode(raw) as List;
      return list
          .map((e) => SpecialDateModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> saveSpecialDates(List<SpecialDateModel> dates) => _write(
    _keySpecialDates,
    jsonEncode(dates.map((d) => d.toJson()).toList()),
  );

  // Partner Moods
  Map<String, String> getPartnerMoods() {
    final raw = _read(_keyPartnerMoods);
    if (raw == null) return {};
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map((k, v) => MapEntry(k, v.toString()));
    } catch (_) {
      return {};
    }
  }

  Future<void> savePartnerMoods(Map<String, String> moods) =>
      _write(_keyPartnerMoods, jsonEncode(moods));

  // Love Nudge
  DateTime? getLastNudgeTime() {
    final raw = _prefs.getString(_keyLastNudgeTime);
    if (raw == null) return null;
    return DateTime.tryParse(raw);
  }

  Future<void> setLastNudgeTime(DateTime? time) =>
      time != null
          ? _prefs.setString(_keyLastNudgeTime, time.toIso8601String())
          : _prefs.remove(_keyLastNudgeTime);

  String? getLastNudgeSender() => _prefs.getString(_keyLastNudgeSender);

  Future<void> setLastNudgeSender(String? senderId) =>
      senderId != null
          ? _prefs.setString(_keyLastNudgeSender, senderId)
          : _prefs.remove(_keyLastNudgeSender);

  String? getLastNudgeMessage() => _read(_keyLastNudgeMessage);

  Future<void> setLastNudgeMessage(String? msg) =>
      msg != null
          ? _write(_keyLastNudgeMessage, msg)
          : _prefs.remove(_keyLastNudgeMessage);

  // Love Notes on Main Page
  List<LoveNoteModel>? getLoveNotes() {
    final raw = _read(_keyLoveNotes);
    if (raw == null) return null;
    try {
      final list = jsonDecode(raw) as List;
      return list
          .map((e) => LoveNoteModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> saveLoveNotes(List<LoveNoteModel> notes) =>
      _write(_keyLoveNotes, jsonEncode(notes.map((n) => n.toJson()).toList()));

  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
