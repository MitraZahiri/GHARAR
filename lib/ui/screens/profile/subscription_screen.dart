import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../providers/app_state_provider.dart';
import '../../widgets/confetti_overlay.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_button.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int _selectedPlanIndex = 1; // 0 = Monthly, 1 = Annual (Best Value), 2 = Lifetime
  bool _playConfetti = false;

  @override
  Widget build(BuildContext context) {
    final isDark = context.select<AppStateProvider, bool>((p) => p.isDarkMode);
    final isTr = context.select<AppStateProvider, bool>((p) => p.isTurkish);
    final isPremium = context.select<AppStateProvider, bool>((p) => p.couple?.isPremium ?? false);

    return ConfettiOverlay(
      isPlaying: _playConfetti,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'GHARAR Premium',
            style: AppTextStyles.titleMedium(isDark: isDark).copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Premium Crown
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  gradient: AppColors.sunsetGold,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.champagneGold.withValues(alpha: 0.4),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text('👑', style: TextStyle(fontSize: 36)),
                ),
              ),

              const SizedBox(height: 16),

              Text(
                isTr
                    ? 'Aşkınızı Birlikte Taçlandırın'
                    : 'A Lifetime of Deep Intimacy',
                textAlign: TextAlign.center,
                style: AppTextStyles.displayMedium(isDark: isDark).copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                isTr
                    ? 'Tüm sorular, sınırsız günlük, Noor AI yoldaşı ve derin bağ kurma yolculukları.'
                    : 'Unlimited daily questions, infinite journal photos, Noor AI guide, and deeper connection journeys.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium(isDark: isDark),
              ),

              const SizedBox(height: 24),

              // Benefits List
              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    PremiumBenefitRow(
                      icon: '✨',
                      title: isTr
                          ? '100+ Soru & Tüm 12 Kategori'
                          : '100+ Deep Questions across 12 Categories',
                      isDark: isDark,
                    ),
                    const Divider(height: 18),
                    PremiumBenefitRow(
                      icon: '🤖',
                      title: isTr
                          ? 'Noor AI ile Sınırsız İletişim Rehberliği'
                          : 'Full Access to Noor AI Relationship Companion',
                      isDark: isDark,
                    ),
                    const Divider(height: 18),
                    PremiumBenefitRow(
                      icon: '📖',
                      title: isTr
                          ? 'Sınırsız Çift Günlüğü & Fotoğraf Hatıraları'
                          : 'Unlimited Couple Journal Entries & Memories',
                      isDark: isDark,
                    ),
                    const Divider(height: 18),
                    PremiumBenefitRow(
                      icon: '🌟',
                      title: isTr
                          ? 'Gelişmiş Uyum & Ortak Gelecek Analizi'
                          : 'Advanced Harmony & Future Alignment Mapping',
                      isDark: isDark,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Plan Cards (Monthly, Annual, Lifetime)
              PlanOptionTile(
                index: 0,
                title: isTr ? 'Aylık Plan' : 'Monthly Sanctuary',
                price: isTr ? '₺99.99 / ay' : '\$4.99 / month',
                subtitle: isTr ? 'İstediğiniz zaman iptal edin' : 'Cancel anytime',
                isSelected: _selectedPlanIndex == 0,
                isDark: isDark,
                onTap: () => setState(() => _selectedPlanIndex = 0),
              ),
              const SizedBox(height: 12),
              PlanOptionTile(
                index: 1,
                title: isTr ? 'Yıllık Plan (En Popüler)' : 'Annual Plan (Best Value)',
                price: isTr ? '₺599.99 / yıl (₺49.99/ay)' : '\$29.99 / year (\$2.49/mo)',
                subtitle: isTr ? '%50 Tasarruf + 7 Gün Ücretsiz Deneme' : 'Save 50% + 7-Day Free Trial',
                badgeText: isTr ? 'EN POPÜLER' : 'BEST VALUE',
                isSelected: _selectedPlanIndex == 1,
                isDark: isDark,
                onTap: () => setState(() => _selectedPlanIndex = 1),
              ),
              const SizedBox(height: 12),
              PlanOptionTile(
                index: 2,
                title: isTr ? 'Ömür Boyu Aşk' : 'Lifetime Devotion',
                price: isTr ? '₺1,499 Tek Seferlik' : '\$79.99 One-time',
                subtitle: isTr ? 'Sonsuza kadar ikiniz için' : 'Forever yours, no subscriptions',
                isSelected: _selectedPlanIndex == 2,
                isDark: isDark,
                onTap: () => setState(() => _selectedPlanIndex = 2),
              ),

              const SizedBox(height: 28),

              // CTA Button
              GradientButton(
                text: isPremium
                    ? (isTr
                        ? 'Premium Zaten Aktif ✨'
                        : 'Premium is Active ✨')
                    : (isTr
                        ? '7 Gün Ücretsiz Denemeyi Başlat'
                        : 'Start 7-Day Free Trial'),
                gradient: AppColors.sunsetGold,
                onPressed: () {
                  context.read<AppStateProvider>().togglePremium();
                  setState(() {
                    _playConfetti = true;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: AppColors.successGreen,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      content: Text(
                        isTr
                            ? 'Tebrikler! GHARAR Premium ayrıcalıkları aktif edildi. 👑'
                            : 'Congratulations! GHARAR Premium is now active. 👑',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),

              Text(
                isTr
                    ? 'Otomatik yenilenir, uygulama mağazası ayarlarınızdan dilediğiniz an iptal edilebilir.'
                    : 'Auto-renews, cancel anytime in store settings. Transparent and non-manipulative.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall(isDark: isDark).copyWith(fontSize: 11),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

/// Dedicated widget for displaying a premium benefit row.
class PremiumBenefitRow extends StatelessWidget {
  final String icon;
  final String title;
  final bool isDark;

  const PremiumBenefitRow({
    super.key,
    required this.icon,
    required this.title,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.bodyMedium(isDark: isDark).copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

/// Dedicated widget for selecting a subscription plan option.
class PlanOptionTile extends StatelessWidget {
  final int index;
  final String title;
  final String price;
  final String subtitle;
  final String? badgeText;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const PlanOptionTile({
    super.key,
    required this.index,
    required this.title,
    required this.price,
    required this.subtitle,
    this.badgeText,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                  ? AppColors.blushPinkDeep.withValues(alpha: 0.16)
                  : AppColors.blushPinkLight)
              : (isDark ? AppColors.darkCard : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? (isDark ? AppColors.blushPinkDeep : AppColors.deepBurgundy)
                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: isSelected
                  ? (isDark ? AppColors.blushPinkDeep : AppColors.deepBurgundy)
                  : AppColors.lightTextMuted,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.titleMedium(isDark: isDark).copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      if (badgeText != null) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.streakFlame,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            badgeText!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    price,
                    style: AppTextStyles.titleMedium(isDark: isDark).copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                      color: isDark ? AppColors.warmPeach : AppColors.deepBurgundy,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall(isDark: isDark).copyWith(fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
