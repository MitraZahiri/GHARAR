import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../providers/app_state_provider.dart';
import '../../widgets/confetti_overlay.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_button.dart';

class QuizGameScreen extends StatefulWidget {
  const QuizGameScreen({super.key});

  @override
  State<QuizGameScreen> createState() => _QuizGameScreenState();
}

class _QuizGameScreenState extends State<QuizGameScreen> {
  int _currentQuizIndex = 0;
  int? _predictedOptionIndex;
  bool _isAnswerRevealed = false;
  int _matchesCount = 0;
  bool _playConfetti = false;

  final List<Map<String, dynamic>> _quizzes = [
    {
      'questionEn': 'What would be your partner’s absolute dream Sunday morning?',
      'questionTr': 'Partnerinizin hayalindeki en kusursuz pazar sabahı hangisi olurdu?',
      'optionsEn': [
        'Sleeping in late + breakfast in bed + soft jazz',
        'Early sunrise run + cold iced coffee + fresh air',
        'Baking warm cinnamon rolls + reading favorite book',
        'Spontaneous road trip to a hidden coastal village',
      ],
      'optionsTr': [
        'Geç uyanmak + yatakta kahvaltı + loş caz müziği',
        'Erken gün doğumu koşusu + soğuk kahve + temiz hava',
        'Tarçınlı çörek pişirmek + en sevdiği kitabı okumak',
        'Gizli bir sahil kasabasına spontane yolculuk',
      ],
      'actualIndex': 0,
      'funInsightEn': 'You both treasure slow mornings with cozy sensory warmth!',
      'funInsightTr': 'İkiniz de yavaş ve huzurlu sabahların kokusuna ve sıcaklığına bayılıyorsunuz!',
    },
    {
      'questionEn': 'When your partner is feeling stressed, what is their secret comfort craving?',
      'questionTr': 'Partneriniz yoğun stres altındayken gizli teselli yiyeceği veya içeceği nedir?',
      'optionsEn': [
        'Rich dark chocolate & steaming chamomile tea',
        'Crispy artisanal pizza with extra melted cheese',
        'Creamy gelato or ice cream directly from the tub',
        'A big bowl of warm comfort soup / pasta',
      ],
      'optionsTr': [
        'Yoğun bitter çikolata & dumanı tüten papatya çayı',
        'Bol peynirli çıtır gurme pizza',
        'Kutudan kaşıkla yenen dondurma',
        'Sıcak ev yapımı çorba veya kremalı makarna',
      ],
      'actualIndex': 3,
      'funInsightEn': 'Warm, savory home cooking brings immediate safety to their nervous system.',
      'funInsightTr': 'Sıcak ve tanıdık ev lezzetleri ruhuna anında sakinlik ve güvende olma hissi veriyor.',
    },
    {
      'questionEn': 'Which dream destination would your partner pack their bags for in 10 minutes?',
      'questionTr': 'Partneriniz 10 dakika içinde bavulunu toplayıp hangi hayal rotasına uçar?',
      'optionsEn': [
        'A cliffside stone cottage in the Amalfi Coast or Santorini',
        'A snowy cabin with a wood-burning fireplace in the Swiss Alps',
        'A lantern-lit bamboo retreat in Kyoto, Japan',
        'A secluded beachfront overwater bungalow in the Maldives',
      ],
      'optionsTr': [
        'Amalfi Kıyısı veya Santorini’de kayalıklara bakan taş ev',
        'İsviçre Alpleri’nde şömineli karlı ahşap bir dağ kulübesi',
        'Kyoto’da fenerlerle aydınlatılmış huzurlu bir bambu tapınağı',
        'Maldivler’de turkuaz sular üzerindeki sakin bir bungalov',
      ],
      'actualIndex': 1,
      'funInsightEn': 'The crackling fireplace and cozy winter blankets speak directly to their soul.',
      'funInsightTr': 'Çatırdayan şömine ateşi ve kış battaniyesi partnerinizin ruhunun sığınağıdır.',
    },
    {
      'questionEn': 'If your partner could have any superpower for just one day, what would it be?',
      'questionTr': 'Partneriniz sadece bir günlüğüne süper güce sahip olsa hangisini seçerdi?',
      'optionsEn': [
        'Teleportation anywhere on Earth in a blink',
        'Time travel to relive our favorite memories',
        'Understanding every language in the universe',
        'Healing every pain with a single touch',
      ],
      'optionsTr': [
        'Göz açıp kapayıncaya kadar dünyanın her yerine ışınlanmak',
        'Zamanda yolculuk yapıp en sevdiğimiz anları yeniden yaşamak',
        'Evrendeki her dili ve duyguyu anında anlamak',
        'Tek bir dokunuşla her acıyı ve yorgunluğu iyileştirmek',
      ],
      'actualIndex': 1,
      'funInsightEn': 'Nostalgia and cherished memories are what they hold closest to their heart.',
      'funInsightTr': 'Nostalji ve birlikte biriktirdiğiniz hatıralar onun kalbinde en kıymetli hazinedir.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppStateProvider>();
    final isDark = provider.isDarkMode;
    final isTr = provider.isTurkish;

    final otherPartner = provider.otherPartner;
    final quiz = _quizzes[_currentQuizIndex];
    final options = isTr
        ? (quiz['optionsTr'] as List<String>)
        : (quiz['optionsEn'] as List<String>);
    final actual = quiz['actualIndex'] as int;

    return ConfettiOverlay(
      isPlaying: _playConfetti,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            isTr ? 'Bizi Ne Kadar Tanıyoruz?' : 'How Well Do We Know Us?',
            style: AppTextStyles.titleMedium(isDark: isDark).copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isTr
                        ? 'Soru ${_currentQuizIndex + 1} / ${_quizzes.length}'
                        : 'Question ${_currentQuizIndex + 1} of ${_quizzes.length}',
                    style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    isTr
                        ? 'Uyum: $_matchesCount Eşleşme ✨'
                        : 'Harmony: $_matchesCount Matches ✨',
                    style: TextStyle(
                      color: AppColors.champagneGold,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: (_currentQuizIndex + 1) / _quizzes.length,
                  backgroundColor: isDark
                      ? AppColors.darkCardElevated
                      : AppColors.lightBorder,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(AppColors.deepBurgundy),
                  minHeight: 6,
                ),
              ),

              const SizedBox(height: 20),

              // Question Header Card
              GlassCard(
                padding: const EdgeInsets.all(22),
                gradient: isDark
                    ? AppColors.darkCardGradient
                    : AppColors.intimateCardGradient,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(otherPartner.avatar,
                            style: const TextStyle(fontSize: 22)),
                        const SizedBox(width: 8),
                        Text(
                          isTr
                              ? '${otherPartner.name} Ne Seçecek?'
                              : 'What would ${otherPartner.name} choose?',
                          style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            color: isDark
                                ? AppColors.blushPinkDeep
                                : AppColors.deepBurgundy,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      isTr ? quiz['questionTr'] : quiz['questionEn'],
                      textAlign: TextAlign.center,
                      style: AppTextStyles.titleMedium(isDark: isDark).copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Options
              for (int i = 0; i < options.length; i++) ...[
                _buildOptionTile(
                  index: i,
                  text: options[i],
                  actualIndex: actual,
                  isDark: isDark,
                  isTr: isTr,
                ),
                const SizedBox(height: 10),
              ],

              const SizedBox(height: 16),

              // Reveal / Next Actions
              if (!_isAnswerRevealed)
                GradientButton(
                  text: isTr
                      ? 'Tahminimi Göster & Aç 🔍'
                      : 'Reveal Prediction & Compare 🔍',
                  onPressed: _predictedOptionIndex == null
                      ? null
                      : () {
                          final isMatch = _predictedOptionIndex == actual;
                          setState(() {
                            _isAnswerRevealed = true;
                            if (isMatch) {
                              _matchesCount++;
                              _playConfetti = true;
                            }
                          });
                        },
                )
              else ...[
                // Fun Insight Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: (_predictedOptionIndex == actual
                            ? AppColors.successGreen
                            : AppColors.coralGold)
                        .withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: (_predictedOptionIndex == actual
                              ? AppColors.successGreen
                              : AppColors.coralGold)
                          .withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        _predictedOptionIndex == actual ? '🎯' : '💡',
                        style: const TextStyle(fontSize: 26),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _predictedOptionIndex == actual
                                  ? (isTr
                                      ? 'Mükemmel Tahmin! Kalpler Senkronize'
                                      : 'Spot On! Souls in Sync')
                                  : (isTr
                                      ? 'Tatlı Bir Keşif! Birbirimizi Öğreniyoruz'
                                      : 'Sweet Discovery! Always Learning'),
                              style: AppTextStyles.labelLarge(isDark: isDark)
                                  .copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isTr
                                  ? quiz['funInsightTr']
                                  : quiz['funInsightEn'],
                              style: AppTextStyles.bodySmall(isDark: isDark),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                GradientButton(
                  text: _currentQuizIndex < _quizzes.length - 1
                      ? (isTr ? 'Sonraki Soruya Geç ➔' : 'Next Quiz Question ➔')
                      : (isTr ? 'Testi Tamamla 🎉' : 'Finish Quiz 🎉'),
                  onPressed: () {
                    if (_currentQuizIndex < _quizzes.length - 1) {
                      setState(() {
                        _currentQuizIndex++;
                        _predictedOptionIndex = null;
                        _isAnswerRevealed = false;
                        _playConfetti = false;
                      });
                    } else {
                      _showFinalScoreDialog(context, isDark, isTr);
                    }
                  },
                ),
              ],

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required int index,
    required String text,
    required int actualIndex,
    required bool isDark,
    required bool isTr,
  }) {
    Color? tileBorderColor;
    Color? tileBgColor;

    if (_isAnswerRevealed) {
      if (index == actualIndex) {
        tileBorderColor = AppColors.successGreen;
        tileBgColor = AppColors.successGreen.withValues(alpha: 0.15);
      } else if (index == _predictedOptionIndex) {
        tileBorderColor = AppColors.coralGold;
        tileBgColor = AppColors.coralGold.withValues(alpha: 0.12);
      }
    } else if (_predictedOptionIndex == index) {
      tileBorderColor =
          isDark ? AppColors.blushPinkDeep : AppColors.deepBurgundy;
      tileBgColor = isDark
          ? AppColors.blushPinkDeep.withValues(alpha: 0.18)
          : AppColors.blushPinkLight;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: _isAnswerRevealed
          ? null
          : () {
              setState(() {
                _predictedOptionIndex = index;
              });
            },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: tileBgColor ??
              (isDark ? AppColors.darkCard : Colors.white),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: tileBorderColor ??
                (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            width: (_predictedOptionIndex == index ||
                    (_isAnswerRevealed && index == actualIndex))
                ? 1.8
                : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkCardElevated
                    : AppColors.lightBackground,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  String.fromCharCode(65 + index),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.deepBurgundy,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.bodyMedium(isDark: isDark).copyWith(
                  fontWeight: _predictedOptionIndex == index
                      ? FontWeight.w700
                      : FontWeight.w400,
                ),
              ),
            ),
            if (_isAnswerRevealed) ...[
              if (index == actualIndex)
                const Icon(Icons.check_circle_rounded,
                    color: AppColors.successGreen, size: 22)
              else if (index == _predictedOptionIndex)
                const Icon(Icons.favorite_border_rounded,
                    color: AppColors.coralGold, size: 22),
            ],
          ],
        ),
      ),
    );
  }

  void _showFinalScoreDialog(BuildContext context, bool isDark, bool isTr) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          title: Text(
            isTr ? 'Aşkın Tatlı Uyumu! 💖' : 'Sweet Harmony! 💖',
            textAlign: TextAlign.center,
            style: AppTextStyles.displaySmall(isDark: isDark),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('✨ 🥂 ✨', style: TextStyle(fontSize: 28)),
              const SizedBox(height: 12),
              Text(
                isTr
                    ? 'İlişkiniz merak ve sevgiyle dolu! Doğru tahminler ve tatlı keşiflerle birbirinizi her gün daha derinden tanıyorsunuz.'
                    : 'Your bond is rich with curiosity and love! Whether predicting right or learning something brand new, you are growing closer every single day.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium(isDark: isDark),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.blushPinkDeep.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  isTr
                      ? '$_matchesCount / ${_quizzes.length} Tahmin Eşleşmesi'
                      : '$_matchesCount of ${_quizzes.length} Matches Predicted',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.deepBurgundy,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text(isTr ? 'Harika!' : 'Wonderful!'),
              ),
            ),
          ],
        );
      },
    );
  }
}
