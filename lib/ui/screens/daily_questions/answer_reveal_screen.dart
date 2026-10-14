import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/question_model.dart';
import '../../../providers/app_state_provider.dart';
import '../../widgets/confetti_overlay.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_button.dart';

class AnswerRevealScreen extends StatefulWidget {
  final QuestionModel question;

  const AnswerRevealScreen({
    super.key,
    required this.question,
  });

  @override
  State<AnswerRevealScreen> createState() => _AnswerRevealScreenState();
}

class _AnswerRevealScreenState extends State<AnswerRevealScreen> {
  bool _playConfetti = true;

  @override
  void initState() {
    super.initState();
    // Confetti automatically bursts upon entering the reveal screen
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) {
        setState(() {
          _playConfetti = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppStateProvider>();
    final isDark = provider.isDarkMode;
    final isTr = provider.isTurkish;

    final answers = provider.getAnswersForQuestion(widget.question.id);
    final partner1 = provider.couple?.partner1 ?? provider.activePartner;
    final partner2 = provider.couple?.partner2 ?? provider.otherPartner;

    final ans1 = answers.where((a) => a.authorId == partner1.id).firstOrNull;
    final ans2 = answers.where((a) => a.authorId == partner2.id).firstOrNull;

    return ConfettiOverlay(
      isPlaying: _playConfetti,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            isTr ? 'Cevaplarımız Açıldı ✨' : 'Answers Revealed ✨',
            style: AppTextStyles.titleMedium(isDark: isDark).copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Celebration Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: AppColors.sunsetGold,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.coralGold.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🎉', style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Text(
                      isTr ? 'İki Kalp Senkronize Oldu!' : 'Two Souls in Sync!',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Question Card
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
                        Text(widget.question.categoryIcon,
                            style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: 8),
                        Text(
                          widget.question.categoryName(isTr).toUpperCase(),
                          style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? AppColors.blushPinkDeep
                                : AppColors.deepBurgundy,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.question.text(isTr),
                      textAlign: TextAlign.center,
                      style: AppTextStyles.displaySmall(isDark: isDark).copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Guided Reflection Prompt
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkCardElevated
                      : AppColors.blushPinkLight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.blushPink.withValues(alpha: 0.8),
                  ),
                ),
                child: Row(
                  children: [
                    const Text('🕊️', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        isTr
                            ? 'Birbirinizin gözlerine bakın ve cevaplarınızı sırayla sesli okuyun. Ne hissettirdiğini birbirinize anlatın.'
                            : 'Look into each other’s eyes and read your thoughts aloud. Savor the tenderness of this moment.',
                        style: AppTextStyles.bodyMedium(isDark: isDark).copyWith(
                          fontStyle: FontStyle.italic,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.burgundyRose,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Partner 1 Answer Card
              if (ans1 != null)
                _buildAnswerCard(
                  context: context,
                  partner: partner1,
                  answer: ans1,
                  isDark: isDark,
                  isTr: isTr,
                  provider: provider,
                ),

              const SizedBox(height: 16),

              // Partner 2 Answer Card
              if (ans2 != null)
                _buildAnswerCard(
                  context: context,
                  partner: partner2,
                  answer: ans2,
                  isDark: isDark,
                  isTr: isTr,
                  provider: provider,
                ),

              const SizedBox(height: 32),

              // Action Buttons: Save to Journal & Close
              GradientButton(
                text: isTr
                    ? 'Bu Anı Çift Günlüğüne Kaydet 📖'
                    : 'Save this Memory to Journal 📖',
                onPressed: () {
                  final snippet = widget.question.text(isTr);
                  provider.addJournalEntry(
                    title: isTr
                        ? '${widget.question.categoryName(isTr)} Sohbetimiz'
                        : 'Our Conversation: ${widget.question.categoryName(isTr)}',
                    notes:
                        '${partner1.name}: "${ans1?.answerText ?? ''}"\n\n${partner2.name}: "${ans2?.answerText ?? ''}"',
                    moodEmoji: '💖',
                    questionSnippet: snippet,
                    tags: ['Daily Question', widget.question.category.name],
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: AppColors.successGreen,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      content: Text(
                        isTr
                            ? 'Cevaplarınız Anılar & Çift Günlüğü bölümüne kaydedildi! 💖'
                            : 'Saved to your Couple Journal! 💖',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),

              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  isTr ? 'Günün Sorularını Tamamla' : 'Return to Dashboard',
                  style: AppTextStyles.labelLarge(isDark: isDark).copyWith(
                    color: isDark
                        ? AppColors.lavenderAccent
                        : AppColors.burgundyRose,
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerCard({
    required BuildContext context,
    required dynamic partner,
    required AnswerModel answer,
    required bool isDark,
    required bool isTr,
    required AppStateProvider provider,
  }) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author Header
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkCardElevated
                      : AppColors.blushPinkLight,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark
                        ? AppColors.blushPinkDeep
                        : AppColors.burgundyRose,
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    partner.avatar,
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    partner.name,
                    style: AppTextStyles.titleMedium(isDark: isDark).copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    isTr ? 'Cevaplandı' : 'Shared with love',
                    style: AppTextStyles.bodySmall(isDark: isDark),
                  ),
                ],
              ),
              const Spacer(),
              if (answer.reactionEmoji != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkCardElevated
                        : AppColors.blushPinkLight,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    answer.reactionEmoji!,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          // Answer Body
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkCardElevated.withValues(alpha: 0.5)
                  : AppColors.warmCream,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isDark
                    ? AppColors.darkBorder
                    : AppColors.lightBorder.withValues(alpha: 0.5),
              ),
            ),
            child: Text(
              answer.answerText,
              style: AppTextStyles.bodyLarge(isDark: isDark).copyWith(
                height: 1.55,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Quick Love Reaction Emojis
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                isTr ? 'Tepki ver:' : 'React:',
                style: AppTextStyles.bodySmall(isDark: isDark),
              ),
              const SizedBox(width: 8),
              for (final emoji in ['💖', '🥰', '✨', '🥺', '🌹'])
                GestureDetector(
                  onTap: () {
                    provider.addReactionEmoji(
                      widget.question.id,
                      answer.id,
                      emoji,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(emoji, style: const TextStyle(fontSize: 20)),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
