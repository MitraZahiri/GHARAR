import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gharar/providers/app_state_provider.dart';
import 'package:gharar/services/home_widget_service.dart';
import 'package:gharar/services/storage_service.dart';

class FakeHomeWidgetService extends HomeWidgetService {
  final List<HomeWidgetNote?> pushed = [];

  @override
  Future<void> showNote(HomeWidgetNote note) async => pushed.add(note);

  @override
  Future<void> clear() async => pushed.add(null);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DateTime now;
  late FakeHomeWidgetService homeWidget;
  late AppStateProvider provider;

  setUp(() async {
    now = DateTime(2026, 10, 30, 12);
    SharedPreferences.setMockInitialValues({});
    homeWidget = FakeHomeWidgetService();
    provider = AppStateProvider(
      StorageService(await SharedPreferences.getInstance()),
      homeWidgetService: homeWidget,
      clock: () => now,
    );
    provider.completeOnboarding(
      name: 'Kerem',
      avatar: '🕊️',
      relationshipStage: 'married',
      goals: const [],
      languageCode: 'en',
    );
    provider.linkPartner(partnerName: 'Elif', avatar: '🌸');
  });

  test('sealing a capsule for the partner', () {
    final sent = provider.sendTimeCapsule(
      text: '  For our next anniversary  ',
      opensAt: now.add(const Duration(days: 30)),
    );

    expect(sent, isTrue);
    final mine = provider.timeCapsulesSentByActivePartner;
    expect(mine, hasLength(1));
    expect(mine.single.text, 'For our next anniversary');
    expect(mine.single.receiverId, provider.otherPartner.id);
    expect(provider.timeCapsulesForActivePartner, isEmpty);
  });

  test('rejects empty text and opening dates that are not in the future', () {
    expect(
      provider.sendTimeCapsule(
        text: '   ',
        opensAt: now.add(const Duration(days: 1)),
      ),
      isFalse,
    );
    expect(provider.sendTimeCapsule(text: 'Hi', opensAt: now), isFalse);
    expect(provider.loveNotes, isEmpty);
  });

  test('a sealed capsule stays off the home note and widget', () {
    provider.switchActivePartner();
    provider.sendTimeCapsule(
      text: 'Not yet!',
      opensAt: now.add(const Duration(days: 180)),
    );
    provider.switchActivePartner();

    expect(provider.timeCapsulesForActivePartner, hasLength(1));
    expect(
      provider.isSealed(provider.timeCapsulesForActivePartner.single),
      isTrue,
    );
    expect(provider.latestNoteForActivePartner, isNull);
    expect(homeWidget.pushed.whereType<HomeWidgetNote>(), isEmpty);
  });

  test('the capsule opens once its date arrives', () {
    provider.switchActivePartner();
    provider.sendTimeCapsule(
      text: 'Happy one year!',
      opensAt: now.add(const Duration(days: 365)),
    );
    provider.switchActivePartner();

    now = now.add(const Duration(days: 365));

    final capsule = provider.timeCapsulesForActivePartner.single;
    expect(provider.isSealed(capsule), isFalse);
    expect(provider.latestNoteForActivePartner?.text, 'Happy one year!');
  });
}
