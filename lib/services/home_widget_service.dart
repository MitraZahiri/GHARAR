import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';

/// What the home-screen widget displays for the latest received love note.
@immutable
class HomeWidgetNote {
  final String senderLine;
  final String emoji;
  final String? caption;
  final String? imagePath;

  const HomeWidgetNote({
    required this.senderLine,
    required this.emoji,
    this.caption,
    this.imagePath,
  });
}

/// Pushes the latest love note to the Android home-screen widget.
///
/// iOS has no widget extension yet, so calls are no-ops there and on web.
class HomeWidgetService {
  static const androidProvider = 'com.gharar.gharar.GhararNoteWidgetProvider';

  static const keySender = 'note_sender';
  static const keyEmoji = 'note_emoji';
  static const keyCaption = 'note_caption';
  static const keyImagePath = 'note_image_path';

  bool get _isSupported =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  Future<void> showNote(HomeWidgetNote note) => _write({
    keySender: note.senderLine,
    keyEmoji: note.emoji,
    keyCaption: note.caption,
    keyImagePath: note.imagePath,
  });

  Future<void> clear() => _write({
    keySender: null,
    keyEmoji: null,
    keyCaption: null,
    keyImagePath: null,
  });

  /// Asks the launcher to pin the widget. Returns false when unsupported.
  Future<bool> requestPin() async {
    if (!_isSupported) return false;
    try {
      final supported = await HomeWidget.isRequestPinWidgetSupported() ?? false;
      if (!supported) return false;
      await HomeWidget.requestPinWidget(qualifiedAndroidName: androidProvider);
      return true;
    } on MissingPluginException {
      return false;
    }
  }

  Future<void> _write(Map<String, String?> data) async {
    if (!_isSupported) return;
    try {
      for (final entry in data.entries) {
        // deleteFile: false — note images are owned by NoteMediaService.
        await HomeWidget.saveWidgetData<String>(
          entry.key,
          entry.value,
          deleteFile: false,
        );
      }
      await HomeWidget.updateWidget(qualifiedAndroidName: androidProvider);
    } on MissingPluginException {
      // Plugin not registered (unit tests, headless engines): no widget to
      // update, and note delivery inside the app must not fail because of it.
    }
  }
}
