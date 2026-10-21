---
name: flutter-test
description: GHARAR Flutter testlerini (unit, widget) çalıştırır, başarısızlıkları teşhis eder, tek tek düzeltir ve kapsam raporu verir. Kullanım - /flutter-test [test dosyası veya --name deseni]
---

# /flutter-test

Hedef: $ARGUMENTS (boşsa tüm paket)

1. Çalıştır:
   - Hedef verilmişse: `flutter test <hedef>` (dosya yolu) veya `flutter test --name "<desen>"`
   - Verilmemişse: `flutter test --coverage`
2. Başarısızlıkları sınıflandır: assertion, derleme, `pumpAndSettle` timeout (sonsuz animasyon → `pump(Duration)`), RenderFlex overflow, eksik provider/localization ancestor, `SharedPreferences.setMockInitialValues` eksikliği.
3. Kök nedeni belirle: **test mi yanlış, kod mu?** Davranışı belgeleyen doğru bir testi, kodu geçirmek için zayıflatma. Belirsizse kullanıcıya sor.
4. Her seferinde tek bir başarısızlığı düzelt, o dosyayı yeniden çalıştır.
5. Hepsi yeşil olunca tüm paketi `flutter test --coverage` ile tekrar koş.
6. Kapsam: `coverage/lcov.info` içinden `lib/models`, `lib/services`, `lib/providers` için satır kapsamını hesapla (ör. `node` ile LF/LH toplayarak) ve %80 hedefine göre raporla.

## Rapor
```
Tests: <geçen>/<toplam>  |  Düzeltilen: N
Kapsam: models %X · services %Y · providers %Z · toplam %T
Kalan sorunlar: ...
```
