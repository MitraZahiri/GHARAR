import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gharar/services/storage_service.dart';
import 'package:gharar/providers/app_state_provider.dart';

void main() {
  group('AppStateProvider Comprehensive Unit Tests', () {
    late StorageService storage;
    late AppStateProvider provider;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      storage = StorageService(prefs);
      provider = AppStateProvider(storage);
    });

    test('Initial state values and language/theme toggling', () {
      expect(provider.isAuthenticated, isFalse);
      expect(provider.hasOnboarded, isFalse);
      expect(provider.isDarkMode, isFalse);
      expect(provider.isTurkish, isFalse);

      provider.toggleTheme();
      expect(provider.isDarkMode, isTrue);

      provider.setLanguageCode('tr');
      expect(provider.isTurkish, isTrue);
      expect(provider.locale.languageCode, 'tr');

      provider.setLanguageCode('ar');
      expect(provider.isArabic, isTrue);
      expect(provider.isRtl, isTrue);

      provider.setLanguageCode('fa');
      expect(provider.isFarsi, isTrue);

      provider.setLanguageCode('de');
      expect(provider.isGerman, isTrue);

      provider.setLanguageCode('es');
      expect(provider.isSpanish, isTrue);

      provider.setLanguageCode('fr');
      expect(provider.isFrench, isTrue);

      provider.setLanguageCode('it');
      expect(provider.isItalian, isTrue);
    });

    test('Onboarding completion and partner linking / switching', () {
      provider.completeOnboarding(
        name: 'Selin',
        avatar: '🌸',
        relationshipStage: 'married',
        goals: const ['deep_talks', 'romance'],
        languageCode: 'tr',
        email: 'selin@example.com',
      );

      expect(provider.hasOnboarded, isTrue);
      expect(provider.currentUser?.name, 'Selin');
      expect(provider.activePartner.name, 'Selin');
      expect(provider.couple, isNotNull);
      expect(provider.isPartnerLinked, isFalse);

      // Link partner
      provider.linkPartner(partnerName: 'Can', avatar: '🌿');
      expect(provider.isPartnerLinked, isTrue);
      expect(provider.couple?.partner2?.name, 'Can');
      expect(provider.otherPartner.name, 'Can');

      // Switch active partner
      provider.switchActivePartner();
      expect(provider.activePartner.name, 'Can');
      expect(provider.otherPartner.name, 'Selin');

      // Switch back
      provider.switchActivePartner();
      expect(provider.activePartner.name, 'Selin');

      // Unlink partner
      provider.unlinkPartner();
      expect(provider.isPartnerLinked, isFalse);
      expect(provider.couple?.partner2, isNull);
    });

    test(
      'Daily Questions, answer submission, mutual-reveal, and streak logic',
      () {
        provider.completeOnboarding(
          name: 'Selin',
          avatar: '🌸',
          relationshipStage: 'married',
          goals: const ['deep_talks'],
          languageCode: 'tr',
        );
        provider.linkPartner(partnerName: 'Can');

        expect(provider.questions, isNotEmpty);
        expect(provider.currentQuestion, isNotNull);

        final initialIdx = provider.currentQuestionIndex;
        provider.nextQuestion();
        expect(
          provider.currentQuestionIndex,
          (initialIdx + 1) % provider.questions.length,
        );

        provider.setQuestionIndex(2);
        expect(provider.currentQuestionIndex, 2);

        provider.drawRandomQuestion();
        expect(
          provider.currentQuestionIndex,
          inInclusiveRange(0, provider.questions.length - 1),
        );

        final qId = provider.currentQuestion!.id;
        expect(provider.getAnswersForQuestion(qId), isEmpty);
        expect(provider.isBothAnswered(qId), isFalse);

        // Partner 1 submits answer
        provider.submitAnswer(
          questionId: qId,
          answerText: 'Selin answer for the question',
          selectedOptionIndex: 0,
        );

        expect(
          provider.getAnswerForActivePartner(qId)?.answerText,
          'Selin answer for the question',
        );
        expect(provider.getAnswerForOtherPartner(qId), isNull);
        expect(provider.isBothAnswered(qId), isFalse);

        final initialStreak = provider.couple!.connectionStreak;

        // Simulate partner answer (mutual reveal triggered!)
        provider.simulatePartnerAnswer(qId);

        expect(provider.getAnswerForOtherPartner(qId), isNotNull);
        expect(provider.isBothAnswered(qId), isTrue);
        expect(provider.couple!.connectionStreak, initialStreak + 1);

        // Add reaction emoji
        final otherAns = provider.getAnswerForOtherPartner(qId)!;
        provider.addReactionEmoji(qId, otherAns.id, '❤️');
        expect(provider.getAnswerForOtherPartner(qId)?.reactionEmoji, '❤️');
      },
    );

    test('Activities, Challenges, and Journal Entries operations', () {
      provider.completeOnboarding(
        name: 'Selin',
        avatar: '🌸',
        relationshipStage: 'married',
        goals: const [],
        languageCode: 'en',
      );

      // Activities
      expect(provider.activities, isNotEmpty);
      final actId = provider.activities.first.id;
      final wasSaved = provider.activities.first.isSaved;
      provider.toggleSaveActivity(actId);
      expect(provider.activities.first.isSaved, !wasSaved);

      final wasCompleted = provider.activities.first.isCompleted;
      provider.toggleCompleteActivity(actId);
      expect(provider.activities.first.isCompleted, !wasCompleted);

      // Challenges
      expect(provider.challenges, isNotEmpty);
      final chId = provider.challenges.first.id;
      final wasChDone = provider.challenges.first.isCompleted;
      provider.toggleCompleteChallenge(chId);
      expect(provider.challenges.first.isCompleted, !wasChDone);

      // Journal
      final initialJournalCount = provider.journalEntries.length;
      provider.addJournalEntry(
        title: 'Sunset conversation',
        notes: 'We talked about our dream home.',
        moodEmoji: '🌅',
        tags: ['home', 'dreams'],
      );
      expect(provider.journalEntries.length, initialJournalCount + 1);
      expect(provider.journalEntries.first.title, 'Sunset conversation');

      // Special Dates
      final initialDateCount = provider.specialDates.length;
      provider.addSpecialDate(
        titleEn: 'Trip to Cappadocia',
        titleTr: 'Kapadokya Gezisi',
        date: DateTime(2026, 9, 10),
        category: 'Trip',
        icon: '🎈',
        notes: 'Hot air balloon ride',
      );
      expect(provider.specialDates.length, initialDateCount + 1);

      // Premium toggle
      final wasPremium = provider.couple!.isPremium;
      provider.togglePremium();
      expect(provider.couple!.isPremium, !wasPremium);
    });

    test('AI Companion message sending and state updates', () async {
      final initialCount = provider.aiMessages.length;
      final future = provider.sendAIMessage('Tell us a sweet bedtime ritual');
      expect(provider.isGeneratingAI, isTrue);
      await future;
      expect(provider.isGeneratingAI, isFalse);
      expect(
        provider.aiMessages.length,
        initialCount + 2,
      ); // user msg + AI response
    });

    test(
      'Authentication flows: Apple, Email, Google, Guest, and Sign Out',
      () async {
        await provider.signInWithApple();
        expect(provider.isAuthenticated, isTrue);
        expect(provider.authProvider, 'apple');
        expect(provider.userEmail, contains('@privaterelay.appleid.com'));

        await provider.signInWithGoogle();
        expect(provider.isAuthenticated, isTrue);
        expect(provider.authProvider, 'google');
        expect(provider.userEmail, equals('user.google@gmail.com'));

        await provider.continueAsGuest();
        expect(provider.isAuthenticated, isTrue);
        expect(provider.authProvider, 'guest');
        expect(provider.userEmail, isNull);

        await provider.authenticateWithEmail(
          name: 'Leyla',
          email: 'leyla@gharar.love',
          password: 'securePassword123',
        );
        expect(provider.isAuthenticated, isTrue);
        expect(provider.authProvider, 'email');
        expect(provider.userEmail, 'leyla@gharar.love');
        expect(provider.currentUser?.name, 'Leyla');

        await provider.signOut();
        expect(provider.isAuthenticated, isFalse);
      },
    );
  });
}
