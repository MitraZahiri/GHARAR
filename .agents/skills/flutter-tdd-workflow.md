---
name: flutter-tdd-workflow
description: Step-by-step Test-Driven Development (TDD) workflow for Flutter business logic (Providers and Services).
---

# 🧪 Flutter TDD Workflow (Red - Green - Refactor)

Bu yetenek kılavuzu, **GHARAR** projesinde yeni bir iş mantığı (Provider, Service veya Domain Model) geliştirirken uygulanacak katı **TDD (Test-Driven Development)** sürecini tanımlar.

---

## 🎯 Temel İlke: "Önce Test, Sonra Kod"

Herhangi bir üretim kodu (`lib/`) yazılmadan önce, o kodun davranışını kanıtlayan test dosyası (`test/`) oluşturulmalıdır.

```
┌─────────────┐       ┌───────────────┐       ┌────────────────┐
│   1. RED    │ ───>  │   2. GREEN    │ ───>  │  3. REFACTOR   │
│  Test Yaz   │       │  Kodu Yaz     │       │ Kodu İyileştir │
│ (Başarısız) │       │ (Testi Geçir) │       │   (0 Regresyon)│
└─────────────┘       └───────────────┘       └────────────────┘
       ▲                                               │
       └───────────────────────────────────────────────┘
```

---

## 📋 Adım Adım TDD Uygulama Döngüsü

### 1. RED Aşaması (Başarısız Test)
1. İlgili katmana karşılık gelen test dosyasını `test/` altında oluşturun:
   - `lib/providers/mood_provider.dart` için -> `test/providers/mood_provider_test.dart`
2. Test senaryolarını `group` ve `test` bloklarıyla tanımlayın.
3. Beklenen davranışı `expect(actual, matcher)` ile yazın.
4. Testi çalıştırın ve **başarısız olduğunu** doğrulayın:
   ```bash
   flutter test test/providers/mood_provider_test.dart
   ```
   > ⚠️ **Kural:** Test derleme hatası vermeden veya assertion hatasıyla kırmızı yanmadan üretim koduna geçilmez.

### 2. GREEN Aşaması (Testi Geçirecek Kod)
1. `lib/` altında hedef dosyayı oluşturun veya güncelleyin.
2. Yalnızca testi geçirecek **en sade, en basit kodu** yazın (over-engineering yapmayın).
3. Testi tekrar çalıştırın ve **yeşil yandığını** doğrulayın:
   ```bash
   flutter test test/providers/mood_provider_test.dart
   ```

### 3. REFACTOR Aşaması (Kod İyileştirme)
1. Kodun okunabilirliğini artırın; DRY ve KISS ilkelerini uygulayın.
2. Değişmezleri `final` ve `const` yapın.
3. Testi tekrar koşturun; hiçbir testin kırılmadığından emin olun.

### 4. DOĞRULAMA (Verification & Coverage)
1. Kod analizi ve kapsamı kontrol edin:
   ```bash
   flutter analyze
   flutter test --coverage
   ```
2. Minimum `%80` kapsam şartını denetleyin.

---

## 💡 Pratik Kod Şablonu

```dart
// test/providers/partner_sync_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:gharar/models/user_model.dart';

void main() {
  group('PartnerSync - TDD Tests', () {
    test('başlangıç durumunda partner bağlı değilken isLinked false dönmelidir', () {
      // 1. Arrange
      const user = UserModel(id: 'u1', name: 'Zahra', isOnline: true);
      
      // 2. Act
      final hasPartner = user.partnerId != null;

      // 3. Assert
      expect(hasPartner, isFalse);
    });

    test('partner bağlandığında copyWith ile yeni immutable kopya dönmelidir', () {
      // 1. Arrange
      const user = UserModel(id: 'u1', name: 'Zahra');

      // 2. Act
      final updatedUser = user.copyWith(partnerId: 'u2');

      // 3. Assert
      expect(updatedUser.partnerId, equals('u2'));
      expect(user.partnerId, isNull); // Orijinal nesne değişmez kalmalı!
    });
  });
}
```
