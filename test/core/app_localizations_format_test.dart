import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gharar/core/localization/app_language.dart';
import 'package:gharar/core/localization/app_localizations.dart';

void main() {
  const newKeys = [
    'distanceTitle',
    'distanceTogether',
    'distanceLong',
    'togetherHeadline',
    'togetherRitualLabel',
    'togetherRitual1',
    'togetherRitual2',
    'togetherRitual3',
    'togetherRitual4',
    'togetherNextIdea',
    'ldrPartnerTime',
    'ldrSetTimezone',
    'ldrUntilMeeting',
    'ldrDaysLeft',
    'ldrMeetingToday',
    'ldrSetMeeting',
    'noteModeText',
    'noteModeDraw',
    'noteModePhoto',
    'drawHint',
    'drawUndo',
    'drawClear',
    'photoCamera',
    'photoGallery',
    'photoCaptionHint',
    'visualNoteEmpty',
    'visualNoteSaveError',
    'photoPickError',
    'visualNoteSend',
    'visualNoteSent',
    'widgetFrom',
    'widgetAddToHome',
  ];

  test('every new key is translated in all supported languages', () {
    for (final lang in AppLanguage.supportedLanguages) {
      final loc = AppLocalizations(Locale(lang.code));
      for (final key in newKeys) {
        expect(
          loc.hasKey(key),
          isTrue,
          reason: '${lang.code} is missing "$key"',
        );
      }
    }
  });

  test('format substitutes named placeholders', () {
    final en = AppLocalizations(const Locale('en'));
    expect(en.format('ldrDaysLeft', {'days': '12'}), contains('12'));
    expect(en.format('widgetFrom', {'name': 'Elif'}), contains('Elif'));
    expect(en.format('widgetFrom', {'name': 'Elif'}), isNot(contains('{')));
  });
}
