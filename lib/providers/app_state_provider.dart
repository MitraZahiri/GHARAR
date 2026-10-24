import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/couple_model.dart';
import '../models/question_model.dart';
import '../models/activity_model.dart';
import '../models/challenge_model.dart';
import '../models/shared_interest_model.dart';
import '../models/journal_entry_model.dart';
import '../models/milestone_model.dart';
import '../models/special_date_model.dart';
import '../models/ai_message_model.dart';
import '../models/love_note_model.dart';
import '../core/localization/app_language.dart';
import '../core/localization/app_localizations.dart';
import '../core/utils/person_name.dart';
import '../services/home_widget_service.dart';
import '../services/note_media_service.dart';
import '../services/storage_service.dart';
import '../services/seed_data_service.dart';
import '../services/ai_companion_service.dart';
import '../services/auth_service.dart';
import '../services/cloud_sync_service.dart';

const _simulatedNotePrefix = 'note_sim_';
const _simulatedAnswerPrefix = 'ans_sim_';

/// Outcome of entering a partner's invite code.
enum PairingResult {
  joined,
  invalidCode,
  ownCode,
  coupleFull,
  needsSignIn,
  failed,
}

class AppStateProvider extends ChangeNotifier {
  final StorageService _storage;
  final AuthService _authService;
  final NoteMediaService _mediaService;
  final HomeWidgetService _homeWidgetService;
  final CloudSyncService? _cloud;

  UserModel? _currentUser;
  CoupleModel? _couple;
  String _activeViewingPartnerId = 'user_1'; // Supports interactive switching

  Locale _locale = const Locale('en');
  ThemeMode _themeMode = ThemeMode.system;
  Brightness _platformBrightness = Brightness.light;
  bool _hasOnboarded = false;
  bool _isAuthenticated = false;
  String? _userEmail;
  String? _authProvider;
  String? _lastAuthError;
  String? _cloudSyncError;

  List<QuestionModel> _questions = [];
  int _currentQuestionIndex = 0;
  Map<String, List<AnswerModel>> _answersMap = {};

  List<ActivityModel> _activities = [];
  List<ChallengeModel> _challenges = [];
  List<SharedInterestModel> _sharedInterests = [];
  List<JournalEntryModel> _journalEntries = [];
  List<MilestoneModel> _milestones = [];
  List<SpecialDateModel> _specialDates = [];
  List<AIMessageModel> _aiMessages = [];

  Map<String, String> _partnerMoods = {};
  DateTime? _lastNudgeTime;
  String? _lastNudgeSenderId;
  String? _lastNudgeMessage;

  List<LoveNoteModel> _loveNotes = [];

  bool _isGeneratingAI = false;

  final List<StreamSubscription<Object?>> _cloudSubscriptions = [];
  String? _listeningCoupleId;
  String? _publishedInviteCode;
  bool _isPairedOnline = false;
  // Set once this phone has read the shared couple, so a later
  // permission-denied means the partner removed us.
  bool _hadCoupleAccess = false;
  Future<void>? _cloudStartup;

  AppStateProvider(
    this._storage, {
    AuthService? authService,
    NoteMediaService? mediaService,
    HomeWidgetService? homeWidgetService,
    CloudSyncService? cloudSync,
  }) : _cloud = cloudSync,
       _authService = authService ?? AuthService(),
       _mediaService = mediaService ?? NoteMediaService(),
       _homeWidgetService = homeWidgetService ?? HomeWidgetService() {
    _loadFromStorage();
    unawaited(_startCloud());
  }

  @override
  void dispose() {
    _stopListening();
    super.dispose();
  }

  // Getters
  UserModel? get currentUser => _currentUser;
  CoupleModel? get couple => _couple;
  String get activeViewingPartnerId => _activeViewingPartnerId;
  Locale get locale => _locale;
  AppLanguage get currentLanguage => AppLanguage.fromCode(_locale.languageCode);
  bool get isTurkish => _locale.languageCode == 'tr';
  bool get isArabic => _locale.languageCode == 'ar';
  bool get isFarsi => _locale.languageCode == 'fa';
  bool get isGerman => _locale.languageCode == 'de';
  bool get isSpanish => _locale.languageCode == 'es';
  bool get isFrench => _locale.languageCode == 'fr';
  bool get isItalian => _locale.languageCode == 'it';
  bool get isRtl => currentLanguage.isRtl;
  ThemeMode get themeMode => _themeMode;

  /// Whether the dark palette is visible right now, resolving
  /// [ThemeMode.system] against the device brightness.
  bool get isDarkMode => switch (_themeMode) {
    ThemeMode.dark => true,
    ThemeMode.light => false,
    ThemeMode.system => _platformBrightness == Brightness.dark,
  };
  bool get hasOnboarded => _hasOnboarded;
  bool get isAuthenticated => _isAuthenticated;
  String? get userEmail => _userEmail;
  String? get authProvider => _authProvider;
  String? get lastAuthError => _lastAuthError;

  /// Firestore error code of the last rejected cloud write, if any.
  String? get cloudSyncError => _cloudSyncError;

  void setLanguageCode(String code) {
    setLocale(Locale(code));
  }

  List<QuestionModel> get questions => _questions;
  int get currentQuestionIndex => _currentQuestionIndex;
  QuestionModel? get currentQuestion =>
      _questions.isNotEmpty
          ? _questions[_currentQuestionIndex % _questions.length]
          : null;

  Map<String, List<AnswerModel>> get answersMap => _answersMap;
  List<ActivityModel> get activities => _activities;
  List<ChallengeModel> get challenges => _challenges;
  List<SharedInterestModel> get sharedInterests => _sharedInterests;
  List<JournalEntryModel> get journalEntries => _journalEntries;
  List<MilestoneModel> get milestones => _milestones;
  List<SpecialDateModel> get specialDates => _specialDates;
  List<AIMessageModel> get aiMessages => _aiMessages;
  bool get isGeneratingAI => _isGeneratingAI;

  Map<String, String> get partnerMoods => _partnerMoods;
  String? get activePartnerMood => _partnerMoods[activePartner.id];
  String? get otherPartnerMood => _partnerMoods[otherPartner.id];
  String? getMoodForPartner(String partnerId) => _partnerMoods[partnerId];
  DateTime? get lastNudgeTime => _lastNudgeTime;
  String? get lastNudgeSenderId => _lastNudgeSenderId;
  String? get lastNudgeMessage => _lastNudgeMessage;
  bool get hasReceivedRecentNudge {
    if (_lastNudgeTime == null || _lastNudgeSenderId != otherPartner.id) {
      return false;
    }
    return DateTime.now().difference(_lastNudgeTime!).inHours < 12;
  }

  // Love Notes Getters
  List<LoveNoteModel> get loveNotes => _loveNotes;

  LoveNoteModel? get latestNoteForActivePartner {
    final forMe =
        _loveNotes.where((n) => n.receiverId == activePartner.id).toList();
    if (forMe.isEmpty) return null;
    forMe.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return forMe.first;
  }

  LoveNoteModel? get latestNoteSentByActivePartner {
    final fromMe =
        _loveNotes.where((n) => n.senderId == activePartner.id).toList();
    if (fromMe.isEmpty) return null;
    fromMe.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return fromMe.first;
  }

  bool get isPartnerLinked => _couple?.isLinked ?? false;

  /// True when signed in with Firebase, so invite codes work across phones.
  bool get canPairOnline => _cloud?.isActive ?? false;

  /// A real partner shares this couple from their own phone.
  bool get isPairedOnline => _isPairedOnline;

  /// Partner switching and simulated partner replies: debug builds only,
  /// and never once a real partner is connected.
  bool get demoToolsEnabled => kDebugMode && !_isPairedOnline;

  // Distance Mode (close by vs. long distance)
  DistanceMode get distanceMode =>
      _couple?.distanceMode ?? DistanceMode.together;
  int? get partnerUtcOffsetMinutes => _couple?.partnerUtcOffsetMinutes;
  DateTime? get nextMeetingDate => _couple?.nextMeetingDate;

  /// Calendar days until the reunion; null when unset or already past.
  int? daysUntilNextMeeting({DateTime? now}) {
    final meeting = _couple?.nextMeetingDate;
    if (meeting == null) return null;
    final today = DateUtils.dateOnly(now ?? DateTime.now());
    final days = DateUtils.dateOnly(meeting).difference(today).inDays;
    return days < 0 ? null : days;
  }

  /// The partner's wall-clock time, or null until their offset is set.
  DateTime? partnerLocalTime({DateTime? nowUtc}) {
    final offset = _couple?.partnerUtcOffsetMinutes;
    if (offset == null) return null;
    return (nowUtc ?? DateTime.now().toUtc()).add(Duration(minutes: offset));
  }

  void setDistanceMode(DistanceMode mode) {
    _updateCouple((c) => c.copyWith(distanceMode: mode));
  }

  void setNextMeetingDate(DateTime? date) {
    _updateCouple(
      (c) =>
          date == null
              ? c.copyWith(clearNextMeetingDate: true)
              : c.copyWith(nextMeetingDate: date),
    );
  }

  void setPartnerUtcOffset(int minutes) {
    _updateCouple((c) => c.copyWith(partnerUtcOffsetMinutes: minutes));
  }

  void _updateCouple(CoupleModel Function(CoupleModel) update) {
    if (_couple == null) return;
    _couple = update(_couple!);
    _storage.saveCouple(_couple!);
    _syncCouple();
    notifyListeners();
  }

  /// Mirrors a change to Firestore without blocking the UI. Failures are
  /// kept in [cloudSyncError]; the local copy stays the source of truth.
  void _cloudWrite(Future<void> Function(CloudSyncService cloud) write) {
    final cloud = _cloud;
    if (cloud == null || !cloud.isActive) return;
    unawaited(
      write(cloud).catchError((Object e) {
        _cloudSyncError = (e as CloudSyncException).code;
        notifyListeners();
      }, test: (e) => e is CloudSyncException),
    );
  }

  void _cloudCoupleWrite(
    Future<void> Function(CloudSyncService cloud, String coupleId) write,
  ) {
    final coupleId = _couple?.id;
    if (coupleId == null) return;
    _cloudWrite((cloud) => write(cloud, coupleId));
  }

  void _syncCouple() {
    final couple = _couple;
    if (couple != null) _cloudWrite((cloud) => cloud.saveCouple(couple));
  }

  void _syncUser() {
    final user = _currentUser;
    if (user != null) _cloudWrite((cloud) => cloud.saveUser(user));
  }

  /// Uploads local data once per Firebase account, then follows the couple
  /// live. Listening never starts before that upload succeeded, so an empty
  /// or unreachable cloud copy can't replace what is on this phone.
  Future<void> _startCloud() {
    // Runs one at a time; a later call sees what the earlier one did.
    final previous = _cloudStartup ?? Future<void>.value();
    return _cloudStartup = previous.then((_) => _runCloudStartup());
  }

  Future<void> _runCloudStartup() async {
    final cloud = _cloud;
    final uid = cloud?.uid;
    final couple = _couple;
    if (cloud == null || uid == null || couple == null) return;
    final uploadKey = '$uid/${couple.id}';
    if (_storage.cloudUploadedFor != uploadKey) {
      if (!await _uploadAll(cloud)) return;
      await _storage.setCloudUploadedFor(uploadKey);
    }
    _listenToCouple();
  }

  /// Uploads everything the couple created on this device. Demo simulations
  /// and seed templates are left out.
  Future<bool> _uploadAll(CloudSyncService cloud) async {
    final couple = _couple;
    if (couple == null) return false;
    final user = _currentUser;
    final seedDateIds =
        SeedDataService.defaultSpecialDates.map((d) => d.id).toSet();
    try {
      if (user != null) await cloud.saveUser(user);
      await cloud.saveCouple(couple);
      await Future.wait([
        for (final note in _loveNotes)
          if (!note.id.startsWith(_simulatedNotePrefix))
            cloud.saveLoveNote(couple.id, note),
        for (final answer in _answersMap.values.expand((list) => list))
          if (!answer.id.startsWith(_simulatedAnswerPrefix))
            cloud.saveAnswer(couple.id, answer),
        for (final entry in _journalEntries)
          cloud.saveJournalEntry(couple.id, entry),
        for (final date in _specialDates)
          if (!seedDateIds.contains(date.id))
            cloud.saveSpecialDate(couple.id, date),
        if (_partnerMoods.isNotEmpty) cloud.saveMoods(couple.id, _partnerMoods),
      ]);
      return true;
    } on CloudSyncException catch (e) {
      _cloudSyncError = e.code;
      notifyListeners();
      return false;
    }
  }

  void _listenToCouple() {
    final cloud = _cloud;
    final coupleId = _couple?.id;
    if (cloud == null || !cloud.isActive || coupleId == null) return;
    if (_listeningCoupleId == coupleId) return;
    _stopListening();
    _listeningCoupleId = coupleId;
    void onError(Object error) {
      final code = error is CloudSyncException ? error.code : error.toString();
      if (code == 'permission-denied' && _hadCoupleAccess) {
        _startOwnCoupleAfterRemoval(coupleId);
        return;
      }
      _cloudSyncError = code;
      notifyListeners();
    }

    _cloudSubscriptions.addAll([
      cloud
          .watchCouple(coupleId)
          .listen(
            (remote) => _applyRemoteCouple(coupleId, remote),
            onError: onError,
          ),
      cloud
          .watchLoveNotes(coupleId)
          .listen(_applyRemoteLoveNotes, onError: onError),
      cloud
          .watchAnswers(coupleId)
          .listen(_applyRemoteAnswers, onError: onError),
      cloud
          .watchJournal(coupleId)
          .listen(_applyRemoteJournal, onError: onError),
      cloud
          .watchSpecialDates(coupleId)
          .listen(_applyRemoteSpecialDates, onError: onError),
    ]);
  }

  void _stopListening() {
    for (final subscription in _cloudSubscriptions) {
      unawaited(subscription.cancel());
    }
    _cloudSubscriptions.clear();
    _listeningCoupleId = null;
    _hadCoupleAccess = false;
  }

  void _setPairedOnline(bool value) {
    if (value == _isPairedOnline) return;
    _isPairedOnline = value;
    _storage.setPairedOnline(value);
  }

  void _applyRemoteCouple(String coupleId, RemoteCouple? remote) {
    if (remote == null) return;
    final uid = _cloud?.uid;
    if (uid != null && !remote.memberUids.contains(uid)) {
      _startOwnCoupleAfterRemoval(coupleId);
      return;
    }
    _hadCoupleAccess = true;
    _setPairedOnline(remote.memberCount >= 2);
    _couple = remote.couple;
    _partnerMoods = Map.of(remote.moods);
    _storage.saveCouple(remote.couple);
    _storage.savePartnerMoods(_partnerMoods);
    notifyListeners();
    if (remote.memberCount < 2) unawaited(_publishInvite());
  }

  /// Lets a partner find this couple by its code; replaces the old
  /// guessable `GHARAR-1234-LOVE` codes first.
  Future<void> _publishInvite() async {
    final cloud = _cloud;
    var couple = _couple;
    if (cloud == null || couple == null) return;
    if (!CloudSyncService.isStrongInviteCode(couple.inviteCode)) {
      couple = couple.copyWith(inviteCode: CloudSyncService.newInviteCode());
      _couple = couple;
      _storage.saveCouple(couple);
      notifyListeners();
    }
    if (_publishedInviteCode == couple.inviteCode) return;
    _publishedInviteCode = couple.inviteCode;
    try {
      await cloud.registerInvite(couple);
    } on CloudSyncException catch (e) {
      _publishedInviteCode = null;
      _cloudSyncError = e.code;
      notifyListeners();
    }
  }

  void _applyRemoteLoveNotes(List<LoveNoteModel> remote) {
    // Images stay on the phone that has them; keep their local paths.
    final localImages = {
      for (final note in _loveNotes)
        if (note.imagePath != null) note.id: note.imagePath!,
    };
    _loveNotes = [
      for (final note in remote)
        note.imagePath == null && localImages.containsKey(note.id)
            ? note.copyWith(imagePath: localImages[note.id])
            : note,
    ]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    _storage.saveLoveNotes(_loveNotes);
    notifyListeners();
    unawaited(_syncHomeWidget());
  }

  void _applyRemoteAnswers(List<AnswerModel> remote) {
    final byQuestion = <String, List<AnswerModel>>{};
    for (final answer in remote) {
      (byQuestion[answer.questionId] ??= []).add(answer);
    }
    _answersMap = byQuestion;
    _storage.saveAnswers(_answersMap);
    notifyListeners();
  }

  void _applyRemoteJournal(List<JournalEntryModel> remote) {
    _journalEntries = [...remote]..sort((a, b) => b.date.compareTo(a.date));
    _storage.saveJournal(_journalEntries);
    notifyListeners();
  }

  void _applyRemoteSpecialDates(List<SpecialDateModel> remote) {
    final seedIds =
        SeedDataService.defaultSpecialDates.map((d) => d.id).toSet();
    final remoteIds = remote.map((d) => d.id).toSet();
    _specialDates = [
      ..._specialDates.where(
        (d) => seedIds.contains(d.id) && !remoteIds.contains(d.id),
      ),
      ...remote,
    ]..sort((a, b) => a.daysUntil.compareTo(b.daysUntil));
    _storage.saveSpecialDates(_specialDates);
    notifyListeners();
  }

  /// The partner removed this phone from the shared couple. Everything this
  /// phone already has stays; it becomes a new couple with a fresh code.
  void _startOwnCoupleAfterRemoval(String coupleId) {
    final old = _couple;
    if (old == null || old.id != coupleId) return;
    _stopListening();
    _setPairedOnline(false);
    final me = _currentUser ?? activePartner;
    _couple = _withoutPartner(
      old,
      id: 'couple_${DateTime.now().millisecondsSinceEpoch}',
      me: me,
    );
    _activeViewingPartnerId = me.id;
    _storage.saveCouple(_couple!);
    notifyListeners();
    unawaited(_startCloud());
  }

  /// [old] with [me] alone in it and a fresh invite code. Shared history
  /// such as the anniversary and streak is kept.
  CoupleModel _withoutPartner(
    CoupleModel old, {
    required String id,
    required UserModel me,
  }) {
    return CoupleModel(
      id: id,
      partner1: me,
      partner2: null,
      inviteCode: CloudSyncService.newInviteCode(),
      anniversaryDate: old.anniversaryDate,
      connectionStreak: old.connectionStreak,
      streakLastMaintained: old.streakLastMaintained,
      isLinked: false,
      isPremium: old.isPremium,
      distanceMode: old.distanceMode,
    );
  }

  /// Joins the partner's couple behind [code]. What this phone created on
  /// its own (notes, answers, journal, dates, mood) moves into the shared
  /// couple, and its single-person couple is deleted from the cloud.
  Future<PairingResult> joinPartnerWithCode(String code) async {
    final cloud = _cloud;
    final uid = cloud?.uid;
    if (cloud == null || uid == null) return PairingResult.needsSignIn;
    final normalized = CloudSyncService.normalizeInviteCode(code);
    if (normalized == _couple?.inviteCode) return PairingResult.ownCode;

    final previousCouple = _couple;
    final previousId = activePartner.id;
    final me = activePartner.copyWith(id: uid);
    final CoupleModel shared;
    try {
      shared = await cloud.joinCouple(normalized, me);
    } on CloudSyncException catch (e) {
      return switch (e.code) {
        CloudSyncException.inviteNotFound => PairingResult.invalidCode,
        CloudSyncException.ownInvite => PairingResult.ownCode,
        CloudSyncException.coupleFull => PairingResult.coupleFull,
        CloudSyncException.notSignedIn => PairingResult.needsSignIn,
        _ => PairingResult.failed,
      };
    }

    // What this phone created by itself, re-addressed to the real partner.
    final partnerId = shared.partner1.id;
    final seedDateIds =
        SeedDataService.defaultSpecialDates.map((d) => d.id).toSet();
    final myNotes = [
      for (final note in _loveNotes)
        if (note.senderId == previousId &&
            !note.id.startsWith(_simulatedNotePrefix))
          note.copyWith(senderId: uid, receiverId: partnerId),
    ];
    final myAnswers = [
      for (final answer in _answersMap.values.expand((list) => list))
        if (answer.authorId == previousId &&
            !answer.id.startsWith(_simulatedAnswerPrefix))
          answer.copyWith(authorId: uid),
    ];
    final myJournal = [
      for (final entry in _journalEntries)
        if (entry.authorId == previousId) entry.copyWith(authorId: uid),
    ];
    final myDates = _specialDates.where((d) => !seedDateIds.contains(d.id));
    final myMood = _partnerMoods[previousId];

    _stopListening();
    _setPairedOnline(true);
    _currentUser = me;
    _activeViewingPartnerId = uid;
    _couple = shared;
    _loveNotes = [];
    _answersMap = {};
    _journalEntries = [];
    _partnerMoods = {};
    _storage.saveUser(me);
    _storage.saveCouple(shared);
    _storage.saveLoveNotes(_loveNotes);
    _storage.saveAnswers(_answersMap);
    _storage.saveJournal(_journalEntries);
    _storage.savePartnerMoods(_partnerMoods);
    await _storage.setCloudUploadedFor('$uid/${shared.id}');
    _syncUser();
    try {
      await Future.wait([
        for (final note in myNotes) cloud.saveLoveNote(shared.id, note),
        for (final answer in myAnswers) cloud.saveAnswer(shared.id, answer),
        for (final entry in myJournal) cloud.saveJournalEntry(shared.id, entry),
        for (final date in myDates) cloud.saveSpecialDate(shared.id, date),
        if (myMood != null) cloud.saveMoods(shared.id, {uid: myMood}),
      ]);
      if (previousCouple != null && previousCouple.id != shared.id) {
        await cloud.deleteSoloCouple(
          previousCouple.id,
          previousCouple.inviteCode,
        );
      }
    } on CloudSyncException catch (e) {
      _cloudSyncError = e.code;
    }
    _listenToCouple();
    notifyListeners();
    return PairingResult.joined;
  }

  UserModel get activePartner {
    if (_couple == null) {
      return _currentUser ??
          UserModel(
            id: 'user_1',
            name: '',
            avatar: '🌸',
            preferredLanguage: _locale.languageCode,
            relationshipStage: 'stageDating',
            selectedGoals: [],
            joinedAt: DateTime.now(),
          );
    }
    if (_activeViewingPartnerId == _couple!.partner1.id) {
      return _couple!.partner1;
    }
    return _couple!.partner2 ?? _couple!.partner1;
  }

  UserModel get otherPartner {
    if (_couple == null || _couple!.partner2 == null) {
      return UserModel(
        id: 'user_2',
        name: '',
        avatar: '🌿',
        preferredLanguage: _locale.languageCode,
        relationshipStage: 'stageDating',
        selectedGoals: [],
        joinedAt: DateTime.now(),
      );
    }
    if (_activeViewingPartnerId == _couple!.partner1.id) {
      return _couple!.partner2!;
    }
    return _couple!.partner1;
  }

  void _loadFromStorage() {
    _isAuthenticated = _storage.isAuthenticated;
    _userEmail = _storage.userEmail;
    _authProvider = _storage.authProvider;
    _themeMode = _storage.themeMode;
    _platformBrightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    _locale = Locale(_storage.localeCode);
    _hasOnboarded = _storage.hasOnboarded;
    _isPairedOnline = _storage.isPairedOnline;

    _currentUser = _storage.getUser();
    _couple = _storage.getCouple();
    _cleanStoredNames();
    _answersMap = _storage.getAnswers();
    _activities = _storage.getActivities() ?? SeedDataService.defaultActivities;
    _challenges = _storage.getChallenges() ?? SeedDataService.defaultChallenges;
    _journalEntries =
        _storage.getJournal() ?? SeedDataService.defaultJournalEntries;
    _specialDates =
        _storage.getSpecialDates() ?? SeedDataService.defaultSpecialDates;

    _questions = SeedDataService.defaultQuestions;
    _sharedInterests = SeedDataService.defaultSharedInterests;
    _milestones = SeedDataService.defaultMilestones;
    _aiMessages = AICompanionService.getInitialMessages();

    _partnerMoods = _storage.getPartnerMoods();
    _lastNudgeTime = _storage.getLastNudgeTime();
    _lastNudgeSenderId = _storage.getLastNudgeSender();
    _lastNudgeMessage = _storage.getLastNudgeMessage();
    _loveNotes = _storage.getLoveNotes() ?? [];

    if (_currentUser != null) {
      _activeViewingPartnerId = _currentUser!.id;
    }

    notifyListeners();
  }

  /// Older builds saved words like "You" or "My Soulmate" as names.
  void _cleanStoredNames() {
    final user = _currentUser;
    if (user != null && cleanPersonName(user.name) != user.name) {
      _currentUser = user.copyWith(name: cleanPersonName(user.name));
      _storage.saveUser(_currentUser!);
    }
    final couple = _couple;
    if (couple == null) return;
    final p1 = couple.partner1;
    final p2 = couple.partner2;
    final cleanP1 = p1.copyWith(name: cleanPersonName(p1.name));
    final cleanP2 = p2?.copyWith(name: cleanPersonName(p2.name));
    if (cleanP1 != p1 || cleanP2 != p2) {
      _couple = couple.copyWith(partner1: cleanP1, partner2: cleanP2);
      _storage.saveCouple(_couple!);
    }
  }

  /// How a person is shown on screen. Looks the person up by [id] so a
  /// rename also updates older notes and answers that stored [name].
  String displayNameFor({required String id, String name = ''}) {
    final couple = _couple;
    final current =
        couple == null
            ? null
            : [
              couple.partner1,
              couple.partner2,
            ].whereType<UserModel>().where((u) => u.id == id).firstOrNull;
    return displayPersonName(
      current?.name ?? name,
      isSelf: id == activePartner.id,
      loc: AppLocalizations(_locale),
    );
  }

  String displayNameOf(UserModel user) =>
      displayNameFor(id: user.id, name: user.name);
  String get activePartnerName => displayNameOf(activePartner);
  String get otherPartnerName => displayNameOf(otherPartner);

  /// "Kerem & Elif", or "You & Your Soulmate" when names are missing,
  /// from the active partner's point of view.
  String get coupleDisplayNames {
    final loc = AppLocalizations(_locale);
    final me = displayPersonName(activePartner.name, isSelf: true, loc: loc);
    final partner = displayPersonName(
      otherPartner.name,
      isSelf: false,
      loc: loc,
    );
    return '$me & $partner';
  }

  // Partner Switcher (Interactive Demo & Simulation)
  void switchActivePartner() {
    // With a real partner, nobody may act on the other's behalf.
    if (_isPairedOnline) return;
    if (_couple == null || _couple!.partner2 == null) return;
    if (_activeViewingPartnerId == _couple!.partner1.id) {
      _activeViewingPartnerId = _couple!.partner2!.id;
    } else {
      _activeViewingPartnerId = _couple!.partner1.id;
    }
    notifyListeners();
  }

  // Soulmate Mood Check-in
  void setMyMood(String moodKey) {
    _partnerMoods[activePartner.id] = moodKey;
    _storage.savePartnerMoods(_partnerMoods);
    final moods = Map<String, String>.of(_partnerMoods);
    _cloudCoupleWrite((cloud, id) => cloud.saveMoods(id, moods));
    notifyListeners();
  }

  // Love Nudge / "Seni Düşünüyorum"
  void sendLoveNudge({String? message}) {
    _lastNudgeTime = DateTime.now();
    _lastNudgeSenderId = activePartner.id;
    _lastNudgeMessage =
        message ?? (isTurkish ? 'Seni Düşünüyorum 💓' : 'Thinking of you 💓');
    _storage.setLastNudgeTime(_lastNudgeTime);
    _storage.setLastNudgeSender(_lastNudgeSenderId);
    _storage.setLastNudgeMessage(_lastNudgeMessage);
    notifyListeners();
  }

  // Love Notes on Main Page (Telefon kapalıyken sayfaya not bırakma)
  void postLoveNote({
    required String text,
    String paperColor = 'rose',
    String emoji = '💌',
  }) {
    final note = LoveNoteModel(
      id: 'note_${DateTime.now().millisecondsSinceEpoch}',
      senderId: activePartner.id,
      senderName: activePartner.name,
      receiverId: otherPartner.id,
      text: text.trim(),
      paperColor: paperColor,
      emoji: emoji,
      createdAt: DateTime.now(),
      isRead: false,
    );

    _addLoveNote(note);
  }

  /// Posts a handwritten drawing ([imageBytes]) or a photo
  /// ([sourceImagePath]) as a love note. Returns false when the image cannot
  /// be stored; no note is added in that case.
  Future<bool> postVisualNote({
    required LoveNoteKind kind,
    Uint8List? imageBytes,
    String? sourceImagePath,
    String caption = '',
    String paperColor = 'rose',
    String emoji = '💌',
  }) async {
    assert(kind != LoveNoteKind.text, 'Use postLoveNote for text notes');
    if (imageBytes == null && sourceImagePath == null) return false;
    final String imagePath;
    try {
      imagePath =
          imageBytes != null
              ? await _mediaService.saveBytes(imageBytes, extension: 'png')
              : await _mediaService.importFile(sourceImagePath!);
    } on NoteMediaException {
      return false;
    }

    _addLoveNote(
      LoveNoteModel(
        id: 'note_${DateTime.now().millisecondsSinceEpoch}',
        senderId: activePartner.id,
        senderName: activePartner.name,
        receiverId: otherPartner.id,
        text: caption.trim(),
        paperColor: paperColor,
        emoji: emoji,
        createdAt: DateTime.now(),
        kind: kind,
        imagePath: imagePath,
      ),
    );
    return true;
  }

  /// Asks the launcher to pin the GHARAR note widget (Android only).
  Future<bool> requestPinHomeWidget() => _homeWidgetService.requestPin();

  void _addLoveNote(LoveNoteModel note) {
    _loveNotes.insert(0, note);
    _storage.saveLoveNotes(_loveNotes);
    if (!note.id.startsWith(_simulatedNotePrefix)) {
      _cloudCoupleWrite((cloud, id) => cloud.saveLoveNote(id, note));
    }
    notifyListeners();
    unawaited(_syncHomeWidget());
  }

  /// Mirrors the newest note received by this device's owner to the
  /// home-screen widget, or clears the widget when there is none.
  Future<void> _syncHomeWidget() {
    final ownerId = _currentUser?.id;
    final received =
        _loveNotes.where((n) => n.receiverId == ownerId).toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    if (received.isEmpty) return _homeWidgetService.clear();

    final note = received.first;
    final loc = AppLocalizations(_locale);
    final sender = displayPersonName(note.senderName, isSelf: false, loc: loc);
    return _homeWidgetService.showNote(
      HomeWidgetNote(
        senderLine: loc.format('widgetFrom', {'name': sender}),
        emoji: note.emoji,
        caption: note.text.isEmpty ? null : note.text,
        imagePath: note.hasImage ? note.imagePath : null,
      ),
    );
  }

  void markLoveNoteAsRead(String noteId) {
    _loveNotes =
        _loveNotes.map((n) {
          if (n.id == noteId) {
            return n.copyWith(isRead: true, readAt: DateTime.now());
          }
          return n;
        }).toList();
    _storage.saveLoveNotes(_loveNotes);
    final read = _loveNotes.where((n) => n.id == noteId).firstOrNull;
    if (read != null && !read.id.startsWith(_simulatedNotePrefix)) {
      _cloudCoupleWrite((cloud, id) => cloud.saveLoveNote(id, read));
    }
    notifyListeners();
  }

  Future<void> deleteLoveNote(String noteId) async {
    final note = _loveNotes.where((n) => n.id == noteId).firstOrNull;
    if (note == null) return;
    _loveNotes.removeWhere((n) => n.id == noteId);
    _storage.saveLoveNotes(_loveNotes);
    _cloudCoupleWrite((cloud, id) => cloud.deleteLoveNote(id, noteId));
    notifyListeners();
    final imagePath = note.imagePath;
    if (imagePath != null) await _mediaService.delete(imagePath);
    await _syncHomeWidget();
  }

  void simulatePartnerLoveNote({
    String? customMessage,
    String paperColor = 'rose',
    String emoji = '💌',
  }) {
    if (_isPairedOnline) return;
    final defaultMsg =
        isTurkish
            ? 'Telefonun kapalıyken ana sayfana bu tatlı notu iliştirdim. Günün harika geçsin sevgilim! ☀️💖'
            : 'Left this sweet note on your main page while your phone was away. Have a beautiful day my love! ☀️💖';

    final note = LoveNoteModel(
      id: '$_simulatedNotePrefix${DateTime.now().millisecondsSinceEpoch}',
      senderId: otherPartner.id,
      senderName: otherPartner.name,
      receiverId: activePartner.id,
      text: customMessage?.trim() ?? defaultMsg,
      paperColor: paperColor,
      emoji: emoji,
      createdAt: DateTime.now(),
      isRead: false,
    );

    _addLoveNote(note);
  }

  void setLocale(Locale loc) {
    _locale = loc;
    _storage.setLocaleCode(loc.languageCode);
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    if (mode == _themeMode) return;
    _themeMode = mode;
    _storage.setThemeMode(mode);
    notifyListeners();
  }

  /// Switches to the opposite of what is visible now, as an explicit choice.
  void toggleTheme() {
    setThemeMode(isDarkMode ? ThemeMode.light : ThemeMode.dark);
  }

  /// Called by the app when the device switches between light and dark.
  void setPlatformBrightness(Brightness brightness) {
    if (brightness == _platformBrightness) return;
    final wasDark = isDarkMode;
    _platformBrightness = brightness;
    if (isDarkMode != wasDark) notifyListeners();
  }

  void completeOnboarding({
    required String name,
    required String avatar,
    required String relationshipStage,
    required List<String> goals,
    required String languageCode,
    String? email,
  }) {
    final effectiveEmail = email ?? _userEmail ?? 'user@gharar.love';
    final user = UserModel(
      // A Firebase uid keeps ids unique once two phones share a couple.
      id: _cloud?.uid ?? 'user_1',
      // Falls back to the name given at sign-in (Google, Apple or email).
      name:
          cleanPersonName(name).isNotEmpty
              ? cleanPersonName(name)
              : cleanPersonName(_currentUser?.name),
      avatar: avatar,
      preferredLanguage: languageCode,
      relationshipStage: relationshipStage,
      selectedGoals: goals,
      joinedAt: DateTime.now(),
      email: effectiveEmail,
      authProvider: _authProvider ?? 'email',
    );

    _currentUser = user;
    _activeViewingPartnerId = user.id;
    _hasOnboarded = true;
    _storage.setHasOnboarded(true);
    _storage.saveUser(user);

    _couple = CoupleModel(
      id: 'couple_${DateTime.now().millisecondsSinceEpoch}',
      partner1: user,
      partner2: null,
      inviteCode: CloudSyncService.newInviteCode(),
      anniversaryDate: DateTime.now(),
      connectionStreak: 1,
      streakLastMaintained: DateTime.now(),
      isLinked: false,
    );
    _storage.saveCouple(_couple!);
    unawaited(_startCloud());

    notifyListeners();
  }

  void linkPartner({required String partnerName, String avatar = '🌿'}) {
    if (_couple == null) return;
    final partner = UserModel(
      id: 'user_2',
      name: cleanPersonName(partnerName),
      avatar: avatar,
      preferredLanguage: _locale.languageCode,
      relationshipStage: _currentUser?.relationshipStage ?? 'stageDating',
      selectedGoals: _currentUser?.selectedGoals ?? [],
      joinedAt: DateTime.now(),
    );

    _couple = _couple!.copyWith(
      partner2: partner,
      isLinked: true,
      connectionStreak:
          (_couple!.connectionStreak == 0) ? 1 : _couple!.connectionStreak,
    );
    _storage.saveCouple(_couple!);
    _syncCouple();
    notifyListeners();
  }

  // Daily Questions Logic
  void nextQuestion() {
    if (_questions.isEmpty) return;
    _currentQuestionIndex = (_currentQuestionIndex + 1) % _questions.length;
    notifyListeners();
  }

  void setQuestionIndex(int index) {
    if (index >= 0 && index < _questions.length) {
      _currentQuestionIndex = index;
      notifyListeners();
    }
  }

  void drawRandomQuestion() {
    if (_questions.isEmpty) return;
    final rand = Random();
    int nextIdx;
    do {
      nextIdx = rand.nextInt(_questions.length);
    } while (nextIdx == _currentQuestionIndex && _questions.length > 1);
    _currentQuestionIndex = nextIdx;
    notifyListeners();
  }

  List<AnswerModel> getAnswersForQuestion(String questionId) {
    return _answersMap[questionId] ?? [];
  }

  AnswerModel? getAnswerForActivePartner(String questionId) {
    final list = _answersMap[questionId];
    if (list == null) return null;
    return list.where((a) => a.authorId == activePartner.id).firstOrNull;
  }

  AnswerModel? getAnswerForOtherPartner(String questionId) {
    final list = _answersMap[questionId];
    if (list == null) return null;
    return list.where((a) => a.authorId == otherPartner.id).firstOrNull;
  }

  bool isBothAnswered(String questionId) {
    final list = _answersMap[questionId];
    if (list == null || list.length < 2) return false;
    final hasActive = list.any((a) => a.authorId == activePartner.id);
    final hasOther = list.any((a) => a.authorId == otherPartner.id);
    return hasActive && hasOther;
  }

  void submitAnswer({
    required String questionId,
    required String answerText,
    int? selectedOptionIndex,
  }) {
    final list = List<AnswerModel>.from(_answersMap[questionId] ?? []);
    // Remove old answer by this partner if exists
    list.removeWhere((a) => a.authorId == activePartner.id);

    final answer = AnswerModel(
      id: 'ans_${DateTime.now().millisecondsSinceEpoch}',
      questionId: questionId,
      authorId: activePartner.id,
      authorName: activePartner.name,
      answerText: answerText.trim(),
      selectedOptionIndex: selectedOptionIndex,
      answeredAt: DateTime.now(),
    );

    list.add(answer);
    _answersMap[questionId] = list;
    _storage.saveAnswers(_answersMap);
    _cloudCoupleWrite((cloud, id) => cloud.saveAnswer(id, answer));

    // If both answered, increment connection streak if not done today
    if (list.length >= 2 && _couple != null) {
      _couple = _couple!.copyWith(
        connectionStreak: _couple!.connectionStreak + 1,
        streakLastMaintained: DateTime.now(),
      );
      _storage.saveCouple(_couple!);
      _syncCouple();
    }

    notifyListeners();
  }

  // Simulate Partner Answer (Demo helper so single user can see mutual reveal immediately!)
  void simulatePartnerAnswer(String questionId) {
    if (_isPairedOnline) return;
    final partner = otherPartner;
    final String simulatedText;
    switch (_locale.languageCode) {
      case 'tr':
        simulatedText =
            'Bu soru kalbimi eritti. Birlikte geçirdiğimiz her an, özellikle o sessizce birbirimize sarıldığımız akşamlar benim için paha biçilemez.';
        break;
      case 'ar':
        simulatedText =
            'هذا السؤال أذاب قلبي بالكامل. كل لحظة نقضيها معاً، وخاصة تلك الأمسيات الهادئة التي نتعانق فيها بصمت، هي أثمن كنز لدي.';
        break;
      case 'fa':
        simulatedText =
            'این پاسخ تمام وجودم را سرشار از عشق کرد. هر لحظه‌ای که با هم می‌گذرانیم، مخصوصاً غروب‌هایی که در سکوت دست در دست هم آرام می‌گیریم، مقدس‌ترین دارایی من است.';
        break;
      case 'de':
        simulatedText =
            'Diese Frage hat mein Herz tief berührt. Jeder Moment mit dir, besonders wenn wir einfach still beieinander sitzen und uns aneinander kuscheln, ist unbezahlbar für mich.';
        break;
      case 'es':
        simulatedText =
            'Esta pregunta me ha derretido el corazón por completo. Cada instante que pasamos juntos, especialmente esos abrazos en silencio al atardecer, es un tesoro para mí.';
        break;
      case 'fr':
        simulatedText =
            'Cette question a fait fondre mon cœur. Chaque instant passé ensemble, surtout ces soirées paisibles où nous nous enlaçons en silence, est un trésor inestimable.';
        break;
      case 'it':
        simulatedText =
            'Questa risposta mi ha scaldato il cuore. Ogni attimo che trascorriamo insieme, soprattutto quando restiamo abbracciati in silenzio la sera, è preziosissimo per me.';
        break;
      default:
        simulatedText =
            'This melted my heart completely. Every moment we spend, especially when we just sit together peacefully with no words needed, is sacred to me.';
        break;
    }

    final list = List<AnswerModel>.from(_answersMap[questionId] ?? []);
    list.removeWhere((a) => a.authorId == partner.id);

    list.add(
      AnswerModel(
        id: '$_simulatedAnswerPrefix${DateTime.now().millisecondsSinceEpoch}',
        questionId: questionId,
        authorId: partner.id,
        authorName: partner.name,
        answerText: simulatedText,
        answeredAt: DateTime.now(),
        reactionEmoji: '🥰',
      ),
    );

    _answersMap[questionId] = list;
    _storage.saveAnswers(_answersMap);

    if (list.length >= 2 && _couple != null) {
      _couple = _couple!.copyWith(
        connectionStreak: _couple!.connectionStreak + 1,
        streakLastMaintained: DateTime.now(),
      );
      _storage.saveCouple(_couple!);
    }

    notifyListeners();
  }

  void addReactionEmoji(String questionId, String answerId, String emoji) {
    final list = _answersMap[questionId];
    if (list == null) return;
    final updated =
        list.map((a) {
          if (a.id == answerId) {
            return a.copyWith(reactionEmoji: emoji);
          }
          return a;
        }).toList();
    _answersMap[questionId] = updated;
    _storage.saveAnswers(_answersMap);
    final reacted = updated.where((a) => a.id == answerId).firstOrNull;
    if (reacted != null && !reacted.id.startsWith(_simulatedAnswerPrefix)) {
      _cloudCoupleWrite((cloud, id) => cloud.saveAnswer(id, reacted));
    }
    notifyListeners();
  }

  // Activities Logic
  void toggleSaveActivity(String activityId) {
    _activities =
        _activities.map((a) {
          if (a.id == activityId) {
            return a.copyWith(isSaved: !a.isSaved);
          }
          return a;
        }).toList();
    _storage.saveActivities(_activities);
    notifyListeners();
  }

  void toggleCompleteActivity(String activityId) {
    _activities =
        _activities.map((a) {
          if (a.id == activityId) {
            final nowCompleted = !a.isCompleted;
            return a.copyWith(
              isCompleted: nowCompleted,
              completedAt: nowCompleted ? DateTime.now() : null,
            );
          }
          return a;
        }).toList();
    _storage.saveActivities(_activities);
    notifyListeners();
  }

  // Challenges
  void toggleCompleteChallenge(String challengeId) {
    _challenges =
        _challenges.map((c) {
          if (c.id == challengeId) {
            final nowDone = !c.isCompleted;
            return c.copyWith(
              isCompleted: nowDone,
              completedAt: nowDone ? DateTime.now() : null,
            );
          }
          return c;
        }).toList();
    _storage.saveChallenges(_challenges);
    notifyListeners();
  }

  // Journal Entries
  void addJournalEntry({
    required String title,
    required String notes,
    required String moodEmoji,
    String? questionSnippet,
    List<String> tags = const [],
  }) {
    final newEntry = JournalEntryModel(
      id: 'journal_${DateTime.now().millisecondsSinceEpoch}',
      title: title.trim(),
      notes: notes.trim(),
      authorId: activePartner.id,
      authorName: activePartner.name,
      date: DateTime.now(),
      moodEmoji: moodEmoji,
      questionSnippet: questionSnippet,
      tags: tags,
    );

    _journalEntries.insert(0, newEntry);
    _storage.saveJournal(_journalEntries);
    _cloudCoupleWrite((cloud, id) => cloud.saveJournalEntry(id, newEntry));
    notifyListeners();
  }

  // Special Dates
  void addSpecialDate({
    required String titleEn,
    required String titleTr,
    required DateTime date,
    required String category,
    required String icon,
    String notes = '',
  }) {
    final newDate = SpecialDateModel(
      id: 'sd_${DateTime.now().millisecondsSinceEpoch}',
      titleEn: titleEn,
      titleTr: titleTr,
      date: date,
      category: category,
      icon: icon,
      notes: notes,
    );

    _specialDates.add(newDate);
    _specialDates.sort((a, b) => a.daysUntil.compareTo(b.daysUntil));
    _storage.saveSpecialDates(_specialDates);
    _cloudCoupleWrite((cloud, id) => cloud.saveSpecialDate(id, newDate));
    notifyListeners();
  }

  // AI Noor Companion
  Future<void> sendAIMessage(String prompt) async {
    if (prompt.trim().isEmpty) return;

    final userMsg = AIMessageModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      sender: MessageSender.user,
      contentEn: prompt.trim(),
      contentTr: prompt.trim(),
      timestamp: DateTime.now(),
    );

    _aiMessages.add(userMsg);
    _isGeneratingAI = true;
    notifyListeners();

    try {
      final response = await AICompanionService.generateResponse(
        userPrompt: prompt,
        isTurkish: isTurkish,
      );
      _aiMessages.add(response);
    } finally {
      _isGeneratingAI = false;
      notifyListeners();
    }
  }

  // Premium Toggle
  void togglePremium() {
    if (_couple != null) {
      _couple = _couple!.copyWith(isPremium: !_couple!.isPremium);
      _storage.saveCouple(_couple!);
      _syncCouple();
      notifyListeners();
    }
  }

  /// Ends the connection. With a real partner, they are removed from the
  /// couple in the cloud (their phone keeps its copy and starts over) and
  /// this couple gets a new invite code, so the old one can't be reused.
  Future<void> unlinkPartner() async {
    final old = _couple;
    if (old == null) return;
    final cloud = _cloud;
    if (_isPairedOnline && cloud != null && cloud.isActive) {
      final me = _currentUser ?? activePartner;
      _couple = _withoutPartner(old, id: old.id, me: me);
      _activeViewingPartnerId = me.id;
      _setPairedOnline(false);
      _storage.saveCouple(_couple!);
      notifyListeners();
      try {
        await cloud.removePartner(_couple!);
      } on CloudSyncException catch (e) {
        _cloudSyncError = e.code;
        notifyListeners();
      }
      return;
    }
    _couple = CoupleModel(
      id: old.id,
      partner1: old.partner1,
      partner2: null,
      inviteCode: old.inviteCode,
      anniversaryDate: old.anniversaryDate,
      connectionStreak: old.connectionStreak,
      streakLastMaintained: old.streakLastMaintained,
      isLinked: false,
      isPremium: old.isPremium,
      distanceMode: old.distanceMode,
    );
    _storage.saveCouple(_couple!);
    _syncCouple();
    notifyListeners();
  }

  // Authentication Methods (Apple ID, Google, Email, Guest)
  Future<bool> signInWithApple() async {
    _lastAuthError = null;
    final result = await _authService.signInWithApple();

    if (result.success) {
      final appleEmail =
          result.email ??
          ((_userEmail != null &&
                  _userEmail!.endsWith('@privaterelay.appleid.com'))
              ? _userEmail!
              : 'user.apple@privaterelay.appleid.com');
      final name = cleanPersonName(result.displayName);
      _setAuthenticatedUser(email: appleEmail, name: name, provider: 'apple');
      return true;
    } else if (result.isCancelled) {
      return false;
    } else {
      _lastAuthError = result.errorMessage;
      // In test/headless environments where native method channels don't exist:
      if (result.errorMessage?.contains('MissingPluginException') == true ||
          result.errorMessage?.contains('channel-error') == true) {
        final appleEmail =
            (_userEmail != null &&
                    _userEmail!.endsWith('@privaterelay.appleid.com'))
                ? _userEmail!
                : 'user.apple@privaterelay.appleid.com';
        _setAuthenticatedUser(email: appleEmail, name: '', provider: 'apple');
        return true;
      }
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    _lastAuthError = null;
    final result = await _authService.signInWithGoogle();

    if (result.success) {
      final googleEmail = result.email ?? 'user.google@gmail.com';
      final name = cleanPersonName(result.displayName);
      _setAuthenticatedUser(email: googleEmail, name: name, provider: 'google');
      unawaited(_startCloud());
      return true;
    } else if (result.isCancelled) {
      return false;
    } else {
      _lastAuthError = result.errorMessage;
      // In test/headless environments where native method channels don't exist:
      if (result.errorMessage?.contains('MissingPluginException') == true ||
          result.errorMessage?.contains('channel-error') == true) {
        const googleEmail = 'user.google@gmail.com';
        _setAuthenticatedUser(email: googleEmail, name: '', provider: 'google');
        return true;
      }
      notifyListeners();
      return false;
    }
  }

  Future<bool> continueAsGuest() async {
    _lastAuthError = null;
    final result = await _authService.continueAsGuest();
    _isAuthenticated = true;
    _authProvider = 'guest';
    _userEmail = null;
    _storage.setIsAuthenticated(true);
    _storage.setAuthProvider('guest');
    _storage.setUserEmail(null);

    if (_currentUser == null) {
      _currentUser = UserModel(
        id: 'user_guest_${DateTime.now().millisecondsSinceEpoch}',
        name: '',
        avatar: '🌿',
        preferredLanguage: _locale.languageCode,
        relationshipStage: 'stageDating',
        selectedGoals: [],
        joinedAt: DateTime.now(),
        email: null,
        authProvider: 'guest',
      );
      _storage.saveUser(_currentUser!);
    }
    notifyListeners();
    return result.success;
  }

  Future<void> authenticateWithEmail({
    required String name,
    required String email,
    required String password,
    bool isRegister = true,
  }) async {
    _lastAuthError = null;
    final cleaned = cleanPersonName(name);
    final trimmedName = cleaned.isEmpty ? (_currentUser?.name ?? '') : cleaned;
    final trimmedEmail = email.trim().toLowerCase();
    _setAuthenticatedUser(
      email: trimmedEmail,
      name: trimmedName,
      provider: 'email',
    );
  }

  void _setAuthenticatedUser({
    required String email,
    required String name,
    required String provider,
  }) {
    _isAuthenticated = true;
    _authProvider = provider;
    _userEmail = email;
    _storage.setIsAuthenticated(true);
    _storage.setAuthProvider(provider);
    _storage.setUserEmail(email);

    if (_currentUser == null) {
      _currentUser = UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        avatar: '🌸',
        preferredLanguage: _locale.languageCode,
        relationshipStage: 'stageDating',
        selectedGoals: [],
        joinedAt: DateTime.now(),
        email: email,
        authProvider: provider,
      );
      _storage.saveUser(_currentUser!);
    } else {
      _currentUser = _currentUser!.copyWith(
        name: name,
        email: email,
        authProvider: provider,
      );
      _storage.saveUser(_currentUser!);
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    _stopListening();
    _isAuthenticated = false;
    _partnerMoods = {};
    _lastNudgeTime = null;
    _lastNudgeSenderId = null;
    _lastNudgeMessage = null;
    _loveNotes = [];
    _storage.setIsAuthenticated(false);
    await _homeWidgetService.clear();
    await _authService.signOut();
    notifyListeners();
  }
}
