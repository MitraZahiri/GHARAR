import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/user_model.dart';
import '../../providers/app_state_provider.dart';
import 'glass_card.dart';

/// Represents romantic emotional mood frequencies that couples can share.
class CoupleMoodDef {
  final String key;
  final String emoji;
  final String labelTr;
  final String labelEn;
  final Color accentColor;

  const CoupleMoodDef({
    required this.key,
    required this.emoji,
    required this.labelTr,
    required this.labelEn,
    required this.accentColor,
  });

  String label(bool isTr) => isTr ? labelTr : labelEn;
}

const List<CoupleMoodDef> kCoupleMoods = [
  CoupleMoodDef(
    key: 'romantic',
    emoji: '💖',
    labelTr: 'Aşık & Romantik',
    labelEn: 'In Love & Romantic',
    accentColor: AppColors.heartGoldGlow,
  ),
  CoupleMoodDef(
    key: 'peaceful',
    emoji: '🕊️',
    labelTr: 'Huzurlu & Sakin',
    labelEn: 'Peaceful & Serene',
    accentColor: AppColors.blushPinkDeep,
  ),
  CoupleMoodDef(
    key: 'joyful',
    emoji: '☀️',
    labelTr: 'Neşeli & Enerjik',
    labelEn: 'Joyful & Vibrant',
    accentColor: AppColors.champagneGold,
  ),
  CoupleMoodDef(
    key: 'cuddle',
    emoji: '🫂',
    labelTr: 'Şefkat & Sarılma',
    labelEn: 'Craving Cuddles',
    accentColor: AppColors.terracotta,
  ),
  CoupleMoodDef(
    key: 'resting',
    emoji: '🌙',
    labelTr: 'Dalgın & Dinleniyor',
    labelEn: 'Quiet & Resting',
    accentColor: AppColors.lavenderAccent,
  ),
  CoupleMoodDef(
    key: 'talk',
    emoji: '☕',
    labelTr: 'Sohbet & Kahve',
    labelEn: 'Ready to Chat',
    accentColor: AppColors.warmCream,
  ),
];

CoupleMoodDef? getMoodDef(String? key) {
  if (key == null) return null;
  return kCoupleMoods.where((m) => m.key == key).firstOrNull;
}

/// An interactive soulmate card showing active moods, a live "Love Pulse" (Seni Düşünüyorum)
/// trigger, and an interactive single-device partner perspective switcher.
class SoulmatePulseCard extends StatelessWidget {
  const SoulmatePulseCard({super.key});

  void _openMoodPicker(BuildContext context, bool isDark, bool isTr) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _MoodPickerModal(isDark: isDark, isTr: isTr),
    );
  }

  void _onSendNudge(BuildContext context, UserModel partner, bool isTr) {
    HapticFeedback.lightImpact();
    context.read<AppStateProvider>().sendLoveNudge();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.deepBurgundy,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Row(
          children: [
            const Text('💓', style: TextStyle(fontSize: 20)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                isTr
                    ? '${partner.name} için sıcacık bir sevgi dokunuşu gönderildi!'
                    : 'A warm love pulse was sent to ${partner.name}!',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.select<AppStateProvider, bool>((p) => p.isDarkMode);
    final isTr = context.select<AppStateProvider, bool>((p) => p.isTurkish);

    final activePartner = context.select<AppStateProvider, UserModel>(
      (p) => p.activePartner,
    );
    final otherPartner = context.select<AppStateProvider, UserModel>(
      (p) => p.otherPartner,
    );
    final activeMoodKey = context.select<AppStateProvider, String?>(
      (p) => p.activePartnerMood,
    );
    final otherMoodKey = context.select<AppStateProvider, String?>(
      (p) => p.otherPartnerMood,
    );
    final lastNudgeTime = context.select<AppStateProvider, DateTime?>(
      (p) => p.lastNudgeTime,
    );
    final lastNudgeSender = context.select<AppStateProvider, String?>(
      (p) => p.lastNudgeSenderId,
    );

    final activeMood = getMoodDef(activeMoodKey);
    final otherMood = getMoodDef(otherMoodKey);

    final isNarrow = MediaQuery.sizeOf(context).width <= 360;

    return GlassCard(
      padding: EdgeInsets.symmetric(
        horizontal: isNarrow ? 14 : 18,
        vertical: 16,
      ),
      gradient:
          isDark ? AppColors.darkCardGradient : AppColors.intimateCardGradient,
      borderColor:
          isDark
              ? AppColors.darkBorder
              : AppColors.heartGold.withValues(alpha: 0.35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title & Perspective Switcher Capsule
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🕊️', style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        isTr ? 'RUH HALİ & BAĞLANTI' : 'SOUL PULSE',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.1,
                          fontSize: 10,
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
              const SizedBox(width: 6),
              // Interactive Single-Device Perspective Switcher
              FittedBox(
                fit: BoxFit.scaleDown,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    HapticFeedback.selectionClick();
                    context.read<AppStateProvider>().switchActivePartner();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: AppColors.deepBurgundy,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        content: Text(
                          isTr
                              ? 'Görünüm: ${otherPartner.name} olarak değiştirildi ⇄'
                              : 'View switched to: ${otherPartner.name} ⇄',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isDark
                              ? AppColors.darkCardElevated
                              : Colors.white.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(14),
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
                        const Icon(
                          Icons.swap_horiz_rounded,
                          size: 14,
                          color: AppColors.champagneGold,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isTr ? 'Görünüm Değiştir' : 'Switch View',
                          style: AppTextStyles.bodySmall(
                            isDark: isDark,
                          ).copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.champagneGold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Two Partners Presence Row
          Row(
            children: [
              // Partner 1 (Active User)
              Expanded(
                child: _PartnerPresenceTile(
                  isSelf: true,
                  name: activePartner.name,
                  avatar: activePartner.avatar,
                  moodDef: activeMood,
                  isDark: isDark,
                  isTr: isTr,
                  onTap: () => _openMoodPicker(context, isDark, isTr),
                ),
              ),

              // Center Love Pulse Nudge Trigger
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () => _onSendNudge(context, otherPartner, isTr),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: AppColors.sunsetGold,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.coralGold.withValues(
                                alpha: 0.35,
                              ),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Text('💓', style: TextStyle(fontSize: 20)),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isTr ? 'Dokunuş' : 'Pulse',
                      style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color:
                            isDark
                                ? AppColors.blushPinkDeep
                                : AppColors.deepBurgundy,
                      ),
                    ),
                  ],
                ),
              ),

              // Partner 2 (Other Partner)
              Expanded(
                child: _PartnerPresenceTile(
                  isSelf: false,
                  name: otherPartner.name,
                  avatar: otherPartner.avatar,
                  moodDef: otherMood,
                  isDark: isDark,
                  isTr: isTr,
                  onTap: () {
                    // Tap on partner opens an encouraging toast
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: AppColors.deepBurgundy,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        content: Text(
                          isTr
                              ? '${otherPartner.name} ruh halini güncellediğinde burada belirecek.'
                              : '${otherPartner.name}’s mood updates will reflect here live.',
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          // Last Nudge Banner (if recently triggered)
          if (lastNudgeTime != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color:
                    isDark
                        ? AppColors.darkCardElevated
                        : Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.heartGold.withValues(alpha: 0.25),
                ),
              ),
              child: Row(
                children: [
                  const Text('💌', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      lastNudgeSender == activePartner.id
                          ? (isTr
                              ? '${otherPartner.name} için bir sevgi dokunuşu ilettiniz.'
                              : 'You sent a warm love pulse to ${otherPartner.name}.')
                          : (isTr
                              ? '${otherPartner.name} şu an seni düşünüyor! 💓'
                              : '${otherPartner.name} is thinking of you right now! 💓'),
                      style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                        color:
                            isDark
                                ? AppColors.champagneGold
                                : AppColors.deepBurgundy,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PartnerPresenceTile extends StatelessWidget {
  final bool isSelf;
  final String name;
  final String avatar;
  final CoupleMoodDef? moodDef;
  final bool isDark;
  final bool isTr;
  final VoidCallback onTap;

  const _PartnerPresenceTile({
    required this.isSelf,
    required this.name,
    required this.avatar,
    required this.moodDef,
    required this.isDark,
    required this.isTr,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color:
              isDark
                  ? AppColors.darkCardElevated
                  : Colors.white.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                moodDef != null
                    ? moodDef!.accentColor.withValues(alpha: 0.45)
                    : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            width: moodDef != null ? 1.4 : 1.0,
          ),
        ),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor:
                      isDark
                          ? AppColors.darkBackground
                          : AppColors.blushPinkDeep.withValues(alpha: 0.2),
                  child: Text(avatar, style: const TextStyle(fontSize: 20)),
                ),
                if (moodDef != null)
                  Positioned(
                    bottom: -2,
                    right: -2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        moodDef!.emoji,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                isSelf ? (isTr ? '$name (Ben)' : '$name (You)') : name,
                maxLines: 1,
                style: AppTextStyles.labelLarge(
                  isDark: isDark,
                ).copyWith(fontWeight: FontWeight.w700, fontSize: 13),
              ),
            ),
            const SizedBox(height: 2),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color:
                      moodDef != null
                          ? moodDef!.accentColor.withValues(alpha: 0.15)
                          : (isDark
                              ? AppColors.darkBackground
                              : AppColors.lightBackground),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  moodDef != null
                      ? moodDef!.label(isTr)
                      : (isSelf
                          ? (isTr ? '+ Ruh Hali' : '+ Mood')
                          : (isTr ? 'Bekleniyor' : 'Pending')),
                  maxLines: 1,
                  style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color:
                        moodDef != null
                            ? (isDark
                                ? AppColors.champagneGold
                                : AppColors.deepBurgundy)
                            : (isDark
                                ? AppColors.darkTextMuted
                                : AppColors.lightTextMuted),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoodPickerModal extends StatelessWidget {
  final bool isDark;
  final bool isTr;

  const _MoodPickerModal({required this.isDark, required this.isTr});

  @override
  Widget build(BuildContext context) {
    final currentMood = context.select<AppStateProvider, String?>(
      (p) => p.activePartnerMood,
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isTr
                ? 'Bugün Kalbin Nasıl Hissediyor? ✨'
                : 'How Does Your Heart Feel Today? ✨',
            style: AppTextStyles.titleMedium(
              isDark: isDark,
            ).copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            isTr
                ? 'Seçtiğiniz ruh halini partneriniz kendi ekranında canlı görecek.'
                : 'Your partner will see this emotional frequency on their sanctuary home.',
            style: AppTextStyles.bodySmall(isDark: isDark),
          ),
          const SizedBox(height: 18),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.6,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: kCoupleMoods.length,
            itemBuilder: (ctx, idx) {
              final mood = kCoupleMoods[idx];
              final isSelected = currentMood == mood.key;

              return InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  HapticFeedback.selectionClick();
                  context.read<AppStateProvider>().setMyMood(mood.key);
                  Navigator.of(ctx).pop();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? mood.accentColor.withValues(alpha: 0.2)
                            : (isDark
                                ? AppColors.darkCardElevated
                                : AppColors.lightBackground),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color:
                          isSelected
                              ? mood.accentColor
                              : (isDark
                                  ? AppColors.darkBorder
                                  : AppColors.lightBorder),
                      width: isSelected ? 1.6 : 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(mood.emoji, style: const TextStyle(fontSize: 22)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          mood.label(isTr),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodySmall(
                            isDark: isDark,
                          ).copyWith(
                            fontWeight:
                                isSelected ? FontWeight.w800 : FontWeight.w600,
                            fontSize: 12,
                            color:
                                isSelected
                                    ? (isDark
                                        ? AppColors.champagneGold
                                        : AppColors.deepBurgundy)
                                    : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
