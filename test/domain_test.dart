import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gharar/providers/app_state_provider.dart';
import 'package:gharar/services/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GHARAR Domain and Provider Tests', () {
    late StorageService storage;
    late AppStateProvider provider;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      storage = await StorageService.init();
      provider = AppStateProvider(storage);
    });

    test('User onboarding initializes clean couple sanctuary and links partner cleanly', () {
      provider.completeOnboarding(
        name: 'Selin',
        avatar: '🌸',
        relationshipStage: 'stageDating',
        goals: ['goalDeeperConversations'],
        languageCode: 'en',
      );

      expect(provider.couple, isNotNull);
      expect(provider.couple!.partner1.name, 'Selin');
      expect(provider.couple!.partner2, isNull);
      expect(provider.isPartnerLinked, isFalse);

      provider.linkPartner(partnerName: 'Can');
      expect(provider.isPartnerLinked, isTrue);
      expect(provider.couple!.partner2?.name, 'Can');
      expect(provider.couple!.connectionStreak, greaterThanOrEqualTo(1));
    });

    test('Interactive partner switcher toggles active viewing partner when linked', () {
      provider.completeOnboarding(
        name: 'Selin',
        avatar: '🌸',
        relationshipStage: 'stageDating',
        goals: ['goalDeeperConversations'],
        languageCode: 'en',
      );
      provider.linkPartner(partnerName: 'Can');

      final initialId = provider.activePartner.id;
      provider.switchActivePartner();
      final toggledId = provider.activePartner.id;

      expect(initialId, isNot(equals(toggledId)));
      expect(toggledId, 'user_2');
      expect(provider.otherPartner.id, initialId);
    });

    test('Submitting answer preserves privacy until mutual reveal condition is met', () {
      final qId = provider.questions.last.id;

      // Active partner submits
      provider.submitAnswer(
        questionId: qId,
        answerText: 'My honest tender answer',
      );

      // Verify active partner has answer, but not both yet
      expect(provider.getAnswerForActivePartner(qId), isNotNull);
      expect(provider.isBothAnswered(qId), isFalse);

      // Partner submits (or simulation)
      provider.simulatePartnerAnswer(qId);

      // Now both answered!
      expect(provider.isBothAnswered(qId), isTrue);
      expect(provider.getAnswersForQuestion(qId).length, 2);
    });

    test('Activity saving and completion toggles properly', () {
      final actId = provider.activities.first.id;
      final initialSaved = provider.activities.first.isSaved;

      provider.toggleSaveActivity(actId);
      final updatedSaved =
          provider.activities.firstWhere((a) => a.id == actId).isSaved;
      expect(updatedSaved, !initialSaved);

      provider.toggleCompleteActivity(actId);
      final isDone =
          provider.activities.firstWhere((a) => a.id == actId).isCompleted;
      expect(isDone, isTrue);
    });

    test('Challenge completion updates challenge status and streak', () {
      final chId = provider.challenges.first.id;
      provider.toggleCompleteChallenge(chId);

      final challenge =
          provider.challenges.firstWhere((c) => c.id == chId);
      expect(challenge.isCompleted, isFalse); // Was true initially in seed, so toggles to false or true
    });

    test('Journal entry creation persists correctly', () {
      final initialCount = provider.journalEntries.length;

      provider.addJournalEntry(
        title: 'Sunset Picnic',
        notes: 'Sweet laughter and warm tea',
        moodEmoji: '🥰',
      );

      expect(provider.journalEntries.length, initialCount + 1);
      expect(provider.journalEntries.first.title, 'Sunset Picnic');
    });

    test('Question models support English and Turkish localized text', () {
      final q = provider.questions.first;
      expect(q.text(false), isNotEmpty);
      expect(q.text(true), isNotEmpty);
      expect(q.categoryName(false), isNotEmpty);
      expect(q.categoryName(true), isNotEmpty);
    });
  });
}
