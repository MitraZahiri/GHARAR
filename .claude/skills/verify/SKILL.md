---
name: verify
description: GHARAR kalite kapısı - CI ve pre-commit ile aynı kontrolleri (dart format, flutter analyze --fatal-infos, flutter test --coverage) ve AGENTS.md §5 güvenlik kontrol listesini çalıştırır. Bir iş bittiğinde veya commit öncesi kullan.
---

# /verify — Kalite Kapısı

Sırayla çalıştır, her adımın sonucunu kaydet:

1. `dart format --output=none --set-exit-if-changed lib test` — değişiklik varsa `dart format lib test` ile düzelt ve belirt.
2. `flutter analyze --fatal-infos` — 0 issue olmalı. Değilse `/flutter-build` kurallarıyla düzelt.
3. `flutter test --coverage` — tamamı yeşil olmalı.
4. Değişen dosyalar (`git diff --name-only HEAD`) için AGENTS.md §5 kontrolü:
   - `lib/` içinde yeni `print(`/`debugPrint(` yok
   - Hardcoded sır yok
   - Yeni model alanları `final`, `copyWith`/`==`/`hashCode`/JSON güncel
   - Yeni controller/subscription'lar `dispose()` ediliyor
   - Yeni `lib/` mantığının karşılık gelen testi var

## Rapor
```
| Kontrol            | Sonuç |
|--------------------|-------|
| dart format        | ✅/❌ |
| flutter analyze    | ✅ 0 issue / ❌ N |
| flutter test       | ✅ X/Y |
| Kapsam (m/s/p)     | %.. / %.. / %.. |
| Güvenlik checklist | ✅/⚠️ |
```
Hepsi ✅ ise commit'e hazır olduğunu söyle; commit'i kullanıcı istemedikçe atma.
