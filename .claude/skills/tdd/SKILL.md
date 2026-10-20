---
name: tdd
description: GHARAR'da yeni özellik veya hata düzeltmeyi Red-Green-Refactor TDD döngüsüyle uygular. Önce test/ altında başarısız test, sonra lib/ altında minimum kod, ardından refactor ve doğrulama. Kullanım - /tdd <özellik veya hata açıklaması>
---

# /tdd — Test-First Geliştirme

Görev: $ARGUMENTS

1. Oku: `rules/common/testing.md`, `.agents/skills/flutter-tdd-workflow.md`; UI işiyse `.agents/skills/widget-testing-loop.md` ve `.agents/skills/ui-to-code-generation.md`.
2. 2'den fazla dosyaya dokunacaksa ya da mimari karar gerekiyorsa önce kısa bir plan sun (AGENTS.md §1.4). Gerekirse `flutter-architect` rehberini uygula.
3. **RED** — `lib/` yapısını yansıtan test dosyasını yaz. `flutter test <dosya>` çalıştır, başarısız olduğunu göster.
4. **GREEN** — Testi geçiren en sade kodu yaz. Tekrar çalıştır, yeşil olduğunu göster.
5. **REFACTOR** — `const`/`final`, widget'ı sınıfa çıkarma, tema token'ları, `AppLocalizations`. Testler yeşil kalmalı.
6. **VERIFY** — `/verify` adımlarını uygula.

Kullanıcıya her aşamanın kanıtını (komut + kısa sonuç) raporla. Kırmızıyı görmeden üretim koduna geçme.
