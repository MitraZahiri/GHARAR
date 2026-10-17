# 🕊️ GHARAR — Agent Instructions & Constitution (AGENTS.md)

Bu belge, **GHARAR** Flutter projesinde otonom ve yarı otonom çalışan AI ajanlarının (özellikle **Gemini Antigravity** ve harness tabanlı ajanların) ve geliştiricilerin uyması zorunlu olan **Proje Anayasası** ve temel mühendislik ilkeleridir. ECC (Enterprise Coding Conventions) mimarisinden uyarlanmış, Flutter/Dart teknoloji yığınına özel olarak sadeleştirilmiştir.

---

## 🏛️ 1. Temel Mühendislik İlkeleri (Core Principles)

1. **Test-First & %80+ Coverage (TDD):**
   - Yeni özellik eklerken veya hata düzeltirken **önce test yazılır** (Red-Green-Refactor döngüsü).
   - `models/`, `services/` ve `providers/` katmanları için minimum **%80 test coverage** zorunludur.
   - Her kritik UI bileşeni için `WidgetTester` ile widget testi yazılmalıdır.
   - Kritik kullanıcı akışları (E2E / Onboarding / Mutual-Reveal) için `integration_test` senaryoları kurgulanmalıdır.
   - Kod tamamlandığında `flutter test` ve `flutter analyze` 0 hata ile geçmelidir.

2. **İmmutability & Bildirimsel Durum (Declarative State):**
   - Bütün veri modelleri (`models/`) `final` alanlara sahip olmalı, asla doğrudan mutasyona uğratılmamalıdır.
   - Nesne güncellemeleri için daima `copyWith()` fonksiyonu ve değer eşitliği (`==` / `hashCode` veya `Equatable`) kullanılmalıdır.
   - Widget ağacında yeniden çizimleri (rebuild) önlemek için mümkün olan her yerde **`const` constructor** kullanılmalıdır.

3. **Güvenlik ve Gizlilik Önceliği (Security & Privacy-First):**
   - GHARAR bir çift mahremiyet sığınağıdır. Kullanıcıların günlükleri, duygu paylaşımları ve özel verileri en yüksek hassasiyetle korunmalıdır.
   - Kod tabanına asla API anahtarları, token'lar veya şifreler **hardcode edilmez**.
   - Hassas veriler düz metin (`SharedPreferences`) yerine şifreli/güvenli mekanizmalarla saklanmalıdır.
   - Konsol loglarında (`print`, `debugPrint`) asla kişisel veri (PII), günlük içeriği veya hassas kimlik bilgisi basılamaz.

4. **Önce Planla, Sonra Uygula (Plan Before Execute):**
   - 2 dosyadan fazla değişiklik veya mimari yenilik gerektiren işlerde kod yazmadan önce plan sunulur.
   - Olası yan etkiler, durum yönetimi kırılmaları ve geriye dönük uyumluluk önceden değerlendirilir.

5. **Katmanlı Temiz Mimari (Layered Clean Architecture):**
   ```
   lib/
   ├── core/         # Temalar, utils, localization, sabitler, tasarım tokenları
   ├── models/       # Saf veri nesneleri (Immutable, copyWith, JSON serileştirme)
   ├── services/     # Veri kaynakları, yerel depolama, AI servisleri (Harici etkileşimler)
   ├── providers/    # Durum yönetimi (Provider/ChangeNotifier, iş mantığı)
   └── ui/           # Ekranlar (screens) ve yeniden kullanılabilir bileşenler (widgets)
   ```
   - **Kural:** UI katmanı doğrudan `services/` katmanını çağırmaz; tüm veri akışı `providers/` üzerinden yürütülür.

---

## 🤖 2. Özel Ajan Rolleri (Specialized Agent Roles)

Aşağıdaki roller, Flutter ve GHARAR mimarisine göre optimize edilmiştir:

| Ajan Rolü | Görev ve Odak Alanı | Ne Zaman Çağrılır? |
| :--- | :--- | :--- |
| **`flutter-architect`** | Durum yönetimi (`Provider`), katman ayrımı, navigasyon, servis hiyerarşisi | Yeni özellik tasarımı, mimari refactoring |
| **`tdd-guide`** | Red-Green-Refactor akışı, unit, widget & integration testleri, %80+ coverage denetimi | Kod yazmaya başlamadan önce ve test yazımı sırasında |
| **`flutter-reviewer`** | Dart linter kuralları, `const` kullanımı, widget ağacı rebuild optimizasyonu (`context.select`), memory leak denetimi | Kod yazımı/değişikliği tamamlandığında |
| **`dart-build-resolver`** | `flutter analyze` hataları, tip güvenliği (null safety), `pubspec.yaml` paket çakışmaları | Derleme, analiz ve bağımlılık hatalarında |
| **`security-reviewer`** | Veri mahremiyeti, yerel şifreleme, girdi doğrulama, log hijyeni | Hassas veri modelleri ve servis değişikliklerinde |
| **`ui-a11y-specialist`** | Responsive düzenler, Dark/Light tema tutarlılığı, erişilebilirlik (`Semantics`), dokunma hedefleri (≥48x48dp) | UI bileşeni ve ekran geliştirmelerinde |

---

## 📐 3. Dart & Flutter Kod Standartları

### 3.1. Dil ve Tip Kuralları
- **Strict Typing:** `dynamic` kullanımından kaçının. Mümkün olan en spesifik tipleri kullanın.
- **Sound Null Safety:** Zorunlu olmadıkça `!` (bang operator) kullanmayın; `?.`, `??` veya `if (x != null)` korumaları tercih edin.
- **Avoid Magic Numbers & Colors:** Renkleri ve boyutları asla doğrudan kod içine yazmayın. `AppTheme`, `Theme.of(context)` ve `core/` sabitlerini kullanın.
- **Localization:** UI içerisindeki kullanıcıya görünen tüm metinler yerelleştirme sistemine (`intl` / `AppLocalizations`) uygun olmalıdır. Asla arayüze hardcoded string gömmeyin.

### 3.2. Widget ve Durum Yönetimi (State Management Standartları)
- **Granular Rebuilds:** `context.watch<T>()` yerine performansı korumak için `context.select<T, R>()` veya odaklanmış `Consumer<T>` blokları tercih edin.
- **Resource Cleanup:** Bellek sızıntılarını (memory leak) önlemek için her `TextEditingController`, `AnimationController`, `ScrollController` ve `StreamSubscription` nesnesi `dispose()` içinde serbest bırakılmalıdır.
- **Widget Derinliği:** Çok derin iç içe widget ağaçlarından kaçının; mantıksal alt bileşenleri küçük `StatelessWidget` sınıflarına bölün (metot ile widget üretmek yerine sınıf tercih edilir).

### 3.3. Hata Yönetimi (Error Handling)
- Hataları sessizce yutmayın (`catch (e) {}` yasaktır).
- Servis katmanında yakalanan istisnalar anlamlı domain hatalarına dönüştürülmeli ve UI katmanında kullanıcıya zarif bildirimlerle (Snackbar, Dialog veya durum widget'ı) yansıtılmalıdır.

---

## 🧪 4. Test ve Kalite Güvencesi (QA, TDD & Integration Test Workflow)

Her geliştirme döngüsü şu sırayla işletilmelidir:

```
1. RED:     Özellik için başarısız test yaz (Unit / Widget / Integration Test)
2. GREEN:   Testi geçirecek en sade kodu yaz
3. REFACTOR: Performans, const kullanımı ve kod standartlarını iyileştir
4. VERIFY:  flutter analyze && flutter test çalıştır
```

### Test Seviyeleri:
- **Birim (Unit) Testleri:** Saf iş mantığı, domain modelleri, `Provider` durum geçişleri ve yardımcı fonksiyonlar (`test/` dizini).
- **Widget Testleri:** Bileşenlerin ekranda doğru çizilmesi, kullanıcı tıklama/girdi tepkileri, tema uyumluluğu ve taşma (overflow) kontrolleri.
- **Entegrasyon (Integration) Testleri:** Çiftlerin eşleşme, günlük yanıtlama ve mutual-reveal gibi çok adımlı uçtan uca akışları (`integration_test/` dizini).

### Zorunlu Doğrulama Komutları:
```bash
# 1. Statik kod analizi (0 hata, 0 uyarı hedeflenir)
flutter analyze

# 2. Bütün testleri çalıştır ve test coverage raporla
flutter test --coverage

# 3. Bağımlılık kontrolü
flutter pub get
```

---

## 🔒 5. Güvenlik ve Gizlilik Kontrol Listesi (Pre-Commit Checklist)

Her commit öncesinde şu maddeler doğrulanmalıdır:
- [ ] Kaynak kodda hiçbir gizli anahtar, API sırrı veya kişisel veri bulunmuyor.
- [ ] Model sınıfları immutable ve `final` alanlara sahip.
- [ ] Yeni/değişen iş mantığı için testler yazıldı ve `%80+` kapsam sağlandı.
- [ ] Gereksiz `print()` veya `debugPrint()` ifadeleri temizlendi.
- [ ] Açık bırakılmış controller veya subscription bulunmuyor (`dispose()` uygulandı).
- [ ] `flutter analyze` temiz çıktı veriyor (0 issue).

---

## 🚀 6. Git ve Dağıtım Standartları (Conventional Commits)

Commit mesajlarında standart ön ekler kullanılmalıdır:
- `feat:` Yeni bir kullanıcı özelliği (örn: `feat: add mutual-reveal daily question widget`)
- `fix:` Hata düzeltmesi (örn: `fix: resolve provider state leak on logout`)
- `test:` Test ekleme veya güncelleme (örn: `test: add unit tests for CoupleModel`)
- `refactor:` Davranış değiştirmeyen kod temizliği (örn: `refactor: extract soul bridge animation widget`)
- `perf:` Performans iyileştirmesi (örn: `perf: optimize provider rebuilds with context.select`)
- `style:` Kod formatı ve stil düzenlemeleri (boşluklar, const eklemeleri)
- `chore:` Bağımlılık güncellemeleri, CI/CD veya yapılandırma ayarları
