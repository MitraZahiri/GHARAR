import 'dart:math';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/couple_model.dart';
import '../models/question_model.dart';
import '../models/activity_model.dart';
import '../models/challenge_model.dart';
import '../models/shared_interest_model.dart';
import '../models/journal_entry_model.dart';
import '../models/special_date_model.dart';
import '../models/ai_message_model.dart';
import '../core/localization/app_language.dart';
import '../services/storage_service.dart';
import '../services/seed_data_service.dart';
import '../services/ai_companion_service.dart';

class AppStateProvider extends ChangeNotifier {
  final StorageService _storage;

  UserModel? _currentUser;
  CoupleModel? _couple;
  String _activeViewingPartnerId = 'user_1'; // Supports interactive switching

  Locale _locale = const Locale('en');
  bool _isDarkMode = false;
  bool _hasOnboarded = false;

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

  bool _isGeneratingAI = false;

  AppStateProvider(this._storage) {
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

  void setLanguageCode(String code) {
    setLocale(Locale(code));
  }

  List<QuestionModel> get questions => _questions;
  int get currentQuestionIndex => _currentQuestionIndex;
  QuestionModel? get currentQuestion =>
      _questions.isNotEmpty ? _questions[_currentQuestionIndex % _questions.length] : null;

  Map<String, List<AnswerModel>> get answersMap => _answersMap;
  List<ActivityModel> get activities => _activities;
  List<ChallengeModel> get challenges => _challenges;
  List<SharedInterestModel> get sharedInterests => _sharedInterests;
  List<JournalEntryModel> get journalEntries => _journalEntries;
  List<MilestoneModel> get milestones => _milestones;
  List<SpecialDateModel> get specialDates => _specialDates;
  List<AIMessageModel> get aiMessages => _aiMessages;
  bool get isGeneratingAI => _isGeneratingAI;

  UserModel get activePartner {
    if (_couple == null) {
      return _currentUser ??
          UserModel(
            id: 'user_1',
            name: 'Mitra',
            avatar: '🌸',
            preferredLanguage: 'en',
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
        name: 'Deniz',
        avatar: '🌿',
        preferredLanguage: 'en',
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
    _isDarkMode = _storage.isDarkMode;
    _locale = Locale(_storage.localeCode);
    _hasOnboarded = _storage.hasOnboarded;

    _currentUser = _storage.getUser();
    _couple = _storage.getCouple();
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

    if (_currentUser == null) {
      seedDemoCouple();
    } else {
      _activeViewingPartnerId = _currentUser!.id;
    }

    notifyListeners();
  }

  void seedDemoCouple() {
    final mitra = UserModel(
      id: 'user_1',
      name: 'Mitra',
      avatar: '🌸',
      preferredLanguage: _locale.languageCode,
      relationshipStage: 'stageLongTerm',
      selectedGoals: ['goalDeeperConversations', 'goalSpontaneousRomance', 'goalFuturePlanning'],
      joinedAt: DateTime(2023, 10, 14),
    );

    final deniz = UserModel(
      id: 'user_2',
      name: 'Deniz',
      avatar: '🌿',
      preferredLanguage: _locale.languageCode,
      relationshipStage: 'stageLongTerm',
      selectedGoals: ['goalDeeperConversations', 'goalUnderstandingNeeds', 'goalFunAdventures'],
      joinedAt: DateTime(2023, 10, 14),
    );

    _currentUser = mitra;
    _activeViewingPartnerId = mitra.id;

    _couple = CoupleModel(
      id: 'couple_gharar_demo',
      partner1: mitra,
      partner2: deniz,
      inviteCode: 'GHARAR-7842-LOVE',
      anniversaryDate: DateTime(2023, 10, 14),
      connectionStreak: 7,
      streakLastMaintained: DateTime.now(),
      isLinked: true,
      isPremium: true,
    );

    _hasOnboarded = true;
    _storage.setHasOnboarded(true);
    _storage.saveUser(mitra);
    _storage.saveCouple(_couple!);

    // Pre-seed some answers for the first question so user can experience the reveal immediately
    final firstQ = _questions.first;
    _answersMap[firstQ.id] = [
      AnswerModel(
        id: 'ans_1',
        questionId: firstQ.id,
        authorId: mitra.id,
        authorName: mitra.name,
        answerText: isTurkish
            ? 'Pazar sabahları kahve yaparken bana o sıcacık gülümsemeyle bakman ve elime dokunman.'
            : 'The way you quietly bring me coffee on Sunday mornings with that warm, sleepy smile and kiss my forehead.',
        answeredAt: DateTime.now().subtract(const Duration(hours: 3)),
        reactionEmoji: '💖',
      ),
      AnswerModel(
        id: 'ans_2',
        questionId: firstQ.id,
        authorId: deniz.id,
        authorName: deniz.name,
        answerText: isTurkish
            ? 'Beni dinlerken gözlerimin içine dikkatle bakman ve elimi usulca avucunun içine alman.'
            : 'When I am speaking excitedly about something and you look straight into my eyes, resting your hand gently on mine.',
        answeredAt: DateTime.now().subtract(const Duration(hours: 2)),
        reactionEmoji: '✨',
      ),
    ];
    _storage.saveAnswers(_answersMap);

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
  }) {
    final user = UserModel(
      id: 'user_1',
      name: name.trim().isEmpty ? 'Mitra' : name.trim(),
      avatar: avatar,
      preferredLanguage: languageCode,
      relationshipStage: relationshipStage,
      selectedGoals: goals,
      joinedAt: DateTime.now(),
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
      name: partnerName.trim().isEmpty ? 'Partner' : partnerName.trim(),
      avatar: avatar,
      preferredLanguage: _locale.languageCode,
      relationshipStage: _currentUser?.relationshipStage ?? 'stageDating',
      selectedGoals: _currentUser?.selectedGoals ?? [],
      joinedAt: DateTime.now(),
    );

    _couple = _couple!.copyWith(
      partner2: partner,
      isLinked: true,
      connectionStreak: (_couple!.connectionStreak == 0) ? 1 : _couple!.connectionStreak,
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

    list.add(AnswerModel(
      id: 'ans_sim_${DateTime.now().millisecondsSinceEpoch}',
      questionId: questionId,
      authorId: partner.id,
      authorName: partner.name,
      answerText: simulatedText,
      answeredAt: DateTime.now(),
      reactionEmoji: '🥰',
    ));

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
    final updated = list.map((a) {
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
    _activities = _activities.map((a) {
      if (a.id == activityId) {
        return a.copyWith(isSaved: !a.isSaved);
      }
      return a;
    }).toList();
    _storage.saveActivities(_activities);
    notifyListeners();
  }

  void toggleCompleteActivity(String activityId) {
    _activities = _activities.map((a) {
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
    _challenges = _challenges.map((c) {
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
      _couple = _couple!.copyWith(
        partner2: null,
        isLinked: false,
      );
      _storage.saveCouple(_couple!);
      notifyListeners();
    }
  }

  void resetToDemo() {
    seedDemoCouple();
  }
}
