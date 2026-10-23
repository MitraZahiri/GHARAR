import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gharar/providers/app_state_provider.dart';
import 'package:gharar/services/storage_service.dart';
import 'package:gharar/ui/widgets/edit_names_sheet.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('saving the sheet renames both partners', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final provider = AppStateProvider(StorageService(prefs));
    provider.completeOnboarding(
      name: '',
      avatar: '🌸',
      relationshipStage: 'married',
      goals: const [],
      languageCode: 'tr',
    );
    provider.setLanguageCode('tr');
    provider.linkPartner(partnerName: '');

    await tester.pumpWidget(
      ChangeNotifierProvider<AppStateProvider>.value(
        value: provider,
        child: const MaterialApp(home: Scaffold(body: EditNamesSheet())),
      ),
    );

    expect(find.text('İsimlerimiz'), findsOneWidget);
    await tester.enterText(find.byKey(const ValueKey('my-name')), 'Mitra');
    await tester.enterText(
      find.byKey(const ValueKey('partner-name')),
      ' Arda ',
    );
    await tester.tap(find.text('Kaydet'));
    await tester.pump();

    expect(provider.coupleDisplayNames, 'Mitra & Arda');
  });
}
