import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/question_model.dart';
import '../../../models/user_model.dart';
import '../../../providers/app_state_provider.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_button.dart';
import 'answer_reveal_screen.dart';
import 'question_vault_screen.dart';

class DailyQuestionScreen extends StatefulWidget {
  final QuestionModel? initialQuestion;

  const DailyQuestionScreen({super.key, this.initialQuestion});

  @override
  State<DailyQuestionScreen> createState() => _DailyQuestionScreenState();
}

class _DailyQuestionScreenState extends State<DailyQuestionScreen> {
  final TextEditingController _answerController = TextEditingController();
  int? _selectedOptionIndex;
  bool _showInspiration = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadExistingAnswer();
    });
  }

  void _loadExistingAnswer() {
    final provider = context.read<AppStateProvider>();
    final q = widget.initialQuestion ?? provider.currentQuestion;
    if (q == null) return;
    final existing = provider.getAnswerForActivePartner(q.id);
    if (existing != null) {
      _answerController.text = existing.answerText;
      _selectedOptionIndex = existing.selectedOptionIndex;
      setState(() {});
    }
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.select<AppStateProvider, bool>((p) => p.isDarkMode);
    final isTr = context.select<AppStateProvider, bool>((p) => p.isTurkish);

    final currentQ = context.select<AppStateProvider, QuestionModel?>(
      (p) => p.currentQuestion,
    );
    final question = widget.initialQuestion ?? currentQ;

    if (question == null) {
      return Scaffold(
        appBar: AppBar(title: Text(isTr ? 'Günün Sorusu' : 'Daily Question')),
        body: Center(
          child: Text(isTr ? 'Soru bulunamadı' : 'No question available'),
        ),
      );
    }

    final activeAnswer = context.select<AppStateProvider, AnswerModel?>(
      (p) => p.getAnswerForActivePartner(question.id),
    );
    final otherAnswer = context.select<AppStateProvider, AnswerModel?>(
      (p) => p.getAnswerForOtherPartner(question.id),
    );
    final isBothDone = context.select<AppStateProvider, bool>(
      (p) => p.isBothAnswered(question.id),
    );
    final activePartner = context.select<AppStateProvider, UserModel>(
      (p) => p.activePartner,
    );
    final otherPartner = context.select<AppStateProvider, UserModel>(
      (p) => p.otherPartner,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isTr ? 'Günün Sorusu' : 'Daily Question',
          style: AppTextStyles.titleMedium(
            isDark: isDark,
          ).copyWith(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_stories_rounded),
            tooltip: isTr ? 'Tüm Soruları Gör' : 'Browse Question Vault',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const QuestionVaultScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question Card with Intensity & Category
            GlassCard(
              padding: const EdgeInsets.all(22),
              gradient:
                  isDark
                      ? AppColors.darkCardGradient
                      : AppColors.intimateCardGradient,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isDark
                                    ? AppColors.darkCardElevated
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color:
                                  isDark
                                      ? AppColors.darkBorder
                                      : AppColors.lightBorder,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                question.categoryIcon,
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  question.categoryName(isTr),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: AppTextStyles.bodySmall(
                                    isDark: isDark,
                                  ).copyWith(
                                    fontWeight: FontWeight.w700,
                                    color:
                                        isDark
                                            ? AppColors.blushPinkDeep
                                            : AppColors.deepBurgundy,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Intensity Badge
                      QuestionIntensityBadge(
                        intensity: question.intensity,
                        isTr: isTr,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    question.text(isTr),
                    style: AppTextStyles.displaySmall(
                      isDark: isDark,
                    ).copyWith(fontWeight: FontWeight.w700, height: 1.3),
                  ),
                  if (question.inspirationTip(isTr) != null) ...[
                    const SizedBox(height: 14),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _showInspiration = !_showInspiration;
                        });
                      },
                      child: Row(
                        children: [
                          Icon(
                            _showInspiration
                                ? Icons.lightbulb_rounded
                                : Icons.lightbulb_outline_rounded,
                            size: 16,
                            color: AppColors.champagneGold,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              isTr
                                  ? (_showInspiration
                                      ? 'İpucunu Gizle'
                                      : 'İlham İpucu İster misiniz?')
                                  : (_showInspiration
                                      ? 'Hide Inspiration Tip'
                                      : 'Need an Inspiration Spark?'),
                              style: AppTextStyles.bodySmall(
                                isDark: isDark,
                              ).copyWith(
                                color: AppColors.champagneGold,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_showInspiration) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.champagneGold.withValues(
                            alpha: 0.12,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColors.champagneGold.withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ),
                        child: Text(
                          question.inspirationTip(isTr)!,
                          style: AppTextStyles.bodySmall(
                            isDark: isDark,
                          ).copyWith(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Partner Status Notice
            PartnerStatusNoticeBox(
              otherPartner: otherPartner,
              hasOtherAnswered: otherAnswer != null,
              isDark: isDark,
              isTr: isTr,
            ),

            const SizedBox(height: 16),

            // Multiple Choice Options (if present)
            if (question.options(isTr) != null &&
                question.options(isTr)!.isNotEmpty) ...[
              Text(
                isTr
                    ? 'Hızlı Seçenekler (Veya Aşağıya Yazın)'
                    : 'Quick Options (Or Type Below)',
                style: AppTextStyles.labelLarge(isDark: isDark),
              ),
              const SizedBox(height: 8),
              for (int i = 0; i < question.options(isTr)!.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      setState(() {
                        _selectedOptionIndex = i;
                        _answerController.text = question.options(isTr)![i];
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color:
                            _selectedOptionIndex == i
                                ? (isDark
                                    ? AppColors.blushPinkDeep.withValues(
                                      alpha: 0.2,
                                    )
                                    : AppColors.blushPinkLight)
                                : (isDark ? AppColors.darkCard : Colors.white),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color:
                              _selectedOptionIndex == i
                                  ? (isDark
                                      ? AppColors.blushPinkDeep
                                      : AppColors.deepBurgundy)
                                  : (isDark
                                      ? AppColors.darkBorder
                                      : AppColors.lightBorder),
                          width: _selectedOptionIndex == i ? 1.8 : 1.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _selectedOptionIndex == i
                                ? Icons.radio_button_checked_rounded
                                : Icons.radio_button_off_rounded,
                            color:
                                _selectedOptionIndex == i
                                    ? (isDark
                                        ? AppColors.blushPinkDeep
                                        : AppColors.deepBurgundy)
                                    : (isDark
                                        ? AppColors.darkTextMuted
                                        : AppColors.lightTextMuted),
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              question.options(isTr)![i],
                              style: AppTextStyles.bodyMedium(
                                isDark: isDark,
                              ).copyWith(
                                fontWeight:
                                    _selectedOptionIndex == i
                                        ? FontWeight.w700
                                        : FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 12),
            ],

            // Free-form Answer Input
            Text(
              isTr
                  ? '${activePartner.name} olarak cevabınız:'
                  : 'Your answer as ${activePartner.name}:',
              style: AppTextStyles.labelLarge(isDark: isDark),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _answerController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText:
                    isTr
                        ? 'İçinizden geldiği gibi tüm samimiyetinizle yazın... Partneriniz bunu ancak kendisi de cevap yazınca görebilecek.'
                        : 'Speak from your heart... Your partner will only see this once both of you submit your answers.',
              ),
            ),

            const SizedBox(height: 12),

            // Privacy Assurance Note
            Row(
              children: [
                const Icon(
                  Icons.lock_rounded,
                  size: 14,
                  color: AppColors.champagneGold,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    isTr
                        ? 'Karşılıklı cevap verilene kadar gizlilik korunur. Önceden bakma yok!'
                        : 'Answers remain strictly confidential until mutual reveal. No peeking!',
                    style: AppTextStyles.bodySmall(
                      isDark: isDark,
                    ).copyWith(color: AppColors.champagneGold, fontSize: 11),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Submit / Reveal Buttons
            if (isBothDone) ...[
              GradientButton(
                text:
                    isTr
                        ? 'Cevapları Birlikte Aç ✨ (İkiniz de Hazırsınız!)'
                        : 'Reveal Answers Together ✨ (Both Ready!)',
                gradient: AppColors.sunsetGold,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (context) => AnswerRevealScreen(question: question),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
            ],

            GradientButton(
              text:
                  activeAnswer != null
                      ? (isTr ? 'Cevabımı Güncelle' : 'Update My Answer')
                      : (isTr ? 'Cevabımı Kaydet 💌' : 'Submit My Answer 💌'),
              onPressed: () {
                if (_answerController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isTr
                            ? 'Lütfen önce cevabınızı yazın veya bir seçenek seçin.'
                            : 'Please enter your thoughts or choose an option.',
                      ),
                    ),
                  );
                  return;
                }

                context.read<AppStateProvider>().submitAnswer(
                  questionId: question.id,
                  answerText: _answerController.text.trim(),
                  selectedOptionIndex: _selectedOptionIndex,
                );

                if (context.read<AppStateProvider>().isBothAnswered(
                  question.id,
                )) {
                  // Direct to reveal!
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder:
                          (context) => AnswerRevealScreen(question: question),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: AppColors.deepBurgundy,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      content: Text(
                        isTr
                            ? 'Cevabınız kaydedildi! ${otherPartner.name} da cevaplayınca birlikte açılacak.'
                            : 'Answer saved! Once ${otherPartner.name} answers, you can reveal together.',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  );
                }
              },
            ),

            const SizedBox(height: 16),

            // Helper Simulation Button (for interactive demo testing!)
            if (otherAnswer == null)
              OutlinedButton.icon(
                icon: const Icon(Icons.bolt_rounded, size: 18),
                label: Text(
                  isTr
                      ? '${otherPartner.name} Adına Cevap Simüle Et (Test)'
                      : 'Simulate ${otherPartner.name}’s Answer (Demo)',
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                onPressed: () {
                  context.read<AppStateProvider>().simulatePartnerAnswer(
                    question.id,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: AppColors.successGreen,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      content: Text(
                        isTr
                            ? '${otherPartner.name} cevabını verdi! Artık açabilirsiniz.'
                            : '${otherPartner.name} just answered! You can now reveal.',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  );
                },
              ),

            const SizedBox(height: 16),

            // Skip & Draw Another Actions (No penalty!)
            Wrap(
              spacing: 8,
              runSpacing: 4,
              alignment: WrapAlignment.center,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.shuffle_rounded, size: 18),
                  label: Text(
                    isTr ? 'Başka Soru Çek' : 'Draw Another',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onPressed: () {
                    context.read<AppStateProvider>().drawRandomQuestion();
                    _answerController.clear();
                    _selectedOptionIndex = null;
                    _loadExistingAnswer();
                  },
                ),
                TextButton.icon(
                  icon: const Icon(Icons.skip_next_rounded, size: 18),
                  label: Text(
                    isTr ? 'Soruyu Atla' : 'Skip Question',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onPressed: () {
                    context.read<AppStateProvider>().nextQuestion();
                    _answerController.clear();
                    _selectedOptionIndex = null;
                    _loadExistingAnswer();
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

/// Dedicated widget for displaying question intensity badge.
class QuestionIntensityBadge extends StatelessWidget {
  final QuestionIntensity intensity;
  final bool isTr;

  const QuestionIntensityBadge({
    super.key,
    required this.intensity,
    required this.isTr,
  });

  @override
  Widget build(BuildContext context) {
    String label;
    Color color;

    switch (intensity) {
      case QuestionIntensity.icebreaker:
        label = isTr ? 'Hafif 🌱' : 'Playful 🌱';
        color = AppColors.successGreen;
        break;
      case QuestionIntensity.meaningful:
        label = isTr ? 'Anlamlı 🌿' : 'Meaningful 🌿';
        color = AppColors.lavenderDeep;
        break;
      case QuestionIntensity.deepSoul:
        label = isTr ? 'Derin Ruh 🌺' : 'Deep Soul 🌺';
        color = AppColors.coralGold;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// Dedicated widget for partner answering status notice.
class PartnerStatusNoticeBox extends StatelessWidget {
  final UserModel otherPartner;
  final bool hasOtherAnswered;
  final bool isDark;
  final bool isTr;

  const PartnerStatusNoticeBox({
    super.key,
    required this.otherPartner,
    required this.hasOtherAnswered,
    required this.isDark,
    required this.isTr,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor =
        hasOtherAnswered ? AppColors.successGreen : AppColors.champagneGold;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: statusColor.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Text(otherPartner.avatar, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              hasOtherAnswered
                  ? (isTr
                      ? '${otherPartner.name} cevabını yazdı bile! ✨ Karşılıklı okumak için şimdi yanıtlayın.'
                      : '${otherPartner.name} has submitted their answer! ✨ Answer yours now to reveal together.')
                  : (isTr
                      ? '${otherPartner.name} henüz yanıtlamadı. Sizinkini hemen kaydedin, hazır olsun!'
                      : '${otherPartner.name} is reflecting. Answer yours now so you are ready!'),
              style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
                fontWeight: FontWeight.w600,
                color:
                    isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
              ),
            ),
          ),
          if (hasOtherAnswered)
            const Icon(
              Icons.check_circle_rounded,
              color: AppColors.successGreen,
              size: 20,
            ),
        ],
      ),
    );
  }
}
