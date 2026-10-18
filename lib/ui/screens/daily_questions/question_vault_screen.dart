import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/question_model.dart';
import '../../../providers/app_state_provider.dart';
import '../../widgets/glass_card.dart';
import 'daily_question_screen.dart';

class QuestionVaultScreen extends StatefulWidget {
  const QuestionVaultScreen({super.key});

  @override
  State<QuestionVaultScreen> createState() => _QuestionVaultScreenState();
}

class _QuestionVaultScreenState extends State<QuestionVaultScreen> {
  QuestionCategory? _selectedCategory;
  QuestionIntensity? _selectedIntensity;

  @override
  Widget build(BuildContext context) {
    final isDark = context.select<AppStateProvider, bool>((p) => p.isDarkMode);
    final isTr = context.select<AppStateProvider, bool>((p) => p.isTurkish);
    final allQuestions = context.select<AppStateProvider, List<QuestionModel>>(
      (p) => p.questions,
    );

    var filtered = allQuestions;
    if (_selectedCategory != null) {
      filtered =
          filtered.where((q) => q.category == _selectedCategory).toList();
    }
    if (_selectedIntensity != null) {
      filtered =
          filtered.where((q) => q.intensity == _selectedIntensity).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isTr ? 'Soru Hazinesi' : 'Question Vault',
          style: AppTextStyles.titleMedium(
            isDark: isDark,
          ).copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          // Filter Chips Carousel
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                FilterChip(
                  label: Text(isTr ? 'Tümü' : 'All'),
                  selected: _selectedCategory == null,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = null;
                    });
                  },
                ),
                const SizedBox(width: 8),
                for (final cat in QuestionCategory.values) ...[
                  FilterChip(
                    avatar: Text(
                      _getCatIcon(cat),
                      style: const TextStyle(fontSize: 14),
                    ),
                    label: Text(_getCatName(cat, isTr)),
                    selected: _selectedCategory == cat,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = selected ? cat : null;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),

          // Intensity Sub-filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Text(
                  isTr ? 'Yoğunluk:' : 'Intensity:',
                  style: AppTextStyles.bodySmall(
                    isDark: isDark,
                  ).copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(width: 10),
                IntensityChoiceChip(
                  label: 'All',
                  isSelected: _selectedIntensity == null,
                  onSelected: (selected) {
                    setState(() => _selectedIntensity = null);
                  },
                ),
                const SizedBox(width: 6),
                IntensityChoiceChip(
                  label: '🌱',
                  isSelected:
                      _selectedIntensity == QuestionIntensity.icebreaker,
                  onSelected: (selected) {
                    setState(
                      () =>
                          _selectedIntensity =
                              selected ? QuestionIntensity.icebreaker : null,
                    );
                  },
                ),
                const SizedBox(width: 6),
                IntensityChoiceChip(
                  label: '🌿',
                  isSelected:
                      _selectedIntensity == QuestionIntensity.meaningful,
                  onSelected: (selected) {
                    setState(
                      () =>
                          _selectedIntensity =
                              selected ? QuestionIntensity.meaningful : null,
                    );
                  },
                ),
                const SizedBox(width: 6),
                IntensityChoiceChip(
                  label: '🌺',
                  isSelected: _selectedIntensity == QuestionIntensity.deepSoul,
                  onSelected: (selected) {
                    setState(
                      () =>
                          _selectedIntensity =
                              selected ? QuestionIntensity.deepSoul : null,
                    );
                  },
                ),
              ],
            ),
          ),

          const Divider(height: 16),

          // Questions List
          Expanded(
            child:
                filtered.isEmpty
                    ? Center(
                      child: Text(
                        isTr
                            ? 'Seçilen filtrede soru bulunamadı.'
                            : 'No questions match this filter.',
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final q = filtered[index];
                        final isAnswered = context
                            .select<AppStateProvider, bool>(
                              (p) => p.getAnswersForQuestion(q.id).isNotEmpty,
                            );
                        final isBoth = context.select<AppStateProvider, bool>(
                          (p) => p.isBothAnswered(q.id),
                        );

                        return QuestionVaultItemCard(
                          question: q,
                          isAnswered: isAnswered,
                          isBoth: isBoth,
                          isDark: isDark,
                          isTr: isTr,
                          onTap: () {
                            final provider = context.read<AppStateProvider>();
                            final realIdx = provider.questions.indexOf(q);
                            if (realIdx != -1) {
                              provider.setQuestionIndex(realIdx);
                            }
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        DailyQuestionScreen(initialQuestion: q),
                              ),
                            );
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  String _getCatIcon(QuestionCategory cat) {
    switch (cat) {
      case QuestionCategory.love:
        return '💖';
      case QuestionCategory.emotionalIntimacy:
        return '🕊️';
      case QuestionCategory.childhood:
        return '🧸';
      case QuestionCategory.memories:
        return '📸';
      case QuestionCategory.communication:
        return '💬';
      case QuestionCategory.futureDreams:
        return '✨';
      case QuestionCategory.coreValues:
        return '🧭';
      case QuestionCategory.fun:
        return '🎉';
      case QuestionCategory.romance:
        return '🌹';
      case QuestionCategory.personalGrowth:
        return '🌱';
      case QuestionCategory.lifestyle:
        return '☕';
      case QuestionCategory.deepConversations:
        return '🌌';
    }
  }

  String _getCatName(QuestionCategory cat, bool isTr) {
    if (isTr) {
      switch (cat) {
        case QuestionCategory.love:
          return 'Aşk';
        case QuestionCategory.emotionalIntimacy:
          return 'Yakınlık';
        case QuestionCategory.childhood:
          return 'Çocukluk';
        case QuestionCategory.memories:
          return 'Anılar';
        case QuestionCategory.communication:
          return 'İletişim';
        case QuestionCategory.futureDreams:
          return 'Hayaller';
        case QuestionCategory.coreValues:
          return 'Değerler';
        case QuestionCategory.fun:
          return 'Eğlence';
        case QuestionCategory.romance:
          return 'Romantizm';
        case QuestionCategory.personalGrowth:
          return 'Gelişim';
        case QuestionCategory.lifestyle:
          return 'Yaşam';
        case QuestionCategory.deepConversations:
          return 'Gece Sohbeti';
      }
    }
    switch (cat) {
      case QuestionCategory.love:
        return 'Love';
      case QuestionCategory.emotionalIntimacy:
        return 'Intimacy';
      case QuestionCategory.childhood:
        return 'Childhood';
      case QuestionCategory.memories:
        return 'Memories';
      case QuestionCategory.communication:
        return 'Communication';
      case QuestionCategory.futureDreams:
        return 'Dreams';
      case QuestionCategory.coreValues:
        return 'Values';
      case QuestionCategory.fun:
        return 'Playful';
      case QuestionCategory.romance:
        return 'Romance';
      case QuestionCategory.personalGrowth:
        return 'Growth';
      case QuestionCategory.lifestyle:
        return 'Lifestyle';
      case QuestionCategory.deepConversations:
        return 'Deep Dive';
    }
  }
}

class QuestionVaultItemCard extends StatelessWidget {
  final QuestionModel question;
  final bool isAnswered;
  final bool isBoth;
  final bool isDark;
  final bool isTr;
  final VoidCallback onTap;

  const QuestionVaultItemCard({
    super.key,
    required this.question,
    required this.isAnswered,
    required this.isBoth,
    required this.isDark,
    required this.isTr,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question.categoryIcon, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      question.categoryName(isTr).toUpperCase(),
                      style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                        letterSpacing: 1,
                        color:
                            isDark
                                ? AppColors.blushPinkDeep
                                : AppColors.burgundyRose,
                      ),
                    ),
                    const Spacer(),
                    if (isBoth)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.successGreen.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isTr ? 'Tamamlandı ✨' : 'Revealed ✨',
                          style: const TextStyle(
                            color: AppColors.successGreen,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )
                    else if (isAnswered)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.champagneGold.withValues(
                            alpha: 0.15,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isTr ? 'Bekliyor' : 'Pending',
                          style: const TextStyle(
                            color: AppColors.champagneGold,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  question.text(isTr),
                  style: AppTextStyles.titleMedium(
                    isDark: isDark,
                  ).copyWith(fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14,
            color: AppColors.lightTextMuted,
          ),
        ],
      ),
    );
  }
}

class IntensityChoiceChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const IntensityChoiceChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      selected: isSelected,
      onSelected: onSelected,
    );
  }
}
