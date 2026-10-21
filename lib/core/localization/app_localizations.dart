import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'app_language.dart';

/// GHARAR Multi-Language Localization Engine
/// Supports English 🇬🇧, Türkçe 🇹🇷, العربية 🇸🇦, فارسی 🇮🇷, Deutsch 🇩🇪, Español 🇪🇸, Français 🇫🇷, Italiano 🇮🇹
/// Preserves warmth, emotional nuance, and romantic intimacy across all cultures and scripts (LTR & RTL).
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  bool get isRtl => locale.languageCode == 'ar' || locale.languageCode == 'fa';
  bool get isTurkish => locale.languageCode == 'tr';
  bool get isArabic => locale.languageCode == 'ar';
  bool get isFarsi => locale.languageCode == 'fa';
  bool get isGerman => locale.languageCode == 'de';
  bool get isSpanish => locale.languageCode == 'es';
  bool get isFrench => locale.languageCode == 'fr';
  bool get isItalian => locale.languageCode == 'it';

  TextDirection get textDirection =>
      isRtl ? TextDirection.rtl : TextDirection.ltr;

  static final Map<String, Map<String, String>> _localizedValues = {
    // ==========================================
    // 🇬🇧 ENGLISH
    // ==========================================
    'en': {
      'appName': 'GHARAR',
      'appTagline': 'A Sanctuary for Two',
      'welcomeBack': 'Welcome back',
      'save': 'Save',
      'cancel': 'Cancel',
      'close': 'Close',
      'streakDays': 'Days Connection Streak',
      'streakTitle': 'Connection Streak',
      'partner': 'Partner',
      'you': 'You',

      // Navigation

      // Onboarding
      'enterYourName': 'Enter your first name',
      'relationshipStage': 'Where is your relationship right now?',
      'stageDating': 'Dating & Exploring',
      'stageEngaged': 'Engaged & Planning',
      'stageNewlywed': 'Newlyweds (1st Years)',
      'stageLongTerm': 'Long-term Partners',
      'stageMarriedWithKids': 'Married with Children',
      'stageLongDistance': 'Long Distance Lovers',
      'goalDeeperConversations': 'Deeper Conversations',
      'goalSpontaneousRomance': 'Spontaneous Romance',
      'goalUnderstandingNeeds': 'Understanding Emotional Needs',
      'goalFuturePlanning': 'Aligning on Future Dreams',
      'goalFunAdventures': 'Playful Fun & Adventures',
      'goalConflictResolution': 'Gentle Conflict Resolution',

      // Partner Invite

      // Home Dashboard
      'daysUntil': 'days left',

      // Daily Question

      // Discover & Quizzes

      // Couple Activities

      // Memories & Journal

      // AI Relationship Companion "Noor"
      'noorTitle': 'Noor • Relationship Companion',

      // Profile & Settings
      'unlinkPartner': 'Unlink Partner',

      // Authentication & Apple ID
      'signInWithApple': 'Sign in with Apple',
      'emailHint': 'name@example.com',
      'passwordHint': 'Password (min. 6 characters)',
      'authContinue': 'Enter Sanctuary ➔',
      'signInTab': 'Sign In',
      'registerTab': 'New Account',
      'authAccountInfo': 'Connected Account',
      'signOutBtn': 'Sign Out',
      'signOutConfirm': 'Are you sure you want to sign out?',
      'emailRequired': 'Please enter your email address',
      'nameRequired': 'Please enter your name',
      'passwordRequired': 'Password must be at least 6 characters',
      'invalidEmail': 'Please enter a valid email address',
      'loginTitle': 'Login',
      'registerTitle': 'Create Account',
      'continueWithGoogle': 'Continue with Google',
      'continueAsGuest': 'Continue As Guest',
      'forgotPassword': 'Forgot Password?',
      'needAccount': 'Need an account? ',
      'alreadyHaveAccount': 'Already have an account? ',
      'or': 'or',
    },

    // ==========================================
    // 🇹🇷 TURKISH
    // ==========================================
    'tr': {
      'appName': 'GHARAR',
      'appTagline': 'İki Kalbin Sığınağı',
      'welcomeBack': 'Tekrar hoş geldiniz',
      'save': 'Kaydet',
      'cancel': 'İptal',
      'close': 'Kapat',
      'streakDays': 'Günlük Bağlılık Serisi',
      'streakTitle': 'Bağlantı Serisi',
      'partner': 'Partner',
      'you': 'Sen',

      // Navigation

      // Onboarding
      'enterYourName': 'İsminizi girin',
      'relationshipStage': 'İlişkiniz şu an hangi evrede?',
      'stageDating': 'Flört & Birbirini Tanıma',
      'stageEngaged': 'Nişanlı & Evlilik Hazırlığı',
      'stageNewlywed': 'Yeni Evli (İlk Yıllar)',
      'stageLongTerm': 'Uzun Süreli Birliktelik',
      'stageMarriedWithKids': 'Çocuklu Evli Çift',
      'stageLongDistance': 'Uzak Mesafe İlişkisi',
      'goalDeeperConversations': 'Daha Derin Sohbetler',
      'goalSpontaneousRomance': 'Kendiliğinden Gelişen Romantizm',
      'goalUnderstandingNeeds': 'Duygusal İhtiyaçları Anlamak',
      'goalFuturePlanning': 'Gelecek Hayallerinde Uyum',
      'goalFunAdventures': 'Eğlenceli Maceralar & Oyunlar',
      'goalConflictResolution': 'Şefkatli İletişim & Çözüm',

      // Partner Invite

      // Home Dashboard
      'daysUntil': 'gün kaldı',

      // Daily Question

      // Discover & Quizzes

      // Couple Activities

      // Memories & Journal

      // AI Relationship Companion "Noor"
      'noorTitle': 'Noor • İlişki Yoldaşı',

      // Profile & Settings
      'unlinkPartner': 'Partner Bağını Kopar',

      // Authentication & Apple ID
      'signInWithApple': 'Apple ile Giriş Yap',
      'emailHint': 'ornek@eposta.com',
      'passwordHint': 'Şifre (en az 6 karakter)',
      'authContinue': 'Sığınağa Adım At ➔',
      'signInTab': 'Giriş Yap',
      'registerTab': 'Yeni Hesap',
      'authAccountInfo': 'Bağlı Hesap',
      'signOutBtn': 'Hesaptan Çıkış Yap',
      'signOutConfirm': 'Hesaptan çıkış yapmak istediğinizden emin misiniz?',
      'emailRequired': 'Lütfen e-posta adresinizi girin',
      'nameRequired': 'Lütfen adınızı girin',
      'passwordRequired': 'Şifre en az 6 karakter olmalıdır',
      'invalidEmail': 'Lütfen geçerli bir e-posta adresi girin',
      'loginTitle': 'Giriş Yap',
      'registerTitle': 'Hesap Oluştur',
      'continueWithGoogle': 'Google ile Devam Et',
      'continueAsGuest': 'Misafir Olarak Devam Et',
      'forgotPassword': 'Şifrenizi mi unuttunuz?',
      'needAccount': 'Hesabınız yok mu? ',
      'alreadyHaveAccount': 'Zaten bir hesabınız var mı? ',
      'or': 'veya',
    },

    // ==========================================
    // 🇸🇦 ARABIC (العربية - RTL)
    // ==========================================
    'ar': {
      'appName': 'قرار',
      'appTagline': 'ملاذ لقلبين',
      'welcomeBack': 'أهلاً بكم من جديد',
      'save': 'حفظ',
      'cancel': 'إلغاء',
      'close': 'إغلاق',
      'streakDays': 'أيام التواصل المستمر',
      'streakTitle': 'سلسلة التقارب',
      'partner': 'الشريك',
      'you': 'أنت',

      // Navigation

      // Onboarding
      'enterYourName': 'أدخل اسمك الأول',
      'relationshipStage': 'ما هي مرحلة علاقتكما الآن؟',
      'stageDating': 'تعارف واستكشاف',
      'stageEngaged': 'مخطوبان وتخطيط للزواج',
      'stageNewlywed': 'حديثا الزواج (السنوات الأولى)',
      'stageLongTerm': 'شريكان منذ سنوات',
      'stageMarriedWithKids': 'متزوجان مع أطفال',
      'stageLongDistance': 'حب عبر المسافات',
      'goalDeeperConversations': 'محادثات أكثر عمقاً',
      'goalSpontaneousRomance': 'رومانسية عفوية',
      'goalUnderstandingNeeds': 'فهم الاحتياجات العاطفية',
      'goalFuturePlanning': 'تناغم في أحلام المستقبل',
      'goalFunAdventures': 'مرح ومغامرات مشتركة',
      'goalConflictResolution': 'تواصل لطيف وحل الخلافات',

      // Partner Invite

      // Home Dashboard
      'daysUntil': 'أيام متبقية',

      // Daily Question

      // Discover & Quizzes

      // Couple Activities

      // Memories & Journal

      // AI Relationship Companion "Noor"
      'noorTitle': 'نور • رفيق العلاقات',

      // Profile & Settings
      'unlinkPartner': 'فصل ارتباط الشريك',

      // Authentication & Apple ID
      'signInWithApple': 'تسجيل الدخول باستخدام Apple',
      'emailHint': 'name@example.com',
      'passwordHint': 'كلمة المرور (6 أحرف على الأقل)',
      'authContinue': 'الدخول إلى الملاذ ➔',
      'signInTab': 'تسجيل الدخول',
      'registerTab': 'حساب جديد',
      'authAccountInfo': 'الحساب المتصل',
      'signOutBtn': 'تسجيل الخروج',
      'signOutConfirm': 'هل أنت متأكد أنك تريد تسجيل الخروج؟',
      'emailRequired': 'يرجى إدخال عنوان البريد الإلكتروني',
      'nameRequired': 'يرجى إدخال اسمك',
      'passwordRequired': 'يجب أن تتكون كلمة المرور من 6 أحرف على الأقل',
      'invalidEmail': 'يرجى إدخال بريد إلكتروني صالح',
    },

    // ==========================================
    // 🇮🇷 FARSI / PERSIAN (فارسی - RTL)
    // ==========================================
    'fa': {
      'appName': 'قرار',
      'appTagline': 'پناهگاه دو قلب',
      'welcomeBack': 'خوش آمدید',
      'save': 'ذخیره',
      'cancel': 'انصراف',
      'close': 'بستن',
      'streakDays': 'روز زنجیره پیوند قلبی',
      'streakTitle': 'زنجیره همبستگی',
      'partner': 'یار',
      'you': 'تو',

      // Navigation

      // Onboarding
      'enterYourName': 'نام خود را وارد کنید',
      'relationshipStage': 'رابطه شما هم‌اکنون در چه مرحله‌ای است؟',
      'stageDating': 'آشنایی و دلدادگی',
      'stageEngaged': 'نامزدی و پیوند مهر',
      'stageNewlywed': 'نوپا در زندگی مشترک (سال‌های نخست)',
      'stageLongTerm': 'همسفران دیرین',
      'stageMarriedWithKids': 'همراهان زندگی با فرزند',
      'stageLongDistance': 'عشق در امتداد فاصله‌ها',
      'goalDeeperConversations': 'گفت‌وگوهای عمیق و دلنشین',
      'goalSpontaneousRomance': 'عاشقانه‌های بی‌بهانه و خودجوش',
      'goalUnderstandingNeeds': 'درک نیازهای عاطفی یکدیگر',
      'goalFuturePlanning': 'هم‌نوایی در آرزوهای آینده',
      'goalFunAdventures': 'شادی، بازی و ماجراهای مشترک',
      'goalConflictResolution': 'گفت‌وگوی آرام و حل مهربانانه دلخوری‌ها',

      // Partner Invite

      // Home Dashboard
      'daysUntil': 'روز باقی‌مانده',

      // Daily Question

      // Discover & Quizzes

      // Couple Activities

      // Memories & Journal

      // AI Relationship Companion "Noor"
      'noorTitle': 'نور • همدم روابط عاشقانه',

      // Profile & Settings
      'unlinkPartner': 'جداسازی پیوند یار',

      // Authentication & Apple ID
      'signInWithApple': 'ورود با اپل آیدی',
      'emailHint': 'name@example.com',
      'passwordHint': 'رمز عبور (حداقل ۶ کاراکتر)',
      'authContinue': 'ورود به پناهگاه ➔',
      'signInTab': 'ورود',
      'registerTab': 'حساب جدید',
      'authAccountInfo': 'حساب متصل',
      'signOutBtn': 'خروج از حساب',
      'signOutConfirm': 'آیا مطمئن هستید که می‌خواهید از حساب خود خارج شوید؟',
      'emailRequired': 'لطفاً آدرس ایمیل خود را وارد کنید',
      'nameRequired': 'لطفاً نام خود را وارد کنید',
      'passwordRequired': 'رمز عبور باید حداقل ۶ نویسه باشد',
      'invalidEmail': 'لطفاً یک آدرس ایمیل معتبر وارد کنید',
    },

    // ==========================================
    // 🇩🇪 GERMAN (Deutsch)
    // ==========================================
    'de': {
      'appName': 'GHARAR',
      'appTagline': 'Ein Zufluchtsort für Zwei',
      'welcomeBack': 'Willkommen zurück',
      'save': 'Speichern',
      'cancel': 'Abbrechen',
      'close': 'Schließen',
      'streakDays': 'Tage Liebes-Serie',
      'streakTitle': 'Verbindungs-Serie',
      'partner': 'Partner',
      'you': 'Du',

      // Navigation

      // Onboarding
      'enterYourName': 'Gib deinen Vornamen ein',
      'relationshipStage': 'Wo steht eure Beziehung gerade?',
      'stageDating': 'Dating & Kennenlernen',
      'stageEngaged': 'Verlobt & Hochzeitsplanung',
      'stageNewlywed': 'Frisch verheiratet (Erste Jahre)',
      'stageLongTerm': 'Langzeit-Partner',
      'stageMarriedWithKids': 'Verheiratet mit Kindern',
      'stageLongDistance': 'Fernbeziehung',
      'goalDeeperConversations': 'Tiefere Gespräche',
      'goalSpontaneousRomance': 'Spontane Romantik',
      'goalUnderstandingNeeds': 'Emotionale Bedürfnisse verstehen',
      'goalFuturePlanning': 'Zukunftsträume in Einklang bringen',
      'goalFunAdventures': 'Spielerischer Spaß & Abenteuer',
      'goalConflictResolution': 'Sanfte Konfliktlösung',

      // Partner Invite

      // Home Dashboard
      'daysUntil': 'Tage verbleibend',

      // Daily Question

      // Discover & Quizzes

      // Couple Activities

      // Memories & Journal

      // AI Relationship Companion "Noor"
      'noorTitle': 'Noor • Beziehungsbegleiter',

      // Profile & Settings
      'unlinkPartner': 'Partner-Verbindung trennen',

      // Authentication & Apple ID
      'signInWithApple': 'Mit Apple anmelden',
      'emailHint': 'name@beispiel.de',
      'passwordHint': 'Passwort (mind. 6 Zeichen)',
      'authContinue': 'Zufluchtsort betreten ➔',
      'signInTab': 'Anmelden',
      'registerTab': 'Neues Konto',
      'authAccountInfo': 'Verbundenes Konto',
      'signOutBtn': 'Abmelden',
      'signOutConfirm': 'Möchtest du dich wirklich abmelden?',
      'emailRequired': 'Bitte gib deine E-Mail-Adresse ein',
      'nameRequired': 'Bitte gib deinen Namen ein',
      'passwordRequired': 'Passwort muss mindestens 6 Zeichen lang sein',
      'invalidEmail': 'Bitte gib eine gültige E-Mail-Adresse ein',
    },

    // ==========================================
    // 🇪🇸 SPANISH (Español)
    // ==========================================
    'es': {
      'appName': 'GHARAR',
      'appTagline': 'Un Santuario para Dos',
      'welcomeBack': 'Bienvenidos de nuevo',
      'save': 'Guardar',
      'cancel': 'Cancelar',
      'close': 'Cerrar',
      'streakDays': 'Días de Racha de Conexión',
      'streakTitle': 'Racha de Unión',
      'partner': 'Pareja',
      'you': 'Tú',

      // Navigation

      // Onboarding
      'enterYourName': 'Ingresa tu nombre',
      'relationshipStage': '¿En qué etapa está su relación hoy?',
      'stageDating': 'Saliendo & Conociéndonos',
      'stageEngaged': 'Comprometidos & Planeando boda',
      'stageNewlywed': 'Recién Casados (Primeros años)',
      'stageLongTerm': 'Pareja de largo camino',
      'stageMarriedWithKids': 'Casados con hijos',
      'stageLongDistance': 'Amor a distancia',
      'goalDeeperConversations': 'Conversaciones más profundas',
      'goalSpontaneousRomance': 'Romance espontáneo',
      'goalUnderstandingNeeds': 'Entender necesidades emocionales',
      'goalFuturePlanning': 'Alinear sueños del futuro',
      'goalFunAdventures': 'Aventuras divertidas y juegos',
      'goalConflictResolution': 'Resolución serena de conflictos',

      // Partner Invite

      // Home Dashboard
      'daysUntil': 'días restantes',

      // Daily Question

      // Discover & Quizzes

      // Couple Activities

      // Memories & Journal

      // AI Relationship Companion "Noor"
      'noorTitle': 'Noor • Acompañante de Pareja',

      // Profile & Settings
      'unlinkPartner': 'Desvincular Pareja',

      // Authentication & Apple ID
      'signInWithApple': 'Iniciar sesión con Apple',
      'emailHint': 'nombre@ejemplo.com',
      'passwordHint': 'Contraseña (mín. 6 caracteres)',
      'authContinue': 'Entrar al Santuario ➔',
      'signInTab': 'Iniciar sesión',
      'registerTab': 'Nueva cuenta',
      'authAccountInfo': 'Cuenta conectada',
      'signOutBtn': 'Cerrar sesión',
      'signOutConfirm': '¿Estás seguro de que deseas cerrar sesión?',
      'emailRequired': 'Por favor ingresa tu correo electrónico',
      'nameRequired': 'Por favor ingresa tu nombre',
      'passwordRequired': 'La contraseña debe tener al menos 6 caracteres',
      'invalidEmail': 'Por favor ingresa un correo válido',
    },

    // ==========================================
    // 🇫🇷 FRENCH (Français)
    // ==========================================
    'fr': {
      'appName': 'GHARAR',
      'appTagline': 'Un Sanctuaire pour Deux',
      'welcomeBack': 'Bon retour parmi nous',
      'save': 'Enregistrer',
      'cancel': 'Annuler',
      'close': 'Fermer',
      'streakDays': 'Jours de Série Amoureuse',
      'streakTitle': 'Série de Connexion',
      'partner': 'Partenaire',
      'you': 'Toi',

      // Navigation

      // Onboarding
      'enterYourName': 'Saisis ton prénom',
      'relationshipStage': 'Où en est votre relation aujourd’hui ?',
      'stageDating': 'Rencontre & Découverte',
      'stageEngaged': 'Fiancés & Préparation du mariage',
      'stageNewlywed': 'Jeunes Mariés (Premières années)',
      'stageLongTerm': 'Partenaires de longue date',
      'stageMarriedWithKids': 'Mariés avec enfants',
      'stageLongDistance': 'Amour à distance',
      'goalDeeperConversations': 'Conversations plus profondes',
      'goalSpontaneousRomance': 'Romantisme spontané',
      'goalUnderstandingNeeds': 'Comprendre les besoins émotionnels',
      'goalFuturePlanning': 'Harmoniser nos rêves d’avenir',
      'goalFunAdventures': 'Jeux complices & aventures',
      'goalConflictResolution': 'Communication douce & apaisement',

      // Partner Invite

      // Home Dashboard
      'daysUntil': 'jours restants',

      // Daily Question

      // Discover & Quizzes

      // Couple Activities

      // Memories & Journal

      // AI Relationship Companion "Noor"
      'noorTitle': 'Noor • Compagnon de Relation',

      // Profile & Settings
      'unlinkPartner': 'Dissocier le Partenaire',

      // Authentication & Apple ID
      'signInWithApple': 'Continuer avec Apple',
      'emailHint': 'prenom@exemple.com',
      'passwordHint': 'Mot de passe (min. 6 caractères)',
      'authContinue': 'Entrer dans le Sanctuaire ➔',
      'signInTab': 'Connexion',
      'registerTab': 'Nouveau compte',
      'authAccountInfo': 'Compte connecté',
      'signOutBtn': 'Se déconnecter',
      'signOutConfirm': 'Voulez-vous vraiment vous déconnecter ?',
      'emailRequired': 'Veuillez saisir votre adresse e-mail',
      'nameRequired': 'Veuillez saisir votre nom',
      'passwordRequired':
          'Le mot de passe doit comporter au moins 6 caractères',
      'invalidEmail': 'Veuillez saisir une adresse e-mail valide',
    },

    // ==========================================
    // 🇮🇹 ITALIAN (Italiano)
    // ==========================================
    'it': {
      'appName': 'GHARAR',
      'appTagline': 'Un Santuario per Due',
      'welcomeBack': 'Bentornati',
      'save': 'Salva',
      'cancel': 'Annulla',
      'close': 'Chiudi',
      'streakDays': 'Giorni di Intesa Continua',
      'streakTitle': 'Sequenza d’Amore',
      'partner': 'Partner',
      'you': 'Tu',

      // Navigation

      // Onboarding
      'enterYourName': 'Inserisci il tuo nome',
      'relationshipStage': 'A quale punto è la vostra storia?',
      'stageDating': 'Frequentazione & Conoscenza',
      'stageEngaged': 'Fidanzati & Progetti di nozze',
      'stageNewlywed': 'Sposi Novelli (Primi anni)',
      'stageLongTerm': 'Compagni di lunga data',
      'stageMarriedWithKids': 'Sposati con figli',
      'stageLongDistance': 'Amore a distanza',
      'goalDeeperConversations': 'Conversazioni più profonde',
      'goalSpontaneousRomance': 'Romanticismo spontaneo',
      'goalUnderstandingNeeds': 'Comprendere i bisogni del cuore',
      'goalFuturePlanning': 'Armonizzare i sogni del futuro',
      'goalFunAdventures': 'Giochi complici & avventure',
      'goalConflictResolution': 'Dialogo gentile e riconciliazione',

      // Partner Invite

      // Home Dashboard
      'daysUntil': 'giorni rimasti',

      // Daily Question

      // Discover & Quizzes

      // Couple Activities

      // Memories & Journal

      // AI Relationship Companion "Noor"
      'noorTitle': 'Noor • Guida di Coppia',

      // Profile & Settings
      'unlinkPartner': 'Scollega Partner',

      // Authentication & Apple ID
      'signInWithApple': 'Accedi con Apple',
      'emailHint': 'nome@esempio.it',
      'passwordHint': 'Password (almeno 6 caratteri)',
      'authContinue': 'Entra nel Santuario ➔',
      'signInTab': 'Accedi',
      'registerTab': 'Nuovo account',
      'authAccountInfo': 'Account connesso',
      'signOutBtn': 'Disconnetti',
      'signOutConfirm': 'Sei sicuro di voler uscire?',
      'emailRequired': 'Inserisci il tuo indirizzo e-mail',
      'nameRequired': 'Inserisci il tuo nome',
      'passwordRequired': 'La password deve contenere almeno 6 caratteri',
      'invalidEmail': 'Inserisci un indirizzo e-mail valido',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }

  String t(String key) => translate(key);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLanguage.supportedLanguages.any((l) => l.code == locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
