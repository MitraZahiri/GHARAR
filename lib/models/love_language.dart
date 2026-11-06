import 'package:flutter/foundation.dart';

/// The five ways people most often give and feel love.
enum LoveLanguage {
  words(
    icon: '💬',
    titleEn: 'Words of Affirmation',
    titleTr: 'Onaylayıcı Sözler',
    descriptionEn:
        'You feel most loved through kind words, compliments and hearing “I love you” out loud.',
    descriptionTr:
        'En çok sevildiğini içten sözlerle, iltifatlarla ve “Seni seviyorum”u duyduğunda hissedersin.',
    tipEn: 'Leave a short note saying one thing you admire about them today.',
    tipTr: 'Bugün ona hayran olduğun bir şeyi yazan kısa bir not bırak.',
  ),
  time(
    icon: '🕰️',
    titleEn: 'Quality Time',
    titleTr: 'Kaliteli Zaman',
    descriptionEn:
        'You feel most loved when your partner gives you their full, undistracted attention.',
    descriptionTr:
        'Partnerin tüm dikkatini telefonsuz, bölünmeden sana verdiğinde en çok sevildiğini hissedersin.',
    tipEn: 'Plan 30 phone-free minutes together tonight, just the two of you.',
    tipTr: 'Bu akşam ikiniz için telefonsuz 30 dakika ayır.',
  ),
  gifts(
    icon: '🎁',
    titleEn: 'Thoughtful Gifts',
    titleTr: 'Anlamlı Hediyeler',
    descriptionEn:
        'You feel most loved by small, meaningful tokens that show you were on their mind.',
    descriptionTr:
        'Aklında olduğunu gösteren küçük ama anlamlı sürprizlerle en çok sevildiğini hissedersin.',
    tipEn: 'Bring home a small surprise that reminds you of a shared memory.',
    tipTr: 'Ortak bir anınızı hatırlatan küçük bir sürprizle eve gel.',
  ),
  service(
    icon: '🤲',
    titleEn: 'Acts of Service',
    titleTr: 'Hizmet Davranışları',
    descriptionEn:
        'You feel most loved when your partner eases your load and helps without being asked.',
    descriptionTr:
        'Partnerin yükünü hafiflettiğinde ve istemeden yardım ettiğinde en çok sevildiğini hissedersin.',
    tipEn: 'Quietly take one chore off their list this week.',
    tipTr: 'Bu hafta onun listesindeki bir işi sessizce üstlen.',
  ),
  touch(
    icon: '🤗',
    titleEn: 'Physical Touch',
    titleTr: 'Fiziksel Temas',
    descriptionEn:
        'You feel most loved through hugs, holding hands and simple closeness.',
    descriptionTr:
        'Sarılmak, el ele tutuşmak ve yakın olmakla en çok sevildiğini hissedersin.',
    tipEn: 'Give a long, unhurried hug when you see each other today.',
    tipTr: 'Bugün buluştuğunuzda acele etmeden uzun uzun sarıl.',
  );

  final String icon;
  final String titleEn;
  final String titleTr;
  final String descriptionEn;
  final String descriptionTr;
  final String tipEn;
  final String tipTr;

  const LoveLanguage({
    required this.icon,
    required this.titleEn,
    required this.titleTr,
    required this.descriptionEn,
    required this.descriptionTr,
    required this.tipEn,
    required this.tipTr,
  });

  String title(bool isTr) => isTr ? titleTr : titleEn;
  String description(bool isTr) => isTr ? descriptionTr : descriptionEn;

  /// How the other partner can speak this language today.
  String partnerTip(bool isTr) => isTr ? tipTr : tipEn;

  static LoveLanguage? fromKey(String? key) {
    for (final language in values) {
      if (language.name == key) return language;
    }
    return null;
  }
}

/// One side of a quiz question: a statement and the language it points to.
@immutable
class LoveLanguageStatement {
  final LoveLanguage language;
  final String textEn;
  final String textTr;

  const LoveLanguageStatement(this.language, this.textEn, this.textTr);

  String text(bool isTr) => isTr ? textTr : textEn;
}

/// A "which feels more like love?" choice between two statements.
@immutable
class LoveLanguageQuestion {
  final LoveLanguageStatement first;
  final LoveLanguageStatement second;

  const LoveLanguageQuestion(this.first, this.second);
}

/// A short forced-choice quiz: every language is paired with every other
/// once, so each one gets the same four chances to be picked.
class LoveLanguageQuiz {
  const LoveLanguageQuiz._();

  static const questions = <LoveLanguageQuestion>[
    LoveLanguageQuestion(
      LoveLanguageStatement(
        LoveLanguage.words,
        'Hearing “I’m so proud of you”',
        '“Seninle gurur duyuyorum” demesi',
      ),
      LoveLanguageStatement(
        LoveLanguage.time,
        'A slow evening walk together',
        'Birlikte ağır ağır bir akşam yürüyüşü',
      ),
    ),
    LoveLanguageQuestion(
      LoveLanguageStatement(
        LoveLanguage.gifts,
        'A small surprise just because',
        'Sebepsiz küçük bir sürpriz',
      ),
      LoveLanguageStatement(
        LoveLanguage.touch,
        'A long hug after a hard day',
        'Zor bir günün ardından uzun bir sarılma',
      ),
    ),
    LoveLanguageQuestion(
      LoveLanguageStatement(
        LoveLanguage.service,
        'Coming home to dinner already made',
        'Eve geldiğinde yemeğin hazır olması',
      ),
      LoveLanguageStatement(
        LoveLanguage.words,
        'A sweet message in the middle of the day',
        'Gün ortasında gelen tatlı bir mesaj',
      ),
    ),
    LoveLanguageQuestion(
      LoveLanguageStatement(
        LoveLanguage.time,
        'A whole weekend with no plans but us',
        'Sadece ikimizin olduğu plansız bir hafta sonu',
      ),
      LoveLanguageStatement(
        LoveLanguage.gifts,
        'A souvenir they picked with me in mind',
        'Beni düşünerek seçtiği bir hatıra',
      ),
    ),
    LoveLanguageQuestion(
      LoveLanguageStatement(
        LoveLanguage.touch,
        'Holding hands while we walk',
        'Yürürken el ele tutuşmak',
      ),
      LoveLanguageStatement(
        LoveLanguage.service,
        'Them taking care of a task I dread',
        'Gözümün korktuğu bir işi onun halletmesi',
      ),
    ),
    LoveLanguageQuestion(
      LoveLanguageStatement(
        LoveLanguage.words,
        'Being told what they love about me',
        'Bende neyi sevdiğini söylemesi',
      ),
      LoveLanguageStatement(
        LoveLanguage.gifts,
        'Flowers for no reason at all',
        'Hiçbir sebep yokken çiçek',
      ),
    ),
    LoveLanguageQuestion(
      LoveLanguageStatement(
        LoveLanguage.touch,
        'Cuddling on the couch',
        'Koltukta sarılarak oturmak',
      ),
      LoveLanguageStatement(
        LoveLanguage.time,
        'A deep talk with phones put away',
        'Telefonlar kenarda derin bir sohbet',
      ),
    ),
    LoveLanguageQuestion(
      LoveLanguageStatement(
        LoveLanguage.service,
        'Them fixing something that was bothering me',
        'Beni rahatsız eden bir şeyi onun düzeltmesi',
      ),
      LoveLanguageStatement(
        LoveLanguage.gifts,
        'A handwritten card tucked into my bag',
        'Çantama sıkıştırılmış el yazısı bir kart',
      ),
    ),
    LoveLanguageQuestion(
      LoveLanguageStatement(
        LoveLanguage.words,
        'A heartfelt thank-you',
        'İçten bir teşekkür',
      ),
      LoveLanguageStatement(
        LoveLanguage.touch,
        'A gentle shoulder rub',
        'Omuzlarıma nazik bir masaj',
      ),
    ),
    LoveLanguageQuestion(
      LoveLanguageStatement(
        LoveLanguage.time,
        'Trying something new together',
        'Birlikte yeni bir şey denemek',
      ),
      LoveLanguageStatement(
        LoveLanguage.service,
        'Them running my errands when I’m busy',
        'Yoğunken işlerimi onun halletmesi',
      ),
    ),
  ];

  static Map<LoveLanguage, int> scoresFrom(List<LoveLanguage> picks) {
    final scores = {for (final language in LoveLanguage.values) language: 0};
    for (final pick in picks) {
      scores[pick] = (scores[pick] ?? 0) + 1;
    }
    return scores;
  }

  /// The most-picked language; a tie goes to the one picked first.
  static LoveLanguage? primaryFrom(List<LoveLanguage> picks) {
    final scores = scoresFrom(picks);
    LoveLanguage? best;
    for (final pick in picks) {
      if (best == null || (scores[pick] ?? 0) > (scores[best] ?? 0)) {
        best = pick;
      }
    }
    return best;
  }
}
