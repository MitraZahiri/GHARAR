import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/love_language.dart';
import '../../../providers/app_state_provider.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_button.dart';

/// Love Languages quiz: each partner picks what feels more like love in
/// ten pairs, then both see their own and their partner's language.
class LoveLanguagesScreen extends StatefulWidget {
  const LoveLanguagesScreen({super.key});

  @override
  State<LoveLanguagesScreen> createState() => _LoveLanguagesScreenState();
}

class _LoveLanguagesScreenState extends State<LoveLanguagesScreen> {
  final List<LoveLanguage> _picks = [];

  void _pick(LoveLanguage language) {
    _picks.add(language);
    if (_picks.length < LoveLanguageQuiz.questions.length) {
      setState(() {});
      return;
    }
    final primary = LoveLanguageQuiz.primaryFrom(_picks);
    _picks.clear();
    if (primary != null) {
      context.read<AppStateProvider>().setMyLoveLanguage(primary);
    }
  }

  void _retake() {
    setState(_picks.clear);
    context.read<AppStateProvider>().clearMyLoveLanguage();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.select<AppStateProvider, bool>((p) => p.isDarkMode);
    final isTr = context.select<AppStateProvider, bool>((p) => p.isTurkish);
    final mine = context.select<AppStateProvider, LoveLanguage?>(
      (p) => p.activePartnerLoveLanguage,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isTr ? 'Sevgi Dillerimiz' : 'Our Love Languages',
          style: AppTextStyles.titleMedium(
            isDark: isDark,
          ).copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child:
            mine == null
                ? LoveLanguageQuestionView(
                  index: _picks.length,
                  isDark: isDark,
                  isTr: isTr,
                  onPick: _pick,
                )
                : LoveLanguageResultView(
                  mine: mine,
                  isDark: isDark,
                  isTr: isTr,
                  onRetake: _retake,
                ),
      ),
    );
  }
}

/// One forced-choice question with a progress bar.
class LoveLanguageQuestionView extends StatelessWidget {
  final int index;
  final bool isDark;
  final bool isTr;
  final ValueChanged<LoveLanguage> onPick;

  const LoveLanguageQuestionView({
    super.key,
    required this.index,
    required this.isDark,
    required this.isTr,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    final total = LoveLanguageQuiz.questions.length;
    final question = LoveLanguageQuiz.questions[index];
    final options = [question.first, question.second];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isTr
              ? 'Soru ${index + 1} / $total'
              : 'Question ${index + 1} of $total',
          style: AppTextStyles.bodySmall(
            isDark: isDark,
          ).copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: (index + 1) / total,
            backgroundColor:
                isDark ? AppColors.darkCardElevated : AppColors.lightBorder,
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppColors.deepBurgundy,
            ),
            minHeight: 6,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          isTr
              ? 'Hangisi sana daha çok sevgi gibi hissettirir?'
              : 'Which feels more like love to you?',
          style: AppTextStyles.headline(isDark: isDark),
        ),
        const SizedBox(height: 16),
        for (var i = 0; i < options.length; i++)
          GlassCard(
            key: ValueKey('love-language-option-$i'),
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(18),
            onTap: () => onPick(options[i].language),
            child: Row(
              children: [
                Text(
                  options[i].language.icon,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    options[i].text(isTr),
                    style: AppTextStyles.bodyLarge(isDark: isDark),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// My result, my partner's result (or a nudge to take it), and a tip.
class LoveLanguageResultView extends StatelessWidget {
  final LoveLanguage mine;
  final bool isDark;
  final bool isTr;
  final VoidCallback onRetake;

  const LoveLanguageResultView({
    super.key,
    required this.mine,
    required this.isDark,
    required this.isTr,
    required this.onRetake,
  });

  @override
  Widget build(BuildContext context) {
    final theirs = context.select<AppStateProvider, LoveLanguage?>(
      (p) => p.otherPartnerLoveLanguage,
    );
    final partnerName = context.select<AppStateProvider, String>(
      (p) => p.otherPartnerName,
    );

    return Column(
      key: const ValueKey('love-language-result'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LoveLanguageCard(
          heading: isTr ? 'Senin sevgi dilin' : 'Your love language',
          language: mine,
          isDark: isDark,
          isTr: isTr,
        ),
        const SizedBox(height: 14),
        if (theirs != null) ...[
          LoveLanguageCard(
            heading:
                isTr
                    ? '$partnerName için sevgi dili'
                    : '$partnerName’s love language',
            language: theirs,
            isDark: isDark,
            isTr: isTr,
          ),
          const SizedBox(height: 14),
          GlassCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('💡', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isTr
                            ? 'Bugün onun dilinden konuş:'
                            : 'Speak their language today:',
                        style: AppTextStyles.bodySmall(
                          isDark: isDark,
                        ).copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        theirs.partnerTip(isTr),
                        style: AppTextStyles.bodyMedium(isDark: isDark),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ] else
          GlassCard(
            padding: const EdgeInsets.all(16),
            child: Text(
              isTr
                  ? '$partnerName henüz testi çözmedi. Birlikte çözün, birbirinizin dilini öğrenin.'
                  : '$partnerName hasn’t taken the quiz yet. Take it together and learn each other’s language.',
              style: AppTextStyles.bodyMedium(isDark: isDark),
            ),
          ),
        const SizedBox(height: 24),
        GradientButton(
          key: const ValueKey('love-language-retake'),
          text: isTr ? 'Testi Yeniden Çöz' : 'Retake the Quiz',
          onPressed: onRetake,
        ),
      ],
    );
  }
}

/// A single partner's love language with its description.
class LoveLanguageCard extends StatelessWidget {
  final String heading;
  final LoveLanguage language;
  final bool isDark;
  final bool isTr;

  const LoveLanguageCard({
    super.key,
    required this.heading,
    required this.language,
    required this.isDark,
    required this.isTr,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading.toUpperCase(),
            style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
              fontSize: 10,
              letterSpacing: 1,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.blushPinkDeep : AppColors.burgundyRose,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(language.icon, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  language.title(isTr),
                  style: AppTextStyles.titleMedium(
                    isDark: isDark,
                  ).copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            language.description(isTr),
            style: AppTextStyles.bodyMedium(isDark: isDark),
          ),
        ],
      ),
    );
  }
}
