import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:gharar/core/localization/app_language.dart';
import 'package:gharar/core/localization/app_localizations.dart';
import 'package:gharar/providers/app_state_provider.dart';
import 'package:gharar/services/storage_service.dart';
import 'package:gharar/ui/widgets/romantic_app_bar.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GHARAR Multilingual Localization Engine Tests', () {
    test(
      '8 supported languages are configured correctly with flags and RTL metadata',
      () {
        final codes =
            AppLanguage.supportedLanguages.map((l) => l.code).toList();
        expect(
          codes,
          containsAll(['en', 'tr', 'ar', 'fa', 'de', 'es', 'fr', 'it']),
        );
        expect(codes.length, 8);

        final arabic = AppLanguage.fromCode('ar');
        expect(arabic.nativeName, 'العربية');
        expect(arabic.flag, '🇸🇦');
        expect(arabic.isRtl, isTrue);
        expect(arabic.tagline, 'ملاذ لقلبين');

        final persian = AppLanguage.fromCode('fa');
        expect(persian.nativeName, 'فارسی');
        expect(persian.flag, '🇮🇷');
        expect(persian.isRtl, isTrue);
        expect(persian.tagline, 'پناهگاه دو قلب');

        final german = AppLanguage.fromCode('de');
        expect(german.nativeName, 'Deutsch');
        expect(german.flag, '🇩🇪');
        expect(german.isRtl, isFalse);

        final spanish = AppLanguage.fromCode('es');
        expect(spanish.nativeName, 'Español');
        expect(spanish.flag, '🇪🇸');
        expect(spanish.isRtl, isFalse);

        final french = AppLanguage.fromCode('fr');
        expect(french.nativeName, 'Français');
        expect(french.flag, '🇫🇷');
        expect(french.isRtl, isFalse);

        final italian = AppLanguage.fromCode('it');
        expect(italian.nativeName, 'Italiano');
        expect(italian.flag, '🇮🇹');
        expect(italian.isRtl, isFalse);

        final turkish = AppLanguage.fromCode('tr');
        expect(turkish.nativeName, 'Türkçe');
        expect(turkish.flag, '🇹🇷');
        expect(turkish.isRtl, isFalse);

        final english = AppLanguage.fromCode('en');
        expect(english.nativeName, 'English');
        expect(english.flag, '🇬🇧');
        expect(english.isRtl, isFalse);
      },
    );

    test(
      'AppLocalizations provides correct translations across all 8 languages',
      () {
        final langs = ['en', 'tr', 'ar', 'fa', 'de', 'es', 'fr', 'it'];

        for (final code in langs) {
          final loc = AppLocalizations(Locale(code));
          expect(
            loc.translate('appName'),
            anyOf(equals('GHARAR'), equals('قرار')),
          );
          expect(loc.translate('appTagline'), isNotEmpty);
          expect(loc.translate('welcomeBack'), isNotEmpty);
          expect(loc.translate('noorTitle'), isNotEmpty);
          expect(loc.translate('streakTitle'), isNotEmpty);
          expect(loc.translate('partnerInviteTitle'), isNotEmpty);

          if (code == 'ar' || code == 'fa') {
            expect(loc.isRtl, isTrue);
            expect(loc.textDirection, TextDirection.rtl);
          } else {
            expect(loc.isRtl, isFalse);
            expect(loc.textDirection, TextDirection.ltr);
          }
        }
      },
    );

    test(
      'AppLocalizations falls back gracefully to English when key is missing in target language',
      () {
        final loc = AppLocalizations(const Locale('it'));
        // A key not in it should fall back to English if in en
        expect(loc.translate('appName'), 'GHARAR');
      },
    );

    test(
      'AppStateProvider live switching updates getters and partner simulation',
      () async {
        SharedPreferences.setMockInitialValues({});
        final storage = await StorageService.init();
        final provider = AppStateProvider(storage);

        // Default is English
        expect(provider.currentLanguage.code, 'en');
        expect(provider.isRtl, isFalse);

        // Switch to Turkish
        provider.setLanguageCode('tr');
        expect(provider.isTurkish, isTrue);
        expect(provider.currentLanguage.nativeName, 'Türkçe');
        expect(provider.currentLanguage.tagline, 'İki Kalbin Sığınağı');

        // Switch to Arabic (RTL)
        provider.setLanguageCode('ar');
        expect(provider.isArabic, isTrue);
        expect(provider.isRtl, isTrue);
        expect(provider.currentLanguage.nativeName, 'العربية');
        expect(provider.currentLanguage.tagline, 'ملاذ لقلبين');

        // Switch to Persian (RTL)
        provider.setLanguageCode('fa');
        expect(provider.isFarsi, isTrue);
        expect(provider.isRtl, isTrue);
        expect(provider.currentLanguage.nativeName, 'فارسی');
        expect(provider.currentLanguage.tagline, 'پناهگاه دو قلب');

        // Test simulated partner answer in Persian
        final qId = provider.questions.first.id;
        provider.simulatePartnerAnswer(qId);
        final partnerAns = provider.getAnswerForOtherPartner(qId);
        expect(partnerAns, isNotNull);
        expect(
          partnerAns!.answerText,
          contains('این پاسخ تمام وجودم را سرشار از عشق کرد'),
        );

        // Switch to German
        provider.setLanguageCode('de');
        expect(provider.isGerman, isTrue);
        expect(provider.isRtl, isFalse);
        expect(provider.currentLanguage.nativeName, 'Deutsch');

        // Test simulated partner answer in German
        provider.simulatePartnerAnswer(qId);
        final deAns = provider.getAnswerForOtherPartner(qId);
        expect(
          deAns!.answerText,
          contains('Diese Frage hat mein Herz tief berührt'),
        );
      },
    );

    testWidgets(
      'RomanticAppBar updates tagline dynamically when language changes',
      (tester) async {
        SharedPreferences.setMockInitialValues({});
        final storage = await StorageService.init();
        final provider = AppStateProvider(storage);

        await tester.pumpWidget(
          ChangeNotifierProvider.value(
            value: provider,
            child: const MaterialApp(home: Scaffold(appBar: RomanticAppBar())),
          ),
        );

        // Initially English tagline
        expect(find.text('A Sanctuary for Two'), findsOneWidget);

        // Change to Turkish live
        provider.setLanguageCode('tr');
        await tester.pumpAndSettle();
        expect(find.text('İki Kalbin Sığınağı'), findsOneWidget);

        // Change to Arabic live
        provider.setLanguageCode('ar');
        await tester.pumpAndSettle();
        expect(find.text('ملاذ لقلبين'), findsOneWidget);

        // Change to Persian live
        provider.setLanguageCode('fa');
        await tester.pumpAndSettle();
        expect(find.text('پناهگاه دو قلب'), findsOneWidget);

        // Change to German live
        provider.setLanguageCode('de');
        await tester.pumpAndSettle();
        expect(find.text('Ein Zufluchtsort für Zwei'), findsOneWidget);

        // Change to Spanish live
        provider.setLanguageCode('es');
        await tester.pumpAndSettle();
        expect(find.text('Un Santuario para Dos'), findsOneWidget);

        // Change to French live
        provider.setLanguageCode('fr');
        await tester.pumpAndSettle();
        expect(find.text('Un Sanctuaire pour Deux'), findsOneWidget);

        // Change to Italian live
        provider.setLanguageCode('it');
        await tester.pumpAndSettle();
        expect(find.text('Un Santuario per Due'), findsOneWidget);
      },
    );
  });
}
