---
name: flutter-review
description: GHARAR değişikliklerini (git diff) flutter-reviewer kontrol listesiyle inceler - mimari katman ihlalleri, Provider rebuild, dispose, const, tema token, yerelleştirme, a11y ve güvenlik. Kullanım - /flutter-review [dosya/dizin veya commit aralığı]
---

# /flutter-review

Kapsam: $ARGUMENTS (boşsa staged + unstaged değişiklikler)

`flutter-reviewer` ajanını bu kapsamla başlat ve raporunu kullanıcıya ilet. Ajan şunları yapar:
1. Değişen `.dart` dosyalarını belirler ve tamamen okur.
2. `.claude/agents/flutter-reviewer.md` kontrol listesini uygular.
3. `flutter analyze` sonucunu ekler.
4. CRITICAL güvenlik bulgusu varsa `security-reviewer` ajanının da çalıştırılmasını önerir.

Rapordan sonra kullanıcıya hangi bulguları düzeltmek istediğini sor; onay olmadan düzeltme yapma.
