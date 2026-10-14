import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../providers/app_state_provider.dart';
import '../../widgets/confetti_overlay.dart';
import '../../widgets/glass_card.dart';

class WeeklyChallengesScreen extends StatefulWidget {
  const WeeklyChallengesScreen({super.key});

  @override
  State<WeeklyChallengesScreen> createState() => _WeeklyChallengesScreenState();
}

class _WeeklyChallengesScreenState extends State<WeeklyChallengesScreen> {
  bool _playConfetti = false;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppStateProvider>();
    final isDark = provider.isDarkMode;
    final isTr = provider.isTurkish;

    final challenges = provider.challenges;
    final completedCount = challenges.where((c) => c.isCompleted).length;

    return ConfettiOverlay(
      isPlaying: _playConfetti,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            isTr ? 'Haftalık Çift Görevleri' : 'Weekly Couple Challenges',
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
              // Badge Showcase Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: isDark
                      ? AppColors.darkCardGradient
                      : AppColors.intimateCardGradient,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        gradient: AppColors.sunsetGold,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.coralGold.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text('🏆', style: TextStyle(fontSize: 28)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isTr ? 'Aşk Rozeti Koleksiyonu' : 'Love Badge Collection',
                            style: AppTextStyles.titleMedium(isDark: isDark)
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isTr
                                ? '$completedCount / ${challenges.length} Başarıyla Tamamlandı'
                                : '$completedCount of ${challenges.length} Completed Together',
                            style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
                              color: AppColors.champagneGold,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            isTr
                                ? 'Görevleri kaçırsanız da suçluluk yok; sevgi her zaman kendi hızında akar!'
                                : 'Gentle streaks with zero guilt. Love always flows at its own pace.',
                            style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Text(
                isTr ? 'Haftalık Görevler' : 'All Weekly Challenges',
                style: AppTextStyles.headline(isDark: isDark),
              ),

              const SizedBox(height: 12),

              for (final ch in challenges) ...[
                GlassCard(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: (ch.isCompleted
                                      ? AppColors.successGreen
                                      : AppColors.lavenderDeep)
                                  .withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              isTr
                                  ? 'Hafta ${ch.weekNumber}'
                                  : 'Week ${ch.weekNumber}',
                              style: TextStyle(
                                color: ch.isCompleted
                                    ? AppColors.successGreen
                                    : AppColors.lavenderDeep,
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          const Spacer(),
                          // Badge preview
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.darkCardElevated
                                  : AppColors.warmCream,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isDark
                                    ? AppColors.darkBorder
                                    : AppColors.lightBorder,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(ch.rewardBadge,
                                    style: const TextStyle(fontSize: 14)),
                                const SizedBox(width: 4),
                                Text(
                                  ch.badgeName(isTr),
                                  style: AppTextStyles.bodySmall(isDark: isDark)
                                      .copyWith(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        ch.title(isTr),
                        style: AppTextStyles.titleMedium(isDark: isDark).copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        ch.description(isTr),
                        style: AppTextStyles.bodyMedium(isDark: isDark),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '“${ch.encouragement(isTr)}”',
                        style: AppTextStyles.quote(isDark: isDark).copyWith(
                          fontSize: 12,
                        ),
                      ),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            icon: Icon(
                              ch.isCompleted
                                  ? Icons.check_circle_rounded
                                  : Icons.circle_outlined,
                              color: ch.isCompleted
                                  ? AppColors.successGreen
                                  : (isDark
                                      ? AppColors.darkTextMuted
                                      : AppColors.lightTextMuted),
                            ),
                            label: Text(
                              ch.isCompleted
                                  ? (isTr ? 'Kutlandı & Bitti ✨' : 'Celebrated! ✨')
                                  : (isTr
                                      ? 'Tamamlandı Olarak İşaretle'
                                      : 'Mark as Completed'),
                              style: TextStyle(
                                color: ch.isCompleted
                                    ? AppColors.successGreen
                                    : (isDark
                                        ? AppColors.darkTextPrimary
                                        : AppColors.deepBurgundy),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            onPressed: () {
                              provider.toggleCompleteChallenge(ch.id);
                              if (!ch.isCompleted) {
                                setState(() {
                                  _playConfetti = true;
                                });
                                Future.delayed(
                                    const Duration(milliseconds: 2500), () {
                                  if (mounted) {
                                    setState(() {
                                      _playConfetti = false;
                                    });
                                  }
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
