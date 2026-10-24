import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gharar/providers/app_state_provider.dart';
import 'package:gharar/services/storage_service.dart';
import 'package:gharar/ui/widgets/unlink_partner_button.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppStateProvider provider;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    provider = AppStateProvider(
      StorageService(await SharedPreferences.getInstance()),
    );
    provider.completeOnboarding(
      name: 'Kerem',
      avatar: '🌸',
      relationshipStage: 'married',
      goals: const [],
      languageCode: 'en',
    );
  });

  Widget host() => ChangeNotifierProvider<AppStateProvider>.value(
    value: provider,
    child: const MaterialApp(home: Scaffold(body: UnlinkPartnerButton())),
  );

  testWidgets('is hidden while no partner is linked', (tester) async {
    await tester.pumpWidget(host());
    expect(find.text('Disconnect from partner'), findsNothing);
  });

  testWidgets('asks for confirmation; cancel keeps the partner', (
    tester,
  ) async {
    provider.linkPartner(partnerName: 'Elif');
    await tester.pumpWidget(host());

    await tester.tap(find.text('Disconnect from partner'));
    await tester.pumpAndSettle();
    expect(find.textContaining('new invite code'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(provider.isPartnerLinked, isTrue);
  });

  testWidgets('confirming disconnects and says so', (tester) async {
    provider.linkPartner(partnerName: 'Elif');
    await tester.pumpWidget(host());

    await tester.tap(find.text('Disconnect from partner'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Disconnect'));
    await tester.pumpAndSettle();

    expect(provider.isPartnerLinked, isFalse);
    expect(find.textContaining('Disconnected.'), findsOneWidget);
  });

  testWidgets('works in Turkish', (tester) async {
    provider.setLanguageCode('tr');
    provider.linkPartner(partnerName: 'Elif');
    await tester.pumpWidget(host());

    expect(find.text('Partnerle bağlantıyı kopar'), findsOneWidget);
  });
}
