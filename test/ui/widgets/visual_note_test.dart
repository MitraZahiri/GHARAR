import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gharar/models/love_note_model.dart';
import 'package:gharar/providers/app_state_provider.dart';
import 'package:gharar/services/note_media_service.dart';
import 'package:gharar/services/storage_service.dart';
import 'package:gharar/ui/widgets/handwriting_canvas.dart';
import 'package:gharar/ui/widgets/love_note_card.dart';
import 'package:gharar/ui/widgets/note_image.dart';
import 'package:gharar/ui/widgets/write_love_note_modal.dart';

class _FakeMedia extends NoteMediaService {
  @override
  Future<String> saveBytes(
    Uint8List bytes, {
    required String extension,
  }) async => '/fake/note.$extension';
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppStateProvider provider;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    provider = AppStateProvider(
      StorageService(prefs),
      mediaService: _FakeMedia(),
    );
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

  Widget host(Widget child) => ChangeNotifierProvider<AppStateProvider>.value(
    value: provider,
    child: MaterialApp(home: Scaffold(body: child)),
  );

  testWidgets('modal switches to handwriting mode and validates empty canvas', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      host(const WriteLoveNoteModal(isDark: false, isTr: true)),
    );

    expect(find.text('Yaz'), findsOneWidget);
    expect(find.byType(HandwritingCanvas), findsNothing);

    await tester.tap(find.text('El yazısı'));
    await tester.pump();

    expect(find.byType(HandwritingCanvas), findsOneWidget);
    expect(find.text('Parmağınla yaz ya da çiz'), findsOneWidget);

    final send = find.text('Ana ekranına gönder 📲');
    await tester.ensureVisible(send);
    await tester.pumpAndSettle();
    await tester.tap(send);
    await tester.pump();

    expect(find.text('Önce bir şey çiz ya da fotoğraf seç.'), findsOneWidget);
    expect(provider.loveNotes, isEmpty);
  });

  testWidgets('photo mode offers camera and gallery', (tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      host(const WriteLoveNoteModal(isDark: false, isTr: true)),
    );
    await tester.tap(find.text('Fotoğraf'));
    await tester.pump();

    expect(find.text('Kamera'), findsOneWidget);
    expect(find.text('Galeri'), findsOneWidget);
  });

  testWidgets('opened drawing note renders its image on the board', (
    tester,
  ) async {
    provider.switchActivePartner();
    await provider.postVisualNote(
      kind: LoveNoteKind.drawing,
      imageBytes: Uint8List.fromList([1]),
    );
    provider.switchActivePartner();
    provider.markLoveNoteAsRead(provider.loveNotes.first.id);

    await tester.pumpWidget(
      host(const SingleChildScrollView(child: LoveNoteCard())),
    );
    await tester.pump();

    expect(find.byType(NoteImage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
