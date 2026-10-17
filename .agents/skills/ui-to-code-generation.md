---
name: ui-to-code-generation
description: Standards and guidelines for generating clean, accessible, and performant Flutter UI components and screens.
---

# 🎨 UI-to-Code Üretim Standartları (UI Generation Guidelines)

Bu yetenek kılavuzu, **GHARAR** projesinde yeni bir sayfa (Screen) veya yeniden kullanılabilir arayüz bileşeni (Widget) oluştururken uyulması zorunlu olan mimari ve kodlama kurallarını tanımlar.

---

## 🚫 1. Metot ile Widget Üretmek Kesinlikle Yasaktır

Kod içinde `Widget _buildHeader()` veya `Widget _buildCard()` gibi yardımcı metotlar kullanılmamalıdır.

### Neden?
- Metot ile üretilen widget'lar Flutter'ın `Element` ağacı optimizasyonlarından yararlanamaz.
- Üst widget her rebuild olduğunda metot içindeki tüm ağaç gereksiz yere baştan oluşturulur.
- `const` constructor avantajı kaybedilir ve gereksiz bellek/CPU tüketilir.

### ✅ Standart Çözüm: Bağımsız `StatelessWidget` Sınıfı
```dart
// ❌ YANLIŞ: Metot ile widget döndürme
Widget _buildPartnerCard(String name) {
  return Card(child: Text(name));
}

// ✅ DOĞRU: Bağımsız StatelessWidget sınıfı
class PartnerCard extends StatelessWidget {
  final String name;

  const PartnerCard({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Text(
        name,
        style: AppTextStyles.headline(isDark: Theme.of(context).brightness == Brightness.dark),
      ),
    );
  }
}
```

---

## ⚡ 2. `const` Constructor Zorunluluğu

- Statik veya dışarıdan sabit parametre alan tüm widget sınıfları `const` constructor tanımlamalıdır.
- Widget ağacındaki tüm `SizedBox`, `Padding`, `EdgeInsets`, `Icon` ve `Text` tanımlarında mümkün olan her yerde `const` kullanılmalıdır.
- Bu kural Flutter'ın `rebuild` süresini sıfıra indirir.

---

## 🎨 3. Tasarım Token'ları ve Tema Referansları

Arayüz kodlarına asla doğrudan hardcoded hex renk veya rastgele piksel değeri yazılamaz. Her zaman projenin `lib/core/theme/` token'ları kullanılmalıdır:

- **Renkler:** `AppColors.terracotta`, `AppColors.earthSlate`, `AppColors.heartGold`, `AppColors.warmParchment`, `AppColors.inkCharcoal`
- **Tipografi:** `AppTextStyles.displayLarge`, `AppTextStyles.headline`, `AppTextStyles.bodyMedium`
- **Tema Bağlamı:** `Theme.of(context).colorScheme...`

```dart
// ❌ YANLIŞ: Hardcoded renk ve font
Container(
  color: Color(0xFFC85A32),
  child: Text('Günün Sorusu', style: TextStyle(fontSize: 18, color: Colors.white)),
)

// ✅ DOĞRU: GHARAR Tema Token'ları
Container(
  decoration: BoxDecoration(
    color: AppColors.terracotta,
    borderRadius: BorderRadius.circular(16),
  ),
  child: Text(
    'Günün Sorusu',
    style: AppTextStyles.headline(isDark: false),
  ),
)
```

---

## 📱 4. Responsive ve Erişilebilirlik (a11y) Kuralları

1. **Dokunma Hedefi (Touch Target):** Tıklanabilir tüm elemanlar (butonlar, ikonlar) minimum **48x48 dp** dokunma alanına sahip olmalıdır (`IconButton`, `InkWell` padding'leri).
2. **Taşma Koruması:** Küçük ekranlarda metinlerin ve kartların taşmasını önlemek için dikey içerikler daima `SingleChildScrollView` veya `ListView` ile sarılmalıdır.
3. **Güvenli Alan (SafeArea):** Çentikli ekranlar ve alt gezinme çubukları için `SafeArea` ile ekran sınırları güvenceye alınmalıdır.
4. **Çok Dillilik (Localization):** Metinler daima `AppLocalizations` veya `intl` üzerinden çekilmeli, ekrana doğrudan hardcoded string yazılmamalıdır.

---

## 🧩 5. Tam Örnek UI Bileşeni Şablonu

```dart
import 'package:flutter/material.dart';
import 'package:gharar/core/theme/app_colors.dart';
import 'package:gharar/core/theme/app_text_styles.dart';

class SoulBridgeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const SoulBridgeCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      button: true,
      label: title,
      child: Material(
        color: isDark ? AppColors.darkSurface : AppColors.warmParchment,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTextStyles.headline(isDark: isDark),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.inkMuted,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```
