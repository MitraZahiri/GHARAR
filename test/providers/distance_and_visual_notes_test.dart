import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gharar/models/couple_model.dart';
import 'package:gharar/models/love_note_model.dart';
import 'package:gharar/providers/app_state_provider.dart';
import 'package:gharar/services/home_widget_service.dart';
import 'package:gharar/services/note_media_service.dart';
import 'package:gharar/services/storage_service.dart';

class FakeNoteMediaService extends NoteMediaService {
  final List<String> saved = [];
  final List<String> deleted = [];
  bool failNextSave = false;

  @override
  Future<String> saveBytes(Uint8List bytes, {required String extension}) async {
    if (failNextSave) {
      failNextSave = false;
      throw const NoteMediaException('disk full');
    }
    final path = '/fake/note_media/${saved.length}.$extension';
    saved.add(path);
    return path;
  }

  @override
  Future<String> importFile(String sourcePath) async {
    final path = '/fake/note_media/${saved.length}.jpg';
    saved.add(path);
    return path;
  }

  @override
  Future<void> delete(String path) async => deleted.add(path);
}

class FakeHomeWidgetService extends HomeWidgetService {
  final List<HomeWidgetNote?> pushed = [];

  @override
  Future<void> showNote(HomeWidgetNote note) async => pushed.add(note);

  @override
  Future<void> clear() async => pushed.add(null);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late StorageService storage;
  late FakeNoteMediaService media;
  late FakeHomeWidgetService homeWidget;
  late AppStateProvider provider;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    storage = StorageService(prefs);
    media = FakeNoteMediaService();
    homeWidget = FakeHomeWidgetService();
    provider = AppStateProvider(
      storage,
      mediaService: media,
      homeWidgetService: homeWidget,
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

  group('Distance mode', () {
    test('defaults to together and persists a switch to long distance', () {
      expect(provider.distanceMode, DistanceMode.together);

      provider.setDistanceMode(DistanceMode.longDistance);

      expect(provider.distanceMode, DistanceMode.longDistance);
      expect(storage.getCouple()?.distanceMode, DistanceMode.longDistance);
    });

    test(
      'daysUntilNextMeeting counts calendar days and ignores past dates',
      () {
        final now = DateTime(2026, 10, 21, 23, 30);
        expect(provider.daysUntilNextMeeting(now: now), isNull);

        provider.setNextMeetingDate(DateTime(2026, 10, 24, 8));
        expect(provider.daysUntilNextMeeting(now: now), 3);

        provider.setNextMeetingDate(DateTime(2026, 10, 21, 6));
        expect(provider.daysUntilNextMeeting(now: now), 0);

        provider.setNextMeetingDate(DateTime(2026, 10, 1));
        expect(provider.daysUntilNextMeeting(now: now), isNull);

        provider.setNextMeetingDate(null);
        expect(storage.getCouple()?.nextMeetingDate, isNull);
      },
    );

    test('partnerLocalTime applies the stored UTC offset', () {
      final nowUtc = DateTime.utc(2026, 10, 21, 12, 0);
      expect(provider.partnerLocalTime(nowUtc: nowUtc), isNull);

      provider.setPartnerUtcOffset(-300);

      final local = provider.partnerLocalTime(nowUtc: nowUtc);
      expect(local?.hour, 7);
      expect(local?.minute, 0);
      expect(storage.getCouple()?.partnerUtcOffsetMinutes, -300);
    });
  });

  group('Visual love notes', () {
    test('a drawing is stored as a file and referenced by the note', () async {
      await provider.postVisualNote(
        kind: LoveNoteKind.drawing,
        imageBytes: Uint8List.fromList([1, 2, 3]),
        caption: '  miss you  ',
      );

      final note = provider.latestNoteSentByActivePartner;
      expect(note?.kind, LoveNoteKind.drawing);
      expect(note?.imagePath, media.saved.single);
      expect(note?.text, 'miss you');
      expect(storage.getLoveNotes()?.first.imagePath, media.saved.single);
    });

    test('a photo is imported from the picker path', () async {
      await provider.postVisualNote(
        kind: LoveNoteKind.photo,
        sourceImagePath: '/tmp/picked.jpg',
      );

      final note = provider.latestNoteSentByActivePartner;
      expect(note?.kind, LoveNoteKind.photo);
      expect(note?.imagePath, endsWith('.jpg'));
    });

    test('a failed save reports false and adds no note', () async {
      media.failNextSave = true;

      final posted = await provider.postVisualNote(
        kind: LoveNoteKind.drawing,
        imageBytes: Uint8List.fromList([1]),
      );

      expect(posted, isFalse);
      expect(provider.loveNotes, isEmpty);
    });

    test('deleting a visual note removes its media file', () async {
      await provider.postVisualNote(
        kind: LoveNoteKind.drawing,
        imageBytes: Uint8List.fromList([1]),
      );
      final note = provider.loveNotes.single;

      await provider.deleteLoveNote(note.id);

      expect(provider.loveNotes, isEmpty);
      expect(media.deleted, [note.imagePath]);
    });
  });

  group('Home screen widget', () {
    test('a note sent to this device owner is pushed to the widget', () async {
      // Elif (partner view) draws a note for Kerem, who owns this device.
      provider.switchActivePartner();
      await provider.postVisualNote(
        kind: LoveNoteKind.drawing,
        imageBytes: Uint8List.fromList([9]),
        emoji: '🫂',
      );

      final pushed = homeWidget.pushed.last;
      expect(pushed?.imagePath, media.saved.single);
      expect(pushed?.senderLine, contains('Elif'));
      expect(pushed?.emoji, '🫂');
    });

    test('notes the owner sends do not replace the owner widget', () async {
      provider.postLoveNote(text: 'for Elif');
      expect(homeWidget.pushed.whereType<HomeWidgetNote>(), isEmpty);
    });

    test('simulated partner text note shows its text on the widget', () {
      provider.simulatePartnerLoveNote(customMessage: 'good morning');
      expect(homeWidget.pushed.last?.caption, 'good morning');
      expect(homeWidget.pushed.last?.imagePath, isNull);
    });

    test('signing out clears the widget', () async {
      provider.simulatePartnerLoveNote(customMessage: 'hi');
      await provider.signOut();
      expect(homeWidget.pushed.last, isNull);
    });
  });
}
