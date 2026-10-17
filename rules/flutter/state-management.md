# ⚡ Flutter Durum Yönetimi Kuralları (State Management Rules)

Bu doküman, **GHARAR** projesinde `Provider` ve `ChangeNotifier` tabanlı durum yönetimi mimarisini, yeniden çizim (rebuild) optimizasyonunu ve bellek güvenliğini standartlaştırır.

---

## 🏛️ 1. Mimari Hiyerarşi ve Sorumluluklar

Uygulamada tek yönlü veri akışı (Unidirectional Data Flow) esastır:

```
[UI Widgets] ──(Dispatches Action)──> [AppStateProvider / Providers]
      ▲                                         │
      │                                    (Calls API/DB)
      │                                         ▼
(Rebuilds Granularly) <──(Notifies State)── [Services]
```

- **UI Katmanı:** Yalnızca veri gösterir ve kullanıcı olaylarını (tıklama, form girişi) provider'a iletir. Servisleri doğrudan çağırmaz.
- **Provider Katmanı:** İş mantığını barındırır, durum geçişlerini yönetir ve `notifyListeners()` ile dinleyicileri uyarır.
- **Service Katmanı:** Saf veri kaynakları, yerel depolama ve harici API'ler ile konuşur; UI veya durum tutmaz.

---

## 🎯 2. Granular Rebuild İlkeleri (Performans Kuralları)

Gereksiz widget rebuild'lerini önlemek uygulamanın akıcılığı ve batarya performansı için kritiktir:

### 2.1. `context.watch<T>()` Yasağı (Geniş Kapsamda)
- Widget'ın `build` metodunun başında tüm provider'ı dinlemekten kaçının:
  ```dart
  // ❌ YANLIŞ: Tüm ekran her provider güncellemesinde yeniden çizilir
  final provider = context.watch<AppStateProvider>();
  ```

### 2.2. `context.select<T, R>()` Kullanımı
- Yalnızca ilgili alanı seçerek dinleyin:
  ```dart
  // ✅ DOĞRU: Sadece userName değiştiğinde bu widget yeniden çizilir
  final userName = context.select<AppStateProvider, String>((p) => p.currentUser.name);
  ```

### 2.3. Odaklanmış `Consumer<T>` veya `Selector<T, R>`
- Ağacın yalnızca değişen küçük bir bölümünü rebuild etmek için `Consumer` veya `Selector` kullanın:
  ```dart
  // ✅ DOĞRU: Scaffold değil, yalnızca sayaç metni yeniden çizilir
  Selector<AppStateProvider, int>(
    selector: (_, provider) => provider.unreadCount,
    builder: (context, unreadCount, child) {
      return Badge(label: Text('$unreadCount'));
    },
  )
  ```

### 2.4. `context.read<T>()` Kuralları
- `context.read<T>()` **asla** `build()` metodu içinde çağrılmamalıdır (rebuild tetiklemez).
- Yalnızca buton `onPressed`, callback veya fonksiyon gövdelerinde event tetiklemek için kullanılmalıdır:
  ```dart
  // ✅ DOĞRU: Callback içinde eylem çağırma
  ElevatedButton(
    onPressed: () => context.read<AppStateProvider>().submitAnswer(answer),
    child: const Text('Gönder'),
  )
  ```

---

## 🧹 3. Bellek Sızıntısı (Memory Leak) Önleme

Her controller ve subscription nesnesi yaşam döngüsü bittiğinde imha edilmelidir:

- `TextEditingController`
- `ScrollController`
- `AnimationController`
- `StreamSubscription`
- `Timer`

```dart
class _MyWidgetState extends State<MyWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose(); // Zorunlu temizlik
    super.dispose();
  }
}
```

---

## 🚦 4. Asenkron Durum Yönetimi (Async States)

Durum sağlayıcılarında asenkron işlemler yürütülürken durum net olarak yönetilmelidir:

1. **`isLoading` / `isSubmitting`:** Asenkron işlem başladığında `true`, bittiğinde `false` olmalı ve `notifyListeners()` çağrılmalıdır.
2. **Hata Yönetimi (`errorMessage`):** İstisnalar yakalanmalı, anlamlı bir hata mesajına dönüştürülmeli ve UI'a yansıtılmalıdır. Asla `catch (e) {}` şeklinde boş bırakılmamalıdır.
3. **Mounted Kontrolü:** Asenkron işlem tamamlandıktan sonra context kullanılıyorsa `if (!context.mounted) return;` kontrolü zorunludur.
