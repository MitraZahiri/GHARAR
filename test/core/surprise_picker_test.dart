import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gharar/core/localization/app_language.dart';
import 'package:gharar/core/localization/app_localizations.dart';
import 'package:gharar/core/utils/surprise_picker.dart';

void main() {
  group('nextSurpriseIndex', () {
    test('first pick stays inside the idea list', () {
      final random = Random(1);
      for (var i = 0; i < 200; i++) {
        final index = nextSurpriseIndex(null, random);
        expect(index, inInclusiveRange(0, kSurpriseIdeaCount - 1));
      }
    });

    test('never shows the same idea twice in a row', () {
      final random = Random(7);
      var current = nextSurpriseIndex(null, random);
      for (var i = 0; i < 500; i++) {
        final next = nextSurpriseIndex(current, random);
        expect(next, isNot(current));
        expect(next, inInclusiveRange(0, kSurpriseIdeaCount - 1));
        current = next;
      }
    });

    test('can reach every idea', () {
      final random = Random(3);
      final seen = <int>{};
      var current = nextSurpriseIndex(null, random);
      for (var i = 0; i < 500; i++) {
        current = nextSurpriseIndex(current, random);
        seen.add(current);
      }
      expect(seen.length, kSurpriseIdeaCount);
    });

    test('a single idea is always index 0', () {
      expect(nextSurpriseIndex(0, Random(1), count: 1), 0);
      expect(nextSurpriseIndex(null, Random(1), count: 1), 0);
    });
  });

  test('surprise texts are translated in every supported language', () {
    final keys = [
      'surpriseTitle',
      'surpriseSubtitle',
      'surpriseRollAnother',
      'surpriseKeepIdea',
      for (var i = 1; i <= kSurpriseIdeaCount; i++) 'surpriseIdea$i',
    ];
    for (final lang in AppLanguage.supportedLanguages) {
      final loc = AppLocalizations(Locale(lang.code));
      for (final key in keys) {
        expect(
          loc.hasKey(key),
          isTrue,
          reason: '${lang.code} is missing "$key"',
        );
      }
    }
  });
}
