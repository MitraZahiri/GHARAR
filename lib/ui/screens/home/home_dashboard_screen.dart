import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/challenge_model.dart';
import '../../../models/couple_model.dart';
import '../../../models/question_model.dart';
import '../../../models/shared_interest_model.dart';
import '../../../models/special_date_model.dart';
import '../../../models/user_model.dart';
import '../../../providers/app_state_provider.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/romantic_app_bar.dart';
import '../../widgets/streak_badge.dart';
import '../../widgets/soul_connection_art.dart';
import '../onboarding/partner_invite_screen.dart';
import '../daily_questions/answer_reveal_screen.dart';
import '../daily_questions/daily_question_screen.dart';
import '../activities/surprise_generator_modal.dart';
import '../activities/weekly_challenges_screen.dart';
import '../memories/special_dates_screen.dart';

class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.select<AppStateProvider, bool>((p) => p.isDarkMode);
    final isTr = context.select<AppStateProvider, bool>((p) => p.isTurkish);
    final isPartnerLinked = context.select<AppStateProvider, bool>((p) => p.isPartnerLinked);

    final couple = context.select<AppStateProvider, CoupleModel?>((p) => p.couple);
    final activePartner = context.select<AppStateProvider, UserModel>((p) => p.activePartner);
    final otherPartner = context.select<AppStateProvider, UserModel>((p) => p.otherPartner);
    final currentQ = context.select<AppStateProvider, QuestionModel?>((p) => p.currentQuestion);

    final isBothAnswered = currentQ != null &&
        context.select<AppStateProvider, bool>((p) => p.isBothAnswered(currentQ.id));
    final activeAnswer = currentQ != null
        ? context.select<AppStateProvider, AnswerModel?>(
            (p) => p.getAnswerForActivePartner(currentQ.id))
        : null;
    final otherAnswer = currentQ != null
        ? context.select<AppStateProvider, AnswerModel?>(
            (p) => p.getAnswerForOtherPartner(currentQ.id))
        : null;

    final activeChallenge = context.select<AppStateProvider, ChallengeModel?>(
      (p) => p.challenges.firstOrNull,
    );
    final upcomingDate = context.select<AppStateProvider, SpecialDateModel?>(
      (p) => p.specialDates.firstOrNull,
    );
    final featuredInterest = context.select<AppStateProvider, SharedInterestModel?>(
      (p) => p.sharedInterests.firstOrNull,
    );

    return Scaffold(
      appBar: const RomanticAppBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          // Soft refresh
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width <= 360 ? 14 : 20,
            vertical: 12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting & Connection Streak Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getGreeting(isTr),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodyMedium(isDark: isDark)
                              .copyWith(
                            color: isDark
                                ? AppColors.lavenderAccent
                                : AppColors.burgundyRose,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          couple != null && couple.partner2 != null
                              ? '${couple.partner1.name} & ${couple.partner2!.name}'
                              : (couple != null
                                  ? '${couple.partner1.name} & ${isTr ? "Partner Bekleniyor" : "Partner Pending"}'
                                  : activePartner.name),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.displaySmall(isDark: isDark)
                              .copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                            fontSize: MediaQuery.sizeOf(context).width <= 360 ? 22 : 26,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (couple != null)
                    StreakBadge(
                      streakDays: couple.connectionStreak,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: AppColors.deepBurgundy,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            content: Text(
                              isTr
                                  ? 'Harika! ${couple.connectionStreak} gündür her gün sevginizi besliyorsunuz. 🔥'
                                  : 'Blooming! You have nurtured your bond for ${couple.connectionStreak} consecutive days. 🔥',
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),

              const SizedBox(height: 18),

              // Soul Connection Invite Card (Displayed when Partner is not linked yet)
              if (!isPartnerLinked) ...[
                GlassCard(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  gradient: isDark
                      ? AppColors.darkCardGradient
                      : AppColors.intimateCardGradient,
                  borderColor: isDark ? AppColors.darkBorder : AppColors.heartGold.withValues(alpha: 0.5),
                  child: Column(
                    children: [
                      const SoulConnectionArt(
                        width: 200,
                        height: 140,
                        animateGlow: true,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        isTr
                            ? 'İki Ruh Birbirini Bekliyor'
                            : 'Two Souls Waiting to Connect',
                        style: AppTextStyles.titleMedium(isDark: isDark).copyWith(
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.heartGoldGlow : AppColors.terracottaDeep,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isTr
                            ? 'Partnerinizi özel çift kodunuzla davet ederek birlikte yanıtları keşfedin.'
                            : 'Invite your partner with your couple code to reveal answers together.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodySmall(isDark: isDark),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.share_rounded, size: 16),
                        label: Text(isTr ? 'Partneri Davet Et 💌' : 'Invite Partner 💌'),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const PartnerInviteScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
              ],

              // Hero Daily Question Card (The Heart of GHARAR)
              if (currentQ != null)
                GlassCard(
                  padding: const EdgeInsets.all(22),
                  gradient: isDark
                      ? AppColors.darkCardGradient
                      : AppColors.intimateCardGradient,
                  borderColor: isBothAnswered
                      ? AppColors.champagneGold
                      : (isDark
                          ? AppColors.darkBorder
                          : AppColors.blushPinkDeep.withValues(alpha: 0.6)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Tag & Draw Another
                      Row(
                        children: [
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.darkCardElevated
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isDark
                                      ? AppColors.darkBorder
                                      : AppColors.lightBorder,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(currentQ.categoryIcon,
                                      style: const TextStyle(fontSize: 14)),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      currentQ.categoryName(isTr).toUpperCase(),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: AppTextStyles.bodySmall(isDark: isDark)
                                          .copyWith(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 10,
                                        letterSpacing: 1,
                                        color: isDark
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
                          IconButton(
                            icon: const Icon(Icons.shuffle_rounded, size: 20),
                            tooltip:
                                isTr ? 'Başka Soru Çek' : 'Draw Another Question',
                            onPressed: () {
                              context.read<AppStateProvider>().drawRandomQuestion();
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      Text(
                        currentQ.text(isTr),
                        style: AppTextStyles.displaySmall(isDark: isDark)
                            .copyWith(
                          fontWeight: FontWeight.w700,
                          height: 1.35,
                          fontSize: 20,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Partner Status Indicator
                      Row(
                        children: [
                          Expanded(
                            child: MiniPartnerAvatarStatus(
                              avatar: activePartner.avatar,
                              name: activePartner.name,
                              hasAnswered: activeAnswer != null,
                              isDark: isDark,
                              isTr: isTr,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: MiniPartnerAvatarStatus(
                              avatar: otherPartner.avatar,
                              name: otherPartner.name,
                              hasAnswered: otherAnswer != null,
                              isDark: isDark,
                              isTr: isTr,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Primary CTA: Connect Today or Reveal Answers
                      if (isBothAnswered)
                        GradientButton(
                          text: isTr
                              ? 'Cevapları Birlikte Aç ✨ (İkiniz de Hazır!)'
                              : 'Reveal Answers Together ✨ (Both Ready!)',
                          gradient: AppColors.sunsetGold,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    AnswerRevealScreen(question: currentQ),
                              ),
                            );
                          },
                        )
                      else
                        GradientButton(
                          text: activeAnswer != null
                              ? (isTr
                                  ? 'Cevabım Hazır • Partnere Bak'
                                  : 'My Answer Saved • View Status')
                              : (isTr ? 'Bugün Bağlan 💌' : 'Connect Today 💌'),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => DailyQuestionScreen(
                                    initialQuestion: currentQ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),

              const SizedBox(height: 18),

              // Weekly Couple Challenge Banner
              if (activeChallenge != null)
                GlassCard(
                  padding: const EdgeInsets.all(18),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const WeeklyChallengesScreen(),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: AppColors.sunsetGold,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(activeChallenge.rewardBadge,
                              style: const TextStyle(fontSize: 24)),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    isTr
                                        ? 'HAFTALIK ÇİFT GÖREVİ'
                                        : 'WEEKLY COUPLE CHALLENGE',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.bodySmall(isDark: isDark)
                                        .copyWith(
                                      fontSize: 10,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.w700,
                                      color: isDark
                                          ? AppColors.blushPinkDeep
                                          : AppColors.burgundyRose,
                                    ),
                                  ),
                                ),
                                if (activeChallenge.isCompleted) ...[
                                  const SizedBox(width: 6),
                                  const Icon(Icons.check_circle_rounded,
                                      color: AppColors.successGreen, size: 16),
                                ],
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              activeChallenge.title(isTr),
                              style: AppTextStyles.titleMedium(isDark: isDark)
                                  .copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              activeChallenge.description(isTr),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.bodySmall(isDark: isDark),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_ios_rounded,
                          size: 14, color: AppColors.lightTextMuted),
                    ],
                  ),
                ),

              const SizedBox(height: 18),

              // Two Column Cards: Romantic Surprise Generator & Upcoming Date
              Row(
                children: [
                  // Romantic Surprise Card
                  Expanded(
                    child: GlassCard(
                      padding: const EdgeInsets.all(16),
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => const SurpriseGeneratorModal(),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('🎲', style: TextStyle(fontSize: 26)),
                          const SizedBox(height: 10),
                          Text(
                            isTr ? 'Romantik Sürpriz' : 'Romantic Surprise',
                            style: AppTextStyles.titleMedium(isDark: isDark)
                                .copyWith(fontWeight: FontWeight.w700, fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isTr ? 'Tatlı bir jest çekin' : 'Roll spontaneous idea',
                            style: AppTextStyles.bodySmall(isDark: isDark)
                                .copyWith(fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Special Dates Countdown Card
                  Expanded(
                    child: GlassCard(
                      padding: const EdgeInsets.all(16),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SpecialDatesScreen(),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(upcomingDate?.icon ?? '💍',
                                  style: const TextStyle(fontSize: 24)),
                              const Spacer(),
                              if (upcomingDate != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.champagneGold
                                        .withValues(alpha: 0.18),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${upcomingDate.daysUntil}d',
                                    style: const TextStyle(
                                      color: AppColors.champagneGold,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            upcomingDate?.title(isTr) ??
                                (isTr ? 'Özel Günler' : 'Special Dates'),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.titleMedium(isDark: isDark)
                                .copyWith(fontWeight: FontWeight.w700, fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isTr ? 'Geri sayım & takvim' : 'Countdown & dates',
                            style: AppTextStyles.bodySmall(isDark: isDark)
                                .copyWith(fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Mutual Spark Feature Card
              if (featuredInterest != null)
                GlassCard(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(featuredInterest.icon,
                              style: const TextStyle(fontSize: 22)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isTr
                                      ? 'GÜNÜN ORTAK KIVILCIMI'
                                      : 'MUTUAL SPARK OF THE DAY',
                                  style: AppTextStyles.bodySmall(isDark: isDark)
                                      .copyWith(
                                    fontSize: 10,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.w700,
                                    color: isDark
                                        ? AppColors.blushPinkDeep
                                        : AppColors.burgundyRose,
                                  ),
                                ),
                                Text(
                                  featuredInterest.title(isTr),
                                  style: AppTextStyles.titleMedium(isDark: isDark)
                                      .copyWith(fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        featuredInterest.description(isTr),
                        style: AppTextStyles.bodyMedium(isDark: isDark),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  String _getGreeting(bool isTr) {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return isTr ? 'Günaydın sevgililer ✨' : 'Good morning, lovely souls ✨';
    } else if (hour < 18) {
      return isTr ? 'Tünaydın güzel kalpler ☀️' : 'Good afternoon, sweethearts ☀️';
    } else {
      return isTr ? 'İyi akşamlar sevgililer 🌙' : 'Good evening, beloved souls 🌙';
    }
  }
}

/// Dedicated widget for displaying a partner's mini avatar status.
class MiniPartnerAvatarStatus extends StatelessWidget {
  final String avatar;
  final String name;
  final bool hasAnswered;
  final bool isDark;
  final bool isTr;

  const MiniPartnerAvatarStatus({
    super.key,
    required this.avatar,
    required this.name,
    required this.hasAnswered,
    required this.isDark,
    required this.isTr,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkCardElevated
                    : AppColors.blushPinkLight,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(avatar, style: const TextStyle(fontSize: 18)),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 11,
                height: 11,
                decoration: BoxDecoration(
                  color: hasAnswered
                      ? AppColors.successGreen
                      : AppColors.champagneGold,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
              Text(
                hasAnswered
                    ? (isTr ? 'Cevapladı' : 'Answered')
                    : (isTr ? 'Düşünüyor' : 'Thinking...'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  color: hasAnswered
                      ? AppColors.successGreen
                      : AppColors.champagneGold,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
