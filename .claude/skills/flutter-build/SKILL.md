---
name: flutter-build
description: GHARAR'da flutter analyze, pub get ve Android/web build hatalarını dart-build-resolver kurallarıyla minimum değişiklikle düzeltir. Kullanım - /flutter-build [apk|web|analyze]
---

# /flutter-build

Hedef: $ARGUMENTS (boşsa `analyze`)

`.claude/agents/dart-build-resolver.md` içindeki kuralları uygula (cerrahi düzeltme, onaysız `// ignore:` yok, `dynamic` ile susturma yok, paket yükseltmeden önce sor).

1. `flutter pub get`
2. `flutter analyze --fatal-infos` — CI ile aynı seviye.
3. Hedef `apk` ise `flutter build apk --debug`; `web` ise `flutter build web`.
4. Hataları dosyaya göre grupla, tek tek düzelt, her düzeltmeden sonra yeniden analiz et.
5. 0 issue olunca `flutter test` ile regresyon kontrolü.
6. Aynı hata 3 denemede çözülmezse dur ve raporla.

Rapor: `Build Status: SUCCESS/FAILED | Fixed: N | Files: ...`
