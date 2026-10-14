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
    final provider = context.watch<AppStateProvider>();
    final isDark = provider.isDarkMode;
    final isTr = provider.isTurkish;
    final isPremium = provider.couple?.isPremium ?? false;

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
                    _buildBenefitRow(
                      icon: '✨',
                      title: isTr
                          ? '100+ Soru & Tüm 12 Kategori'
                          : '100+ Deep Questions across 12 Categories',
                      isDark: isDark,
                    ),
                    const Divider(height: 18),
                    _buildBenefitRow(
                      icon: '🤖',
                      title: isTr
                          ? 'Noor AI ile Sınırsız İletişim Rehberliği'
                          : 'Full Access to Noor AI Relationship Companion',
                      isDark: isDark,
                    ),
                    const Divider(height: 18),
                    _buildBenefitRow(
                      icon: '📖',
                      title: isTr
                          ? 'Sınırsız Çift Günlüğü & Fotoğraf Hatıraları'
                          : 'Unlimited Couple Journal Entries & Memories',
                      isDark: isDark,
                    ),
                    const Divider(height: 18),
                    _buildBenefitRow(
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
              _buildPlanTile(
                index: 0,
                title: isTr ? 'Aylık Plan' : 'Monthly Sanctuary',
                price: isTr ? '₺99.99 / ay' : '\$4.99 / month',
                subtitle: isTr ? 'İstediğiniz zaman iptal edin' : 'Cancel anytime',
                isDark: isDark,
              ),
              const SizedBox(height: 12),
              _buildPlanTile(
                index: 1,
                title: isTr ? 'Yıllık Plan (En Popüler)' : 'Annual Plan (Best Value)',
                price: isTr ? '₺599.99 / yıl (₺49.99/ay)' : '\$29.99 / year (\$2.49/mo)',
                subtitle: isTr ? '%50 Tasarruf + 7 Gün Ücretsiz Deneme' : 'Save 50% + 7-Day Free Trial',
                badgeText: isTr ? 'EN POPÜLER' : 'BEST VALUE',
                isDark: isDark,
              ),
              const SizedBox(height: 12),
              _buildPlanTile(
                index: 2,
                title: isTr ? 'Ömür Boyu Aşk' : 'Lifetime Devotion',
                price: isTr ? '₺1,499 Tek Seferlik' : '\$79.99 One-time',
                subtitle: isTr ? 'Sonsuza kadar ikiniz için' : 'Forever yours, no subscriptions',
                isDark: isDark,
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
                  provider.togglePremium();
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

  Widget _buildBenefitRow({
    required String icon,
    required String title,
    required bool isDark,
  }) {
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

  Widget _buildPlanTile({
    required int index,
    required String title,
    required String price,
    required String subtitle,
    String? badgeText,
    required bool isDark,
  }) {
    final isSelected = _selectedPlanIndex == index;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => setState(() => _selectedPlanIndex = index),
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
                            badgeText,
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
