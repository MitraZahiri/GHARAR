import '../models/question_model.dart';
import '../models/activity_model.dart';
import '../models/challenge_model.dart';
import '../models/shared_interest_model.dart';
import '../models/milestone_model.dart';
import '../models/journal_entry_model.dart';
import '../models/special_date_model.dart';

class SeedDataService {
  SeedDataService._();

  static List<QuestionModel> get defaultQuestions => [
        // 1. Love & Affection
        QuestionModel(
          id: 'q_love_1',
          textEn: 'What is a small, quiet gesture I do that makes you feel deeply cherished?',
          textTr: 'Yaptığım hangi küçük ve sessiz hareket sana derinden sevildiğini hissettiriyor?',
          category: QuestionCategory.love,
          intensity: QuestionIntensity.meaningful,
          inspirationTipEn: 'Think about ordinary mornings, glances across a room, or gentle touches.',
          inspirationTipTr: 'Sıradan sabahları, kalabalık bir odadaki bakışmaları veya şefkatli dokunuşları düşünün.',
        ),
        QuestionModel(
          id: 'q_love_2',
          textEn: 'If you had to describe our connection in three romantic words, which would you choose?',
          textTr: 'Aramızdaki bağı üç romantik kelimeyle anlatacak olsan hangilerini seçerdin?',
          category: QuestionCategory.love,
          intensity: QuestionIntensity.icebreaker,
          optionsEn: ['Haven • Passion • Laughter', 'Depth • Solace • Playfulness', 'Magic • Warmth • Destiny', 'Trust • Fire • Peace'],
          optionsTr: ['Sığınak • Tutku • Kahkaha', 'Derinlik • Huzur • Neşe', 'Büyü • Sıcaklık • Kader', 'Güven • Ateş • Barış'],
        ),
        QuestionModel(
          id: 'q_love_3',
          textEn: 'When in the last few months did you feel the most magnetic spark between us?',
          textTr: 'Son birkaç ayda aramızdaki en güçlü çekimi ve kıvılcımı tam olarak ne zaman hissettin?',
          category: QuestionCategory.love,
          intensity: QuestionIntensity.deepSoul,
        ),
        QuestionModel(
          id: 'q_love_4',
          textEn: 'What is one way I can love and support you better during exhausting weeks?',
          textTr: 'Yorucu geçen haftalarda sana daha iyi destek olmak ve sevgimi hissettirmek için ne yapabilirim?',
          category: QuestionCategory.love,
          intensity: QuestionIntensity.meaningful,
        ),

        // 2. Emotional Intimacy
        QuestionModel(
          id: 'q_emot_1',
          textEn: 'What is a tender vulnerability you carry right now that you rarely speak aloud?',
          textTr: 'Şu günlerde içten içe taşıdığın ve pek dile getirmediğin en hassas duygun nedir?',
          category: QuestionCategory.emotionalIntimacy,
          intensity: QuestionIntensity.deepSoul,
        ),
        QuestionModel(
          id: 'q_emot_2',
          textEn: 'When you are feeling overwhelmed, what brings your nervous system the deepest comfort?',
          textTr: 'Kendini bunalmış hissettiğinde, ruhuna ve kalbine en derin rahatlığı ne getirir?',
          category: QuestionCategory.emotionalIntimacy,
          intensity: QuestionIntensity.meaningful,
          optionsEn: ['A long silent embrace', 'Talking it through without advice', 'Alone time in a quiet space', 'A warm cup of tea & soothing music'],
          optionsTr: ['Uzun ve sessiz bir sarılma', 'Tavsiye almadan sadece dinlenmek', 'Sessiz bir köşede yalnız kalmak', 'Sıcak bir çay ve sakinleştirici müzik'],
        ),
        QuestionModel(
          id: 'q_emot_3',
          textEn: 'What part of your true self do you feel safest showing only to me?',
          textTr: 'Gerçek benliğinin sadece benim yanımdayken en güvende hissettiğin yanı hangisi?',
          category: QuestionCategory.emotionalIntimacy,
          intensity: QuestionIntensity.deepSoul,
        ),

        // 3. Childhood & Roots
        QuestionModel(
          id: 'q_child_1',
          textEn: 'What is your favorite sensory memory from your childhood home?',
          textTr: 'Çocukluğunun geçtiği evden aklında kalan en sevdiğin koku, tat veya ses nedir?',
          category: QuestionCategory.childhood,
          intensity: QuestionIntensity.icebreaker,
        ),
        QuestionModel(
          id: 'q_child_2',
          textEn: 'Which habit from your upbringing would you love us to cherish or transform in our home?',
          textTr: 'Büyürken ailenden gördüğün hangi alışkanlığı yuvamızda yaşatmak veya dönüştürmek istersin?',
          category: QuestionCategory.childhood,
          intensity: QuestionIntensity.meaningful,
        ),

        // 4. Cherished Memories
        QuestionModel(
          id: 'q_mem_1',
          textEn: 'What was going through your mind the very first time we held hands or hugged?',
          textTr: 'İlk kez el ele tutuştuğumuzda veya sarıldığımızda aklından tam olarak ne geçiyordu?',
          category: QuestionCategory.memories,
          intensity: QuestionIntensity.meaningful,
        ),
        QuestionModel(
          id: 'q_mem_2',
          textEn: 'If we could relive one single day from our past together, which day would you press replay on?',
          textTr: 'Birlikte geçirdiğimiz geçmişten tek bir günü baştan yaşayabilsek, hangi günü seçerdin?',
          category: QuestionCategory.memories,
          intensity: QuestionIntensity.icebreaker,
        ),

        // 5. Communication & Needs
        QuestionModel(
          id: 'q_comm_1',
          textEn: 'When we have a small disagreement, what helps you feel respected and heard?',
          textTr: 'Ufak bir fikir ayrılığı yaşadığımızda, saygı duyulduğunu ve anlaşıldığını hissettiren şey nedir?',
          category: QuestionCategory.communication,
          intensity: QuestionIntensity.meaningful,
        ),
        QuestionModel(
          id: 'q_comm_2',
          textEn: 'Which love language makes your heart feel fullest right now?',
          textTr: 'Şu sıralar kalbine en çok hangi sevgi dili hitap ediyor?',
          category: QuestionCategory.communication,
          intensity: QuestionIntensity.icebreaker,
          optionsEn: ['Words of Affirmation', 'Quality Time without Screens', 'Warm Physical Touch', 'Acts of Service & Care', 'Thoughtful Romantic Gifts'],
          optionsTr: ['Takdir ve Güzel Sözler', 'Ekransız Baş Başa Vakit', 'Sıcak Fiziksel Temas', 'Düşünceli Yardım ve Eylemler', 'Anlamlı Küçük Hediyeler'],
        ),

        // 6. Future Dreams
        QuestionModel(
          id: 'q_fut_1',
          textEn: 'What is a wild, joyful dream we haven’t dared to plan yet, but should?',
          textTr: 'Henüz planlamaya cesaret edemediğimiz ama mutlaka yapmamız gereken çılgın hayalimiz ne?',
          category: QuestionCategory.futureDreams,
          intensity: QuestionIntensity.icebreaker,
        ),
        QuestionModel(
          id: 'q_fut_2',
          textEn: 'In ten years, on a quiet Sunday morning in our dream home, what does our life look like?',
          textTr: 'On yıl sonra hayalimizdeki yuvada sakin bir pazar sabahı... Hayatımız sence nasıl görünüyor?',
          category: QuestionCategory.futureDreams,
          intensity: QuestionIntensity.deepSoul,
        ),

        // 7. Values & Meaning
        QuestionModel(
          id: 'q_val_1',
          textEn: 'What principle or value do you admire most in how I live my life?',
          textTr: 'Hayatı yaşama biçimimde ve duruşumda en çok takdir ettiğin değer veya ilke nedir?',
          category: QuestionCategory.coreValues,
          intensity: QuestionIntensity.meaningful,
        ),

        // 8. Fun & Playfulness
        QuestionModel(
          id: 'q_fun_1',
          textEn: 'If we were cast as a dynamic duo in a movie or series, what genre would we star in?',
          textTr: 'Bir film veya dizide başrol ikili olsaydık, sence hangi türde harikalar yaratırdık?',
          category: QuestionCategory.fun,
          intensity: QuestionIntensity.icebreaker,
          optionsEn: ['Romantic Comedy in Paris', 'Action Adventure Treasure Hunt', 'Mysterious Detective Duo', 'Cosmic Sci-Fi Explorers'],
          optionsTr: ['Paris’te Romantik Komedi', 'Aksiyon Dolu Define Avı', 'Gizemli Dedektif Çifti', 'Kozmik Bilim Kurgu Gezginleri'],
        ),
        QuestionModel(
          id: 'q_fun_2',
          textEn: 'What is the most hilariously awkward moment we shared that we now laugh until we cry about?',
          textTr: 'Birlikte yaşadığımız ve şimdi her hatırladığımızda kahkahalarla güldüğümüz en tatlı sakarlık ne?',
          category: QuestionCategory.fun,
          intensity: QuestionIntensity.icebreaker,
        ),

        // 9. Romance & Passion
        QuestionModel(
          id: 'q_rom_1',
          textEn: 'What is an unexpected romantic surprise or fantasy you have secretly thought about?',
          textTr: 'Gizliden gizliye aklından geçirdiğin beklenmedik bir romantik sürpriz veya fantezi nedir?',
          category: QuestionCategory.romance,
          intensity: QuestionIntensity.deepSoul,
        ),
        QuestionModel(
          id: 'q_rom_2',
          textEn: 'What outfit or style of mine makes you secretly swoon every time?',
          textTr: 'Hangi kıyafetim veya tarzım her gördüğünde kalbini biraz daha hızlı çarptırıyor?',
          category: QuestionCategory.romance,
          intensity: QuestionIntensity.icebreaker,
        ),

        // 10. Personal Growth
        QuestionModel(
          id: 'q_grow_1',
          textEn: 'In what ways has being in love with you made me become a gentler, braver person?',
          textTr: 'Seni sevmek ve senin tarafından sevilmek beni hangi yönlerden daha nazik ve cesur biri yaptı?',
          category: QuestionCategory.personalGrowth,
          intensity: QuestionIntensity.deepSoul,
        ),

        // 11. Lifestyle & Rhythm
        QuestionModel(
          id: 'q_life_1',
          textEn: 'What new ritual or mini-tradition would you love us to start this season?',
          textTr: 'Bu mevsim birlikte başlatmak istediğin yeni bir mini gelenek veya ritüel ne olurdu?',
          category: QuestionCategory.lifestyle,
          intensity: QuestionIntensity.meaningful,
        ),

        // 12. Deep Conversations
        QuestionModel(
          id: 'q_deep_1',
          textEn: 'What does unconditional love truly mean to you, and when did you feel it most?',
          textTr: 'Koşulsuz sevgi senin için tam olarak ne ifade ediyor ve bunu en çok ne zaman hissettin?',
          category: QuestionCategory.deepConversations,
          intensity: QuestionIntensity.deepSoul,
        ),
        QuestionModel(
          id: 'q_deep_2',
          textEn: 'What is a fear about getting older that you want us to conquer side by side?',
          textTr: 'Yaşlanmaya dair birlikte yan yana yenmek istediğin en büyük korkun veya endişen nedir?',
          category: QuestionCategory.deepConversations,
          intensity: QuestionIntensity.deepSoul,
        ),
      ];

  static List<ActivityModel> get defaultActivities => [
        ActivityModel(
          id: 'act_1',
          titleEn: 'Candlelit Stargazing & Acoustic Melodies',
          titleTr: 'Mum Işığında Yıldız İzleme & Akustik Ezgiler',
          descriptionEn: 'Pack cozy blankets, a thermos of spiced tea or hot chocolate, and lie under the open night sky listening to a shared playlist.',
          descriptionTr: 'Yumuşak battaniyeler, sıcak baharatlı çay veya çikolata termosu alın ve ortak bir çalma listesi eşliğinde açık gökyüzünü izleyin.',
          categoryEn: 'Romantic & Intimate',
          categoryTr: 'Romantik & İntim',
          budget: ActivityBudget.free,
          setting: ActivitySetting.outdoor,
          vibe: ActivityVibe.romantic,
          duration: '1-2 hrs',
          icon: '✨',
          tipsEn: [
            'Download a constellation app like SkyView to spot planets together.',
            'Leave smartphones on silent to savor uninterrupted whispering.'
          ],
          tipsTr: [
            'Birlikte gezegenleri bulmak için bir gökyüzü uygulaması açın.',
            'Fısıltıların tadını çıkarmak için telefonları sessize alın.'
          ],
          isSaved: true,
        ),
        ActivityModel(
          id: 'act_2',
          titleEn: 'Living Room Blanket Fort & Vintage Movie Night',
          titleTr: 'Oturma Odasında Battaniye Kalesi & Nostalji Sineması',
          descriptionEn: 'Build a childlike, luxurious blanket fortress with fairy lights, plush pillows, and your favorite childhood comfort snacks.',
          descriptionTr: 'Peri ışıkları ve kabarık yastıklarla çocuksu bir battaniye kalesi inşa edin, çocukluğunuzun en sevdiğiniz atıştırmalıklarıyla film izleyin.',
          categoryEn: 'At Home Cozy',
          categoryTr: 'Evde Sıcak',
          budget: ActivityBudget.low,
          setting: ActivitySetting.atHome,
          vibe: ActivityVibe.playful,
          duration: '2-3 hrs',
          icon: '🏰',
          tipsEn: [
            'Pick a classic romance or nostalgic film you haven’t watched in years.',
            'Pop fresh popcorn with melted butter and cinnamon sugar.'
          ],
          tipsTr: [
            'Yıllardır izlemediğiniz nostaljik bir aşk klasiği seçin.',
            'Taze patlamış mısırı tereyağı ve tarçınla lezzetlendirin.'
          ],
          isCompleted: true,
        ),
        ActivityModel(
          id: 'act_3',
          titleEn: 'Mystery Ingredient Gourmet Cook-Off',
          titleTr: 'Gizemli Malzemeli Gurme Yemek Düellosu',
          descriptionEn: 'Each partner secretly buys 2 quirky ingredients for the other. Put on upbeat jazz and collaborate to craft a master dish!',
          descriptionTr: 'Her partner diğeri için gizlice 2 sürpriz malzeme alır. Caz müziği açın ve mutfakta harika bir lezzet yaratmak için güçlerinizi birleştirin!',
          categoryEn: 'Culinary Adventure',
          categoryTr: 'Mutfak Macerası',
          budget: ActivityBudget.low,
          setting: ActivitySetting.atHome,
          vibe: ActivityVibe.playful,
          duration: '1-2 hrs',
          icon: '🍳',
          tipsEn: [
            'Set a friendly 45-minute countdown clock for added fun.',
            'Taste-test each stage with eyes closed.'
          ],
          tipsTr: [
            'Heyecanı artırmak için 45 dakikalık bir geri sayım başlatın.',
            'Gözlerinizi kapatıp birbirinize sosları tattırın.'
          ],
        ),
        ActivityModel(
          id: 'act_4',
          titleEn: 'Sunrise Coffee & Golden Hour Walk',
          titleTr: 'Gün Doğumu Kahvesi & Altın Saat Yürüyüşü',
          descriptionEn: 'Wake up before the rest of the world, grab steaming cups of artisanal roast coffee, and watch the sun paint the city or shoreline.',
          descriptionTr: 'Dünya uyanmadan önce kalkın, dumanı tüten kahvelerinizi alın ve güneşin şehri veya sahili kızıla boyamasını izleyin.',
          categoryEn: 'Morning Serenity',
          categoryTr: 'Sabah Huzuru',
          budget: ActivityBudget.free,
          setting: ActivitySetting.outdoor,
          vibe: ActivityVibe.relaxing,
          duration: '<1 hr',
          icon: '🌅',
          tipsEn: [
            'Breathe in the cool morning air and share what you look forward to today.',
            'Take one sweet candid photo with the morning light.'
          ],
          tipsTr: [
            'Sabahın serin havasını içinize çekip güne dair heyecanlarınızı paylaşın.',
            'Sabah ışığında birbirinizin tatlı birer fotoğrafını çekin.'
          ],
          isSaved: true,
        ),
        ActivityModel(
          id: 'act_5',
          titleEn: 'Clay Pottery & Touch Evening',
          titleTr: 'Kil Seramik & Şekillendirme Akşamı',
          descriptionEn: 'Get air-dry clay and craft personalized espresso cups, ring dishes, or small sculptures of things you love about each other.',
          descriptionTr: 'Hava ile kuruyan seramik kili alın; birbiriniz için kahve fincanı, takı tabağı veya sevginizi anlatan küçük heykeller yapın.',
          categoryEn: 'Creative & Soulful',
          categoryTr: 'Yaratıcı & Sanatsal',
          budget: ActivityBudget.low,
          setting: ActivitySetting.atHome,
          vibe: ActivityVibe.romantic,
          duration: '1-2 hrs',
          icon: '🏺',
          tipsEn: [
            'Carve your anniversary date or initials onto the bottom of each piece.',
            'Don’t worry about perfection; celebrate the charming imperfections!'
          ],
          tipsTr: [
            'Eserlerin altına yıldönümünüzü veya baş harflerinizi kazıyın.',
            'Kusursuz olmaya çalışmayın, el yapımı olmanın sıcaklığını sevin!'
          ],
        ),
        ActivityModel(
          id: 'act_6',
          titleEn: 'Boutique Bookstore Secret Mission',
          titleTr: 'Butik Kitabevinde Gizli Görev',
          descriptionEn: 'Visit a charming independent bookstore. Split up for 20 minutes to find a book or poem that reminded you of your partner, then present it with a love note.',
          descriptionTr: 'Sevimli bir kitapçıya gidin. 20 dakika ayrılıp partnerinizi anlatan bir kitap veya şiir seçin, sonra içine sevgi notu koyup hediye edin.',
          categoryEn: 'Cultural Date',
          categoryTr: 'Kültür & Sanat',
          budget: ActivityBudget.medium,
          setting: ActivitySetting.indoor,
          vibe: ActivityVibe.romantic,
          duration: '1-2 hrs',
          icon: '📚',
          tipsEn: [
            'Sit in a quiet reading corner and read your favorite paragraphs aloud.',
            'Pair it with warm croissants or herbal tea.'
          ],
          tipsTr: [
            'Sessiz bir köşede birbirinize en sevdiğiniz paragrafları sesli okuyun.',
            'Yanına taze bir kruvasan veya bitki çayı ekleyin.'
          ],
        ),
      ];

  static List<ChallengeModel> get defaultChallenges => [
        ChallengeModel(
          id: 'ch_w1',
          weekNumber: 1,
          titleEn: 'The 3 Unspoken Appreciations',
          titleTr: 'Dile Gelmemiş 3 Teşekkür',
          descriptionEn: 'Every day for three days, surprise your partner with an appreciation for something they do that usually goes unnoticed.',
          descriptionTr: 'Üç gün boyunca her gün, partnerinizin genelde fark edilmeyen güzel bir inceliğine teşekkür edin ve sarılın.',
          rewardBadge: '🌸',
          badgeNameEn: 'Grateful Hearts',
          badgeNameTr: 'Şükran Dolu Kalpler',
          encouragementEn: 'Gratitude is the soil where romance thrives.',
          encouragementTr: 'Şükran, romantizmin en güzel kök saldığı topraktır.',
          isCompleted: true,
          completedAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
        ChallengeModel(
          id: 'ch_w2',
          weekNumber: 2,
          titleEn: 'Digital Sunset & 60-Minute Bubble',
          titleTr: 'Dijital Gün Batımı & 60 Dakikalık Balon',
          descriptionEn: 'Turn off all screens, dim the main lights, light scented candles, and spend one full hour in deep, eye-contact conversation or gentle music.',
          descriptionTr: 'Tüm telefon ve ekranları kapatın, ışıkları kısın, mum yakın ve bir tam saati göz temasıyla sohbet ederek veya dinlenerek geçirin.',
          rewardBadge: '🕯️',
          badgeNameEn: 'Sanctuary of Peace',
          badgeNameTr: 'Huzur Sığınağı',
          encouragementEn: 'Unbroken presence is the rarest modern luxury.',
          encouragementTr: 'Kesintisiz dikkat, günümüzün en değerli lüksüdür.',
        ),
        ChallengeModel(
          id: 'ch_w3',
          weekNumber: 3,
          titleEn: 'Recreate a Golden First Date Moment',
          titleTr: 'İlk Buluşmanın Büyülü Anını Canlandırın',
          descriptionEn: 'Recreate the soundtrack, the perfume/cologne, or the favorite dessert from your very early dating days.',
          descriptionTr: 'İlişkinizin ilk günlerindeki o şarkıyı açın, o kokuyu sürün veya o günkü tatlıyı yeniden tadın.',
          rewardBadge: '✨',
          badgeNameEn: 'Nostalgic Spark',
          badgeNameTr: 'Nostalji Kıvılcımı',
          encouragementEn: 'Remembering how you fell in love renews your current flame.',
          encouragementTr: 'Nasıl aşık olduğunuzu hatırlamak bugünkü ateşi tazeler.',
        ),
        ChallengeModel(
          id: 'ch_w4',
          weekNumber: 4,
          titleEn: 'Secret Love Postcard Challenge',
          titleTr: 'Gizli Sevgi Kartpostalı Görevi',
          descriptionEn: 'Slip a handwritten mini love note inside your partner’s coat pocket, car visor, or laptop keyboard to be found unexpectedly.',
          descriptionTr: 'Partnerinizin ceket cebine, araba güneşliğine veya klavyesine beklenmedik bir anda bulacağı el yazısı bir aşk notu bırakın.',
          rewardBadge: '💌',
          badgeNameEn: 'Whispered Affection',
          badgeNameTr: 'Fısıldanan Sevgi',
          encouragementEn: 'Unexpected romance turns ordinary days into poetry.',
          encouragementTr: 'Beklenmedik incelikler sıradan günleri şiire dönüştürür.',
        ),
      ];

  static List<SharedInterestModel> get defaultSharedInterests => [
        SharedInterestModel(
          id: 'int_1',
          titleEn: 'Mediterranean Sunset Escapes',
          titleTr: 'Akdeniz Gün Batımı Kaçamakları',
          category: 'Travel & Wonder',
          descriptionEn: 'Both of you adore coastal breezes, charming cobblestone alleys, seafood by the water, and slow sunsets.',
          descriptionTr: 'İkiniz de deniz meltemine, taş sokaklara, sahil kenarında sakin yemeklere ve yavaş gün batımlarına bayılıyorsunuz.',
          suggestedDateEn: 'Book a weekend seaside getaway or prepare an olive & feta mezze board on your balcony tonight.',
          suggestedDateTr: 'Hafta sonu için deniz kıyısına mini bir kaçamak planlayın veya balkonda zeytinli, peynirli bir meze tabağı hazırlayın.',
          icon: '⛵',
          bothEnjoy: true,
        ),
        SharedInterestModel(
          id: 'int_2',
          titleEn: 'Acoustic Jazz & Velvet Vinyl',
          titleTr: 'Akustik Caz & Plak Akşamları',
          category: 'Music & Mood',
          descriptionEn: 'You both feel deepest relaxation when warm saxophone and acoustic guitar melodies fill the room.',
          descriptionTr: 'Odayı sıcak saksafon ve akustik gitar ezgileri doldurduğunda ikiniz de derin bir huzur buluyorsunuz.',
          suggestedDateEn: 'Light amber lamps, pour herbal tea or wine, and listen to a vintage jazz vinyl without talking for the first 15 mins.',
          suggestedDateTr: 'Loş ışıkları yakın, çayınızı veya kahvenizi alın ve ilk 15 dakika sadece müziğin ritmini hissedin.',
          icon: '🎷',
          bothEnjoy: true,
        ),
        SharedInterestModel(
          id: 'int_3',
          titleEn: 'Weekend Energy & Pacing',
          titleTr: 'Hafta Sonu Enerjisi & Temposu',
          category: 'Lifestyle Contrast',
          descriptionEn: 'One partner loves spontaneous outdoor explorations, while the other recharges with structured, cozy home routines.',
          descriptionTr: 'Biriniz plansız doğa gezilerini severken, diğeriniz evde sakin ve planlı bir dinlenme rutiniyle enerji topluyor.',
          suggestedDateEn: 'The Golden Balance: Spend Saturday morning adventuring in the fresh air, then reserve Sunday entirely for cozy blankets and reading side by side.',
          suggestedDateTr: 'Altın Denge: Cumartesi sabahını açık havada keşifle geçirin, Pazar gününü ise tamamen evde kitap ve battaniye keyfine ayırın.',
          icon: '⚖️',
          bothEnjoy: false,
          partner1PreferenceEn: 'Spontaneous morning trips & discovering new cafes',
          partner1PreferenceTr: 'Spontane sabah gezileri & yeni kafeler keşfetmek',
          partner2PreferenceEn: 'Cozy home mornings with coffee & quiet reflection',
          partner2PreferenceTr: 'Evde sakin kahve, müzik ve dingin bir dinlenme',
          bridgeConversationEn: 'How can we honor both our spontaneous spark and our sanctuary of rest this upcoming weekend?',
          bridgeConversationTr: 'Bu hafta sonu hem dışarıdaki keşif arzumuzu hem de evdeki dinlenme ihtiyacımızı nasıl dengeleriz?',
        ),
        SharedInterestModel(
          id: 'int_4',
          titleEn: 'Artisanal Coffee & Roastery Tasting',
          titleTr: 'Nitelikli Kahve & Tadım Seansları',
          category: 'Taste & Ritual',
          descriptionEn: 'The aroma of freshly ground Ethiopian or Colombian beans is an instant comfort ritual for both of you.',
          descriptionTr: 'Taze çekilmiş çekirdek kokusu ve yavaş demleme kahve ikiniz için de günün en huzurlu ritüeli.',
          suggestedDateEn: 'Do a blind taste-test of two different single-origin beans at home and compare fruity vs chocolate notes.',
          suggestedDateTr: 'Evde iki farklı çekirdekle kör tadım yapın ve aradaki çikolata veya meyve notalarını tahmin edin.',
          icon: '☕',
          bothEnjoy: true,
        ),
      ];

  static List<MilestoneModel> get defaultMilestones => [
        MilestoneModel(
          id: 'm_1',
          titleEn: 'The Day Our Paths Crossed',
          titleTr: 'Yollarımızın Kesiştiği Gün',
          descriptionEn: 'A serendipitous afternoon when a brief conversation turned into hours of lost time.',
          descriptionTr: 'Kısa bir sohbetin saatlerin nasıl geçtiğini unutturduğu o ilk an.',
          milestoneDate: DateTime(2025, 1, 1),
          icon: '🌧️',
          badgeTextEn: 'First Spark',
          badgeTextTr: 'İlk Kıvılcım',
          isCelebrated: true,
        ),
        MilestoneModel(
          id: 'm_2',
          titleEn: 'Our First Road Trip & Sunset Cabin',
          titleTr: 'İlk Yolculuğumuz & Gün Batımı',
          descriptionEn: 'Driving with the windows down, singing terribly to favorite songs, and watching golden hour.',
          descriptionTr: 'Camlar açık, sevdiğimiz şarkılara bağıra bağıra eşlik ettiğimiz ve gün batımına vardığımız o ilk yolculuk.',
          milestoneDate: DateTime(2025, 6, 1),
          icon: '🚗',
          badgeTextEn: 'Adventure Unlocked',
          badgeTextTr: 'İlk Macera',
          isCelebrated: true,
        ),
      ];

  static List<JournalEntryModel> get defaultJournalEntries => [];

  static List<SpecialDateModel> get defaultSpecialDates => [
        SpecialDateModel(
          id: 'sd_1',
          titleEn: 'Our Special Anniversary',
          titleTr: 'Büyük Yıl Dönümümüz',
          date: DateTime(2026, 10, 14),
          category: 'Anniversary',
          icon: '💍',
          notes: 'Celebrating another year of unconditional companionship and love.',
        ),
        SpecialDateModel(
          id: 'sd_2',
          titleEn: 'Planned Sunset Vineyard Date',
          titleTr: 'Bağ Evi Gün Batımı Randevumuz',
          date: DateTime.now().add(const Duration(days: 9)),
          category: 'Date Night',
          icon: '🍇',
          notes: 'Tasting local cheeses, listening to acoustic melodies, and no laptops!',
        ),
      ];

  static List<String> get romanticSurpriseIdeasEn => [
        'Write 3 reasons you love them on small sticky notes and place them in their shoe, laptop, and coat pocket.',
        'Prepare their favorite hot beverage exactly how they like it and serve it with a 5-minute shoulder massage.',
        'Create a secret 7-song playlist of melodies that tell the story of how you two met.',
        'Plan a 30-minute “silent dance” in the living room with fairy lights and no talking.',
        'Surprise them by taking complete charge of dinner and bedtime routines so they can take a long, serene bath.',
        'Leave a single fresh flower with a sweet handwritten note on the bathroom mirror.',
        'Blindfold your partner and give them a 3-course sensory taste test with strawberries, dark chocolate, and honey.',
      ];

  static List<String> get romanticSurpriseIdeasTr => [
        'Onu neden sevdiğine dair 3 küçük not yazıp ayakkabısına, bilgisayarına ve ceket cebine gizlice iliştir.',
        'En sevdiği sıcak içeceği tam istediği kıvamda hazırla ve 5 dakikalık omuz masajıyla ikram et.',
        'Tanışma hikayenizi anlatan 7 şarkılık gizli bir romantik çalma listesi oluştur.',
        'Oturma odasında peri ışıklarını yakıp hiç konuşmadan 30 dakikalık sakin bir dans anı başlat.',
        'Akşam yemeği ve toparlanma işlerini tamamen üstlenerek partnerine sıcak, köpüklü ve dinlendirici bir banyo hediye et.',
        'Banyo aynasına ruj veya küçük bir not kağıdıyla gününü aydınlatacak tatlı bir sevgi sözcüğü bırak.',
        'Partnerinin gözlerini bağlayıp çilek, bitter çikolata ve bal gibi tatlarla 3 aşamalı duyusal bir tadım yaptır.',
      ];
}
