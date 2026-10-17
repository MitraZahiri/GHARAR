# 🧪 Ortak Test Kuralları (Common Testing Rules)

Bu doküman, **GHARAR** projesindeki test yazım standartlarını, kalite güvence (QA) süreçlerini ve TDD disiplinini belirler.

---

## 🎯 1. TDD Zorunluluğu (Test-Driven Development)

Tüm yeni özellik geliştirmeleri, mimari refactoring ve hata düzeltmeleri (bugfix) için **Test-First** yaklaşımı zorunludur:

1. **RED:** Önce başarısız olan testi yazın (`flutter test`).
2. **GREEN:** Testi geçirecek minimum ve en temiz kodu yazın.
3. **REFACTOR:** Kodu ve testleri temizleyin; `const` kullanımlarını, kod standartlarını ve performansı optimize edin.
4. **VERIFY:** Tüm test paketini ve statik analizi çalıştırın.

---

## 📊 2. Test Kapsamı (%80+ Coverage)

- `models/`: **%100** (Serileştirme, `copyWith`, eşitlik ve doğrulama mantığı)
- `services/`: **%80+** (Veri işleme, yerel depolama dönüşümleri, istisna yönetimi)
- `providers/`: **%85+** (Durum geçişleri, asenkron işlemler, hata durumları)
- `ui/`: Kritik kullanıcı arayüzleri, form doğrulama ve kullanıcı etkileşimleri için widget testleri zorunludur.

Coverage kontrolü:
```bash
flutter test --coverage
```

---

## 🏗️ 3. Test Seviyeleri ve Sorumlulukları

### 3.1. Birim (Unit) Testleri (`test/`)
- Saf iş mantığı, domain kuralları ve durum sağlayıcılarını (ChangeNotifier) hedefler.
- UI bileşenlerine (`WidgetTester`) ihtiyaç duymadan, milisaniyeler seviyesinde hızlı çalışmalıdır.
- Örnek: `test/auth_test.dart`, `test/domain_test.dart`

### 3.2. Bileşen (Widget) Testleri (`test/`)
- `WidgetTester` kullanılarak bileşenlerin doğru render edilmesi, responsive düzenleri, metin taşmaları (overflow) ve kullanıcı etkileşimleri (tıklama, form doldurma) test edilir.
- `pump()`, `pumpAndSettle()` ve `find` API'leri doğru asenkron akışlarla kullanılmalıdır.
- Her ekran boyutu (Ultra Compact'tan Phablet'e kadar) için responsive testler yazılmalıdır (`test/responsive_test.dart`).

### 3.3. Uçtan Uca Entegrasyon Testleri (`integration_test/`)
- İki partnerin eşleşmesi, günlük soru yanıtlama ve mutual-reveal gibi çok adımlı kritik akışlar için kurgulanır.
- Gerçek ortam simülasyonu yapılır.

---

## 🛡️ 4. Test İzolasyonu ve Mocking Standartları

- **Dış Bağımlılık Yasağı:** Testler asla gerçek ağ (network) istekleri atmamalı veya gerçek diskte izinsiz kalıcı veri bırakmamalıdır.
- **Mock / Fake Servisler:** Servis katmanı için testlerde kullanılmak üzere hafif fake implementasyonlar veya `mockito` nesneleri kullanılmalıdır.
- **Determinizm:** Testler sistem saatine, rastgele seed değerlerine veya çalışma sırasına bağımlı olmamalı; her koşulda aynı sonucu vermelidir.

---

## 🚀 5. Çalıştırma ve Doğrulama

```bash
# Tüm testleri koştur
flutter test

# Belirli bir test dosyasını koştur
flutter test test/domain_test.dart

# Statik kod analizi ile birlikte test doğrulaması
flutter analyze && flutter test
```
