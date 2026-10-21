import 'package:flutter_test/flutter_test.dart';
import 'package:gharar/core/utils/partner_display_name.dart';

void main() {
  group('partnerDisplayName', () {
    test('returns the real name unchanged', () {
      expect(partnerDisplayName('Elif', isTurkish: false), 'Elif');
      expect(partnerDisplayName('Elif', isTurkish: true), 'Elif');
    });

    test('replaces the English placeholder "You" with a soulmate label', () {
      expect(partnerDisplayName('You', isTurkish: false), 'Your Soulmate');
      expect(partnerDisplayName('You', isTurkish: true), 'Ruh Eşin');
    });

    test('replaces the Turkish placeholder "Ben" with a soulmate label', () {
      expect(partnerDisplayName('Ben', isTurkish: false), 'Your Soulmate');
      expect(partnerDisplayName('Ben', isTurkish: true), 'Ruh Eşin');
    });

    test('replaces blank names with a soulmate label', () {
      expect(partnerDisplayName('   ', isTurkish: false), 'Your Soulmate');
    });
  });
}
