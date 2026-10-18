import 'package:flutter_test/flutter_test.dart';
import 'package:gharar/models/user_model.dart';
import 'package:gharar/models/couple_model.dart';
import 'package:gharar/models/question_model.dart';
import 'package:gharar/models/journal_entry_model.dart';
import 'package:gharar/models/milestone_model.dart';
import 'package:gharar/models/activity_model.dart';
import 'package:gharar/models/special_date_model.dart';
import 'package:gharar/models/challenge_model.dart';
import 'package:gharar/models/shared_interest_model.dart';
import 'package:gharar/models/ai_message_model.dart';

void main() {
  group('Domain Models Strict Equality and Immutability Tests', () {
    test('UserModel supports value equality, copyWith, and hashCode', () {
      final now = DateTime(2026, 1, 1);
      final user1 = UserModel(
        id: 'u1',
        name: 'Selin',
        avatar: '🌸',
        preferredLanguage: 'tr',
        relationshipStage: 'married',
        selectedGoals: const ['deep_talks', 'romance'],
        joinedAt: now,
      );

      final user2 = UserModel(
        id: 'u1',
        name: 'Selin',
        avatar: '🌸',
        preferredLanguage: 'tr',
        relationshipStage: 'married',
        selectedGoals: const ['deep_talks', 'romance'],
        joinedAt: now,
      );

      expect(user1, equals(user2));
      expect(user1.hashCode, equals(user2.hashCode));

      final updated = user1.copyWith(name: 'Can');
      expect(updated, isNot(equals(user1)));
      expect(updated.name, 'Can');
      expect(user1.name, 'Selin'); // immutability preserved
    });

    test('CoupleModel supports value equality and copyWith', () {
      final now = DateTime(2026, 1, 1);
      final p1 = UserModel(
        id: 'u1',
        name: 'Selin',
        avatar: '🌸',
        preferredLanguage: 'tr',
        relationshipStage: 'married',
        selectedGoals: const ['deep_talks'],
        joinedAt: now,
      );
      final p2 = UserModel(
        id: 'u2',
        name: 'Can',
        avatar: '🌿',
        preferredLanguage: 'tr',
        relationshipStage: 'married',
        selectedGoals: const ['deep_talks'],
        joinedAt: now,
      );

      final c1 = CoupleModel(
        id: 'c1',
        partner1: p1,
        partner2: p2,
        inviteCode: 'GHARAR-1234',
        anniversaryDate: now,
        connectionStreak: 5,
      );

      final c2 = CoupleModel(
        id: 'c1',
        partner1: p1,
        partner2: p2,
        inviteCode: 'GHARAR-1234',
        anniversaryDate: now,
        connectionStreak: 5,
      );

      expect(c1, equals(c2));
      expect(c1.hashCode, equals(c2.hashCode));

      final streakBumped = c1.copyWith(connectionStreak: 6);
      expect(streakBumped, isNot(equals(c1)));
      expect(streakBumped.connectionStreak, 6);
      expect(c1.connectionStreak, 5);
    });

    test('QuestionModel and AnswerModel support value equality', () {
      const q1 = QuestionModel(
        id: 'q1',
        textEn: 'What do you cherish?',
        textTr: 'Neyi değerli buluyorsun?',
        category: QuestionCategory.love,
        intensity: QuestionIntensity.meaningful,
        optionsEn: ['Warmth', 'Trust'],
        optionsTr: ['Sıcaklık', 'Güven'],
      );

      const q2 = QuestionModel(
        id: 'q1',
        textEn: 'What do you cherish?',
        textTr: 'Neyi değerli buluyorsun?',
        category: QuestionCategory.love,
        intensity: QuestionIntensity.meaningful,
        optionsEn: ['Warmth', 'Trust'],
        optionsTr: ['Sıcaklık', 'Güven'],
      );

      expect(q1, equals(q2));
      expect(q1.hashCode, equals(q2.hashCode));

      final now = DateTime(2026, 1, 1);
      final a1 = AnswerModel(
        id: 'a1',
        questionId: 'q1',
        authorId: 'u1',
        authorName: 'Selin',
        answerText: 'Trust',
        answeredAt: now,
      );
      final a2 = AnswerModel(
        id: 'a1',
        questionId: 'q1',
        authorId: 'u1',
        authorName: 'Selin',
        answerText: 'Trust',
        answeredAt: now,
      );

      expect(a1, equals(a2));
      expect(a1.hashCode, equals(a2.hashCode));
    });

    test('JournalEntryModel and MilestoneModel support value equality', () {
      final now = DateTime(2026, 1, 1);
      final j1 = JournalEntryModel(
        id: 'j1',
        title: 'Starry Night',
        notes: 'Walked under the stars',
        authorId: 'u1',
        authorName: 'Selin',
        date: now,
        tags: const ['date', 'peace'],
      );
      final j2 = JournalEntryModel(
        id: 'j1',
        title: 'Starry Night',
        notes: 'Walked under the stars',
        authorId: 'u1',
        authorName: 'Selin',
        date: now,
        tags: const ['date', 'peace'],
      );

      expect(j1, equals(j2));
      expect(j1.hashCode, equals(j2.hashCode));

      final m1 = MilestoneModel(
        id: 'm1',
        titleEn: '100 Days Streak',
        titleTr: '100 Gün Serisi',
        descriptionEn: 'Celebrated love',
        descriptionTr: 'Aşk kutlandı',
        milestoneDate: now,
        icon: '🌟',
        badgeTextEn: 'Centurion',
        badgeTextTr: 'Yüzyıl',
      );
      final m2 = MilestoneModel(
        id: 'm1',
        titleEn: '100 Days Streak',
        titleTr: '100 Gün Serisi',
        descriptionEn: 'Celebrated love',
        descriptionTr: 'Aşk kutlandı',
        milestoneDate: now,
        icon: '🌟',
        badgeTextEn: 'Centurion',
        badgeTextTr: 'Yüzyıl',
      );

      expect(m1, equals(m2));
      expect(m1.hashCode, equals(m2.hashCode));
    });

    test(
      'ActivityModel, ChallengeModel, SpecialDateModel, SharedInterestModel, AIMessageModel equality',
      () {
        final now = DateTime(2026, 1, 1);
        const act1 = ActivityModel(
          id: 'act1',
          titleEn: 'Stargazing',
          titleTr: 'Yıldızları İzleme',
          descriptionEn: 'Warm blanket night',
          descriptionTr: 'Battaniye altında gece',
          categoryEn: 'Cozy',
          categoryTr: 'Sıcak',
          budget: ActivityBudget.free,
          setting: ActivitySetting.outdoor,
          vibe: ActivityVibe.romantic,
          duration: '1 hr',
          icon: '✨',
          tipsEn: ['Bring tea'],
          tipsTr: ['Çay al'],
        );
        const act2 = ActivityModel(
          id: 'act1',
          titleEn: 'Stargazing',
          titleTr: 'Yıldızları İzleme',
          descriptionEn: 'Warm blanket night',
          descriptionTr: 'Battaniye altında gece',
          categoryEn: 'Cozy',
          categoryTr: 'Sıcak',
          budget: ActivityBudget.free,
          setting: ActivitySetting.outdoor,
          vibe: ActivityVibe.romantic,
          duration: '1 hr',
          icon: '✨',
          tipsEn: ['Bring tea'],
          tipsTr: ['Çay al'],
        );
        expect(act1, equals(act2));

        final ai1 = AIMessageModel(
          id: 'msg1',
          sender: MessageSender.noor,
          contentEn: 'Hello darling',
          contentTr: 'Merhaba canım',
          timestamp: now,
        );
        final ai2 = AIMessageModel(
          id: 'msg1',
          sender: MessageSender.noor,
          contentEn: 'Hello darling',
          contentTr: 'Merhaba canım',
          timestamp: now,
        );
        expect(ai1, equals(ai2));

        final date1 = SpecialDateModel(
          id: 'sd1',
          titleEn: 'First Date',
          titleTr: 'İlk Buluşma',
          date: now,
          category: 'Anniversary',
          icon: '🎉',
        );
        final date2 = SpecialDateModel(
          id: 'sd1',
          titleEn: 'First Date',
          titleTr: 'İlk Buluşma',
          date: now,
          category: 'Anniversary',
          icon: '🎉',
        );
        expect(date1, equals(date2));
        expect(date1.hashCode, equals(date2.hashCode));

        const ch1 = ChallengeModel(
          id: 'ch1',
          weekNumber: 1,
          titleEn: 'Eye Contact',
          titleTr: 'Göz Teması',
          descriptionEn: 'Look for 5 mins',
          descriptionTr: '5 dk bakışın',
          rewardBadge: '🏆',
          badgeNameEn: 'Spark',
          badgeNameTr: 'Kıvılcım',
          encouragementEn: 'Great job',
          encouragementTr: 'Harika',
        );
        const ch2 = ChallengeModel(
          id: 'ch1',
          weekNumber: 1,
          titleEn: 'Eye Contact',
          titleTr: 'Göz Teması',
          descriptionEn: 'Look for 5 mins',
          descriptionTr: '5 dk bakışın',
          rewardBadge: '🏆',
          badgeNameEn: 'Spark',
          badgeNameTr: 'Kıvılcım',
          encouragementEn: 'Great job',
          encouragementTr: 'Harika',
        );
        expect(ch1, equals(ch2));
        expect(ch1.hashCode, equals(ch2.hashCode));

        const si1 = SharedInterestModel(
          id: 'si1',
          titleEn: 'Coffee Crawl',
          titleTr: 'Kahve Turu',
          category: 'Cozy',
          descriptionEn: 'Find new spots',
          descriptionTr: 'Yeni yerler keşfedin',
          suggestedDateEn: 'Sunday Morning',
          suggestedDateTr: 'Pazar Sabahı',
          icon: '☕',
        );
        const si2 = SharedInterestModel(
          id: 'si1',
          titleEn: 'Coffee Crawl',
          titleTr: 'Kahve Turu',
          category: 'Cozy',
          descriptionEn: 'Find new spots',
          descriptionTr: 'Yeni yerler keşfedin',
          suggestedDateEn: 'Sunday Morning',
          suggestedDateTr: 'Pazar Sabahı',
          icon: '☕',
        );
        expect(si1, equals(si2));
        expect(si1.hashCode, equals(si2.hashCode));
      },
    );
  });
}
