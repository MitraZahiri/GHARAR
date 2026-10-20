# 🔒 Dart/Flutter Güvenlik ve Mahremiyet Kuralları (Security & Privacy)

Bu doküman, ECC `rules/dart/security.md` kuralının **GHARAR**'a uyarlanmış halidir. GHARAR bir çift mahremiyet sığınağıdır; aşağıdaki kurallar `lib/`, `android/`, `ios/` ve `pubspec.yaml` için geçerlidir.

---

## 🗝️ 1. Sır Yönetimi (Secrets)

- API anahtarı, token, şifre **asla** Dart kaynağına yazılmaz.
- Derleme zamanı yapılandırma: `--dart-define` / `--dart-define-from-file` (bunlar gerçek sır değildir; APK'dan çıkarılabilir).
- Gerçek sunucu sırları (ör. AI sağlayıcı anahtarı) istemcide tutulmaz → backend proxy kullanılır.
- `.env` / `dart_defines.json` gibi dosyalar `.gitignore`'a eklenir.

```dart
// ❌ YANLIŞ
const aiKey = 'sk-abc123...';

// ✅ DOĞRU (yapılandırılabilir, sır değil)
const apiBaseUrl = String.fromEnvironment('API_BASE_URL');
```

---

## 📝 2. Log Hijyeni

- `print`, `debugPrint`, `log` içinde **asla**: günlük içeriği, soru cevapları, aşk notları, duygu durumu, isim, e-posta, partner ID, auth token.
- Hata loglarında yalnızca hata tipi ve teknik bağlam; kullanıcı içeriği değil.
- Üretimde `print` kullanılmaz (`avoid_print` lint'i açık).

```dart
// ❌ YANLIŞ
debugPrint('Saving journal: ${entry.content}');

// ✅ DOĞRU
assert(() { developer.log('Journal saved (id=${entry.id.hashCode})'); return true; }());
```

---

## 💾 3. Veri Depolama Sınıflandırması

| Sınıf | Örnek | Depolama |
| :--- | :--- | :--- |
| **S1 — Kritik** | Günlük, cevaplar, aşk notları, duygu geçmişi, auth token | Şifreli (`flutter_secure_storage` veya Keychain/Keystore anahtarlı şifreli dosya) |
| **S2 — Kişisel** | İsim, e-posta, partner ID, özel tarihler | Tercihen şifreli; çıkışta mutlaka silinir |
| **S3 — Tercih** | Tema, dil, onboarding bayrağı | `SharedPreferences` (düz metin) uygundur |

- ⚠️ **Bilinen borç:** `StorageService` şu an tüm verileri `SharedPreferences`'te düz JSON olarak tutuyor. Yeni S1/S2 veri eklerken bu borcu büyütme; şifreli depolamaya geçiş planını öner.
- Çıkışta (`clearAll`) tüm S1/S2 verileri temizlenmelidir.

---

## ✅ 4. Girdi Doğrulama

- Kullanıcı girdileri (not, cevap, davet kodu) uzunluk ve karakter açısından doğrulanır, `trim` edilir.
- QR / davet kodu: `Uri.tryParse` veya format regex'i ile doğrulanmadan eşleşme yapılmaz; tahmin edilemez (yeterli entropi) olmalıdır.
- Deep link'ler izinli host/path listesiyle doğrulanır.
- Harici JSON (`fromJson`) bozuk veriye karşı dayanıklı olmalı (tip kontrolü, varsayılanlar).

---

## 🌐 5. Ağ ve AI Servisleri

- Yalnızca HTTPS; HTTP istemcilerinde zaman aşımı tanımlı.
- Kullanıcı içeriği (günlük, cevap) harici AI servisine gönderilecekse açık kullanıcı rızası ve minimum veri ilkesi uygulanır.
- Sunucu hataları kullanıcıya ham haliyle gösterilmez; yerelleştirilmiş, zarif mesaja çevrilir.

---

## 📱 6. Platform

- **Android:** Yalnızca launcher activity `exported="true"`; cleartext trafik kapalı; sadece gerekli izinler; günlük/not ekranlarında `FLAG_SECURE` değerlendirilir.
- **iOS:** ATS açık (arbitrary loads yok); yalnızca gerekli `Info.plist` usage açıklamaları.
- **Release:** `flutter build apk --obfuscate --split-debug-info=build/debug-info` (debug-info klasörü repoya girmez).
