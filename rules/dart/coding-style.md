# 📐 Dart Kod Stili ve Standartları (Dart Coding Style)

Bu doküman, **GHARAR** Flutter projesindeki Dart dil kurallarını, tip güvenliğini, immutability ve kod kalitesi standartlarını belirler.

---

## 🔒 1. Tip Güvenliği ve Sound Null Safety

- **Strict Typing:** `dynamic` ve `Object?` kullanımından kaçının. Mümkün olan en kesin (specific) tipleri kullanın.
- **Null Assertion (`!`) Yasağı:** Zorunlu ve kesinlikle kanıtlanabilir durumlar dışında `!` (bang operator) kullanmayın.
  ```dart
  // ❌ YANLIŞ
  final length = user!.name!.length;

  // ✅ DOĞRU
  final length = user?.name?.length ?? 0;
  ```
- **Late Değişkenler:** `late` anahtar kelimesini yalnızca yaşam döngüsü (`initState`) içinde başlatılan controller veya animasyon nesnelerinde kullanın. İsteğe bağlı alanlar için nullable tip (`?`) tercih edin.

---

## 💎 2. İmmutability ve Veri Modelleri

Tüm domain modelleri (`lib/models/`) değişmez (immutable) olmalıdır:

- Bütün model alanları `final` tanımlanmalıdır.
- Nesne güncellemeleri için `copyWith()` metodu zorunludur.
- Değer eşitliği için `==` operatörü ve `hashCode` override edilmelidir.

```dart
@immutable
class UserModel {
  final String id;
  final String name;
  final bool isOnline;

  const UserModel({
    required this.id,
    required this.name,
    this.isOnline = false,
  });

  UserModel copyWith({
    String? id,
    String? name,
    bool? isOnline,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isOnline: isOnline ?? this.isOnline,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          isOnline == other.isOnline;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ isOnline.hashCode;
}
```

---

## ⚡ 3. `const` Constructor Zorunluluğu

- Widget ağacında değişmeyen her yapı için `const` constructor kullanılmalıdır.
- Değişmeyen padding, margin, border, text style ve container dekorasyonlarında `const` eklenmelidir.
- Linter kuralı: `prefer_const_constructors`, `prefer_const_declarations`.

```dart
// ✅ DOĞRU
const SizedBox(height: 16);
const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
```

---

## 🎨 4. Tasarım Sabitleri ve Sihirli Değerler (Magic Numbers)

- Kod içerisine doğrudan hex renk (`Color(0xFF...)`) veya rastgele piksel boyutu gömmek yasaktır.
- Renkler ve tipografi için `AppTheme`, `Theme.of(context)` veya `core/theme/` tokenları kullanılmalıdır.
- Boyutlar ve aralıklar için `core/utils/` veya ortak sabitler tercih edilmelidir.
- Tüm metinler `AppLocalizations` / `intl` sistemiyle çok dilli (TR / EN / AR vb.) olarak sunulmalıdır.

---

## 🧩 5. Widget Tasarım Kuralları

- **Metot Yerine Sınıf:** Widget ağacında `Widget _buildHeader()` şeklinde metotla widget üretmek yerine, ayrı bir `StatelessWidget` sınıfı oluşturun.
  - *Neden:* Sınıflar Flutter framework tarafından optimize edilebilir, `const` constructor alabilir ve gereksiz yeniden çizimleri engeller.
- **Tek Sorumluluk:** Bir widget 100 satırı aşıyorsa mantıksal alt bileşenlere ayrılmalıdır.
