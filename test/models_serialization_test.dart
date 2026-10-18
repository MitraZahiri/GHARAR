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
  group('Domain Models Serialization & Helper Methods Tests', () {
    test('UserModel toJson and fromJson round-trip', () {
      final now = DateTime(2026, 3, 15, 12, 0, 0);
      final user = UserModel(
        id: 'u_101',
        name: 'Deniz',
        avatar: '🌊',
        email: 'deniz@example.com',
        authProvider: 'email',
        preferredLanguage: 'tr',
        relationshipStage: 'engaged',
        selectedGoals: const ['deep_conversations', 'adventure'],
        joinedAt: now,
      );

      final json = user.toJson();
      final reconstructed = UserModel.fromJson(json);

      expect(reconstructed, equals(user));
      expect(reconstructed.id, 'u_101');
      expect(reconstructed.name, 'Deniz');
      expect(reconstructed.email, 'deniz@example.com');
      expect(reconstructed.authProvider, 'email');
      expect(reconstructed.selectedGoals, ['deep_conversations', 'adventure']);
    });

    test('CoupleModel toJson, fromJson, and partnerNames getter', () {
      final now = DateTime(2026, 1, 1);
      final p1 = UserModel(
        id: 'u1',
        name: 'Leyla',
        avatar: '🌙',
        preferredLanguage: 'tr',
        relationshipStage: 'married',
        selectedGoals: const ['gratitude'],
        joinedAt: now,
      );
      final p2 = UserModel(
        id: 'u2',
        name: 'Mecnun',
        avatar: '☀️',
        preferredLanguage: 'tr',
        relationshipStage: 'married',
        selectedGoals: const ['gratitude'],
        joinedAt: now,
      );

      final couple = CoupleModel(
        id: 'c1',
        partner1: p1,
        partner2: p2,
        inviteCode: 'GHARAR77',
        anniversaryDate: DateTime(2024, 5, 1),
        connectionStreak: 42,
        streakLastMaintained: DateTime(2026, 1, 1),
        isLinked: true,
        isPremium: true,
      );

      final json = couple.toJson();
      final fromJson = CoupleModel.fromJson(json);

      expect(fromJson, equals(couple));
      expect(couple.partnerNames, 'Leyla & Mecnun');

      final singleCouple = CoupleModel(
        id: 'c2',
        partner1: p1,
        inviteCode: 'SINGLE77',
        anniversaryDate: DateTime(2024, 5, 1),
      );
      expect(singleCouple.partnerNames, 'Leyla');
    });

    test('QuestionModel and AnswerModel toJson, fromJson, and getters', () {
      const question = QuestionModel(
        id: 'q_test_1',
        textEn: 'What is your favorite memory?',
        textTr: 'En sevdiğin anı nedir?',
        category: QuestionCategory.memories,
        intensity: QuestionIntensity.meaningful,
        optionsEn: ['First trip', 'A quiet night'],
        optionsTr: ['İlk gezi', 'Sessiz bir gece'],
        inspirationTipEn: 'Be as specific as possible.',
        inspirationTipTr: 'Mümkün olduğunca detaylı anlatın.',
      );

      expect(question.text(true), 'En sevdiğin anı nedir?');
      expect(question.text(false), 'What is your favorite memory?');
      expect(question.options(true), ['İlk gezi', 'Sessiz bir gece']);
      expect(question.options(false), ['First trip', 'A quiet night']);
      expect(
        question.inspirationTip(true),
        'Mümkün olduğunca detaylı anlatın.',
      );
      expect(question.inspirationTip(false), 'Be as specific as possible.');
      expect(question.categoryIcon, '📸');
      expect(question.categoryName(true), 'Unutulmaz Anılar');
      expect(question.categoryName(false), 'Cherished Memories');

      // Test all category icons and names
      for (final cat in QuestionCategory.values) {
        final q = question.copyWith(category: cat);
        expect(q.categoryIcon, isNotEmpty);
        expect(q.categoryName(true), isNotEmpty);
        expect(q.categoryName(false), isNotEmpty);
      }

      final json = question.toJson();
      final fromJson = QuestionModel.fromJson(json);
      expect(fromJson, equals(question));

      final answeredAt = DateTime(2026, 2, 14, 20, 0);
      final answer = AnswerModel(
        id: 'ans_1',
        questionId: 'q_test_1',
        authorId: 'u1',
        authorName: 'Leyla',
        answerText: 'Our seaside walk at sunset.',
        selectedOptionIndex: 0,
        answeredAt: answeredAt,
        reactionEmoji: '🥰',
      );

      final ansJson = answer.toJson();
      final ansFromJson = AnswerModel.fromJson(ansJson);
      expect(ansFromJson, equals(answer));
      expect(ansFromJson.reactionEmoji, '🥰');
    });

    test('ActivityModel toJson, fromJson, and format helpers', () {
      final now = DateTime(2026, 4, 10);
      final activity = ActivityModel(
        id: 'act_10',
        titleEn: 'Stargazing Picnic',
        titleTr: 'Yıldızları İzleme Pikniği',
        descriptionEn: 'Lay a blanket under the open sky.',
        descriptionTr: 'Açık gökyüzü altında bir battaniye serin.',
        categoryEn: 'Romance',
        categoryTr: 'Romantizm',
        budget: ActivityBudget.free,
        setting: ActivitySetting.outdoor,
        vibe: ActivityVibe.romantic,
        duration: '1-2 hrs',
        icon: '🌌',
        tipsEn: const ['Bring warm tea'],
        tipsTr: const ['Sıcak çay getirin'],
        isCompleted: true,
        isSaved: true,
        completedAt: now,
      );

      expect(activity.title(true), 'Yıldızları İzleme Pikniği');
      expect(activity.title(false), 'Stargazing Picnic');
      expect(
        activity.description(true),
        'Açık gökyüzü altında bir battaniye serin.',
      );
      expect(activity.description(false), 'Lay a blanket under the open sky.');
      expect(activity.category(true), 'Romantizm');
      expect(activity.category(false), 'Romance');
      expect(activity.tips(true), ['Sıcak çay getirin']);
      expect(activity.tips(false), ['Bring warm tea']);

      // Budget display
      expect(activity.budgetDisplay, 'Free');
      expect(
        activity.copyWith(budget: ActivityBudget.low).budgetDisplay,
        r'$ (Low)',
      );
      expect(
        activity.copyWith(budget: ActivityBudget.medium).budgetDisplay,
        r'$$ (Moderate)',
      );
      expect(
        activity.copyWith(budget: ActivityBudget.luxury).budgetDisplay,
        r'$$$ (Splurge)',
      );

      // Setting display
      expect(activity.settingDisplay(true), 'Açık Hava & Doğa');
      expect(activity.settingDisplay(false), 'Outdoors');
      expect(
        activity.copyWith(setting: ActivitySetting.atHome).settingDisplay(true),
        'Evde Sıcak',
      );
      expect(
        activity
            .copyWith(setting: ActivitySetting.atHome)
            .settingDisplay(false),
        'At Home',
      );
      expect(
        activity.copyWith(setting: ActivitySetting.indoor).settingDisplay(true),
        'Kapalı Mekan',
      );
      expect(
        activity
            .copyWith(setting: ActivitySetting.indoor)
            .settingDisplay(false),
        'Indoor',
      );

      // Vibe display
      expect(activity.vibeDisplay(true), 'Romantik & İntim');
      expect(activity.vibeDisplay(false), 'Romantic');
      expect(
        activity.copyWith(vibe: ActivityVibe.adventurous).vibeDisplay(true),
        'Maceracı',
      );
      expect(
        activity.copyWith(vibe: ActivityVibe.adventurous).vibeDisplay(false),
        'Adventurous',
      );
      expect(
        activity.copyWith(vibe: ActivityVibe.relaxing).vibeDisplay(true),
        'Huzurlu & Sakin',
      );
      expect(
        activity.copyWith(vibe: ActivityVibe.relaxing).vibeDisplay(false),
        'Relaxing',
      );
      expect(
        activity.copyWith(vibe: ActivityVibe.playful).vibeDisplay(true),
        'Neşeli & Oyun',
      );
      expect(
        activity.copyWith(vibe: ActivityVibe.playful).vibeDisplay(false),
        'Playful',
      );

      final json = activity.toJson();
      final reconstructed = ActivityModel.fromJson(json);
      expect(reconstructed, equals(activity));
    });

    test('SharedInterestModel toJson, fromJson, and language helpers', () {
      const interest = SharedInterestModel(
        id: 'int_1',
        titleEn: 'Coffee Roasting',
        titleTr: 'Kahve Kavurma',
        category: 'Food',
        descriptionEn: 'Exploring single-origin coffees together.',
        descriptionTr: 'Farklı yöresel kahveleri birlikte keşfetmek.',
        suggestedDateEn: 'Visit an artisanal cafe',
        suggestedDateTr: 'Butik bir kahveciyi ziyaret edin',
        icon: '☕',
        bothEnjoy: true,
        partner1PreferenceEn: 'Loves pour-over',
        partner1PreferenceTr: 'Filtre kahve seviyor',
        partner2PreferenceEn: 'Enjoys flat whites',
        partner2PreferenceTr: 'Sütlü kahve seviyor',
        bridgeConversationEn: 'What coffee memory stands out?',
        bridgeConversationTr: 'Unutamadığınız kahve anısı hangisi?',
      );

      expect(interest.title(true), 'Kahve Kavurma');
      expect(interest.title(false), 'Coffee Roasting');
      expect(
        interest.description(true),
        'Farklı yöresel kahveleri birlikte keşfetmek.',
      );
      expect(
        interest.description(false),
        'Exploring single-origin coffees together.',
      );
      expect(interest.suggestedDate(true), 'Butik bir kahveciyi ziyaret edin');
      expect(interest.suggestedDate(false), 'Visit an artisanal cafe');
      expect(interest.partner1Pref(true), 'Filtre kahve seviyor');
      expect(interest.partner1Pref(false), 'Loves pour-over');
      expect(interest.partner2Pref(true), 'Sütlü kahve seviyor');
      expect(interest.partner2Pref(false), 'Enjoys flat whites');
      expect(interest.bridgeConv(true), 'Unutamadığınız kahve anısı hangisi?');
      expect(interest.bridgeConv(false), 'What coffee memory stands out?');

      final json = interest.toJson();
      final fromJson = SharedInterestModel.fromJson(json);
      expect(fromJson, equals(interest));
    });

    test('SpecialDateModel toJson, fromJson, and daysUntil calculation', () {
      final date = DateTime(2022, 10, 29);
      final specialDate = SpecialDateModel(
        id: 'date_1',
        titleEn: 'Wedding Anniversary',
        titleTr: 'Evlilik Yıldönümü',
        date: date,
        category: 'Anniversary',
        icon: '💍',
        notes: 'Reservation at sunset terrace',
        reminderEnabled: true,
      );

      expect(specialDate.title(true), 'Evlilik Yıldönümü');
      expect(specialDate.title(false), 'Wedding Anniversary');
      expect(specialDate.daysUntil, inInclusiveRange(0, 366));

      final json = specialDate.toJson();
      final fromJson = SpecialDateModel.fromJson(json);
      expect(fromJson, equals(specialDate));
    });

    test('MilestoneModel toJson, fromJson, and text helpers', () {
      final milestone = MilestoneModel(
        id: 'mile_1',
        titleEn: 'First Trip Together',
        titleTr: 'İlk Birlikte Tatil',
        descriptionEn: 'Weekend cabin in the mountains',
        descriptionTr: 'Dağlarda hafta sonu kulübesi',
        milestoneDate: DateTime(2023, 8, 14),
        icon: '⛰️',
        badgeTextEn: 'Explorer Pair',
        badgeTextTr: 'Kaşif Çift',
        isCelebrated: true,
      );

      expect(milestone.title(true), 'İlk Birlikte Tatil');
      expect(milestone.title(false), 'First Trip Together');
      expect(milestone.description(true), 'Dağlarda hafta sonu kulübesi');
      expect(milestone.description(false), 'Weekend cabin in the mountains');
      expect(milestone.badgeText(true), 'Kaşif Çift');
      expect(milestone.badgeText(false), 'Explorer Pair');

      final json = milestone.toJson();
      final fromJson = MilestoneModel.fromJson(json);
      expect(fromJson, equals(milestone));
    });

    test('AIMessageModel toJson, fromJson, and content resolution', () {
      final now = DateTime(2026, 5, 20, 18, 30);
      final msg = AIMessageModel(
        id: 'msg_99',
        sender: MessageSender.noor,
        contentEn: 'Gentle words build castles of trust.',
        contentTr: 'Şefkatli kelimeler güven kaleleri kurar.',
        timestamp: now,
        suggestedActionPrompt: 'Reflect on a compliment',
      );

      expect(msg.content(true), 'Şefkatli kelimeler güven kaleleri kurar.');
      expect(msg.content(false), 'Gentle words build castles of trust.');

      final json = msg.toJson();
      final fromJson = AIMessageModel.fromJson(json);
      expect(fromJson, equals(msg));
    });

    test('ChallengeModel toJson, fromJson, and language helpers', () {
      final challenge = ChallengeModel(
        id: 'chal_1',
        weekNumber: 1,
        titleEn: 'Digital Sunset',
        titleTr: 'Dijital Gün Batımı',
        descriptionEn: 'No screens 1 hour before sleep for 3 days.',
        descriptionTr: '3 gün boyunca uyumadan 1 saat önce ekranları kapatın.',
        rewardBadge: '🌅',
        badgeNameEn: 'Presence Keeper',
        badgeNameTr: 'Huzur Koruyucusu',
        encouragementEn: 'Eyes speak clearer than screens.',
        encouragementTr: 'Gözler ekranlardan daha berrak konuşur.',
        isCompleted: true,
        completedAt: DateTime(2026, 3, 2),
      );

      expect(challenge.title(true), 'Dijital Gün Batımı');
      expect(challenge.title(false), 'Digital Sunset');
      expect(
        challenge.description(true),
        '3 gün boyunca uyumadan 1 saat önce ekranları kapatın.',
      );
      expect(
        challenge.description(false),
        'No screens 1 hour before sleep for 3 days.',
      );
      expect(challenge.badgeName(true), 'Huzur Koruyucusu');
      expect(challenge.badgeName(false), 'Presence Keeper');
      expect(
        challenge.encouragement(true),
        'Gözler ekranlardan daha berrak konuşur.',
      );
      expect(
        challenge.encouragement(false),
        'Eyes speak clearer than screens.',
      );

      final json = challenge.toJson();
      final fromJson = ChallengeModel.fromJson(json);
      expect(fromJson, equals(challenge));
    });

    test('JournalEntryModel toJson and fromJson round-trip', () {
      final entry = JournalEntryModel(
        id: 'entry_1',
        authorId: 'u1',
        authorName: 'Selin',
        title: 'Akşam Yürüyüşü',
        notes: 'Birlikte yağmur sonrası yürüyüş yaptık.',
        moodEmoji: '🌿',
        date: DateTime(2026, 4, 18),
        questionId: 'q1',
        questionSnippet: 'What makes you feel peaceful?',
        imagePlaceholder: 'autumn_walk',
        tags: const ['doğa', 'huzur'],
      );

      final json = entry.toJson();
      final fromJson = JournalEntryModel.fromJson(json);
      expect(fromJson, equals(entry));
      expect(fromJson.title, 'Akşam Yürüyüşü');
      expect(fromJson.notes, 'Birlikte yağmur sonrası yürüyüş yaptık.');
      expect(fromJson.moodEmoji, '🌿');
      expect(fromJson.questionId, 'q1');
      expect(fromJson.questionSnippet, 'What makes you feel peaceful?');
      expect(fromJson.tags, ['doğa', 'huzur']);
    });
  });
}
