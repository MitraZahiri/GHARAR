import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gharar/providers/app_state_provider.dart';
import 'package:gharar/services/storage_service.dart';
import 'package:gharar/ui/screens/activities/activities_explorer_screen.dart';
import 'package:gharar/ui/screens/discover/discover_hub_screen.dart';
import 'package:gharar/ui/screens/explore/explore_screen.dart';
import 'package:gharar/ui/screens/main_navigation_shell.dart';
import 'package:gharar/ui/screens/memories/memories_hub_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppStateProvider provider;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    provider = AppStateProvider(StorageService(prefs));
    provider.completeOnboarding(
      name: 'Kerem',
      avatar: '🕊️',
      relationshipStage: 'married',
      goals: const [],
      languageCode: 'tr',
    );
    provider.setLanguageCode('tr');
    provider.linkPartner(partnerName: 'Elif', avatar: '🌸');
  });

  Future<void> pumpShell(WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 860);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ChangeNotifierProvider<AppStateProvider>.value(
        value: provider,
        child: const MaterialApp(home: MainNavigationShell()),
      ),
    );
    await tester.pump();
  }

  testWidgets('bottom bar has exactly three tabs', (tester) async {
    await pumpShell(tester);

    final bar = tester.widget<BottomNavigationBar>(
      find.byType(BottomNavigationBar),
    );
    expect(bar.items, hasLength(3));
    expect(find.text('Bugün'), findsOneWidget);
    expect(find.text('Keşfet'), findsOneWidget);
    expect(find.text('Biz'), findsOneWidget);
  });

  testWidgets('explore tab switches between games, dates and memories', (
    tester,
  ) async {
    await pumpShell(tester);

    await tester.tap(find.text('Keşfet'));
    await tester.pump();
    expect(find.byType(ExploreScreen), findsOneWidget);
    expect(find.byType(DiscoverHubScreen), findsOneWidget);

    await tester.tap(find.text('Randevu'));
    await tester.pump();
    expect(find.byType(ActivitiesExplorerScreen), findsOneWidget);

    await tester.tap(find.text('Anılar'));
    await tester.pump();
    expect(find.byType(MemoriesHubScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
