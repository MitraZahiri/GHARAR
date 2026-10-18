import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/couple_model.dart';
import '../models/question_model.dart';
import '../models/activity_model.dart';
import '../models/challenge_model.dart';
import '../models/journal_entry_model.dart';
import '../models/special_date_model.dart';

class StorageService {
  static const _keyUser = 'gharar_user';
  static const _keyCouple = 'gharar_couple';
  static const _keyAnswers = 'gharar_answers';
  static const _keyActivities = 'gharar_activities';
  static const _keyChallenges = 'gharar_challenges';
  static const _keyJournal = 'gharar_journal';
  static const _keySpecialDates = 'gharar_special_dates';
  static const _keyTheme = 'gharar_theme_dark';
  static const _keyLocale = 'gharar_locale';
  static const _keyHasOnboarded = 'gharar_has_onboarded';
  static const _keyIsAuthenticated = 'gharar_is_authenticated';
  static const _keyUserEmail = 'gharar_user_email';
  static const _keyAuthProvider = 'gharar_auth_provider';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  // Authentication status
  bool get isAuthenticated => _prefs.getBool(_keyIsAuthenticated) ?? false;
  Future<void> setIsAuthenticated(bool val) =>
      _prefs.setBool(_keyIsAuthenticated, val);

  String? get userEmail => _prefs.getString(_keyUserEmail);
  Future<void> setUserEmail(String? email) =>
      email != null
          ? _prefs.setString(_keyUserEmail, email)
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
  bool get isDarkMode => _prefs.getBool(_keyTheme) ?? false;
  Future<void> setIsDarkMode(bool val) => _prefs.setBool(_keyTheme, val);

  String get localeCode => _prefs.getString(_keyLocale) ?? 'en';
  Future<void> setLocaleCode(String code) => _prefs.setString(_keyLocale, code);

  // User
  UserModel? getUser() {
    final raw = _prefs.getString(_keyUser);
    if (raw == null) return null;
    try {
      return UserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveUser(UserModel user) =>
      _prefs.setString(_keyUser, jsonEncode(user.toJson()));

  // Couple
  CoupleModel? getCouple() {
    final raw = _prefs.getString(_keyCouple);
    if (raw == null) return null;
    try {
      return CoupleModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveCouple(CoupleModel couple) =>
      _prefs.setString(_keyCouple, jsonEncode(couple.toJson()));

  // Answers Map: questionId -> List<AnswerModel>
  Map<String, List<AnswerModel>> getAnswers() {
    final raw = _prefs.getString(_keyAnswers);
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
    return _prefs.setString(_keyAnswers, jsonEncode(mapped));
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
    final raw = _prefs.getString(_keyJournal);
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

  Future<void> saveJournal(List<JournalEntryModel> journal) => _prefs.setString(
    _keyJournal,
    jsonEncode(journal.map((j) => j.toJson()).toList()),
  );

  // Special Dates
  List<SpecialDateModel>? getSpecialDates() {
    final raw = _prefs.getString(_keySpecialDates);
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

  Future<void> saveSpecialDates(List<SpecialDateModel> dates) =>
      _prefs.setString(
        _keySpecialDates,
        jsonEncode(dates.map((d) => d.toJson()).toList()),
      );

  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
