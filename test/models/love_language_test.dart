import 'package:flutter_test/flutter_test.dart';
import 'package:gharar/models/love_language.dart';

void main() {
  group('LoveLanguageQuiz', () {
    test('pairs every love language with every other exactly once', () {
      final pairs =
          LoveLanguageQuiz.questions
              .map((q) => {q.first.language, q.second.language})
              .toList();

      expect(pairs.length, 10);
      expect(pairs.toSet().length, 10);
      for (final language in LoveLanguage.values) {
        final appearances = pairs.where((p) => p.contains(language)).length;
        expect(appearances, 4, reason: '$language should appear 4 times');
      }
    });

    test('scores count each picked language', () {
      final scores = LoveLanguageQuiz.scoresFrom(const [
        LoveLanguage.touch,
        LoveLanguage.touch,
        LoveLanguage.words,
      ]);

      expect(scores[LoveLanguage.touch], 2);
      expect(scores[LoveLanguage.words], 1);
      expect(scores[LoveLanguage.gifts], 0);
      expect(scores.length, LoveLanguage.values.length);
    });

    test('primary language is the highest score', () {
      final primary = LoveLanguageQuiz.primaryFrom(const [
        LoveLanguage.service,
        LoveLanguage.time,
        LoveLanguage.service,
      ]);

      expect(primary, LoveLanguage.service);
    });

    test('ties go to the language picked first', () {
      final primary = LoveLanguageQuiz.primaryFrom(const [
        LoveLanguage.gifts,
        LoveLanguage.words,
        LoveLanguage.words,
        LoveLanguage.gifts,
      ]);

      expect(primary, LoveLanguage.gifts);
    });

    test('no picks gives no primary language', () {
      expect(LoveLanguageQuiz.primaryFrom(const []), isNull);
    });
  });

  group('LoveLanguage', () {
    test('round-trips through its storage key', () {
      for (final language in LoveLanguage.values) {
        expect(LoveLanguage.fromKey(language.name), language);
      }
      expect(LoveLanguage.fromKey('unknown'), isNull);
      expect(LoveLanguage.fromKey(null), isNull);
    });

    test('has Turkish and English copy for every language', () {
      for (final language in LoveLanguage.values) {
        for (final isTr in [true, false]) {
          expect(language.title(isTr), isNotEmpty);
          expect(language.description(isTr), isNotEmpty);
          expect(language.partnerTip(isTr), isNotEmpty);
        }
        expect(language.title(true), isNot(language.title(false)));
      }
    });
  });
}
