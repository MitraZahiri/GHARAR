import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../providers/app_state_provider.dart';
import '../../widgets/glass_card.dart';

class FutureAlignmentScreen extends StatelessWidget {
  const FutureAlignmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppStateProvider>();
    final isDark = provider.isDarkMode;
    final isTr = provider.isTurkish;

    final partner1 = provider.couple?.partner1 ?? provider.activePartner;
    final partner2 = provider.couple?.partner2 ?? provider.otherPartner;

    final pillars = [
      {
        'titleEn': 'Dream Living & Home Sanctuary',
        'titleTr': 'Hayalimizdeki Yuva & Yaşam Alanı',
        'icon': '🏡',
        'statusEn': 'Aligned with Excitement ✨',
        'statusTr': 'Büyük Bir Heyecanla Uyumlu ✨',
        'p1En': 'Sunlit loft or stone house with a big book library and green balcony.',
        'p1Tr': 'Büyük bir kitaplığı ve bol çiçekli balkonu olan aydınlık, ferah bir yuva.',
        'p2En': 'Warm wooden kitchen with acoustic music and serene mountain or sea breeze.',
        'p2Tr': 'Akustik müzik dinlenebilen sıcak ahşap bir mutfak ve huzurlu bir deniz/doğa esintisi.',
        'bridgeEn': 'You both crave natural light, quiet nooks, and a home that feels like a refuge from the world.',
        'bridgeTr': 'İkiniz de doğal ışığı, sessiz köşeleri ve dünyaya karşı bir sığınak hissi veren huzurlu bir evi hayal ediyorsunuz.',
      },
      {
        'titleEn': 'Travel & Bucket List Horizons',
        'titleTr': 'Seyahat & Ortak Keşif Ufukları',
        'icon': '🌍',
        'statusEn': 'Shared Aspiration ✈️',
        'statusTr': 'Ortak Ufuklar ✈️',
        'p1En': 'A month-long slow road trip exploring the Mediterranean and cooking classes.',
        'p1Tr': 'Akdeniz boyunca yavaş bir yolculuk ve yerel yemek atölyelerine katılmak.',
        'p2En': 'Renting a campervan or scenic train journey across historic villages.',
        'p2Tr': 'Karavan kiralayarak tarihi dağ köylerini ve manzaralı tren rotalarını gezmek.',
        'bridgeEn': 'Focus on unhurried, cultural immersion rather than crowded tourist checklists.',
        'bridgeTr': 'Kalabalık turist listeleri yerine ikiniz de yerel kültürü sindirerek yavaş seyahat etmeyi seviyorsunuz.',
      },
      {
        'titleEn': 'Financial Harmony & Growth',
        'titleTr': 'Finansal Uyum & Gelecek Güvencesi',
        'icon': '🌱',
        'statusEn': 'Open Discussion Invitation 💬',
        'statusTr': 'Tatlı Bir Sohbet Başlatıcı 💬',
        'p1En': 'Balance healthy savings with generous budget for shared spontaneous travel & dates.',
        'p1Tr': 'Gelecek birikimini korurken ortak seyahatler ve randevular için cömert bir bütçe ayırmak.',
        'p2En': 'Prioritize investing in long-term peace of mind, family safety, and sustainable freedom.',
        'p2Tr': 'Önceliği uzun vadeli huzur, aile güvencesi ve finansal özgürlüğe vermek.',
        'bridgeEn': 'A wonderful opportunity to design a joint "Spontaneous Joy Fund" alongside your long-term security plan!',
        'bridgeTr': 'Gelecek güvencenizin yanına tatlı bir "Spontane Neşe Fonu" eklemek için mükemmel bir sohbet fırsatı!',
      },
      {
        'titleEn': 'Family, Rituals & Traditions',
        'titleTr': 'Aile, Ritüeller & Gelenekler',
        'icon': '🕯️',
        'statusEn': 'Deeply Harmonious 🕊️',
        'statusTr': 'Derinden Uyumlu 🕊️',
        'p1En': 'Sunday family pancake mornings, holiday gratitude dinners, and unconditional love.',
        'p1Tr': 'Pazar sabahı pankek ritüeli, şükran dolu bayram sofraları ve koşulsuz sevgi.',
        'p2En': 'Cultivating open emotional communication and bedtime reflection routines.',
        'p2Tr': 'Açık duygusal iletişim ve uyku öncesi sakin gün değerlendirme alışkanlıkları.',
        'bridgeEn': 'Your values of warmth, emotional presence, and gentle traditions are beautifully linked.',
        'bridgeTr': 'Sıcaklık, duygusal varlık ve nazik aile geleneklerine verdiğiniz değerler birbiriyle pürüzsüz örtüşüyor.',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isTr ? 'Nereye Doğru İlerliyoruz?' : 'Where Are We Heading?',
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
            // Intro Callout
            Container(
              padding: const EdgeInsets.all(18),
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
                  const Text('🧭', style: TextStyle(fontSize: 30)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isTr
                              ? 'Ortak Ufuklar & Şefkatli Sohbetler'
                              : 'Shared Horizons & Gentle Dialogue',
                          style: AppTextStyles.titleMedium(isDark: isDark)
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isTr
                              ? 'Geleceğe dair hayallerinizi karşılaştırın. Farklılıklar bir ayrılık değil, merakla keşfedilecek zenginliklerdir.'
                              : 'Explore future dreams side by side. Differing perspectives are treated as loving conversation starters, never relationship verdicts.',
                          style: AppTextStyles.bodySmall(isDark: isDark),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Text(
              isTr ? 'Temel Yaşam Sütunlarımız' : 'Our Future Pillars',
              style: AppTextStyles.headline(isDark: isDark),
            ),

            const SizedBox(height: 12),

            for (final p in pillars) ...[
              GlassCard(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Text(p['icon'] as String,
                            style: const TextStyle(fontSize: 22)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            isTr ? p['titleTr'] as String : p['titleEn'] as String,
                            style: AppTextStyles.titleMedium(isDark: isDark)
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.champagneGold.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isTr
                            ? p['statusTr'] as String
                            : p['statusEn'] as String,
                        style: const TextStyle(
                          color: AppColors.champagneGold,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Divider(height: 20),

                    // Partner 1 Thought
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(partner1.avatar,
                            style: const TextStyle(fontSize: 16)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: AppTextStyles.bodySmall(isDark: isDark)
                                  .copyWith(fontSize: 13),
                              children: [
                                TextSpan(
                                  text: '${partner1.name}: ',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700),
                                ),
                                TextSpan(
                                    text: isTr
                                        ? p['p1Tr'] as String
                                        : p['p1En'] as String),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Partner 2 Thought
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(partner2.avatar,
                            style: const TextStyle(fontSize: 16)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: AppTextStyles.bodySmall(isDark: isDark)
                                  .copyWith(fontSize: 13),
                              children: [
                                TextSpan(
                                  text: '${partner2.name}: ',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700),
                                ),
                                TextSpan(
                                    text: isTr
                                        ? p['p2Tr'] as String
                                        : p['p2En'] as String),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // Bridge Reflection
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkCardElevated
                            : AppColors.warmIvory,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('🕊️', style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              isTr
                                  ? p['bridgeTr'] as String
                                  : p['bridgeEn'] as String,
                              style: AppTextStyles.bodySmall(isDark: isDark)
                                  .copyWith(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
