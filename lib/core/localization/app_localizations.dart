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
      // Distance mode, visual notes & home widget
      'distanceTitle': 'OUR DISTANCE',
      'distanceTogether': 'Close by',
      'distanceLong': 'Long distance',
      'togetherHeadline': 'Same city, same sky',
      'togetherRitualLabel': 'Tonight\'s tiny ritual',
      'togetherRitual1':
          'Cook one new recipe together, phones left in another room.',
      'togetherRitual2':
          'Take a 20-minute walk and share one thing that made you smile today.',
      'togetherRitual3':
          'Slow-dance in the kitchen to the first song you both loved.',
      'togetherRitual4':
          'Write three things you appreciate about each other and swap notes.',
      'togetherNextIdea': 'Another idea',
      'ldrPartnerTime': '{name} right now',
      'ldrSetTimezone': 'Set time zone',
      'ldrUntilMeeting': 'Until we meet',
      'ldrDaysLeft': '{days} days',
      'ldrMeetingToday': 'Today! 🎉',
      'ldrSetMeeting': 'Pick reunion date',
      'noteModeText': 'Write',
      'noteModeDraw': 'Handwrite',
      'noteModePhoto': 'Photo',
      'drawHint': 'Write or draw with your finger',
      'drawUndo': 'Undo',
      'drawClear': 'Clear',
      'photoCamera': 'Camera',
      'photoGallery': 'Gallery',
      'photoCaptionHint': 'Add a short caption (optional)',
      'visualNoteEmpty': 'Draw something or pick a photo first.',
      'visualNoteSaveError': 'Couldn\'t save your note. Please try again.',
      'photoPickError': 'Couldn\'t open the photo. Please try again.',
      'visualNoteSend': 'Send to their home screen 📲',
      'visualNoteSent':
          'Sent! It will appear on {name}\'s home screen widget 📲',
      'widgetFrom': 'From {name}',
      'widgetAddToHome': 'Add widget to home screen',
      // Navigation (3 tabs)
      'navToday': 'Today',
      'navExplore': 'Explore',
      'navUs': 'Us',
      'themeTitle': 'Appearance',
      'themeSystem': 'System',
      'themeLight': 'Light',
      'themeDark': 'Dark',
      'themeToggle': 'Switch light/dark theme',
      'exploreGames': 'Games',
      'exploreDates': 'Dates',
      'exploreMemories': 'Memories',
      // Names
      'nameYou': 'You',
      'nameYourSoulmate': 'Your Soulmate',
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
      // Distance mode, visual notes & home widget
      'distanceTitle': 'ARAMIZDAKİ MESAFE',
      'distanceTogether': 'Yakın Mesafe',
      'distanceLong': 'Uzak Mesafe',
      'togetherHeadline': 'Aynı şehir, aynı gökyüzü',
      'togetherRitualLabel': 'Bu akşamın küçük ritüeli',
      'togetherRitual1':
          'Telefonları başka odaya bırakıp birlikte yeni bir tarif deneyin.',
      'togetherRitual2':
          '20 dakikalık bir yürüyüşe çıkın, bugün sizi gülümseten bir şeyi paylaşın.',
      'togetherRitual3':
          'İkinizin de ilk sevdiği şarkıyla mutfakta ağır ağır dans edin.',
      'togetherRitual4':
          'Birbirinizde sevdiğiniz üç şeyi yazıp kâğıtları değişin.',
      'togetherNextIdea': 'Başka fikir',
      'ldrPartnerTime': '{name} şu an',
      'ldrSetTimezone': 'Saat dilimini ayarla',
      'ldrUntilMeeting': 'Kavuşmaya',
      'ldrDaysLeft': '{days} gün',
      'ldrMeetingToday': 'Bugün! 🎉',
      'ldrSetMeeting': 'Buluşma tarihi seç',
      'noteModeText': 'Yaz',
      'noteModeDraw': 'El yazısı',
      'noteModePhoto': 'Fotoğraf',
      'drawHint': 'Parmağınla yaz ya da çiz',
      'drawUndo': 'Geri al',
      'drawClear': 'Temizle',
      'photoCamera': 'Kamera',
      'photoGallery': 'Galeri',
      'photoCaptionHint': 'Kısa bir not ekle (isteğe bağlı)',
      'visualNoteEmpty': 'Önce bir şey çiz ya da fotoğraf seç.',
      'visualNoteSaveError': 'Not kaydedilemedi. Lütfen tekrar dene.',
      'photoPickError': 'Fotoğraf açılamadı. Lütfen tekrar dene.',
      'visualNoteSend': 'Ana ekranına gönder 📲',
      'visualNoteSent': 'Gönderildi! {name} ana ekran widget’ında görecek 📲',
      'widgetFrom': 'Kimden: {name}',
      'widgetAddToHome': 'Widget’ı ana ekrana ekle',
      // Navigation (3 tabs)
      'navToday': 'Bugün',
      'navExplore': 'Keşfet',
      'navUs': 'Biz',
      'themeTitle': 'Görünüm',
      'themeSystem': 'Sistem',
      'themeLight': 'Açık',
      'themeDark': 'Koyu',
      'themeToggle': 'Açık/koyu temaya geç',
      'exploreGames': 'Oyunlar',
      'exploreDates': 'Randevu',
      'exploreMemories': 'Anılar',
      // Names
      'nameYou': 'Sen',
      'nameYourSoulmate': 'Ruh Eşin',
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
      // Distance mode, visual notes & home widget
      'distanceTitle': 'المسافة بيننا',
      'distanceTogether': 'قريبان',
      'distanceLong': 'عن بُعد',
      'togetherHeadline': 'المدينة نفسها، السماء نفسها',
      'togetherRitualLabel': 'طقس صغير لهذه الليلة',
      'togetherRitual1': 'اطبخا وصفة جديدة معاً واتركا الهواتف في غرفة أخرى.',
      'togetherRitual2': 'تمشّيا عشرين دقيقة وشاركا شيئاً أسعدكما اليوم.',
      'togetherRitual3': 'ارقصا ببطء في المطبخ على أول أغنية أحببتماها.',
      'togetherRitual4':
          'اكتبا ثلاثة أشياء تقدّرانها في بعضكما وتبادلا الأوراق.',
      'togetherNextIdea': 'فكرة أخرى',
      'ldrPartnerTime': '{name} الآن',
      'ldrSetTimezone': 'اضبط المنطقة الزمنية',
      'ldrUntilMeeting': 'حتى نلتقي',
      'ldrDaysLeft': '{days} يوم',
      'ldrMeetingToday': 'اليوم! 🎉',
      'ldrSetMeeting': 'اختر موعد اللقاء',
      'noteModeText': 'اكتب',
      'noteModeDraw': 'بخط اليد',
      'noteModePhoto': 'صورة',
      'drawHint': 'اكتب أو ارسم بإصبعك',
      'drawUndo': 'تراجع',
      'drawClear': 'مسح',
      'photoCamera': 'الكاميرا',
      'photoGallery': 'المعرض',
      'photoCaptionHint': 'أضف تعليقاً قصيراً (اختياري)',
      'visualNoteEmpty': 'ارسم شيئاً أو اختر صورة أولاً.',
      'visualNoteSaveError': 'تعذّر حفظ رسالتك. حاول مرة أخرى.',
      'photoPickError': 'تعذّر فتح الصورة. حاول مرة أخرى.',
      'visualNoteSend': 'أرسل إلى شاشته الرئيسية 📲',
      'visualNoteSent':
          'تم الإرسال! ستظهر في أداة {name} على الشاشة الرئيسية 📲',
      'widgetFrom': 'من {name}',
      'widgetAddToHome': 'أضف الأداة إلى الشاشة الرئيسية',
      // Navigation (3 tabs)
      'navToday': 'اليوم',
      'navExplore': 'اكتشف',
      'navUs': 'نحن',
      'themeTitle': 'المظهر',
      'themeSystem': 'النظام',
      'themeLight': 'فاتح',
      'themeDark': 'داكن',
      'themeToggle': 'التبديل بين الوضع الفاتح والداكن',
      'exploreGames': 'ألعاب',
      'exploreDates': 'مواعيد',
      'exploreMemories': 'ذكريات',
      // Names
      'nameYou': 'أنت',
      'nameYourSoulmate': 'توأم روحك',
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
      // Distance mode, visual notes & home widget
      'distanceTitle': 'فاصله‌ی ما',
      'distanceTogether': 'نزدیک',
      'distanceLong': 'از راه دور',
      'togetherHeadline': 'یک شهر، یک آسمان',
      'togetherRitualLabel': 'آیین کوچک امشب',
      'togetherRitual1':
          'با هم یک دستور پخت تازه امتحان کنید و گوشی‌ها را در اتاق دیگری بگذارید.',
      'togetherRitual2':
          'بیست دقیقه قدم بزنید و از چیزی بگویید که امروز لبخندتان را ساخت.',
      'togetherRitual3':
          'با اولین آهنگی که هر دو دوستش داشتید، آرام در آشپزخانه برقصید.',
      'togetherRitual4':
          'سه چیزی را که در هم دوست دارید بنویسید و کاغذها را عوض کنید.',
      'togetherNextIdea': 'ایده‌ی دیگر',
      'ldrPartnerTime': '{name} همین حالا',
      'ldrSetTimezone': 'تنظیم منطقه‌ی زمانی',
      'ldrUntilMeeting': 'تا دیدار',
      'ldrDaysLeft': '{days} روز',
      'ldrMeetingToday': 'امروز! 🎉',
      'ldrSetMeeting': 'انتخاب تاریخ دیدار',
      'noteModeText': 'نوشتن',
      'noteModeDraw': 'دست‌نویس',
      'noteModePhoto': 'عکس',
      'drawHint': 'با انگشتت بنویس یا نقاشی کن',
      'drawUndo': 'برگرداندن',
      'drawClear': 'پاک کردن',
      'photoCamera': 'دوربین',
      'photoGallery': 'گالری',
      'photoCaptionHint': 'یک توضیح کوتاه اضافه کن (اختیاری)',
      'visualNoteEmpty': 'اول چیزی بکش یا عکسی انتخاب کن.',
      'visualNoteSaveError': 'یادداشتت ذخیره نشد. دوباره تلاش کن.',
      'photoPickError': 'عکس باز نشد. دوباره تلاش کن.',
      'visualNoteSend': 'ارسال به صفحه‌ی اصلی‌اش 📲',
      'visualNoteSent': 'ارسال شد! در ویجت صفحه‌ی اصلی {name} دیده می‌شود 📲',
      'widgetFrom': 'از طرف {name}',
      'widgetAddToHome': 'افزودن ویجت به صفحه‌ی اصلی',
      // Navigation (3 tabs)
      'navToday': 'امروز',
      'navExplore': 'کاوش',
      'navUs': 'ما',
      'themeTitle': 'ظاهر',
      'themeSystem': 'سیستم',
      'themeLight': 'روشن',
      'themeDark': 'تیره',
      'themeToggle': 'تغییر پوسته روشن/تیره',
      'exploreGames': 'بازی‌ها',
      'exploreDates': 'قرارها',
      'exploreMemories': 'خاطره‌ها',
      // Names
      'nameYou': 'تو',
      'nameYourSoulmate': 'نیمه‌ی گمشده‌ات',
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
      // Distance mode, visual notes & home widget
      'distanceTitle': 'UNSERE DISTANZ',
      'distanceTogether': 'Ganz nah',
      'distanceLong': 'Fernbeziehung',
      'togetherHeadline': 'Gleiche Stadt, gleicher Himmel',
      'togetherRitualLabel': 'Kleines Ritual für heute Abend',
      'togetherRitual1':
          'Kocht gemeinsam ein neues Rezept – die Handys bleiben im anderen Zimmer.',
      'togetherRitual2':
          'Macht einen 20-minütigen Spaziergang und erzählt, was euch heute zum Lächeln gebracht hat.',
      'togetherRitual3':
          'Tanzt langsam in der Küche zu dem ersten Lied, das ihr beide geliebt habt.',
      'togetherRitual4':
          'Schreibt drei Dinge auf, die ihr aneinander schätzt, und tauscht die Zettel.',
      'togetherNextIdea': 'Andere Idee',
      'ldrPartnerTime': '{name} gerade',
      'ldrSetTimezone': 'Zeitzone festlegen',
      'ldrUntilMeeting': 'Bis wir uns sehen',
      'ldrDaysLeft': '{days} Tage',
      'ldrMeetingToday': 'Heute! 🎉',
      'ldrSetMeeting': 'Wiedersehen planen',
      'noteModeText': 'Schreiben',
      'noteModeDraw': 'Handschrift',
      'noteModePhoto': 'Foto',
      'drawHint': 'Schreib oder zeichne mit dem Finger',
      'drawUndo': 'Rückgängig',
      'drawClear': 'Löschen',
      'photoCamera': 'Kamera',
      'photoGallery': 'Galerie',
      'photoCaptionHint': 'Kurze Bildunterschrift (optional)',
      'visualNoteEmpty': 'Zeichne zuerst etwas oder wähle ein Foto.',
      'visualNoteSaveError':
          'Deine Notiz konnte nicht gespeichert werden. Bitte versuche es erneut.',
      'photoPickError':
          'Das Foto konnte nicht geöffnet werden. Bitte versuche es erneut.',
      'visualNoteSend': 'Auf den Startbildschirm senden 📲',
      'visualNoteSent': 'Gesendet! Es erscheint im Widget von {name} 📲',
      'widgetFrom': 'Von {name}',
      'widgetAddToHome': 'Widget zum Startbildschirm hinzufügen',
      // Navigation (3 tabs)
      'navToday': 'Heute',
      'navExplore': 'Entdecken',
      'navUs': 'Wir',
      'themeTitle': 'Darstellung',
      'themeSystem': 'System',
      'themeLight': 'Hell',
      'themeDark': 'Dunkel',
      'themeToggle': 'Hell/Dunkel wechseln',
      'exploreGames': 'Spiele',
      'exploreDates': 'Dates',
      'exploreMemories': 'Erinnerungen',
      // Names
      'nameYou': 'Du',
      'nameYourSoulmate': 'Dein Seelenverwandter',
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
      // Distance mode, visual notes & home widget
      'distanceTitle': 'NUESTRA DISTANCIA',
      'distanceTogether': 'Cerca',
      'distanceLong': 'A distancia',
      'togetherHeadline': 'Misma ciudad, mismo cielo',
      'togetherRitualLabel': 'El pequeño ritual de esta noche',
      'togetherRitual1':
          'Cocinad juntos una receta nueva, con los móviles en otra habitación.',
      'togetherRitual2':
          'Dad un paseo de 20 minutos y contad algo que os hizo sonreír hoy.',
      'togetherRitual3':
          'Bailad despacio en la cocina con la primera canción que os enamoró.',
      'togetherRitual4':
          'Escribid tres cosas que admiráis el uno del otro e intercambiad los papeles.',
      'togetherNextIdea': 'Otra idea',
      'ldrPartnerTime': '{name} ahora',
      'ldrSetTimezone': 'Configurar zona horaria',
      'ldrUntilMeeting': 'Hasta vernos',
      'ldrDaysLeft': '{days} días',
      'ldrMeetingToday': '¡Hoy! 🎉',
      'ldrSetMeeting': 'Elegir fecha del reencuentro',
      'noteModeText': 'Escribir',
      'noteModeDraw': 'A mano',
      'noteModePhoto': 'Foto',
      'drawHint': 'Escribe o dibuja con el dedo',
      'drawUndo': 'Deshacer',
      'drawClear': 'Borrar',
      'photoCamera': 'Cámara',
      'photoGallery': 'Galería',
      'photoCaptionHint': 'Añade un pie corto (opcional)',
      'visualNoteEmpty': 'Dibuja algo o elige una foto primero.',
      'visualNoteSaveError': 'No se pudo guardar tu nota. Inténtalo de nuevo.',
      'photoPickError': 'No se pudo abrir la foto. Inténtalo de nuevo.',
      'visualNoteSend': 'Enviar a su pantalla de inicio 📲',
      'visualNoteSent': '¡Enviado! Aparecerá en el widget de {name} 📲',
      'widgetFrom': 'De {name}',
      'widgetAddToHome': 'Añadir widget a la pantalla de inicio',
      // Navigation (3 tabs)
      'navToday': 'Hoy',
      'navExplore': 'Explorar',
      'navUs': 'Nosotros',
      'themeTitle': 'Apariencia',
      'themeSystem': 'Sistema',
      'themeLight': 'Claro',
      'themeDark': 'Oscuro',
      'themeToggle': 'Cambiar tema claro/oscuro',
      'exploreGames': 'Juegos',
      'exploreDates': 'Citas',
      'exploreMemories': 'Recuerdos',
      // Names
      'nameYou': 'Tú',
      'nameYourSoulmate': 'Tu alma gemela',
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
      // Distance mode, visual notes & home widget
      'distanceTitle': 'NOTRE DISTANCE',
      'distanceTogether': 'Tout près',
      'distanceLong': 'À distance',
      'togetherHeadline': 'Même ville, même ciel',
      'togetherRitualLabel': 'Le petit rituel de ce soir',
      'togetherRitual1':
          'Cuisinez ensemble une nouvelle recette, téléphones dans une autre pièce.',
      'togetherRitual2':
          'Faites une marche de 20 minutes et partagez ce qui vous a fait sourire aujourd\'hui.',
      'togetherRitual3':
          'Dansez lentement dans la cuisine sur la première chanson que vous avez aimée tous les deux.',
      'togetherRitual4':
          'Écrivez trois choses que vous appréciez l\'un chez l\'autre et échangez vos papiers.',
      'togetherNextIdea': 'Autre idée',
      'ldrPartnerTime': '{name} en ce moment',
      'ldrSetTimezone': 'Définir le fuseau horaire',
      'ldrUntilMeeting': 'Jusqu\'aux retrouvailles',
      'ldrDaysLeft': '{days} jours',
      'ldrMeetingToday': 'Aujourd\'hui ! 🎉',
      'ldrSetMeeting': 'Choisir la date des retrouvailles',
      'noteModeText': 'Écrire',
      'noteModeDraw': 'Manuscrit',
      'noteModePhoto': 'Photo',
      'drawHint': 'Écris ou dessine avec ton doigt',
      'drawUndo': 'Annuler',
      'drawClear': 'Effacer',
      'photoCamera': 'Appareil photo',
      'photoGallery': 'Galerie',
      'photoCaptionHint': 'Ajoute une courte légende (facultatif)',
      'visualNoteEmpty': 'Dessine quelque chose ou choisis d\'abord une photo.',
      'visualNoteSaveError': 'Impossible d\'enregistrer ta note. Réessaie.',
      'photoPickError': 'Impossible d\'ouvrir la photo. Réessaie.',
      'visualNoteSend': 'Envoyer sur son écran d\'accueil 📲',
      'visualNoteSent': 'Envoyé ! Visible dans le widget de {name} 📲',
      'widgetFrom': 'De {name}',
      'widgetAddToHome': 'Ajouter le widget à l\'écran d\'accueil',
      // Navigation (3 tabs)
      'navToday': 'Aujourd\'hui',
      'navExplore': 'Explorer',
      'navUs': 'Nous',
      'themeTitle': 'Apparence',
      'themeSystem': 'Système',
      'themeLight': 'Clair',
      'themeDark': 'Sombre',
      'themeToggle': 'Basculer thème clair/sombre',
      'exploreGames': 'Jeux',
      'exploreDates': 'Sorties',
      'exploreMemories': 'Souvenirs',
      // Names
      'nameYou': 'Toi',
      'nameYourSoulmate': 'Ton âme sœur',
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
      // Distance mode, visual notes & home widget
      'distanceTitle': 'LA NOSTRA DISTANZA',
      'distanceTogether': 'Vicini',
      'distanceLong': 'A distanza',
      'togetherHeadline': 'Stessa città, stesso cielo',
      'togetherRitualLabel': 'Il piccolo rituale di stasera',
      'togetherRitual1':
          'Cucinate insieme una ricetta nuova, con i telefoni in un\'altra stanza.',
      'togetherRitual2':
          'Fate una passeggiata di 20 minuti e raccontatevi cosa vi ha fatto sorridere oggi.',
      'togetherRitual3':
          'Ballate lentamente in cucina sulla prima canzone che avete amato insieme.',
      'togetherRitual4':
          'Scrivete tre cose che apprezzate l\'uno dell\'altra e scambiatevi i bigliettini.',
      'togetherNextIdea': 'Un\'altra idea',
      'ldrPartnerTime': '{name} adesso',
      'ldrSetTimezone': 'Imposta fuso orario',
      'ldrUntilMeeting': 'Al prossimo incontro',
      'ldrDaysLeft': '{days} giorni',
      'ldrMeetingToday': 'Oggi! 🎉',
      'ldrSetMeeting': 'Scegli la data dell\'incontro',
      'noteModeText': 'Scrivi',
      'noteModeDraw': 'A mano',
      'noteModePhoto': 'Foto',
      'drawHint': 'Scrivi o disegna con il dito',
      'drawUndo': 'Annulla',
      'drawClear': 'Cancella',
      'photoCamera': 'Fotocamera',
      'photoGallery': 'Galleria',
      'photoCaptionHint': 'Aggiungi una breve didascalia (facoltativa)',
      'visualNoteEmpty': 'Prima disegna qualcosa o scegli una foto.',
      'visualNoteSaveError': 'Impossibile salvare la nota. Riprova.',
      'photoPickError': 'Impossibile aprire la foto. Riprova.',
      'visualNoteSend': 'Invia alla sua schermata Home 📲',
      'visualNoteSent': 'Inviato! Comparirà nel widget di {name} 📲',
      'widgetFrom': 'Da {name}',
      'widgetAddToHome': 'Aggiungi il widget alla schermata Home',
      // Navigation (3 tabs)
      'navToday': 'Oggi',
      'navExplore': 'Esplora',
      'navUs': 'Noi',
      'themeTitle': 'Aspetto',
      'themeSystem': 'Sistema',
      'themeLight': 'Chiaro',
      'themeDark': 'Scuro',
      'themeToggle': 'Cambia tema chiaro/scuro',
      'exploreGames': 'Giochi',
      'exploreDates': 'Appuntamenti',
      'exploreMemories': 'Ricordi',
      // Names
      'nameYou': 'Tu',
      'nameYourSoulmate': 'La tua anima gemella',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }

  String t(String key) => translate(key);

  bool hasKey(String key) =>
      _localizedValues[locale.languageCode]?.containsKey(key) ?? false;

  /// Translates [key] and fills `{placeholder}` tokens from [args].
  String format(String key, Map<String, String> args) {
    var text = translate(key);
    args.forEach((name, value) => text = text.replaceAll('{$name}', value));
    return text;
  }
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
