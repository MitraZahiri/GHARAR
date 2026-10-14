/// GHARAR Multi-Language Localization Engine
/// Represents a supported language with native display names, flags, and text direction.
class AppLanguage {
  final String code;
  final String name;
  final String nativeName;
  final String flag;
  final bool isRtl;
  final String tagline;

  const AppLanguage({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flag,
    this.isRtl = false,
    required this.tagline,
  });

  static const List<AppLanguage> supportedLanguages = [
    AppLanguage(
      code: 'en',
      name: 'English',
      nativeName: 'English',
      flag: '🇬🇧',
      isRtl: false,
      tagline: 'A Sanctuary for Two',
    ),
    AppLanguage(
      code: 'tr',
      name: 'Turkish',
      nativeName: 'Türkçe',
      flag: '🇹🇷',
      isRtl: false,
      tagline: 'İki Kalbin Sığınağı',
    ),
    AppLanguage(
      code: 'ar',
      name: 'Arabic',
      nativeName: 'العربية',
      flag: '🇸🇦',
      isRtl: true,
      tagline: 'ملاذ لقلبين',
    ),
    AppLanguage(
      code: 'fa',
      name: 'Persian',
      nativeName: 'فارسی',
      flag: '🇮🇷',
      isRtl: true,
      tagline: 'پناهگاه دو قلب',
    ),
    AppLanguage(
      code: 'de',
      name: 'German',
      nativeName: 'Deutsch',
      flag: '🇩🇪',
      isRtl: false,
      tagline: 'Ein Zufluchtsort für Zwei',
    ),
    AppLanguage(
      code: 'es',
      name: 'Spanish',
      nativeName: 'Español',
      flag: '🇪🇸',
      isRtl: false,
      tagline: 'Un Santuario para Dos',
    ),
    AppLanguage(
      code: 'fr',
      name: 'French',
      nativeName: 'Français',
      flag: '🇫🇷',
      isRtl: false,
      tagline: 'Un Sanctuaire pour Deux',
    ),
    AppLanguage(
      code: 'it',
      name: 'Italian',
      nativeName: 'Italiano',
      flag: '🇮🇹',
      isRtl: false,
      tagline: 'Un Santuario per Due',
    ),
  ];

  static AppLanguage fromCode(String code) {
    return supportedLanguages.firstWhere(
      (l) => l.code == code,
      orElse: () => supportedLanguages.first,
    );
  }
}
