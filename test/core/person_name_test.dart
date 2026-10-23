import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gharar/core/localization/app_localizations.dart';
import 'package:gharar/core/utils/person_name.dart';

void main() {
  group('cleanPersonName', () {
    test('trims and collapses whitespace', () {
      expect(cleanPersonName('  Elif   Nur '), 'Elif Nur');
    });

    test('placeholders from older versions become empty', () {
      for (final placeholder in [
        'You',
        'ben',
        'Partner',
        'Partneriniz',
        'My Soulmate',
        'Ruh Eşim',
        'Soulmate',
        'Guest',
        'Misafir',
      ]) {
        expect(cleanPersonName(placeholder), '', reason: placeholder);
      }
    });

    test('null stays empty and long names are capped', () {
      expect(cleanPersonName(null), '');
      expect(cleanPersonName('A' * 60).length, kMaxPersonNameLength);
    });
  });

  group('displayPersonName', () {
    final tr = AppLocalizations(const Locale('tr'));
    final en = AppLocalizations(const Locale('en'));

    test('real names are shown as they are', () {
      expect(displayPersonName('Elif', isSelf: false, loc: tr), 'Elif');
    });

    test('missing names fall back to you / your soulmate', () {
      expect(displayPersonName('', isSelf: true, loc: en), 'You');
      // On your own screen you are always "You", even with a stored name.
      expect(displayPersonName('Mitra', isSelf: true, loc: en), 'You');
      expect(displayPersonName('', isSelf: false, loc: en), 'Your Soulmate');
      expect(displayPersonName('Ben', isSelf: true, loc: tr), 'Sen');
      expect(displayPersonName('', isSelf: false, loc: tr), 'Ruh Eşin');
    });
  });
}
