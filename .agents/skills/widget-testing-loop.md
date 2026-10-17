---
name: widget-testing-loop
description: Comprehensive workflow for writing Flutter widget tests using WidgetTester, finders, user interaction simulation, and overflow validation.
---

# 🔍 Flutter Widget Testing Loop

Bu yetenek kılavuzu, **GHARAR** projesinde UI bileşenlerinin (Widgets ve Ekranlar) `WidgetTester` ile test edilmesini, kullanıcı etkileşimlerini simüle etmeyi ve render taşmalarını (RenderFlex overflow) yakalamayı standartlaştırır.

---

## 🎯 Temel Hedefler

1. **Görsel Doğruluk:** Bileşenlerin ekranda doğru metin, ikon ve stil ile çizilmesi.
2. **Kullanıcı Etkileşimleri:** Tıklama (`tap`), metin yazma (`enterText`), kaydırma (`drag`) tepkilerinin testi.
3. **Responsive & Overflow Dayanıklılığı:** Farklı ekran boyutlarında (Compact SE'den Phablet Pro Max'e kadar) taşma hatası olmaksızın render edilmesi.

---

## 📋 5 Adımlı Widget Test Döngüsü

### 1. Test Ortamını Hazırlama (Test Harness Setup)
Widget'ları bağımsız test ederken tema, yönlendirme ve provider bağlamını sağlayın:

```dart
Widget createTestWidget(Widget child, {AppStateProvider? provider}) {
  return MaterialApp(
    theme: AppTheme.lightTheme,
    darkTheme: AppTheme.darkTheme,
    home: Scaffold(body: child),
  );
}
```

### 2. Widget'ı Ekrana Çizdirme (`pump` vs `pumpAndSettle`)
- `await tester.pumpWidget(...)`: Ağacı tek bir kare (frame) render eder.
- `await tester.pumpAndSettle()`: Tüm animasyonlar, geçişler ve asenkron çizimler tamamlanana kadar (tüm mikro-görevler bitene kadar) bekler.
  > ⚠️ Sonsuz animasyon (infinite looping animation) içeren bileşenlerde `pumpAndSettle()` yerine `tester.pump(const Duration(milliseconds: 100))` kullanın!

### 3. Eleman Bulma Stratejileri (Finder Strategies)
- **Tipe Göre Bulma:** `find.byType(ElevatedButton)` veya `find.byType(CustomCard)`
- **Metne Göre Bulma:** `find.text('Devam Et')` veya `find.textContaining('GHARAR')`
- **Anahtara (Key) Göre Bulma:** `find.byKey(const Key('submit_answer_button'))`
- **İkona Göre Bulma:** `find.byIcon(Icons.favorite)`

### 4. Kullanıcı Etkileşimi Simülasyonu
```dart
// Butona tıklama
await tester.tap(find.byType(ElevatedButton));
await tester.pumpAndSettle();

// Metin alanına yazı yazma
await tester.enterText(find.byType(TextField), 'Seni çok seviyorum');
await tester.pumpAndSettle();
```

### 5. Taşma (Overflow) ve Assert Kontrolü
Render hatalarını yakalamak için `FlutterError.onError` dinlenir ve ekran boyutları simüle edilir:

```dart
testWidgets('Ekran iPhone SE boyutunda taşma yapmadan çizilmelidir', (WidgetTester tester) async {
  // Ultra-compact ekran simülasyonu (320 x 568)
  tester.view.physicalSize = const Size(320, 568);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);

  bool hasOverflow = false;
  final originalOnError = FlutterError.onError;
  FlutterError.onError = (details) {
    if (details.toString().contains('overflowed')) {
      hasOverflow = true;
    }
    originalOnError?.call(details);
  };

  await tester.pumpWidget(createTestWidget(const DailyQuestionScreen()));
  await tester.pumpAndSettle();

  expect(hasOverflow, isFalse, reason: 'Ekranda RenderFlex overflow hatası tespit edildi!');
  expect(find.text('Günün Sorusu'), findsOneWidget);
});
```

---

## ⚡ En İyi Pratikler Kontrol Listesi

- [ ] Her etkileşimden (`tap`, `enterText`) sonra `await tester.pumpAndSettle()` çağrıldı mı?
- [ ] Widget testi bitince `tester.view.resetPhysicalSize` ile ekran boyutu sıfırlandı mı?
- [ ] Provider'lar mocklanarak UI mantığından harici ağ çağrıları izole edildi mi?
