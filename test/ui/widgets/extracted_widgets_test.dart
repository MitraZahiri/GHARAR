import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gharar/core/theme/app_theme.dart';
import 'package:gharar/models/ai_message_model.dart';
import 'package:gharar/models/special_date_model.dart';
import 'package:gharar/models/challenge_model.dart';
import 'package:gharar/models/user_model.dart';
import 'package:gharar/ui/screens/ai_companion/ai_companion_screen.dart';
import 'package:gharar/ui/screens/onboarding/partner_invite_screen.dart';
import 'package:gharar/ui/screens/memories/special_dates_screen.dart';
import 'package:gharar/ui/screens/memories/add_memory_modal.dart';
import 'package:gharar/ui/screens/activities/weekly_challenges_screen.dart';
import 'package:gharar/ui/screens/discover/future_alignment_screen.dart';

Widget _wrapWithMaterial(Widget child, {bool isDark = false}) {
  return MaterialApp(
    theme: AppTheme.lightTheme,
    darkTheme: AppTheme.darkTheme,
    themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  group('Extracted Standalone UI Widgets Tests', () {
    testWidgets(
      'AIMessageBubble renders Noor AI message and user message correctly',
      (tester) async {
        final now = DateTime(2026, 1, 1);
        final aiMessage = AIMessageModel(
          id: '1',
          sender: MessageSender.noor,
          contentEn: 'Hello from Noor AI',
          contentTr: 'Noor AI selamlar',
          timestamp: now,
        );

        await tester.pumpWidget(
          _wrapWithMaterial(
            AIMessageBubble(message: aiMessage, isDark: false, isTr: true),
          ),
        );

        expect(find.text('Noor'), findsOneWidget);
        expect(find.text('Noor AI selamlar'), findsOneWidget);

        final userMessage = AIMessageModel(
          id: '2',
          sender: MessageSender.user,
          contentEn: 'Hello Noor',
          contentTr: 'Selam Noor',
          timestamp: now,
        );

        await tester.pumpWidget(
          _wrapWithMaterial(
            AIMessageBubble(message: userMessage, isDark: true, isTr: false),
            isDark: true,
          ),
        );

        expect(find.text('Hello Noor'), findsOneWidget);
        expect(find.text('Noor'), findsNothing); // sender name only for AI
      },
    );

    testWidgets('QuickPromptChip renders prompt and responds to tap', (
      tester,
    ) async {
      bool tapped = false;
      await tester.pumpWidget(
        _wrapWithMaterial(
          QuickPromptChip(
            prompt: 'Spark a cozy date',
            isDark: false,
            onPressed: () => tapped = true,
          ),
        ),
      );

      expect(find.text('Spark a cozy date'), findsOneWidget);
      await tester.tap(find.text('Spark a cozy date'));
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('InviteCodeDisplayCard renders invite code and copy action', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrapWithMaterial(
          const InviteCodeDisplayCard(
            inviteCode: 'GHARAR-7777-LOVE',
            isDark: false,
            isTr: true,
          ),
        ),
      );

      expect(find.text('GHARAR-7777-LOVE'), findsOneWidget);
      expect(find.text('SİZE ÖZEL ÇİFT KODU'), findsOneWidget);
      expect(find.text('Kodu Kopyala'), findsOneWidget);

      await tester.tap(find.text('Kodu Kopyala'));
      await tester.pump();
      expect(find.textContaining('Davet kodu kopyalandı!'), findsOneWidget);
    });

    testWidgets(
      'SpecialDateItemTile renders special date details and countdown',
      (tester) async {
        final now = DateTime.now();
        final targetDate = DateTime(now.year, now.month, now.day + 5);
        final item = SpecialDateModel(
          id: 'date_1',
          titleEn: 'Romantic Weekend',
          titleTr: 'Romantik Hafta Sonu',
          date: targetDate,
          category: 'Trip',
          icon: '✈️',
        );

        await tester.pumpWidget(
          _wrapWithMaterial(
            SpecialDateItemTile(item: item, isDark: false, isTr: true),
          ),
        );

        expect(find.text('Romantik Hafta Sonu'), findsOneWidget);
        expect(find.text('✈️'), findsOneWidget);
        expect(find.text('TRIP'), findsOneWidget);
        expect(find.textContaining('gün'), findsOneWidget);
      },
    );

    testWidgets('MoodPickerItem triggers onTap when tapped', (tester) async {
      bool selected = false;
      await tester.pumpWidget(
        _wrapWithMaterial(
          MoodPickerItem(
            emoji: '🥰',
            isSelected: true,
            isDark: false,
            onTap: () => selected = true,
          ),
        ),
      );

      expect(find.text('🥰'), findsOneWidget);
      await tester.tap(find.text('🥰'));
      await tester.pump();
      expect(selected, isTrue);
    });

    testWidgets('ChallengeCardItem renders details and executes onToggle', (
      tester,
    ) async {
      bool toggled = false;
      const challenge = ChallengeModel(
        id: 'c1',
        weekNumber: 3,
        titleEn: 'Cook Together',
        titleTr: 'Birlikte Yemek Pişirin',
        descriptionEn: 'Make fresh pasta together.',
        descriptionTr: 'Birlikte taze makarna yapın.',
        rewardBadge: '🍝',
        badgeNameEn: 'Chef Duo',
        badgeNameTr: 'Şef İkili',
        encouragementEn: 'Food tastes sweeter together.',
        encouragementTr: 'Sevgiyle pişen yemek daha tatlıdır.',
        isCompleted: false,
      );

      await tester.pumpWidget(
        _wrapWithMaterial(
          ChallengeCardItem(
            challenge: challenge,
            isDark: false,
            isTr: true,
            onToggle: () => toggled = true,
          ),
        ),
      );

      expect(find.text('Birlikte Yemek Pişirin'), findsOneWidget);
      expect(find.text('Hafta 3'), findsOneWidget);
      expect(find.text('Tamamlandı Olarak İşaretle'), findsOneWidget);

      await tester.tap(find.text('Tamamlandı Olarak İşaretle'));
      await tester.pump();
      expect(toggled, isTrue);
    });

    testWidgets('FuturePillarCard renders partner perspectives and status', (
      tester,
    ) async {
      final now = DateTime(2026, 1, 1);
      final p1 = UserModel(
        id: 'u1',
        name: 'Leyla',
        avatar: '🌙',
        preferredLanguage: 'tr',
        relationshipStage: 'married',
        selectedGoals: const [],
        joinedAt: now,
      );
      final p2 = UserModel(
        id: 'u2',
        name: 'Mecnun',
        avatar: '☀️',
        preferredLanguage: 'tr',
        relationshipStage: 'married',
        selectedGoals: const [],
        joinedAt: now,
      );

      final pillar = {
        'icon': '🏡',
        'titleEn': 'Living Space',
        'titleTr': 'Yaşam Alanı & Yuva',
        'statusEn': 'Strong Alignment',
        'statusTr': 'Tam Uyum',
        'p1En': 'Cozy home near nature',
        'p1Tr': 'Doğaya yakın sıcak bir yuva',
        'p2En': 'Peaceful sanctuary with garden',
        'p2Tr': 'Bahçeli huzurlu bir sığınak',
        'bridgeEn': 'Create a small balcony garden together.',
        'bridgeTr': 'Birlikte küçük bir balkon bahçesi kurun.',
      };

      await tester.pumpWidget(
        _wrapWithMaterial(
          FuturePillarCard(
            pillar: pillar,
            partner1: p1,
            partner2: p2,
            partner1Name: p1.name,
            partner2Name: p2.name,
            isDark: false,
            isTr: true,
          ),
        ),
      );

      expect(find.text('Yaşam Alanı & Yuva'), findsOneWidget);
      expect(find.text('Tam Uyum'), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (w) => w is RichText && w.text.toPlainText().contains('Leyla:'),
        ),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate(
          (w) => w is RichText && w.text.toPlainText().contains('Mecnun:'),
        ),
        findsOneWidget,
      );
      expect(
        find.text('Birlikte küçük bir balkon bahçesi kurun.'),
        findsOneWidget,
      );
    });
  });
}
