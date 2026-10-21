# GHARAR — Claude Code Talimatları

Proje anayasası `AGENTS.md` dosyasındadır ve her oturumda geçerlidir:

@AGENTS.md

## Claude Code Kurulumu (ECC uyarlaması)

Bu proje, [ECC](https://github.com/affaan-m/ECC) mimarisinin Flutter/Dart parçalarından uyarlanmış yerel bir kurulum kullanır. ECC plugin'i kurulu değildir; gerekli her şey repo içindedir.

| Konum | İçerik |
| :--- | :--- |
| `.claude/agents/` | AGENTS.md §2'deki 6 uzman rol (subagent) |
| `.claude/skills/` | `/tdd`, `/flutter-test`, `/flutter-build`, `/flutter-review`, `/verify` iş akışları |
| `.claude/hooks/` | `.dart` düzenlemesi sonrası otomatik `dart format` + log/sır hijyeni kontrolü |
| `rules/` | Ayrıntılı kod kuralları (dart, flutter, common) |
| `.agents/skills/` | Gemini Antigravity ile ortak kullanılan derin rehberler |
| `hooks/pre-commit` | `core.hooksPath=hooks` ile aktif: `flutter analyze` + `flutter test` |

## Çalışma Kuralları

- Kod yazmadan önce ilgili kural dosyasını oku: Dart kodu → `rules/dart/coding-style.md`, state → `rules/flutter/state-management.md`, test → `rules/common/testing.md`, hassas veri → `rules/dart/security.md`.
- Yeni özellik / hata düzeltme: TDD döngüsü (`/tdd`). Önce `test/` altında kırmızı test, sonra `lib/`.
- İş bitince `/verify` çalıştır: `dart format`, `flutter analyze --fatal-infos`, `flutter test --coverage`. CI (`.github/workflows/ci.yml`) aynı kontrolleri yapar.
- Ajan kullanımı: kullanıcı istemedikçe subagent başlatma; rollerin kontrol listelerini kendin uygula. Kullanıcı "review", "güvenlik denetimi" vb. isterse ilgili ajanı çağır.
- Kullanıcıya Türkçe yanıt ver; kod, tanımlayıcılar ve commit mesajları İngilizce (Conventional Commits).

## Projeye Özgü Gerçekler

- State: tek `ChangeNotifierProvider<AppStateProvider>` (`lib/providers/app_state_provider.dart`), `main.dart` içinde `StorageService` ile oluşturulur.
- Kalıcılık: `StorageService` (`shared_preferences`, JSON string). Günlük/duygu/not gibi hassas veriler şu an düz metin — yeni hassas alan eklerken `rules/dart/security.md` §3'e bak.
- Tema token'ları: `AppColors`, `AppTextStyles`, `AppTheme` (`lib/core/theme/`). Responsive: `lib/core/utils/responsive_utils.dart`.
- Yerelleştirme: elle yazılmış `AppLocalizations` (`lib/core/localization/app_localizations.dart`, `AppLocalizations.of(context)`); diller `AppLanguage` enum'ında. Yeni metin eklerken tüm dillere çeviri ekle.
- Flutter 3.29.0 / Dart ^3.7 (Windows geliştirme ortamı).
