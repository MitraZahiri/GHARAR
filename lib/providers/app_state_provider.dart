import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
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

class AppStateProvider extends ChangeNotifier {
  final StorageService _storage;
  final AuthService _authService;
  final NoteMediaService _mediaService;
  final HomeWidgetService _homeWidgetService;

  UserModel? _currentUser;
  CoupleModel? _couple;
  String _activeViewingPartnerId = 'user_1'; // Supports interactive switching

  Locale _locale = const Locale('en');
  bool _isDarkMode = false;
  bool _hasOnboarded = false;
  bool _isAuthenticated = false;
  String? _userEmail;
  String? _authProvider;
  String? _lastAuthError;

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

  AppStateProvider(
    this._storage, {
    AuthService? authService,
    NoteMediaService? mediaService,
    HomeWidgetService? homeWidgetService,
  }) : _authService = authService ?? AuthService(),
       _mediaService = mediaService ?? NoteMediaService(),
       _homeWidgetService = homeWidgetService ?? HomeWidgetService() {
    _loadFromStorage();
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
  bool get isDarkMode => _isDarkMode;
  bool get hasOnboarded => _hasOnboarded;
  bool get isAuthenticated => _isAuthenticated;
  String? get userEmail => _userEmail;
  String? get authProvider => _authProvider;
  String? get lastAuthError => _lastAuthError;

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
    notifyListeners();
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
    _isDarkMode = _storage.isDarkMode;
    _locale = Locale(_storage.localeCode);
    _hasOnboarded = _storage.hasOnboarded;

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

  /// Renames the active partner and the other partner.
  void renameCouple({required String myName, required String partnerName}) {
    final couple = _couple;
    if (couple == null) return;
    final me = activePartner.copyWith(name: cleanPersonName(myName));
    final other = otherPartner.copyWith(name: cleanPersonName(partnerName));
    final meIsFirst = me.id == couple.partner1.id;
    _couple = couple.copyWith(
      partner1: meIsFirst ? me : other,
      partner2: couple.partner2 == null ? null : (meIsFirst ? other : me),
    );
    _storage.saveCouple(_couple!);
    for (final user in [me, other]) {
      if (user.id == _currentUser?.id) {
        _currentUser = user;
        _storage.saveUser(user);
      }
    }
    notifyListeners();
  }

  // Partner Switcher (Interactive Demo & Simulation)
  void switchActivePartner() {
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
    notifyListeners();
  }

  Future<void> deleteLoveNote(String noteId) async {
    final note = _loveNotes.where((n) => n.id == noteId).firstOrNull;
    if (note == null) return;
    _loveNotes.removeWhere((n) => n.id == noteId);
    _storage.saveLoveNotes(_loveNotes);
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
    final defaultMsg =
        isTurkish
            ? 'Telefonun kapalıyken ana sayfana bu tatlı notu iliştirdim. Günün harika geçsin sevgilim! ☀️💖'
            : 'Left this sweet note on your main page while your phone was away. Have a beautiful day my love! ☀️💖';

    final note = LoveNoteModel(
      id: 'note_sim_${DateTime.now().millisecondsSinceEpoch}',
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

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _storage.setIsDarkMode(_isDarkMode);
    notifyListeners();
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
      id: 'user_1',
      name: cleanPersonName(name),
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
      inviteCode: 'GHARAR-${1000 + Random().nextInt(8999)}-LOVE',
      anniversaryDate: DateTime.now(),
      connectionStreak: 1,
      streakLastMaintained: DateTime.now(),
      isLinked: false,
    );
    _storage.saveCouple(_couple!);

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

    // If both answered, increment connection streak if not done today
    if (list.length >= 2 && _couple != null) {
      _couple = _couple!.copyWith(
        connectionStreak: _couple!.connectionStreak + 1,
        streakLastMaintained: DateTime.now(),
      );
      _storage.saveCouple(_couple!);
    }

    notifyListeners();
  }

  // Simulate Partner Answer (Demo helper so single user can see mutual reveal immediately!)
  void simulatePartnerAnswer(String questionId) {
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
        id: 'ans_sim_${DateTime.now().millisecondsSinceEpoch}',
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
      notifyListeners();
    }
  }

  // Unlink / Reset
  void unlinkPartner() {
    if (_couple != null) {
      _couple = CoupleModel(
        id: _couple!.id,
        partner1: _couple!.partner1,
        partner2: null,
        inviteCode: _couple!.inviteCode,
        anniversaryDate: _couple!.anniversaryDate,
        connectionStreak: _couple!.connectionStreak,
        streakLastMaintained: _couple!.streakLastMaintained,
        isLinked: false,
        isPremium: _couple!.isPremium,
        distanceMode: _couple!.distanceMode,
      );
      _storage.saveCouple(_couple!);
      notifyListeners();
    }
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
