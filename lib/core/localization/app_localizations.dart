import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// GHARAR Dual-Language Localization Engine (English & Turkish)
/// Preserves warmth, emotional nuance, and romantic intimacy in both languages.
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  bool get isTurkish => locale.languageCode == 'tr';

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // General & Brand
      'appName': 'GHARAR',
      'appTagline': 'Deepen your bond, every single day',
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

      // Navigation
      'navHome': 'Home',
      'navDiscover': 'Discover',
      'navActivities': 'Activities',
      'navMemories': 'Memories',
      'navProfile': 'Profile',

      // Onboarding
      'onboarding1Title': 'A Sacred Space Just for the Two of You',
      'onboarding1Desc': 'GHARAR is your private sanctuary to spark deep conversations, discover shared passions, and cherish every moment.',
      'onboarding2Title': 'Daily Questions, Answered Privately',
      'onboarding2Desc': 'Each day brings a thoughtful question. Your answers remain hidden until both of you have answered, preserving authentic surprise!',
      'onboarding3Title': 'Romantic Adventures & Lifelong Growth',
      'onboarding3Desc': 'Curated date ideas, playful quizzes, shared future dreams, and emotional intimacy exercises tailored to your unique love story.',
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
      'invitePartnerSubtitle': 'GHARAR is designed as a synchronized sanctuary for two. Share this invite code with your partner to link your hearts.',
      'yourInviteCode': 'Your Unique Couple Code',
      'enterPartnerCode': 'Or enter partner’s code to connect',
      'connectPartnerButton': 'Connect to Partner',
      'simulatedPartner': 'Simulate Partner (Demo Mode)',
      'simulatedPartnerDesc': 'Toggle between partners or test mutual reveals instantly with 1-click!',

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
      'yourAnswerHint': 'Speak honestly from your heart... Your partner will only see this once they also submit their answer.',
      'privateAnswerNotice': '🔒 Strictly Private until mutual reveal. No peeking allowed!',
      'partnerAnsweredNotice': 'has submitted their answer! Answer now to reveal together.',
      'partnerPendingNotice': 'is taking their time to think. Answer yours now so you are ready!',
      'revealCelebration': 'Your Souls Have Spoken! ✨',
      'reflectTogetherPrompt': 'Take a gentle breath and read each other’s thoughts aloud.',

      // Discover & Quizzes
      'discoverHubTitle': 'Discover & Align',
      'sharedInterestsTab': 'Shared Sparks',
      'quizGameTab': 'How Well Do We Know Us?',
      'differencesTab': 'Beautiful Differences',
      'futureAlignmentTab': 'Where Are We Heading?',
      'quizSubtitle': 'Predict your partner’s thoughts and unlock playful, romantic insights.',
      'compatibilityScore': 'Soul Harmony',
      'planThisActivity': 'Plan this Date Together',
      'celebrateDifference': 'Difference is where curiosity blooms. Here is a sweet way to blend both preferences:',

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
      'noorSubtitle': 'A gentle, empathetic guide to inspire meaningful conversations, nonjudgmental reflections, and loving gestures.',
      'noorDisclaimer': 'Noor provides inspiration and gentle communication tips. Not a substitute for professional couples therapy.',
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
      'exportDataDesc': 'Download a beautiful backup of your shared answers and journal.',
      'unlinkPartner': 'Unlink Partner',
      'unlinkWarning': 'This will safely disconnect the couple session.',
      'aboutApp': 'About GHARAR',
      'resetDemo': 'Reset to Demo Couple (Mitra & Deniz)',
    },
    'tr': {
      // General & Brand
      'appName': 'GHARAR',
      'appTagline': 'Her gün birbirinize bir adım daha yakın',
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

      // Navigation
      'navHome': 'Ana Sayfa',
      'navDiscover': 'Keşfet',
      'navActivities': 'Aktiviteler',
      'navMemories': 'Anılarımız',
      'navProfile': 'Profil',

      // Onboarding
      'onboarding1Title': 'Sadece İkinize Özel Masalsı Bir Alan',
      'onboarding1Desc': 'GHARAR; derin sohbetler başlatmak, ortak tutkuları keşfetmek ve her anı ölümsüzleştirmek için tasarlanmış özel sığınağınızdır.',
      'onboarding2Title': 'Günlük Sorular, Gizli Cevaplar',
      'onboarding2Desc': 'Her gün ikinize özel düşünceli bir soru gelir. İkiniz de cevaplayana kadar yanıtlar gizli kalır, sürprizin büyüsü bozulmaz!',
      'onboarding3Title': 'Romantik Maceralar ve Derin Uyum',
      'onboarding3Desc': 'Özenle seçilmiş randevu fikirleri, eğlenceli testler, ortak gelecek hayalleri ve ilişkinizi besleyen duygusal egzersizler.',
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
      'invitePartnerSubtitle': 'GHARAR, iki kalbin senkronize olması için tasarlandı. Bu özel kodu partnerinle paylaşarak alanınızı birleştirin.',
      'yourInviteCode': 'Size Özel Çift Kodu',
      'enterPartnerCode': 'Veya partnerinizin kodunu girin',
      'connectPartnerButton': 'Partnere Bağlan',
      'simulatedPartner': 'Partner Simülasyonu (Demo Modu)',
      'simulatedPartnerDesc': 'Karşılıklı cevap açılma deneyimini tek tıkla partner bakış açısıyla hemen deneyin!',

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
      'yourAnswerHint': 'Tüm kalbinizle içtenlikle yazın... Partneriniz bu cevabı sadece kendisi de yazınca görebilecek.',
      'privateAnswerNotice': '🔒 Karşılıklı açılana kadar tamamen gizli. Kimse bakamaz!',
      'partnerAnsweredNotice': 'cevabını yazdı bile! Birlikte okumak için şimdi yanıtlayın.',
      'partnerPendingNotice': 'düşüncelerini toparlıyor. Sizinkini hemen kaydedin, hazır olun!',
      'revealCelebration': 'Cevaplarınız Aydınlandı! ✨',
      'reflectTogetherPrompt': 'Derin bir nefes alın ve birbirinizin yazdıklarını sesli olarak okuyun.',

      // Discover & Quizzes
      'discoverHubTitle': 'Keşfet & Uyum Sağla',
      'sharedInterestsTab': 'Ortak Kıvılcımlar',
      'quizGameTab': 'Bizi Ne Kadar Tanıyoruz?',
      'differencesTab': 'Güzel Farklılıklarımız',
      'futureAlignmentTab': 'Nereye Doğru İlerliyoruz?',
      'quizSubtitle': 'Partnerinizin ne seçeceğini tahmin edin, tatlı ve merak uyandıran sürprizler keşfedin.',
      'compatibilityScore': 'Ruh Uyumu',
      'planThisActivity': 'Bu Randevuyu Birlikte Planla',
      'celebrateDifference': 'Farklılıklar merakın doğduğu yerdir. İkinizin zevkini birleştiren tatlı bir öneri:',

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
      'noorSubtitle': 'Daha yapıcı konuşmalar, şefkatli yansımalar ve romantik fikirler için nazik bir yapay zeka rehberi.',
      'noorDisclaimer': 'Noor sadece ilham ve nazik iletişim ipuçları sunar. Profesyonel çift terapisi yerine geçmez.',
      'noorPrompt1': 'Duygularımı incitmeden nasıl ifade edebilirim?',
      'noorPrompt2': 'Bu akşam için evde tatlı bir sürpriz öner',
      'noorPrompt3': 'Bize bu gece için düşündürücü bir soru ver',
      'noorPrompt4': 'Farklı sosyal enerji seviyelerimizi nasıl dengeleriz?',
      'askNoorHint': 'Noor’a bir soru sorun, tavsiye veya randevu fikri isteyin...',

      // Profile & Settings
      'profileTitle': 'Çift Alanı & Ayarlar',
      'switchPartner': 'Görünüm Değiştir (Simülasyon)',
      'activeViewingAs': 'Şu anda görüntüleyen:',
      'themeMode': 'Görünüm & Tema',
      'lightRomantic': 'Yumuşak Krem & Pudra (Açık)',
      'darkRomantic': 'Kadife Bordo (Koyu Romantik)',
      'privacySecurity': 'Gizlilik & Güvenlik Kontrolleri',
      'exportData': 'Çift Anılarını Dışa Aktar',
      'exportDataDesc': 'Cevaplarınızın ve günlüğünüzün güzel bir yedeğini indirin.',
      'unlinkPartner': 'Partner Bağını Kopar',
      'unlinkWarning': 'Bu işlem mevcut çift eşleşmesini güvenle sonlandırır.',
      'aboutApp': 'GHARAR Hakkında',
      'resetDemo': 'Demo Çift Verilerine Dön (Mitra & Deniz)',
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
  bool isSupported(Locale locale) => ['en', 'tr'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
