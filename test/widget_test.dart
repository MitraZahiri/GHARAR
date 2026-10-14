import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:gharar/main.dart';
import 'package:gharar/providers/app_state_provider.dart';
import 'package:gharar/services/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('GHARAR app boots up and renders main shell',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final storageService = await StorageService.init();
    final provider = AppStateProvider(storageService);

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: const GhararApp(),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Verify app brand is rendered
    expect(find.text('GHARAR'), findsWidgets);
  });
}
