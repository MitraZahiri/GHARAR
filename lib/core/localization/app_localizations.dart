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
      'connectToday': 'Connect Today',
      'today': 'Today',
      'save': 'Save',
      'cancel': 'Cancel',
      'close': 'Close',
      'continueText': 'Continue',
      'getStarted': 'Begin Your Journey',
      'share': 'Share',
      'copy': 'Copy Code',
      'copied': 'Copied to clipboard!',
      'reveal': 'Reveal Answers',
      'completed': 'Completed',
      'saved': 'Saved',
      'edit': 'Edit',
      'delete': 'Delete',
      'skip': 'Skip Question',
      'submit': 'Submit Answer',
      'waitingPartner': 'Waiting for partner',
      'bothAnswered': 'Both of you answered!',
      'streakDays': 'Days Connection Streak',
      'streakTitle': 'Connection Streak',
      'streakEncourage': 'Your love is blooming!',
      'partner': 'Partner',
      'you': 'You',
      'premium': 'GHARAR Premium',
      'appLanguage': 'App Language',

      // Navigation
      'navHome': 'Home',
      'navDiscover': 'Discover',
      'navActivities': 'Activities',
      'navMemories': 'Memories',
      'navProfile': 'Profile',

      // Onboarding
      'onboarding1Title': 'A Sacred Space Just for the Two of You',
      'onboarding1Desc':
          'GHARAR is your private sanctuary to spark deep conversations, discover shared passions, and cherish every moment.',
      'onboarding2Title': 'Daily Questions, Answered Privately',
      'onboarding2Desc':
          'Each day brings a thoughtful question. Your answers remain hidden until both of you have answered, preserving authentic surprise!',
      'onboarding3Title': 'Romantic Adventures & Lifelong Growth',
      'onboarding3Desc':
          'Curated date ideas, playful quizzes, shared future dreams, and emotional intimacy exercises tailored to your unique love story.',
      'whatsYourName': 'What is your name?',
      'enterYourName': 'Enter your first name',
      'selectLanguage': 'Choose Your Preferred Language',
      'relationshipStage': 'Where is your relationship right now?',
      'stageDating': 'Dating & Exploring',
      'stageEngaged': 'Engaged & Planning',
      'stageNewlywed': 'Newlyweds (1st Years)',
      'stageLongTerm': 'Long-term Partners',
      'stageMarriedWithKids': 'Married with Children',
      'stageLongDistance': 'Long Distance Lovers',
      'selectGoals': 'What would you like to nurture most?',
      'goalDeeperConversations': 'Deeper Conversations',
      'goalSpontaneousRomance': 'Spontaneous Romance',
      'goalUnderstandingNeeds': 'Understanding Emotional Needs',
      'goalFuturePlanning': 'Aligning on Future Dreams',
      'goalFunAdventures': 'Playful Fun & Adventures',
      'goalConflictResolution': 'Gentle Conflict Resolution',

      // Partner Invite
      'invitePartnerTitle': 'Invite Your Special One',
      'invitePartnerSubtitle':
          'GHARAR is designed as a synchronized sanctuary for two. Share this invite code with your partner to link your hearts.',
      'yourInviteCode': 'Your Unique Couple Code',
      'enterPartnerCode': 'Or enter partner’s code to connect',
      'connectPartnerButton': 'Connect to Partner',
      'simulatedPartner': 'Simulate Partner (Demo Mode)',
      'simulatedPartnerDesc':
          'Toggle between partners or test mutual reveals instantly with 1-click!',

      // Home Dashboard
      'dailyGreetingMorning': 'Good morning, my dears',
      'dailyGreetingAfternoon': 'Good afternoon',
      'dailyGreetingEvening': 'Good evening, lovely souls',
      'dailyQuestionCardTitle': 'Daily Connection Question',
      'drawAnother': 'Draw Another',
      'weeklyChallengeTitle': 'This Week’s Couple Challenge',
      'sharedInterestTitle': 'Mutual Spark of the Day',
      'upcomingDateTitle': 'Upcoming Milestone',
      'daysUntil': 'days left',

      // Daily Question
      'intensityIcebreaker': 'Light & Playful 🌱',
      'intensityMeaningful': 'Heartfelt & Meaningful 🌿',
      'intensityDeep': 'Deep Soul Exploration 🌺',
      'yourAnswerHint':
          'Speak honestly from your heart... Your partner will only see this once they also submit their answer.',
      'privateAnswerNotice':
          '🔒 Strictly Private until mutual reveal. No peeking allowed!',
      'partnerAnsweredNotice':
          'has submitted their answer! Answer now to reveal together.',
      'partnerPendingNotice':
          'is taking their time to think. Answer yours now so you are ready!',
      'revealCelebration': 'Your Souls Have Spoken! ✨',
      'reflectTogetherPrompt':
          'Take a gentle breath and read each other’s thoughts aloud.',

      // Discover & Quizzes
      'discoverHubTitle': 'Discover & Align',
      'sharedInterestsTab': 'Shared Sparks',
      'quizGameTab': 'How Well Do We Know Us?',
      'differencesTab': 'Beautiful Differences',
      'futureAlignmentTab': 'Where Are We Heading?',
      'quizSubtitle':
          'Predict your partner’s thoughts and unlock playful, romantic insights.',
      'compatibilityScore': 'Soul Harmony',
      'planThisActivity': 'Plan this Date Together',
      'celebrateDifference':
          'Difference is where curiosity blooms. Here is a sweet way to blend both preferences:',

      // Couple Activities
      'activitiesTitle': 'Couple Experiences & Dates',
      'filterAll': 'All Ideas',
      'filterRomantic': 'Romantic',
      'filterAtHome': 'At Home',
      'filterOutdoor': 'Outdoor',
      'filterBudget': 'Budget Friendly',
      'filterCreative': 'Creative & Fun',
      'filterDuration': 'Time Needed',
      'surpriseMe': 'Romantic Surprise Generator 🎲',
      'markAsDone': 'Mark as Cherished & Done',
      'activitySaved': 'Saved to your Couple Bucket List',

      // Memories & Journal
      'memoriesTitle': 'Our Story & Journal',
      'timelineTab': 'Timeline Milestones',
      'journalTab': 'Private Couple Journal',
      'specialDatesTab': 'Special Dates & Anniversaries',
      'addEntry': 'Add Love Note / Memory',
      'newMilestone': 'New Milestone',
      'entryTitle': 'Memory Title',
      'entryReflection': 'Write what made this moment unforgettable...',

      // AI Relationship Companion "Noor"
      'noorTitle': 'Noor • Relationship Companion',
      'noorSubtitle':
          'A gentle, empathetic guide to inspire meaningful conversations, nonjudgmental reflections, and loving gestures.',
      'noorDisclaimer':
          'Noor provides inspiration and gentle communication tips. Not a substitute for professional couples therapy.',
      'noorPrompt1': 'Help me express my feelings gently',
      'noorPrompt2': 'Suggest a cozy at-home surprise for tonight',
      'noorPrompt3': 'Give us a thoughtful late-night conversation prompt',
      'noorPrompt4': 'How do we navigate different social energy levels?',
      'askNoorHint': 'Ask Noor for advice, ideas, or communication prompts...',

      // Profile & Settings
      'profileTitle': 'Couple Space & Settings',
      'switchPartner': 'Switch Active Partner View',
      'activeViewingAs': 'Currently viewing as:',
      'themeMode': 'Appearance & Tone',
      'lightRomantic': 'Soft Cream & Blush (Light)',
      'darkRomantic': 'Velvet Burgundy (Dark Romantic)',
      'privacySecurity': 'Privacy & Security Controls',
      'exportData': 'Export Couple Memories',
      'exportDataDesc':
          'Download a beautiful backup of your shared answers and journal.',
      'unlinkPartner': 'Unlink Partner',
      'unlinkWarning': 'This will safely disconnect the couple session.',
      'aboutApp': 'About GHARAR',
      'resetDemo': 'Refresh Couple Sanctuary',

      // Authentication & Apple ID
      'authTitle': 'Welcome to Your Sanctuary',
      'authSubtitle':
          'Sign in with your Apple ID or email to deepen your connection.',
      'signInWithApple': 'Sign in with Apple',
      'orDivider': 'or continue with email',
      'nameHint': 'Your Name',
      'emailHint': 'name@example.com',
      'passwordHint': 'Password (min. 6 characters)',
      'authContinue': 'Enter Sanctuary ➔',
      'signInTab': 'Sign In',
      'registerTab': 'New Account',
      'demoCoupleBtn': 'Enter Couple Sanctuary',
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
      'continueWithApple': 'Continue with Apple',
      'continueAsGuest': 'Continue As Guest',
      'forgotPassword': 'Forgot Password?',
      'needAccount': 'Need an account? ',
      'alreadyHaveAccount': 'Already have an account? ',
      'signUpLink': 'Sign up',
      'logInLink': 'Log in',
      'or': 'or',
      'passwordResetSent': 'Password reset instructions sent to your email.',
    },

    // ==========================================
    // 🇹🇷 TURKISH
    // ==========================================
    'tr': {
      'appName': 'GHARAR',
      'appTagline': 'İki Kalbin Sığınağı',
      'welcomeBack': 'Tekrar hoş geldiniz',
      'connectToday': 'Bugün Bağlan',
      'today': 'Bugün',
      'save': 'Kaydet',
      'cancel': 'İptal',
      'close': 'Kapat',
      'continueText': 'Devam Et',
      'getStarted': 'Aşk Yolculuğunuza Başlayın',
      'share': 'Paylaş',
      'copy': 'Kodu Kopyala',
      'copied': 'Panoya kopyalandı!',
      'reveal': 'Cevapları Birlikte Aç',
      'completed': 'Tamamlandı',
      'saved': 'Kaydedildi',
      'edit': 'Düzenle',
      'delete': 'Sil',
      'skip': 'Soruyu Atla',
      'submit': 'Cevabımı Gönder',
      'waitingPartner': 'Partner bekleniyor',
      'bothAnswered': 'İkiniz de cevapladınız!',
      'streakDays': 'Günlük Bağlılık Serisi',
      'streakTitle': 'Bağlantı Serisi',
      'streakEncourage': 'Aşkınız her gün çiçek açıyor!',
      'partner': 'Partner',
      'you': 'Sen',
      'premium': 'GHARAR Premium',
      'appLanguage': 'Uygulama Dili',

      // Navigation
      'navHome': 'Ana Sayfa',
      'navDiscover': 'Keşfet',
      'navActivities': 'Aktiviteler',
      'navMemories': 'Anılarımız',
      'navProfile': 'Profil',

      // Onboarding
      'onboarding1Title': 'Sadece İkinize Özel Masalsı Bir Alan',
      'onboarding1Desc':
          'GHARAR; derin sohbetler başlatmak, ortak tutkuları keşfetmek ve her anı ölümsüzleştirmek için tasarlanmış özel sığınağınızdır.',
      'onboarding2Title': 'Günlük Sorular, Gizli Cevaplar',
      'onboarding2Desc':
          'Her gün ikinize özel düşünceli bir soru gelir. İkiniz de cevaplayana kadar yanıtlar gizli kalır, sürprizin büyüsü bozulmaz!',
      'onboarding3Title': 'Romantik Maceralar ve Derin Uyum',
      'onboarding3Desc':
          'Özenle seçilmiş randevu fikirleri, eğlenceli testler, ortak gelecek hayalleri ve ilişkinizi besleyen duygusal egzersizler.',
      'whatsYourName': 'Adınız nedir?',
      'enterYourName': 'İsminizi girin',
      'selectLanguage': 'Tercih Ettiğiniz Dili Seçin',
      'relationshipStage': 'İlişkiniz şu an hangi evrede?',
      'stageDating': 'Flört & Birbirini Tanıma',
      'stageEngaged': 'Nişanlı & Evlilik Hazırlığı',
      'stageNewlywed': 'Yeni Evli (İlk Yıllar)',
      'stageLongTerm': 'Uzun Süreli Birliktelik',
      'stageMarriedWithKids': 'Çocuklu Evli Çift',
      'stageLongDistance': 'Uzak Mesafe İlişkisi',
      'selectGoals': 'Birlikte en çok neyi güçlendirmek istersiniz?',
      'goalDeeperConversations': 'Daha Derin Sohbetler',
      'goalSpontaneousRomance': 'Kendiliğinden Gelişen Romantizm',
      'goalUnderstandingNeeds': 'Duygusal İhtiyaçları Anlamak',
      'goalFuturePlanning': 'Gelecek Hayallerinde Uyum',
      'goalFunAdventures': 'Eğlenceli Maceralar & Oyunlar',
      'goalConflictResolution': 'Şefkatli İletişim & Çözüm',

      // Partner Invite
      'invitePartnerTitle': 'Ruh Eşini Davet Et',
      'invitePartnerSubtitle':
          'GHARAR, iki kalbin senkronize olması için tasarlandı. Bu özel kodu partnerinle paylaşarak alanınızı birleştirin.',
      'yourInviteCode': 'Size Özel Çift Kodu',
      'enterPartnerCode': 'Veya partnerinizin kodunu girin',
      'connectPartnerButton': 'Partnere Bağlan',
      'simulatedPartner': 'Partner Simülasyonu (Demo Modu)',
      'simulatedPartnerDesc':
          'Karşılıklı cevap açılma deneyimini tek tıkla partner bakış açısıyla hemen deneyin!',

      // Home Dashboard
      'dailyGreetingMorning': 'Günaydın sevgililer',
      'dailyGreetingAfternoon': 'Tünaydın',
      'dailyGreetingEvening': 'İyi akşamlar, güzel ruhlar',
      'dailyQuestionCardTitle': 'Günün Bağlantı Sorusu',
      'drawAnother': 'Başka Soru Çek',
      'weeklyChallengeTitle': 'Bu Haftanın Çift Görevi',
      'sharedInterestTitle': 'Günün Ortak Kıvılcımı',
      'upcomingDateTitle': 'Yaklaşan Özel Günümüz',
      'daysUntil': 'gün kaldı',

      // Daily Question
      'intensityIcebreaker': 'Hafif & Eğlenceli 🌱',
      'intensityMeaningful': 'Samimi & Anlamlı 🌿',
      'intensityDeep': 'Ruhani & Derin Keşif 🌺',
      'yourAnswerHint':
          'Tüm kalbinizle içtenlikle yazın... Partneriniz bu cevabı sadece kendisi de yazınca görebilecek.',
      'privateAnswerNotice':
          '🔒 Karşılıklı açılana kadar tamamen gizli. Kimse bakamaz!',
      'partnerAnsweredNotice':
          'cevabını yazdı bile! Birlikte okumak için şimdi yanıtlayın.',
      'partnerPendingNotice':
          'düşüncelerini toparlıyor. Sizinkini hemen kaydedin, hazır olun!',
      'revealCelebration': 'Cevaplarınız Aydınlandı! ✨',
      'reflectTogetherPrompt':
          'Derin bir nefes alın ve birbirinizin yazdıklarını sesli olarak okuyun.',

      // Discover & Quizzes
      'discoverHubTitle': 'Keşfet & Uyum Sağla',
      'sharedInterestsTab': 'Ortak Kıvılcımlar',
      'quizGameTab': 'Bizi Ne Kadar Tanıyoruz?',
      'differencesTab': 'Güzel Farklılıklarımız',
      'futureAlignmentTab': 'Nereye Doğru İlerliyoruz?',
      'quizSubtitle':
          'Partnerinizin ne seçeceğini tahmin edin, tatlı ve merak uyandıran sürprizler keşfedin.',
      'compatibilityScore': 'Ruh Uyumu',
      'planThisActivity': 'Bu Randevuyu Birlikte Planla',
      'celebrateDifference':
          'Farklılıklar merakın doğduğu yerdir. İkinizin zevkini birleştiren tatlı bir öneri:',

      // Couple Activities
      'activitiesTitle': 'Çift Deneyimleri & Randevular',
      'filterAll': 'Tüm Fikirler',
      'filterRomantic': 'Romantik',
      'filterAtHome': 'Evde Sıcak',
      'filterOutdoor': 'Açık Hava',
      'filterBudget': 'Bütçe Dostu',
      'filterCreative': 'Yaratıcı & Eğlenceli',
      'filterDuration': 'Gereken Süre',
      'surpriseMe': 'Romantik Sürpriz Üretici 🎲',
      'markAsDone': 'Bunu Yaptık & Hatıralara Ekle',
      'activitySaved': 'Çift İstek Listenize Eklendi',

      // Memories & Journal
      'memoriesTitle': 'Hikayemiz & Günlüğümüz',
      'timelineTab': 'Zaman Çizelgesi',
      'journalTab': 'Özel Çift Günlüğü',
      'specialDatesTab': 'Özel Günler & Yıldönümleri',
      'addEntry': 'Sevgi Notu / Anı Ekle',
      'newMilestone': 'Yeni Dönüm Noktası',
      'entryTitle': 'Anı Başlığı',
      'entryReflection': 'Bu anı unutulmaz kılan hislerinizi yazın...',

      // AI Relationship Companion "Noor"
      'noorTitle': 'Noor • İlişki Yoldaşı',
      'noorSubtitle':
          'Daha yapıcı konuşmalar, şefkatli yansımalar ve romantik fikirler için nazik bir yapay zeka rehberi.',
      'noorDisclaimer':
          'Noor sadece ilham ve nazik iletişim ipuçları sunar. Profesyonel çift terapisi yerine geçmez.',
      'noorPrompt1': 'Duygularımı incitmeden nasıl ifade edebilirim?',
      'noorPrompt2': 'Bu akşam için evde tatlı bir sürpriz öner',
      'noorPrompt3': 'Bize bu gece için düşündürücü bir soru ver',
      'noorPrompt4': 'Farklı sosyal enerji seviyelerimizi nasıl dengeleriz?',
      'askNoorHint':
          'Noor’a bir soru sorun, tavsiye veya randevu fikri isteyin...',

      // Profile & Settings
      'profileTitle': 'Çift Alanı & Ayarlar',
      'switchPartner': 'Görünüm Değiştir (Simülasyon)',
      'activeViewingAs': 'Şu anda görüntüleyen:',
      'themeMode': 'Görünüm & Tema',
      'lightRomantic': 'Yumuşak Krem & Pudra (Açık)',
      'darkRomantic': 'Kadife Bordo (Koyu Romantik)',
      'privacySecurity': 'Gizlilik & Güvenlik Kontrolleri',
      'exportData': 'Çift Anılarını Dışa Aktar',
      'exportDataDesc':
          'Cevaplarınızın ve günlüğünüzün güzel bir yedeğini indirin.',
      'unlinkPartner': 'Partner Bağını Kopar',
      'unlinkWarning': 'Bu işlem mevcut çift eşleşmesini güvenle sonlandırır.',
      'aboutApp': 'GHARAR Hakkında',
      'resetDemo': 'Çift Alanını Yenile',

      // Authentication & Apple ID
      'authTitle': 'Aşk Sığınağınıza Hoş Geldiniz',
      'authSubtitle':
          'İlişkinizi derinleştirmek ve güvenle bağlanmak için Apple ID veya e-postanızla giriş yapın.',
      'signInWithApple': 'Apple ile Giriş Yap',
      'orDivider': 'veya e-posta ile devam edin',
      'nameHint': 'Adınız',
      'emailHint': 'ornek@eposta.com',
      'passwordHint': 'Şifre (en az 6 karakter)',
      'authContinue': 'Sığınağa Adım At ➔',
      'signInTab': 'Giriş Yap',
      'registerTab': 'Yeni Hesap',
      'demoCoupleBtn': 'Çift Alanına Giriş Yap',
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
      'continueWithApple': 'Apple ile Devam Et',
      'continueAsGuest': 'Misafir Olarak Devam Et',
      'forgotPassword': 'Şifrenizi mi unuttunuz?',
      'needAccount': 'Hesabınız yok mu? ',
      'alreadyHaveAccount': 'Zaten bir hesabınız var mı? ',
      'signUpLink': 'Kayıt Ol',
      'logInLink': 'Giriş Yap',
      'or': 'veya',
      'passwordResetSent':
          'Şifre sıfırlama talimatları e-postanıza gönderildi.',
    },

    // ==========================================
    // 🇸🇦 ARABIC (العربية - RTL)
    // ==========================================
    'ar': {
      'appName': 'قرار',
      'appTagline': 'ملاذ لقلبين',
      'welcomeBack': 'أهلاً بكم من جديد',
      'connectToday': 'تواصل اليوم',
      'today': 'اليوم',
      'save': 'حفظ',
      'cancel': 'إلغاء',
      'close': 'إغلاق',
      'continueText': 'متابعة',
      'getStarted': 'ابدآ رحلتكما معاً',
      'share': 'مشاركة',
      'copy': 'نسخ الرمز',
      'copied': 'تم النسخ إلى الحافظة!',
      'reveal': 'كشف الإجابات معاً',
      'completed': 'مكتمل',
      'saved': 'تم الحفظ',
      'edit': 'تعديل',
      'delete': 'حذف',
      'skip': 'تخطي السؤال',
      'submit': 'إرسال إجابتي',
      'waitingPartner': 'في انتظار الشريك',
      'bothAnswered': 'أجاب كِلاكما!',
      'streakDays': 'أيام التواصل المستمر',
      'streakTitle': 'سلسلة التقارب',
      'streakEncourage': 'حبكما يزهر كل يوم!',
      'partner': 'الشريك',
      'you': 'أنت',
      'premium': 'قرار بريميوم',
      'appLanguage': 'لغة التطبيق',

      // Navigation
      'navHome': 'الرئيسية',
      'navDiscover': 'اكتشف',
      'navActivities': 'أنشطة',
      'navMemories': 'ذكرياتنا',
      'navProfile': 'الملف الشخصي',

      // Onboarding
      'onboarding1Title': 'ملاذ مقدس خُصص لكما وحدكما',
      'onboarding1Desc':
          'قرار هو ملاذكما الهادئ لفتح أحاديث عميقة، واستكشاف المشاعر المشتركة، وتخليد أجمل اللحظات.',
      'onboarding2Title': 'أسئلة يومية بإجابات سرية',
      'onboarding2Desc':
          'في كل يوم سؤال مليء بالمشاعر. تظل الإجابات مخفية حتى يجيب كِلاكما لحفظ متعة المفاجأة الصادقة!',
      'onboarding3Title': 'مغامرات رومانسية وانسجام عميق',
      'onboarding3Desc':
          'أفكار مواعيد مختارة بعناية، اختبارات مرحة، أحلام مستقبلية مشتركة وتمارين لتعميق الألفة بينكما.',
      'whatsYourName': 'ما هو اسمك؟',
      'enterYourName': 'أدخل اسمك الأول',
      'selectLanguage': 'اختر لغتك المفضلة',
      'relationshipStage': 'ما هي مرحلة علاقتكما الآن؟',
      'stageDating': 'تعارف واستكشاف',
      'stageEngaged': 'مخطوبان وتخطيط للزواج',
      'stageNewlywed': 'حديثا الزواج (السنوات الأولى)',
      'stageLongTerm': 'شريكان منذ سنوات',
      'stageMarriedWithKids': 'متزوجان مع أطفال',
      'stageLongDistance': 'حب عبر المسافات',
      'selectGoals': 'ما الذي تودان تقويته معاً؟',
      'goalDeeperConversations': 'محادثات أكثر عمقاً',
      'goalSpontaneousRomance': 'رومانسية عفوية',
      'goalUnderstandingNeeds': 'فهم الاحتياجات العاطفية',
      'goalFuturePlanning': 'تناغم في أحلام المستقبل',
      'goalFunAdventures': 'مرح ومغامرات مشتركة',
      'goalConflictResolution': 'تواصل لطيف وحل الخلافات',

      // Partner Invite
      'invitePartnerTitle': 'دعوة توأم روحك',
      'invitePartnerSubtitle':
          'صُمم قرار ليكون مساحة متزامنة لقلبين. شارك هذا الرمز مع شريكك لربط قلبيكما معاً.',
      'yourInviteCode': 'رمزكما الثنائي الفريد',
      'enterPartnerCode': 'أو أدخل رمز شريكك للارتباط',
      'connectPartnerButton': 'ارتبط بالشريك',
      'simulatedPartner': 'محاكاة الشريك (وضع تجريبي)',
      'simulatedPartnerDesc':
          'بدّل العرض بين الشريكين لتجربة كشف الإجابات المتبادلة فوراً!',

      // Home Dashboard
      'dailyGreetingMorning': 'صباح الخير يا أحبة',
      'dailyGreetingAfternoon': 'طاب مساؤكم',
      'dailyGreetingEvening': 'مساء السكينة، يا أرواحاً جميلة',
      'dailyQuestionCardTitle': 'سؤال التقارب اليومي',
      'drawAnother': 'سحب سؤال آخر',
      'weeklyChallengeTitle': 'تحدي الأسبوع للزوجين',
      'sharedInterestTitle': 'شرارة اليوم المشتركة',
      'upcomingDateTitle': 'مناسبتنا القادمة',
      'daysUntil': 'أيام متبقية',

      // Daily Question
      'intensityIcebreaker': 'خفيف ومرح 🌱',
      'intensityMeaningful': 'صادق وذو معنى 🌿',
      'intensityDeep': 'استكشاف عميق للأعماق 🌺',
      'yourAnswerHint':
          'اكتب بكل صدق من قلبك... لن يرى شريكك هذا إلا بعد أن يقدم إجابته أيضاً.',
      'privateAnswerNotice': '🔒 إجابة خاصة تماماً حتى الكشف المتبادل.',
      'partnerAnsweredNotice':
          'أرسل إجابته بالفعل! أجب الآن لتكتشفا الإجابات معاً.',
      'partnerPendingNotice':
          'يأخذ وقته في التفكير. اكتب إجابتك الآن لتكون جاهزاً!',
      'revealCelebration': 'تلاقت قلوبكما بالإجابات! ✨',
      'reflectTogetherPrompt': 'تنفسا بعمق واقرآ مشاعر بعضكما البعض بصوت دافئ.',

      // Discover & Quizzes
      'discoverHubTitle': 'اكتشف وتناغم',
      'sharedInterestsTab': 'شرارات مشتركة',
      'quizGameTab': 'كم نعرف بعضنا جيداً؟',
      'differencesTab': 'اختلافاتنا الجميلة',
      'futureAlignmentTab': 'إلى أين نتجه معاً؟',
      'quizSubtitle': 'توقع خيارات شريكك واكتشف رؤى لطيفة ورومانسية.',
      'compatibilityScore': 'انسجام الأرواح',
      'planThisActivity': 'خططا لهذا الموعد معاً',
      'celebrateDifference':
          'في الاختلاف يزهر الفضول. إليكما طريقة لطيفة لدمج ذوقيكما:',

      // Couple Activities
      'activitiesTitle': 'تجارب ومواعيد رومانسية',
      'filterAll': 'كل الأفكار',
      'filterRomantic': 'رومانسي',
      'filterAtHome': 'في دفء المنزل',
      'filterOutdoor': 'في الهواء الطلق',
      'filterBudget': 'اقتصادي ولطيف',
      'filterCreative': 'مبتكر وممتع',
      'filterDuration': 'الوقت المطلوب',
      'surpriseMe': 'مُولّد المفاجآت الرومانسية 🎲',
      'markAsDone': 'عشناه وأضفناه لذكرياتنا',
      'activitySaved': 'تم الحفظ في قائمة أمنياتكما',

      // Memories & Journal
      'memoriesTitle': 'قصتنا ويومياتنا',
      'timelineTab': 'محطات مسارنا',
      'journalTab': 'دفتر يومياتنا الخاص',
      'specialDatesTab': 'تواريخنا وذكراياتنا',
      'addEntry': 'إضافة لمسة حب / ذكرى',
      'newMilestone': 'محطة جديدة',
      'entryTitle': 'عنوان الذكرى',
      'entryReflection': 'اكتب ما جعل هذه اللحظة خالدة في وجدانك...',

      // AI Relationship Companion "Noor"
      'noorTitle': 'نور • رفيق العلاقات',
      'noorSubtitle':
          'مرشد لطيف وودود يلهمكما بأحاديث دافئة، تأملات دون أحكام، ولفتات محبة.',
      'noorDisclaimer':
          'يقدم نور إلهاماً وتوجيهات تواصل ودية. ليس بديلاً عن الاستشارة الزوجية المتخصصة.',
      'noorPrompt1': 'ساعدني في التعبير عن مشاعري بلطف',
      'noorPrompt2': 'اقترح مفاجأة منزلية دافئة لهذه الليلة',
      'noorPrompt3': 'أعطنا سؤالاً عميقاً لمحادثة مسائية',
      'noorPrompt4': 'كيف نوازن بين رغباتنا الاجتماعية المختلفة؟',
      'askNoorHint': 'اسأل نور عن نصيحة أو فكرة موعد رومانسي...',

      // Profile & Settings
      'profileTitle': 'مساحة الزوجين والإعدادات',
      'switchPartner': 'تبديل عرض الشريك (تجريبي)',
      'activeViewingAs': 'تشاهد حالياً كـ:',
      'themeMode': 'المظهر والألوان',
      'lightRomantic': 'كريم ووردي ناعم (فاتح)',
      'darkRomantic': 'مخملي عودي (داكن رومانسي)',
      'privacySecurity': 'الخصوصية والأمان',
      'exportData': 'تصدير ذكريات الزوجين',
      'exportDataDesc': 'تحميل نسخة جميلة من إجاباتكما المشتركة ويومياتكما.',
      'unlinkPartner': 'فصل ارتباط الشريك',
      'unlinkWarning': 'سيؤدي هذا إلى إنهاء جلسة الاقتران الحالية بأمان.',
      'aboutApp': 'عن قرار',
      'resetDemo': 'تحديث مساحة الزوجين',

      // Authentication & Apple ID
      'authTitle': 'مرحباً بك في ملاذكما الخاص',
      'authSubtitle':
          'سجل الدخول باستخدام Apple ID أو بريدك الإلكتروني لتعميق التواصل بينكما.',
      'signInWithApple': 'تسجيل الدخول باستخدام Apple',
      'orDivider': 'أو المتابعة عبر البريد الإلكتروني',
      'nameHint': 'اسمك',
      'emailHint': 'name@example.com',
      'passwordHint': 'كلمة المرور (6 أحرف على الأقل)',
      'authContinue': 'الدخول إلى الملاذ ➔',
      'signInTab': 'تسجيل الدخول',
      'registerTab': 'حساب جديد',
      'demoCoupleBtn': 'الدخول إلى ملاذ الزوجين',
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
      'connectToday': 'ارتباط امروز',
      'today': 'امروز',
      'save': 'ذخیره',
      'cancel': 'انصراف',
      'close': 'بستن',
      'continueText': 'ادامه',
      'getStarted': 'آغاز سفر عاشقی',
      'share': 'اشتراک‌گذاری',
      'copy': 'کپی کد',
      'copied': 'در حافظه کپی شد!',
      'reveal': 'گشودن پاسخ‌ها با هم',
      'completed': 'تکمیل شد',
      'saved': 'ذخیره شد',
      'edit': 'ویرایش',
      'delete': 'حذف',
      'skip': 'رد کردن سوال',
      'submit': 'ارسال پاسخ من',
      'waitingPartner': 'در انتظار همسفر',
      'bothAnswered': 'هر دوی شما پاسخ دادید!',
      'streakDays': 'روز زنجیره پیوند قلبی',
      'streakTitle': 'زنجیره همبستگی',
      'streakEncourage': 'عشق شما هر روز شکوفاتر می‌شود!',
      'partner': 'یار',
      'you': 'تو',
      'premium': 'قرار ویژه',
      'appLanguage': 'زبان برنامه',

      // Navigation
      'navHome': 'خانه',
      'navDiscover': 'کاوش',
      'navActivities': 'عاشقانه‌ها',
      'navMemories': 'خاطرات ما',
      'navProfile': 'پروفایل',

      // Onboarding
      'onboarding1Title': 'پناهگاهی امن و شاعرانه فقط برای شما دو نفر',
      'onboarding1Desc':
          '«قرار» گوشه دنج شماست تا گفت‌وگوهای عمیق را آغاز کنید، اشتیاق‌های مشترک را بشناسید و هر لحظه را ماندگار کنید.',
      'onboarding2Title': 'پرسش‌های روزانه، با پاسخ‌های رازآلود',
      'onboarding2Desc':
          'هر روز یک پرسش تامل‌برانگیز پیش روی شماست. پاسخ‌ها تا زمانی که هر دو پاسخ ندهید پنهان می‌ماند تا شگفتی عشق زنده بماند!',
      'onboarding3Title': 'ماجراجویی‌های عاشقانه و پیوند همیشگی',
      'onboarding3Desc':
          'ایده‌های ناب قرار دونفره، آزمون‌های شیرین، رویاهای آینده مشترک و تمرین‌هایی برای صمیمیت عمیق‌تر.',
      'whatsYourName': 'نام زیبای شما چیست؟',
      'enterYourName': 'نام خود را وارد کنید',
      'selectLanguage': 'زبان دلخواه خود را برگزینید',
      'relationshipStage': 'رابطه شما هم‌اکنون در چه مرحله‌ای است؟',
      'stageDating': 'آشنایی و دلدادگی',
      'stageEngaged': 'نامزدی و پیوند مهر',
      'stageNewlywed': 'نوپا در زندگی مشترک (سال‌های نخست)',
      'stageLongTerm': 'همسفران دیرین',
      'stageMarriedWithKids': 'همراهان زندگی با فرزند',
      'stageLongDistance': 'عشق در امتداد فاصله‌ها',
      'selectGoals': 'دوست دارید بیشتر چه جنبه‌ای از عشق را پرورش دهید؟',
      'goalDeeperConversations': 'گفت‌وگوهای عمیق و دلنشین',
      'goalSpontaneousRomance': 'عاشقانه‌های بی‌بهانه و خودجوش',
      'goalUnderstandingNeeds': 'درک نیازهای عاطفی یکدیگر',
      'goalFuturePlanning': 'هم‌نوایی در آرزوهای آینده',
      'goalFunAdventures': 'شادی، بازی و ماجراهای مشترک',
      'goalConflictResolution': 'گفت‌وگوی آرام و حل مهربانانه دلخوری‌ها',

      // Partner Invite
      'invitePartnerTitle': 'دعوت از نیمه گمشده‌ات',
      'invitePartnerSubtitle':
          'قرار طراحی شده تا فضای مشترک دو دلداده باشد. این کد ویژه را با یارتان به اشتراک بگذارید تا دل‌هایتان پیوند بخورد.',
      'yourInviteCode': 'کد اختصاصی زوج شما',
      'enterPartnerCode': 'یا کد یارتان را برای اتصال وارد کنید',
      'connectPartnerButton': 'پیوند به یار',
      'simulatedPartner': 'شبیه‌سازی یار (حالت آزمایشی)',
      'simulatedPartnerDesc':
          'دیدگاه را به یار تغییر دهید تا لذت پرده‌برداری مشترک را بی‌درنگ تجربه کنید!',

      // Home Dashboard
      'dailyGreetingMorning': 'صبح بخیر جانِ دل',
      'dailyGreetingAfternoon': 'روزگارتان خوش',
      'dailyGreetingEvening': 'عصرگاهتان پر از آرامش و عشق',
      'dailyQuestionCardTitle': 'پرسش پیوند روزانه',
      'drawAnother': 'انتخاب پرسشی دیگر',
      'weeklyChallengeTitle': 'چالش این هفته زوج ما',
      'sharedInterestTitle': 'جرقه مشترک امروز',
      'upcomingDateTitle': 'رویداد خاطره‌انگیز پیش‌رو',
      'daysUntil': 'روز باقی‌مانده',

      // Daily Question
      'intensityIcebreaker': 'سبک و بازیگوشانه 🌱',
      'intensityMeaningful': 'دلی و پرمعنا 🌿',
      'intensityDeep': 'کاوش عمیق در ژرفای روح 🌺',
      'yourAnswerHint':
          'از صمیم قلبت بنویس... یارت این پاسخ را تنها زمانی می‌بیند که خود نیز بنویسد.',
      'privateAnswerNotice': '🔒 کاملاً محرمانه تا زمان گشودن دوطرفه.',
      'partnerAnsweredNotice':
          'پاسخش را نوشت! اکنون تو نیز پاسخ بده تا با هم بخوانید.',
      'partnerPendingNotice':
          'در حال چیدن واژه‌هاست. تو پاسخت را ثبت کن تا آماده باشی!',
      'revealCelebration': 'راز دل‌هایتان آشکار شد! ✨',
      'reflectTogetherPrompt':
          'نفسی عمیق بکشید و نوشته‌های یکدیگر را آرام و با مهر بخوانید.',

      // Discover & Quizzes
      'discoverHubTitle': 'کاوش و هم‌دلی',
      'sharedInterestsTab': 'جرقه‌های مشترک',
      'quizGameTab': 'چقدر همدیگر را می‌شناسیم؟',
      'differencesTab': 'تفاوت‌های زیبای ما',
      'futureAlignmentTab': 'مسیر مشترک آینده‌مان',
      'quizSubtitle': 'حدس بزن یارت چه پاسخی می‌دهد و شیرینی شگفتی‌ها را بچش.',
      'compatibilityScore': 'هماهنگی جان‌ها',
      'planThisActivity': 'این قرار عاشقانه را برنامه‌ریزی کنید',
      'celebrateDifference':
          'تفاوت‌ها سرآغاز کنجکاوی و شور است. راهی دلنشین برای آمیختن سلیقه‌هایتان:',

      // Couple Activities
      'activitiesTitle': 'تجربه‌ها و قرارهای دونفره',
      'filterAll': 'همه ایده‌ها',
      'filterRomantic': 'رمانتیک',
      'filterAtHome': 'در آغوش خانه',
      'filterOutdoor': 'زیر آسمان و در دل طبیعت',
      'filterBudget': 'ساده و کم‌هزینه',
      'filterCreative': 'خلاقانه و پر از خنده',
      'filterDuration': 'زمان موردنیاز',
      'surpriseMe': 'گردونه غافلگیری‌های عاشقانه 🎲',
      'markAsDone': 'تجربه شد و در دل تاریخ ماند',
      'activitySaved': 'به فهرست آرزوهای دونفره افزوده شد',

      // Memories & Journal
      'memoriesTitle': 'داستان ما و دفتر خاطرات',
      'timelineTab': 'گاه‌شمار پیوندمان',
      'journalTab': 'دفترچه دلنوشته‌های اختصاصی',
      'specialDatesTab': 'سالروزها و روزهای زرین',
      'addEntry': 'نگارش یادداشتی از جنس عشق',
      'newMilestone': 'نقطه عطف تازه',
      'entryTitle': 'عنوان خاطره',
      'entryReflection': 'بنویس چه چیزی این لحظه را تا ابد ماندگار کرد...',

      // AI Relationship Companion "Noor"
      'noorTitle': 'نور • همدم روابط عاشقانه',
      'noorSubtitle':
          'راهنمایی مهربان و باهمدلی برای هدایت گفت‌وگوهای آرام، نگاه‌های دور از قضاوت و لفت‌های محبت‌آمیز.',
      'noorDisclaimer':
          'نور تنها الهام‌بخش کلمات مهرآمیز است و جایگزین درمان تخصصی زوجین نمی‌باشد.',
      'noorPrompt1': 'کمکم کن احساساتم را با ملایمت بیان کنم',
      'noorPrompt2': 'ایده‌ای گرم برای غافلگیری امشب در خانه پیشنهاد کن',
      'noorPrompt3': 'یک پرسش ژرف برای گفت‌وگوی شبانه به ما هدیه بده',
      'noorPrompt4': 'چگونه انرژی‌های اجتماعی متفاوت‌مان را متعادل کنیم؟',
      'askNoorHint':
          'از نور درباره ایده‌های قرار یا رازهای گفت‌وگوی مهرآمیز بپرسید...',

      // Profile & Settings
      'profileTitle': 'حریم زوج و تنظیمات',
      'switchPartner': 'تغییر دیدگاه یار (آزمایشی)',
      'activeViewingAs': 'اکنون در حال مشاهده از نگاه:',
      'themeMode': 'جلوه و رنگ‌بندی',
      'lightRomantic': 'کرم و صورتی ملیح (روشن)',
      'darkRomantic': 'زرشکی مخملی و رازآلود (تیره رمانتیک)',
      'privacySecurity': 'حریم خصوصی و امنیت',
      'exportData': 'خروجی گرفتن از خاطرات مشترک',
      'exportDataDesc':
          'دریافت نسخه زیبای پشتیبان از پاسخ‌ها و خاطرات دونفره‌تان.',
      'unlinkPartner': 'جداسازی پیوند یار',
      'unlinkWarning': 'این کار اتصال دو حساب را با امنیت قطع می‌کند.',
      'aboutApp': 'درباره قرار',
      'resetDemo': 'تازه‌سازی فضای دو نفره',

      // Authentication & Apple ID
      'authTitle': 'به پناهگاه عشق خود خوش آمدید',
      'authSubtitle':
          'برای تعمیق پیوند عاطفی و صمیمیت، با اپل آیدی یا ایمیل خود وارد شوید.',
      'signInWithApple': 'ورود با اپل آیدی',
      'orDivider': 'یا ادامه با آدرس ایمیل',
      'nameHint': 'نام شما',
      'emailHint': 'name@example.com',
      'passwordHint': 'رمز عبور (حداقل ۶ کاراکتر)',
      'authContinue': 'ورود به پناهگاه ➔',
      'signInTab': 'ورود',
      'registerTab': 'حساب جدید',
      'demoCoupleBtn': 'ورود به پناهگاه عاشقی',
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
      'connectToday': 'Heute verbinden',
      'today': 'Heute',
      'save': 'Speichern',
      'cancel': 'Abbrechen',
      'close': 'Schließen',
      'continueText': 'Weiter',
      'getStarted': 'Beginnt eure Reise',
      'share': 'Teilen',
      'copy': 'Code kopieren',
      'copied': 'In die Zwischenablage kopiert!',
      'reveal': 'Antworten gemeinsam enthüllen',
      'completed': 'Abgeschlossen',
      'saved': 'Gespeichert',
      'edit': 'Bearbeiten',
      'delete': 'Löschen',
      'skip': 'Frage überspringen',
      'submit': 'Antwort absenden',
      'waitingPartner': 'Warten auf Partner',
      'bothAnswered': 'Ihr habt beide geantwortet!',
      'streakDays': 'Tage Liebes-Serie',
      'streakTitle': 'Verbindungs-Serie',
      'streakEncourage': 'Eure Liebe blüht jeden Tag!',
      'partner': 'Partner',
      'you': 'Du',
      'premium': 'GHARAR Premium',
      'appLanguage': 'App-Sprache',

      // Navigation
      'navHome': 'Start',
      'navDiscover': 'Entdecken',
      'navActivities': 'Aktivitäten',
      'navMemories': 'Erinnerungen',
      'navProfile': 'Profil',

      // Onboarding
      'onboarding1Title': 'Ein geschützter Raum nur für euch zwei',
      'onboarding1Desc':
          'GHARAR ist euer privater Rückzugsort, um tiefe Gespräche zu führen, gemeinsame Leidenschaften zu entdecken und jeden Moment zu schätzen.',
      'onboarding2Title': 'Tägliche Fragen, privat beantwortet',
      'onboarding2Desc':
          'Jeder Tag bringt eine tiefgründige Frage. Antworten bleiben geheim, bis ihr beide geantwortet habt – für echte Überraschung!',
      'onboarding3Title': 'Romantische Abenteuer & tiefe Verbundenheit',
      'onboarding3Desc':
          'Kuratierte Date-Ideen, verspielte Quizze, gemeinsame Zukunftsträume und Übungen für emotionale Nähe.',
      'whatsYourName': 'Wie heißt du?',
      'enterYourName': 'Gib deinen Vornamen ein',
      'selectLanguage': 'Wähle deine bevorzugte Sprache',
      'relationshipStage': 'Wo steht eure Beziehung gerade?',
      'stageDating': 'Dating & Kennenlernen',
      'stageEngaged': 'Verlobt & Hochzeitsplanung',
      'stageNewlywed': 'Frisch verheiratet (Erste Jahre)',
      'stageLongTerm': 'Langzeit-Partner',
      'stageMarriedWithKids': 'Verheiratet mit Kindern',
      'stageLongDistance': 'Fernbeziehung',
      'selectGoals': 'Was möchtet ihr gemeinsam stärken?',
      'goalDeeperConversations': 'Tiefere Gespräche',
      'goalSpontaneousRomance': 'Spontane Romantik',
      'goalUnderstandingNeeds': 'Emotionale Bedürfnisse verstehen',
      'goalFuturePlanning': 'Zukunftsträume in Einklang bringen',
      'goalFunAdventures': 'Spielerischer Spaß & Abenteuer',
      'goalConflictResolution': 'Sanfte Konfliktlösung',

      // Partner Invite
      'invitePartnerTitle': 'Lade deine bessere Hälfte ein',
      'invitePartnerSubtitle':
          'GHARAR ist als synchronisierter Zufluchtsort für zwei konzipiert. Teile diesen Code mit deinem Partner.',
      'yourInviteCode': 'Euer persönlicher Paar-Code',
      'enterPartnerCode': 'Oder gib den Code deines Partners ein',
      'connectPartnerButton': 'Mit Partner verbinden',
      'simulatedPartner': 'Partner simulieren (Demo-Modus)',
      'simulatedPartnerDesc':
          'Wechsle zwischen Partnern, um das gemeinsame Enthüllen sofort zu testen!',

      // Home Dashboard
      'dailyGreetingMorning': 'Guten Morgen, ihr Lieben',
      'dailyGreetingAfternoon': 'Guten Tag',
      'dailyGreetingEvening': 'Guten Abend, wundervolle Seelen',
      'dailyQuestionCardTitle': 'Tägliche Frage der Nähe',
      'drawAnother': 'Andere Frage ziehen',
      'weeklyChallengeTitle': 'Paar-Challenge der Woche',
      'sharedInterestTitle': 'Gemeinsamer Funke des Tages',
      'upcomingDateTitle': 'Bevorstehender Meilenstein',
      'daysUntil': 'Tage verbleibend',

      // Daily Question
      'intensityIcebreaker': 'Leicht & Spielerisch 🌱',
      'intensityMeaningful': 'Herzensnah & Bedeutungsvoll 🌿',
      'intensityDeep': 'Tiefe Seelenreise 🌺',
      'yourAnswerHint':
          'Schreibe ganz ehrlich aus deinem Herzen... Dein Partner sieht dies erst, wenn er auch antwortet.',
      'privateAnswerNotice':
          '🔒 Streng vertraulich bis zur beidseitigen Enthüllung.',
      'partnerAnsweredNotice':
          'hat bereits geantwortet! Antworte jetzt, um es gemeinsam zu lesen.',
      'partnerPendingNotice':
          'denkt noch nach. Gib deine Antwort jetzt ein, um bereit zu sein!',
      'revealCelebration': 'Eure Seelen haben gesprochen! ✨',
      'reflectTogetherPrompt':
          'Atmet tief durch und lest euch die Gedanken gegenseitig laut vor.',

      // Discover & Quizzes
      'discoverHubTitle': 'Entdecken & Harmonisieren',
      'sharedInterestsTab': 'Gemeinsame Funken',
      'quizGameTab': 'Wie gut kennen wir uns?',
      'differencesTab': 'Schöne Unterschiede',
      'futureAlignmentTab': 'Wohin führt unser Weg?',
      'quizSubtitle':
          'Errate, was dein Partner wählen würde, und entdecke liebevolle Einblicke.',
      'compatibilityScore': 'Seelenharmonie',
      'planThisActivity': 'Dieses Date zusammen planen',
      'celebrateDifference':
          'In Unterschieden erblüht Neugier. Hier ist eine süße Idee, beides zu verbinden:',

      // Couple Activities
      'activitiesTitle': 'Erlebnisse & Dates für Paare',
      'filterAll': 'Alle Ideen',
      'filterRomantic': 'Romantisch',
      'filterAtHome': 'Gemütlich zuhause',
      'filterOutdoor': 'An der frischen Luft',
      'filterBudget': 'Günstig & Schön',
      'filterCreative': 'Kreativ & Bunt',
      'filterDuration': 'Benötigte Zeit',
      'surpriseMe': 'Romantischer Überraschungs-Generator 🎲',
      'markAsDone': 'Erlebt & in Ehren gehalten',
      'activitySaved': 'Zur Paar-Wunschliste hinzugefügt',

      // Memories & Journal
      'memoriesTitle': 'Unsere Geschichte & Tagebuch',
      'timelineTab': 'Zeitstrahl-Meilensteine',
      'journalTab': 'Privates Paar-Tagebuch',
      'specialDatesTab': 'Besondere Daten & Jubiläen',
      'addEntry': 'Liebesnotiz / Erinnerung hinzufügen',
      'newMilestone': 'Neuer Meilenstein',
      'entryTitle': 'Titel der Erinnerung',
      'entryReflection': 'Was hat diesen Moment unvergesslich gemacht...',

      // AI Relationship Companion "Noor"
      'noorTitle': 'Noor • Beziehungsbegleiter',
      'noorSubtitle':
          'Ein sanfter, einfühlsamer Begleiter für bedeutungsvolle Gespräche und liebevolle Gesten.',
      'noorDisclaimer':
          'Noor schenkt Inspiration und Kommunikationstipps. Kein Ersatz für professionelle Paartherapie.',
      'noorPrompt1': 'Hilf mir, Gefühle behutsam auszudrücken',
      'noorPrompt2': 'Schlage eine gemütliche Überraschung für heute Abend vor',
      'noorPrompt3': 'Gib uns eine tiefgründige Frage für die Nacht',
      'noorPrompt4': 'Wie gehen wir mit unterschiedlicher sozialer Energie um?',
      'askNoorHint':
          'Frag Noor um Rat, Date-Ideen oder Kommunikationsanstöße...',

      // Profile & Settings
      'profileTitle': 'Paar-Bereich & Einstellungen',
      'switchPartner': 'Ansicht wechseln (Demo)',
      'activeViewingAs': 'Aktuelle Ansicht als:',
      'themeMode': 'Erscheinungsbild',
      'lightRomantic': 'Creme & Zartrosa (Hell)',
      'darkRomantic': 'Samt-Burgunder (Dunkel Romantisch)',
      'privacySecurity': 'Privatsphäre & Sicherheit',
      'exportData': 'Paar-Erinnerungen exportieren',
      'exportDataDesc':
          'Lade ein wunderschönes Backup eurer gemeinsamen Antworten herunter.',
      'unlinkPartner': 'Partner-Verbindung trennen',
      'unlinkWarning': 'Trennt die Kopplung beider Konten sicher.',
      'aboutApp': 'Über GHARAR',
      'resetDemo': 'Paar-Zufluchtsort aktualisieren',

      // Authentication & Apple ID
      'authTitle': 'Willkommen in eurem Zufluchtsort',
      'authSubtitle':
          'Melde dich mit deiner Apple-ID oder E-Mail an, um eure Verbindung zu vertiefen.',
      'signInWithApple': 'Mit Apple anmelden',
      'orDivider': 'oder mit E-Mail fortfahren',
      'nameHint': 'Dein Name',
      'emailHint': 'name@beispiel.de',
      'passwordHint': 'Passwort (mind. 6 Zeichen)',
      'authContinue': 'Zufluchtsort betreten ➔',
      'signInTab': 'Anmelden',
      'registerTab': 'Neues Konto',
      'demoCoupleBtn': 'Paar-Zufluchtsort betreten',
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
      'connectToday': 'Conectar Hoy',
      'today': 'Hoy',
      'save': 'Guardar',
      'cancel': 'Cancelar',
      'close': 'Cerrar',
      'continueText': 'Continuar',
      'getStarted': 'Comiencen su viaje',
      'share': 'Compartir',
      'copy': 'Copiar Código',
      'copied': '¡Copiado al portapapeles!',
      'reveal': 'Revelar Respuestas Juntos',
      'completed': 'Completado',
      'saved': 'Guardado',
      'edit': 'Editar',
      'delete': 'Eliminar',
      'skip': 'Saltar Pregunta',
      'submit': 'Enviar Mi Respuesta',
      'waitingPartner': 'Esperando a la pareja',
      'bothAnswered': '¡Ambos han respondido!',
      'streakDays': 'Días de Racha de Conexión',
      'streakTitle': 'Racha de Unión',
      'streakEncourage': '¡Su amor florece cada día!',
      'partner': 'Pareja',
      'you': 'Tú',
      'premium': 'GHARAR Premium',
      'appLanguage': 'Idioma de la Aplicación',

      // Navigation
      'navHome': 'Inicio',
      'navDiscover': 'Descubrir',
      'navActivities': 'Citas & Planes',
      'navMemories': 'Recuerdos',
      'navProfile': 'Perfil',

      // Onboarding
      'onboarding1Title': 'Un espacio sagrado sólo para ustedes dos',
      'onboarding1Desc':
          'GHARAR es su santuario privado para profundizar conversaciones, descubrir pasiones compartidas y atesorar cada instante.',
      'onboarding2Title': 'Preguntas diarias, respondidas en privado',
      'onboarding2Desc':
          'Cada día trae una pregunta reflexiva. Las respuestas permanecen ocultas hasta que ambos respondan, ¡manteniendo viva la sorpresa!',
      'onboarding3Title': 'Aventuras románticas e intimidad duradera',
      'onboarding3Desc':
          'Ideas de citas seleccionadas, cuestionarios divertidos, sueños compartidos y ejercicios emocionales diseñados para su amor.',
      'whatsYourName': '¿Cómo te llamas?',
      'enterYourName': 'Ingresa tu nombre',
      'selectLanguage': 'Elige tu idioma preferido',
      'relationshipStage': '¿En qué etapa está su relación hoy?',
      'stageDating': 'Saliendo & Conociéndonos',
      'stageEngaged': 'Comprometidos & Planeando boda',
      'stageNewlywed': 'Recién Casados (Primeros años)',
      'stageLongTerm': 'Pareja de largo camino',
      'stageMarriedWithKids': 'Casados con hijos',
      'stageLongDistance': 'Amor a distancia',
      'selectGoals': '¿Qué les gustaría cultivar más juntos?',
      'goalDeeperConversations': 'Conversaciones más profundas',
      'goalSpontaneousRomance': 'Romance espontáneo',
      'goalUnderstandingNeeds': 'Entender necesidades emocionales',
      'goalFuturePlanning': 'Alinear sueños del futuro',
      'goalFunAdventures': 'Aventuras divertidas y juegos',
      'goalConflictResolution': 'Resolución serena de conflictos',

      // Partner Invite
      'invitePartnerTitle': 'Invita a tu persona especial',
      'invitePartnerSubtitle':
          'GHARAR fue diseñado como un santuario sincronizado para dos. Comparte este código para entrelazar sus corazones.',
      'yourInviteCode': 'Su Código Único de Pareja',
      'enterPartnerCode': 'O ingresa el código de tu pareja para conectar',
      'connectPartnerButton': 'Conectar con Pareja',
      'simulatedPartner': 'Simular Pareja (Modo Demo)',
      'simulatedPartnerDesc':
          '¡Alterna vistas entre ambos para probar la revelación mutua al instante!',

      // Home Dashboard
      'dailyGreetingMorning': 'Buenos días, queridos',
      'dailyGreetingAfternoon': 'Buenas tardes',
      'dailyGreetingEvening': 'Buenas noches, almas hermosas',
      'dailyQuestionCardTitle': 'Pregunta de Conexión Diaria',
      'drawAnother': 'Elegir Otra Pregunta',
      'weeklyChallengeTitle': 'Desafío de Pareja de la Semana',
      'sharedInterestTitle': 'Chispa Compartida del Día',
      'upcomingDateTitle': 'Próxima Fecha Especial',
      'daysUntil': 'días restantes',

      // Daily Question
      'intensityIcebreaker': 'Ligero y Divertido 🌱',
      'intensityMeaningful': 'Sentido y Significativo 🌿',
      'intensityDeep': 'Exploración Profunda del Alma 🌺',
      'yourAnswerHint':
          'Escribe con total sinceridad desde el corazón... Tu pareja solo verá esto cuando también envíe su respuesta.',
      'privateAnswerNotice':
          '🔒 Estrictamente privado hasta la revelación mutua.',
      'partnerAnsweredNotice':
          '¡ya ha respondido! Responde ahora para leerlo juntos.',
      'partnerPendingNotice':
          'se está tomando un momento para pensar. ¡Escribe la tuya para estar listos!',
      'revealCelebration': '¡Sus almas han hablado! ✨',
      'reflectTogetherPrompt':
          'Respiren hondo y lean en voz alta lo que escribió el otro.',

      // Discover & Quizzes
      'discoverHubTitle': 'Descubrir y Alinear',
      'sharedInterestsTab': 'Chispas en Común',
      'quizGameTab': '¿Cuánto nos conocemos?',
      'differencesTab': 'Hermosas Diferencias',
      'futureAlignmentTab': '¿Hacia dónde vamos?',
      'quizSubtitle':
          'Adivina qué elegirá tu pareja y descubran detalles tiernos y románticos.',
      'compatibilityScore': 'Armonía de Almas',
      'planThisActivity': 'Planear esta Cita Juntos',
      'celebrateDifference':
          'En las diferencias florece la curiosidad. Una forma dulce de unir ambos gustos:',

      // Couple Activities
      'activitiesTitle': 'Experiencias y Citas en Pareja',
      'filterAll': 'Todas las Ideas',
      'filterRomantic': 'Romántico',
      'filterAtHome': 'En el calor del hogar',
      'filterOutdoor': 'Al aire libre',
      'filterBudget': 'Económico y Dulce',
      'filterCreative': 'Creativo y Divertido',
      'filterDuration': 'Tiempo necesario',
      'surpriseMe': 'Generador de Sorpresas Románticas 🎲',
      'markAsDone': 'Vivido y Guardado en el Corazón',
      'activitySaved': 'Guardado en su Lista de Deseos',

      // Memories & Journal
      'memoriesTitle': 'Nuestra Historia & Diario',
      'timelineTab': 'Línea de Tiempo',
      'journalTab': 'Diario Privado de Pareja',
      'specialDatesTab': 'Fechas Especiales & Aniversarios',
      'addEntry': 'Agregar Nota de Amor / Recuerdo',
      'newMilestone': 'Nuevo Hito',
      'entryTitle': 'Título del Recuerdo',
      'entryReflection': 'Escribe qué hizo inolvidable este momento...',

      // AI Relationship Companion "Noor"
      'noorTitle': 'Noor • Acompañante de Pareja',
      'noorSubtitle':
          'Una guía cálida y empática para inspirar conversaciones significativas y gestos amorosos.',
      'noorDisclaimer':
          'Noor ofrece inspiración y consejos de comunicación. No reemplaza terapia de parejas profesional.',
      'noorPrompt1': 'Ayúdame a expresar mis sentimientos con ternura',
      'noorPrompt2': 'Sugiere una sorpresa acogedora en casa para esta noche',
      'noorPrompt3': 'Danos una pregunta profunda para conversar esta noche',
      'noorPrompt4': '¿Cómo equilibramos niveles distintos de energía social?',
      'askNoorHint': 'Pídele consejo, ideas de citas o sugerencias a Noor...',

      // Profile & Settings
      'profileTitle': 'Espacio de Pareja & Ajustes',
      'switchPartner': 'Cambiar Vista de Pareja (Demo)',
      'activeViewingAs': 'Viendo actualmente como:',
      'themeMode': 'Apariencia y Tono',
      'lightRomantic': 'Crema & Rosa Pastel (Claro)',
      'darkRomantic': 'Borgoña Terciopelo (Oscuro Romántico)',
      'privacySecurity': 'Privacidad y Seguridad',
      'exportData': 'Exportar Recuerdos Compartidos',
      'exportDataDesc':
          'Descarga una copia hermosa de sus respuestas y diario.',
      'unlinkPartner': 'Desvincular Pareja',
      'unlinkWarning': 'Esto finalizará de forma segura la sesión compartida.',
      'aboutApp': 'Acerca de GHARAR',
      'resetDemo': 'Actualizar Espacio de Pareja',

      // Authentication & Apple ID
      'authTitle': 'Bienvenidos a su Santuario',
      'authSubtitle':
          'Inicia sesión con tu Apple ID o correo para profundizar su conexión.',
      'signInWithApple': 'Iniciar sesión con Apple',
      'orDivider': 'o continuar con correo',
      'nameHint': 'Tu Nombre',
      'emailHint': 'nombre@ejemplo.com',
      'passwordHint': 'Contraseña (mín. 6 caracteres)',
      'authContinue': 'Entrar al Santuario ➔',
      'signInTab': 'Iniciar sesión',
      'registerTab': 'Nueva cuenta',
      'demoCoupleBtn': 'Entrar al Santuario',
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
      'connectToday': 'Se Connecter Aujourd’hui',
      'today': 'Aujourd’hui',
      'save': 'Enregistrer',
      'cancel': 'Annuler',
      'close': 'Fermer',
      'continueText': 'Continuer',
      'getStarted': 'Commencez Votre Voyage',
      'share': 'Partager',
      'copy': 'Copier le Code',
      'copied': 'Copié dans le presse-papiers !',
      'reveal': 'Révéler les Réponses Ensemble',
      'completed': 'Terminé',
      'saved': 'Enregistré',
      'edit': 'Modifier',
      'delete': 'Supprimer',
      'skip': 'Passer la Question',
      'submit': 'Envoyer ma Réponse',
      'waitingPartner': 'En attente du partenaire',
      'bothAnswered': 'Vous avez tous deux répondu !',
      'streakDays': 'Jours de Série Amoureuse',
      'streakTitle': 'Série de Connexion',
      'streakEncourage': 'Votre amour s’épanouit chaque jour !',
      'partner': 'Partenaire',
      'you': 'Toi',
      'premium': 'GHARAR Premium',
      'appLanguage': 'Langue de l’Application',

      // Navigation
      'navHome': 'Accueil',
      'navDiscover': 'Découvrir',
      'navActivities': 'Activités',
      'navMemories': 'Souvenirs',
      'navProfile': 'Profil',

      // Onboarding
      'onboarding1Title': 'Un havre sacré rien que pour vous deux',
      'onboarding1Desc':
          'GHARAR est votre sanctuaire intime pour susciter des conversations profondes, explorer vos passions et chérir chaque instant.',
      'onboarding2Title': 'Des questions quotidiennes, des réponses secrètes',
      'onboarding2Desc':
          'Chaque jour apporte une question inspirante. Vos réponses restent voilées jusqu’à ce que chacun ait répondu, pour préserver la surprise !',
      'onboarding3Title': 'Aventures romantiques & complicité durable',
      'onboarding3Desc':
          'Des idées de rendez-vous poétiques, des quiz complices, des rêves d’avenir partagés et des rituels d’intimité émotionnelle.',
      'whatsYourName': 'Quel est ton prénom ?',
      'enterYourName': 'Saisis ton prénom',
      'selectLanguage': 'Choisis ta langue préférée',
      'relationshipStage': 'Où en est votre relation aujourd’hui ?',
      'stageDating': 'Rencontre & Découverte',
      'stageEngaged': 'Fiancés & Préparation du mariage',
      'stageNewlywed': 'Jeunes Mariés (Premières années)',
      'stageLongTerm': 'Partenaires de longue date',
      'stageMarriedWithKids': 'Mariés avec enfants',
      'stageLongDistance': 'Amour à distance',
      'selectGoals': 'Que souhaitez-vous faire grandir ensemble ?',
      'goalDeeperConversations': 'Conversations plus profondes',
      'goalSpontaneousRomance': 'Romantisme spontané',
      'goalUnderstandingNeeds': 'Comprendre les besoins émotionnels',
      'goalFuturePlanning': 'Harmoniser nos rêves d’avenir',
      'goalFunAdventures': 'Jeux complices & aventures',
      'goalConflictResolution': 'Communication douce & apaisement',

      // Partner Invite
      'invitePartnerTitle': 'Invite ton âme sœur',
      'invitePartnerSubtitle':
          'GHARAR a été pensé comme un cocon synchronisé pour deux. Partage ce code avec ton partenaire pour lier vos cœurs.',
      'yourInviteCode': 'Votre Code de Couple Unique',
      'enterPartnerCode': 'Ou entre le code de ton partenaire',
      'connectPartnerButton': 'Se Lier au Partenaire',
      'simulatedPartner': 'Simuler le Partenaire (Mode Démo)',
      'simulatedPartnerDesc':
          'Basculez d’un partenaire à l’autre pour tester la révélation instantanée en 1 clic !',

      // Home Dashboard
      'dailyGreetingMorning': 'Bonjour, chers amoureux',
      'dailyGreetingAfternoon': 'Bel après-midi',
      'dailyGreetingEvening': 'Douce soirée, belles âmes',
      'dailyQuestionCardTitle': 'Question de Connexion du Jour',
      'drawAnother': 'Tirer une Autre Question',
      'weeklyChallengeTitle': 'Défi de Couple de la Semaine',
      'sharedInterestTitle': 'Étincelle Partagée du Jour',
      'upcomingDateTitle': 'Prochaine Date Précieuse',
      'daysUntil': 'jours restants',

      // Daily Question
      'intensityIcebreaker': 'Léger & Espiègle 🌱',
      'intensityMeaningful': 'Sincère & Plein de Sens 🌿',
      'intensityDeep': 'Exploration Profonde de l’Âme 🌺',
      'yourAnswerHint':
          'Écris en toute sincérité avec ton cœur... Ton partenaire ne lira ceci qu’après avoir partagé sa réponse.',
      'privateAnswerNotice':
          '🔒 Strictement confidentiel jusqu’à la découverte mutuelle.',
      'partnerAnsweredNotice':
          'a répondu ! Écris ta réponse pour découvrir vos cœurs ensemble.',
      'partnerPendingNotice':
          'prend le temps de méditer. Écris la tienne dès maintenant pour être prêt !',
      'revealCelebration': 'Vos âmes se sont exprimées ! ✨',
      'reflectTogetherPrompt':
          'Prenez une douce inspiration et lisez à haute voix ce que vous avez écrit.',

      // Discover & Quizzes
      'discoverHubTitle': 'Découvrir & S’accorder',
      'sharedInterestsTab': 'Étincelles Communes',
      'quizGameTab': 'À quel point nous connaissons-nous ?',
      'differencesTab': 'Nos Belles Différences',
      'futureAlignmentTab': 'Vers où nous avançons ?',
      'quizSubtitle':
          'Devine ce que choisirait ton partenaire et savoure de douces révélations romantiques.',
      'compatibilityScore': 'Harmonie des Âmes',
      'planThisActivity': 'Organiser ce Rendez-vous Ensemble',
      'celebrateDifference':
          'C’est dans la différence que fleurit la tendresse. Voici une idée pour marier vos envies :',

      // Couple Activities
      'activitiesTitle': 'Rendez-vous & Moments Partagés',
      'filterAll': 'Toutes les Idées',
      'filterRomantic': 'Romantique',
      'filterAtHome': 'Cocon à la maison',
      'filterOutdoor': 'En plein air',
      'filterBudget': 'Doux pour le budget',
      'filterCreative': 'Créatif & Pétillant',
      'filterDuration': 'Temps nécessaire',
      'surpriseMe': 'Générateur de Surprises Romantiques 🎲',
      'markAsDone': 'Vécu et Gravé dans nos Mémoires',
      'activitySaved': 'Ajouté à Votre Liste de Vœux',

      // Memories & Journal
      'memoriesTitle': 'Notre Histoire & Journal',
      'timelineTab': 'Ligne du Temps',
      'journalTab': 'Journal Intime de Couple',
      'specialDatesTab': 'Dates Spéciales & Anniversaires',
      'addEntry': 'Ajouter un Mot d’Amour / Souvenir',
      'newMilestone': 'Nouvelle Étape Clé',
      'entryTitle': 'Titre du Souvenir',
      'entryReflection': 'Raconte ce qui a rendu ce moment inoubliable...',

      // AI Relationship Companion "Noor"
      'noorTitle': 'Noor • Compagnon de Relation',
      'noorSubtitle':
          'Un guide bienveillant et plein d’empathie pour inspirer des échanges sincères et des attentions douces.',
      'noorDisclaimer':
          'Noor offre de l’inspiration et des pistes d’écoute. Ne remplace pas une thérapie de couple professionnelle.',
      'noorPrompt1': 'Aide-moi à exprimer mes ressentis avec délicatesse',
      'noorPrompt2': 'Suggère une surprise intime à la maison pour ce soir',
      'noorPrompt3': 'Donne-nous une question émouvante pour ce soir',
      'noorPrompt4':
          'Comment concilier nos besoins différents d’énergie sociale ?',
      'askNoorHint':
          'Demande un conseil, une idée ou une inspiration à Noor...',

      // Profile & Settings
      'profileTitle': 'Espace du Couple & Paramètres',
      'switchPartner': 'Changer de Vue Partenaire (Démo)',
      'activeViewingAs': 'Actuellement vu sous le regard de :',
      'themeMode': 'Ambiance Visuelle',
      'lightRomantic': 'Crème & Rose Poudré (Clair)',
      'darkRomantic': 'Velours Bourgogne (Sombre Romantique)',
      'privacySecurity': 'Confidentialité & Sécurité',
      'exportData': 'Exporter Nos Souvenirs de Couple',
      'exportDataDesc':
          'Télécharge une belle sauvegarde de vos réponses et de votre journal.',
      'unlinkPartner': 'Dissocier le Partenaire',
      'unlinkWarning':
          'Cette action mettra fin à la session commune en toute sécurité.',
      'aboutApp': 'À propos de GHARAR',
      'resetDemo': 'Actualiser l’espace couple',

      // Authentication & Apple ID
      'authTitle': 'Bienvenue dans votre Sanctuaire',
      'authSubtitle':
          'Connectez-vous avec Apple ID ou votre e-mail pour approfondir votre lien.',
      'signInWithApple': 'Continuer avec Apple',
      'orDivider': 'ou continuer avec un e-mail',
      'nameHint': 'Votre Prénom',
      'emailHint': 'prenom@exemple.com',
      'passwordHint': 'Mot de passe (min. 6 caractères)',
      'authContinue': 'Entrer dans le Sanctuaire ➔',
      'signInTab': 'Connexion',
      'registerTab': 'Nouveau compte',
      'demoCoupleBtn': 'Entrer dans le sanctuaire',
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
      'connectToday': 'Connettiti Oggi',
      'today': 'Oggi',
      'save': 'Salva',
      'cancel': 'Annulla',
      'close': 'Chiudi',
      'continueText': 'Continua',
      'getStarted': 'Iniziate il Vostro Viaggio',
      'share': 'Condividi',
      'copy': 'Copia Codice',
      'copied': 'Copiato negli appunti!',
      'reveal': 'Svelare le Risposte Insieme',
      'completed': 'Completato',
      'saved': 'Salvato',
      'edit': 'Modifica',
      'delete': 'Elimina',
      'skip': 'Salta Domanda',
      'submit': 'Invia Risposta',
      'waitingPartner': 'In attesa del partner',
      'bothAnswered': 'Entrambi avete risposto!',
      'streakDays': 'Giorni di Intesa Continua',
      'streakTitle': 'Sequenza d’Amore',
      'streakEncourage': 'Il vostro amore fiorisce ogni giorno!',
      'partner': 'Partner',
      'you': 'Tu',
      'premium': 'GHARAR Premium',
      'appLanguage': 'Lingua dell’App',

      // Navigation
      'navHome': 'Home',
      'navDiscover': 'Scopri',
      'navActivities': 'Attività',
      'navMemories': 'Ricordi',
      'navProfile': 'Profilo',

      // Onboarding
      'onboarding1Title': 'Un rifugio sacro solo per voi due',
      'onboarding1Desc':
          'GHARAR è il vostro nido privato per accendere dialoghi intimi, scoprire passioni condivise e custodire ogni istante.',
      'onboarding2Title': 'Domande quotidiane, risposte segrete',
      'onboarding2Desc':
          'Ogni giorno una domanda colma di sentimento. Le risposte restano celate finché entrambi non rispondete, per donarvi la gioia della sorpresa!',
      'onboarding3Title': 'Avventure romantiche e profonda armonia',
      'onboarding3Desc':
          'Idee per appuntamenti poetici, quiz giocosi, sogni per il futuro ed esercizi per nutrire la vostra complicità emotiva.',
      'whatsYourName': 'Come ti chiami?',
      'enterYourName': 'Inserisci il tuo nome',
      'selectLanguage': 'Scegli la lingua desiderata',
      'relationshipStage': 'A quale punto è la vostra storia?',
      'stageDating': 'Frequentazione & Conoscenza',
      'stageEngaged': 'Fidanzati & Progetti di nozze',
      'stageNewlywed': 'Sposi Novelli (Primi anni)',
      'stageLongTerm': 'Compagni di lunga data',
      'stageMarriedWithKids': 'Sposati con figli',
      'stageLongDistance': 'Amore a distanza',
      'selectGoals': 'Cosa desiderate coltivare di più insieme?',
      'goalDeeperConversations': 'Conversazioni più profonde',
      'goalSpontaneousRomance': 'Romanticismo spontaneo',
      'goalUnderstandingNeeds': 'Comprendere i bisogni del cuore',
      'goalFuturePlanning': 'Armonizzare i sogni del futuro',
      'goalFunAdventures': 'Giochi complici & avventure',
      'goalConflictResolution': 'Dialogo gentile e riconciliazione',

      // Partner Invite
      'invitePartnerTitle': 'Invita la tua dolce metà',
      'invitePartnerSubtitle':
          'GHARAR è stato creato come uno spazio sincronizzato per due cuori. Condividi questo codice con il partner.',
      'yourInviteCode': 'Il Vostro Codice di Coppia',
      'enterPartnerCode': 'O inserisci il codice del partner',
      'connectPartnerButton': 'Collegati al Partner',
      'simulatedPartner': 'Simula Partner (Modalità Demo)',
      'simulatedPartnerDesc':
          'Alterna tra i due partner per provare subito l’emozione dello svelamento reciproco!',

      // Home Dashboard
      'dailyGreetingMorning': 'Buongiorno, anime care',
      'dailyGreetingAfternoon': 'Buon pomeriggio',
      'dailyGreetingEvening': 'Buona sera, cuori gentili',
      'dailyQuestionCardTitle': 'Domanda di Connessione Quotidiana',
      'drawAnother': 'Pesca un’Altra Domanda',
      'weeklyChallengeTitle': 'Sfida di Coppia della Settimana',
      'sharedInterestTitle': 'Scintilla Condivisa del Giorno',
      'upcomingDateTitle': 'Prossima Ricorrenza Speciale',
      'daysUntil': 'giorni rimasti',

      // Daily Question
      'intensityIcebreaker': 'Leggero & Giocoso 🌱',
      'intensityMeaningful': 'Sentito & Significativo 🌿',
      'intensityDeep': 'Esplorazione Profonda dell’Anima 🌺',
      'yourAnswerHint':
          'Scrivi sinceramente con tutto il cuore... Il tuo partner potrà leggere queste righe solo dopo aver risposto a sua volta.',
      'privateAnswerNotice':
          '🔒 Rigorosamente privato fino allo svelamento congiunto.',
      'partnerAnsweredNotice':
          'ha già risposto! Invia la tua risposta per scoprirvi insieme.',
      'partnerPendingNotice':
          'sta raccogliendo i pensieri. Scrivi ora per farti trovare pronto!',
      'revealCelebration': 'I vostri cuori si sono parlati! ✨',
      'reflectTogetherPrompt':
          'Fate un respiro profondo e leggete ad alta voce i pensieri dell’altro.',

      // Discover & Quizzes
      'discoverHubTitle': 'Scopri & Armonizza',
      'sharedInterestsTab': 'Scintille Comuni',
      'quizGameTab': 'Quanto ci conosciamo?',
      'differencesTab': 'Le Nostre Belle Differenze',
      'futureAlignmentTab': 'Dove stiamo andando?',
      'quizSubtitle':
          'Indovina cosa sceglierebbe il partner e scopri sguardi dolci e inaspettati.',
      'compatibilityScore': 'Armonia delle Anime',
      'planThisActivity': 'Organizza questa Uscita Insieme',
      'celebrateDifference':
          'Nella diversità fiorisce la curiosità. Ecco un modo soave per abbracciare entrambi i gusti:',

      // Couple Activities
      'activitiesTitle': 'Esperienze & Appuntamenti di Coppia',
      'filterAll': 'Tutte le Idee',
      'filterRomantic': 'Romantico',
      'filterAtHome': 'Nell’intimità di casa',
      'filterOutdoor': 'All’aria aperta',
      'filterBudget': 'Semplice & Accessibile',
      'filterCreative': 'Creativo & Giocoso',
      'filterDuration': 'Tempo necessario',
      'surpriseMe': 'Generatore di Sorprese Romantiche 🎲',
      'markAsDone': 'Vissuto & Custodito nei Ricordi',
      'activitySaved': 'Aggiunto alla Vostra Lista dei Desideri',

      // Memories & Journal
      'memoriesTitle': 'La Nostra Storia & Diario',
      'timelineTab': 'Linea del Tempo',
      'journalTab': 'Diario Privato di Coppia',
      'specialDatesTab': 'Date Speciali & Anniversari',
      'addEntry': 'Aggiungi Nota d’Amore / Ricordo',
      'newMilestone': 'Nuova Tappa',
      'entryTitle': 'Titolo del Ricordo',
      'entryReflection':
          'Racconta cosa ha reso indimenticabile questo istante...',

      // AI Relationship Companion "Noor"
      'noorTitle': 'Noor • Guida di Coppia',
      'noorSubtitle':
          'Una guida delicata ed empatica per ispirare dialoghi accoglienti e gesti pieni d’affetto.',
      'noorDisclaimer':
          'Noor offre ispirazione e suggerimenti di comunicazione. Non sostituisce una consulenza di coppia professionale.',
      'noorPrompt1': 'Aiutami a esprimere i miei sentimenti con gentilezza',
      'noorPrompt2': 'Suggerisci una dolce sorpresa a casa per stasera',
      'noorPrompt3': 'Donaci una domanda suggestiva per chiacchierare stanotte',
      'noorPrompt4':
          'Come conciliare i nostri diversi livelli di energia sociale?',
      'askNoorHint':
          'Chiedi a Noor un consiglio, un’idea per un appuntamento o uno spunto...',

      // Profile & Settings
      'profileTitle': 'Spazio di Coppia & Impostazioni',
      'switchPartner': 'Cambia Vista Partner (Demo)',
      'activeViewingAs': 'Stai visualizzando come:',
      'themeMode': 'Stile Visivo',
      'lightRomantic': 'Crema & Rosa Cipria (Chiaro)',
      'darkRomantic': 'Velluto Borgogna (Scuro Romantico)',
      'privacySecurity': 'Privacy & Sicurezza',
      'exportData': 'Esporta i Ricordi di Coppia',
      'exportDataDesc':
          'Scarica un elegante archivio delle vostre risposte e del diario.',
      'unlinkPartner': 'Scollega Partner',
      'unlinkWarning':
          'Questo interromperà la sessione condivisa in sicurezza.',
      'aboutApp': 'Informazioni su GHARAR',
      'resetDemo': 'Aggiorna spazio di coppia',

      // Authentication & Apple ID
      'authTitle': 'Benvenuti nel vostro Santuario',
      'authSubtitle':
          'Accedi con Apple ID o la tua e-mail per approfondire il vostro legame.',
      'signInWithApple': 'Accedi con Apple',
      'orDivider': 'oppure continua con e-mail',
      'nameHint': 'Il tuo Nome',
      'emailHint': 'nome@esempio.it',
      'passwordHint': 'Password (almeno 6 caratteri)',
      'authContinue': 'Entra nel Santuario ➔',
      'signInTab': 'Accedi',
      'registerTab': 'Nuovo account',
      'demoCoupleBtn': 'Entra nel santuario',
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
