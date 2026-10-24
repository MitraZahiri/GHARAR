import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gharar/services/storage_service.dart';
import 'package:gharar/services/ai_companion_service.dart';
import 'package:gharar/models/user_model.dart';
import 'package:gharar/models/couple_model.dart';
import 'package:gharar/models/question_model.dart';
import 'package:gharar/models/activity_model.dart';
import 'package:gharar/models/challenge_model.dart';
import 'package:gharar/models/journal_entry_model.dart';
import 'package:gharar/models/special_date_model.dart';
import 'package:gharar/models/ai_message_model.dart';

void main() {
  group('AICompanionService Tests', () {
    test('getInitialMessages returns valid welcome message', () {
      final initial = AICompanionService.getInitialMessages();
      expect(initial, isNotEmpty);
      expect(initial.first.sender, MessageSender.noor);
      expect(initial.first.content(true), contains('Noor'));
      expect(initial.first.content(false), contains('Noor'));
    });

    test('generateResponse handles feeling and emotions prompt', () async {
      final responseTr = await AICompanionService.generateResponse(
        userPrompt: 'Duygularımı nasıl ifade etmeliyim?',
        isTurkish: true,
      );
      expect(responseTr.sender, MessageSender.noor);
      expect(responseTr.content(true), contains('Duygularınızı paylaşırken'));

      final responseEn = await AICompanionService.generateResponse(
        userPrompt: 'How can I express feeling vulnerable?',
        isTurkish: false,
      );
      expect(responseEn.content(false), contains('tender emotions'));
    });

    test('generateResponse handles surprise and date ideas prompt', () async {
      final responseTr = await AICompanionService.generateResponse(
        userPrompt: 'Bu akşam için güzel bir sürpriz randevu önerisi var mı?',
        isTurkish: true,
      );
      expect(responseTr.content(true), contains('Çay Seremonisi'));

      final responseEn = await AICompanionService.generateResponse(
        userPrompt: 'Give me a cozy date idea',
        isTurkish: false,
      );
      expect(responseEn.content(false), contains('Tea Ceremony'));
    });

    test('generateResponse handles disagreement and dispute prompt', () async {
      final responseTr = await AICompanionService.generateResponse(
        userPrompt: 'Ufak bir tartışma yaşadık ve kırgınız',
        isTurkish: true,
      );
      expect(responseTr.content(true), contains('Fikir ayrılıkları'));

      final responseEn = await AICompanionService.generateResponse(
        userPrompt: 'We had a fight and disagree on things',
        isTurkish: false,
      );
      expect(responseEn.content(false), contains('Differences of perspective'));
    });

    test(
      'generateResponse returns default warm reflection on generic prompts',
      () async {
        final response = await AICompanionService.generateResponse(
          userPrompt: 'Hello Noor, good morning',
          isTurkish: true,
        );
        expect(response.content(true), contains('Büyük aşklar'));
        expect(response.content(false), contains('Love is built'));
      },
    );
  });

  group('StorageService Comprehensive Tests', () {
    late StorageService storage;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      storage = StorageService(prefs);
    });

    test('Authentication and user profile prefs persistence', () async {
      expect(storage.isAuthenticated, isFalse);
      expect(storage.userEmail, isNull);
      expect(storage.authProvider, isNull);
      expect(storage.hasOnboarded, isFalse);

      await storage.setIsAuthenticated(true);
      await storage.setUserEmail('test@gharar.love');
      await storage.setAuthProvider('apple');
      await storage.setHasOnboarded(true);

      expect(storage.isAuthenticated, isTrue);
      expect(storage.userEmail, 'test@gharar.love');
      expect(storage.authProvider, 'apple');
      expect(storage.hasOnboarded, isTrue);

      // Null handling (removal)
      await storage.setUserEmail(null);
      await storage.setAuthProvider(null);
      expect(storage.userEmail, isNull);
      expect(storage.authProvider, isNull);
    });

    test('Theme and locale preferences persistence', () async {
      expect(storage.themeMode, ThemeMode.system);
      expect(storage.localeCode, 'en');

      await storage.setThemeMode(ThemeMode.dark);
      await storage.setLocaleCode('tr');

      expect(storage.themeMode, ThemeMode.dark);
      expect(storage.localeCode, 'tr');
    });

    test('User and Couple persistence and corrupt data resilience', () async {
      expect(storage.getUser(), isNull);
      expect(storage.getCouple(), isNull);

      final now = DateTime(2026, 1, 1);
      final user = UserModel(
        id: 'u_test',
        name: 'Aslı',
        avatar: '🪷',
        preferredLanguage: 'tr',
        relationshipStage: 'married',
        selectedGoals: const ['gratitude'],
        joinedAt: now,
      );

      await storage.saveUser(user);
      final savedUser = storage.getUser();
      expect(savedUser, equals(user));

      final couple = CoupleModel(
        id: 'c_test',
        partner1: user,
        inviteCode: 'TEST99',
        anniversaryDate: DateTime(2025, 5, 20),
      );

      await storage.saveCouple(couple);
      final savedCouple = storage.getCouple();
      expect(savedCouple, equals(couple));

      // Corrupt data test
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('gharar_user', 'invalid-json{{{');
      await prefs.setString('gharar_couple', 'invalid-json{{{');

      expect(storage.getUser(), isNull);
      expect(storage.getCouple(), isNull);
    });

    test('Answers map persistence and corrupt handling', () async {
      expect(storage.getAnswers(), isEmpty);

      final now = DateTime(2026, 1, 1);
      final answer = AnswerModel(
        id: 'a1',
        questionId: 'q1',
        authorId: 'u1',
        authorName: 'Kerem',
        answerText: 'A quiet sunset walk',
        answeredAt: now,
      );

      await storage.saveAnswers({
        'q1': [answer],
      });

      final retrieved = storage.getAnswers();
      expect(retrieved.containsKey('q1'), isTrue);
      expect(retrieved['q1']!.length, 1);
      expect(retrieved['q1']!.first, equals(answer));

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('gharar_answers', 'not_a_json_map');
      expect(storage.getAnswers(), isEmpty);
    });

    test(
      'Activities, Challenges, Journal and SpecialDates persistence',
      () async {
        expect(storage.getActivities(), isNull);
        expect(storage.getChallenges(), isNull);
        expect(storage.getJournal(), isNull);
        expect(storage.getSpecialDates(), isNull);

        final now = DateTime(2026, 1, 1);
        final activity = ActivityModel(
          id: 'act1',
          titleEn: 'Title En',
          titleTr: 'Title Tr',
          descriptionEn: 'Desc En',
          descriptionTr: 'Desc Tr',
          categoryEn: 'Fun',
          categoryTr: 'Eğlence',
          budget: ActivityBudget.free,
          setting: ActivitySetting.atHome,
          vibe: ActivityVibe.playful,
          duration: '1 hr',
          icon: '🎲',
          tipsEn: const [],
          tipsTr: const [],
        );
        final challenge = ChallengeModel(
          id: 'ch1',
          weekNumber: 1,
          titleEn: 'Ch En',
          titleTr: 'Ch Tr',
          descriptionEn: 'Desc En',
          descriptionTr: 'Desc Tr',
          rewardBadge: '⭐',
          badgeNameEn: 'Badge En',
          badgeNameTr: 'Badge Tr',
          encouragementEn: 'Enc En',
          encouragementTr: 'Enc Tr',
        );
        final journal = JournalEntryModel(
          id: 'j1',
          title: 'Title',
          notes: 'Notes',
          authorId: 'u1',
          authorName: 'Kerem',
          date: now,
        );
        final specialDate = SpecialDateModel(
          id: 'sd1',
          titleEn: 'Anniversary',
          titleTr: 'Yıldönümü',
          date: now,
          category: 'Anniversary',
          icon: '💍',
        );

        await storage.saveActivities([activity]);
        await storage.saveChallenges([challenge]);
        await storage.saveJournal([journal]);
        await storage.saveSpecialDates([specialDate]);

        expect(storage.getActivities()?.first, equals(activity));
        expect(storage.getChallenges()?.first, equals(challenge));
        expect(storage.getJournal()?.first, equals(journal));
        expect(storage.getSpecialDates()?.first, equals(specialDate));

        // Test clearAll
        await storage.clearAll();
        expect(storage.getActivities(), isNull);
        expect(storage.getChallenges(), isNull);
        expect(storage.getJournal(), isNull);
        expect(storage.getSpecialDates(), isNull);
      },
    );

    test('StorageService.init returns initialized instance', () async {
      final initialized = await StorageService.init();
      expect(initialized, isA<StorageService>());
    });
  });
}
