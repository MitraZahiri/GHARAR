import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gharar/core/theme/app_theme.dart';
import 'package:gharar/providers/app_state_provider.dart';
import 'package:gharar/services/storage_service.dart';
import 'package:gharar/ui/screens/home/home_dashboard_screen.dart';
import 'package:gharar/ui/screens/daily_questions/daily_question_screen.dart';
import 'package:gharar/ui/screens/daily_questions/answer_reveal_screen.dart';
import 'package:gharar/ui/screens/discover/quiz_game_screen.dart';
import 'package:gharar/ui/screens/onboarding/onboarding_screen.dart';
import 'package:gharar/ui/screens/onboarding/partner_invite_screen.dart';
import 'package:gharar/ui/screens/discover/discover_hub_screen.dart';
import 'package:gharar/ui/screens/activities/activities_explorer_screen.dart';
import 'package:gharar/ui/screens/memories/memories_hub_screen.dart';
import 'package:gharar/ui/screens/profile/subscription_screen.dart';
import 'package:gharar/ui/screens/main_navigation_shell.dart';

Widget createTestableWidget({
  required Widget child,
  required AppStateProvider provider,
  TextScaler? textScaler,
}) {
  return ChangeNotifierProvider<AppStateProvider>.value(
    value: provider,
    child: MaterialApp(
      theme: AppTheme.lightTheme,
      builder: (context, widget) {
        if (textScaler != null) {
          final mq = MediaQuery.of(context);
          return MediaQuery(
            data: mq.copyWith(textScaler: textScaler),
            child: widget ?? const SizedBox.shrink(),
          );
        }
        return widget ?? const SizedBox.shrink();
      },
      home: child,
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppStateProvider provider;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final storageService = await StorageService.init();
    provider = AppStateProvider(storageService);
    provider.completeOnboarding(
      name: 'Ben',
      avatar: '🌸',
      relationshipStage: 'stageDating',
      goals: ['goalDeeperConversations'],
      languageCode: 'en',
    );
    provider.linkPartner(partnerName: 'Partner');
  });

  group('Multi-Phone Responsive Compatibility Tests', () {
    final phoneViewports = <String, Size>{
      'iPhone SE 1st Gen (Ultra Compact)': const Size(320, 568),
      'iPhone SE 2nd/3rd Gen (Compact)': const Size(375, 667),
      'iPhone 14/15/16 (Standard)': const Size(390, 844),
      'Samsung Galaxy S23 (Standard Android)': const Size(412, 915),
      'iPhone 15/16 Pro Max (Phablet)': const Size(430, 932),
    };

    for (final entry in phoneViewports.entries) {
      final deviceName = entry.key;
      final size = entry.value;

      testWidgets('Renders MainNavigationShell cleanly on $deviceName', (
        WidgetTester tester,
      ) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          createTestableWidget(
            child: const MainNavigationShell(),
            provider: provider,
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        expect(find.byType(HomeDashboardScreen), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Renders OnboardingScreen without overflow on $deviceName', (
        WidgetTester tester,
      ) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          createTestableWidget(
            child: const OnboardingScreen(),
            provider: provider,
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        expect(find.text('GHARAR'), findsWidgets);
        expect(tester.takeException(), isNull);
      });

      testWidgets(
        'Renders DailyQuestionScreen without overflow on $deviceName',
        (WidgetTester tester) async {
          tester.view.physicalSize = size;
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);

          await tester.pumpWidget(
            createTestableWidget(
              child: const DailyQuestionScreen(),
              provider: provider,
            ),
          );
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 200));

          expect(find.byType(DailyQuestionScreen), findsOneWidget);
          expect(tester.takeException(), isNull);
        },
      );

      testWidgets(
        'Renders AnswerRevealScreen without overflow on $deviceName',
        (WidgetTester tester) async {
          tester.view.physicalSize = size;
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);

          final q = provider.currentQuestion ?? provider.questions.first;
          await tester.pumpWidget(
            createTestableWidget(
              child: AnswerRevealScreen(question: q),
              provider: provider,
            ),
          );
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 200));

          expect(find.byType(AnswerRevealScreen), findsOneWidget);
          expect(tester.takeException(), isNull);
          await tester.pump(const Duration(seconds: 4));
        },
      );

      testWidgets('Renders QuizGameScreen without overflow on $deviceName', (
        WidgetTester tester,
      ) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          createTestableWidget(
            child: const QuizGameScreen(),
            provider: provider,
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        expect(find.byType(QuizGameScreen), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Renders DiscoverHubScreen without overflow on $deviceName', (
        WidgetTester tester,
      ) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          createTestableWidget(
            child: const DiscoverHubScreen(),
            provider: provider,
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        expect(find.byType(DiscoverHubScreen), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets(
        'Renders ActivitiesExplorerScreen without overflow on $deviceName',
        (WidgetTester tester) async {
          tester.view.physicalSize = size;
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);

          await tester.pumpWidget(
            createTestableWidget(
              child: const ActivitiesExplorerScreen(),
              provider: provider,
            ),
          );
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 200));

          expect(find.byType(ActivitiesExplorerScreen), findsOneWidget);
          expect(tester.takeException(), isNull);
        },
      );

      testWidgets('Renders MemoriesHubScreen without overflow on $deviceName', (
        WidgetTester tester,
      ) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          createTestableWidget(
            child: const MemoriesHubScreen(),
            provider: provider,
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        expect(find.byType(MemoriesHubScreen), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets(
        'Renders SubscriptionScreen without overflow on $deviceName',
        (WidgetTester tester) async {
          tester.view.physicalSize = size;
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);

          await tester.pumpWidget(
            createTestableWidget(
              child: const SubscriptionScreen(),
              provider: provider,
            ),
          );
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 200));

          expect(find.byType(SubscriptionScreen), findsOneWidget);
          expect(tester.takeException(), isNull);
        },
      );

      testWidgets(
        'Renders PartnerInviteScreen without overflow on $deviceName',
        (WidgetTester tester) async {
          tester.view.physicalSize = size;
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);

          await tester.pumpWidget(
            createTestableWidget(
              child: const PartnerInviteScreen(),
              provider: provider,
            ),
          );
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 200));

          expect(find.byType(PartnerInviteScreen), findsOneWidget);
          expect(tester.takeException(), isNull);
        },
      );
    }

    testWidgets(
      'Renders HomeDashboardScreen with 1.3x accessibility text scaling',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(375, 667);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          createTestableWidget(
            child: const HomeDashboardScreen(),
            provider: provider,
            textScaler: const TextScaler.linear(1.3),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        expect(tester.takeException(), isNull);
      },
    );
  });
}
