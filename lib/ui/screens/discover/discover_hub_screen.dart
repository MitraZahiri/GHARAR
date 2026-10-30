import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/shared_interest_model.dart';
import '../../../providers/app_state_provider.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/romantic_app_bar.dart';
import 'future_alignment_screen.dart';
import 'love_languages_screen.dart';
import 'quiz_game_screen.dart';

class DiscoverHubScreen extends StatefulWidget {
  const DiscoverHubScreen({super.key});

  @override
  State<DiscoverHubScreen> createState() => _DiscoverHubScreenState();
}

class _DiscoverHubScreenState extends State<DiscoverHubScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.select<AppStateProvider, bool>((p) => p.isDarkMode);
    final isTr = context.select<AppStateProvider, bool>((p) => p.isTurkish);

    return Scaffold(
      appBar: RomanticAppBar(
        title: isTr ? 'Keşfet & Uyum' : 'Discover & Align',
      ),
      body: Column(
        children: [
          // Sub-navigation Cards for Games & Future
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: DiscoverActionTile(
                    title:
                        isTr
                            ? 'Bizi Ne Kadar Tanıyoruz?'
                            : 'Quiz: How Well We Know Us',
                    subtitle:
                        isTr ? 'Eğlenceli tahmin oyunu' : 'Playful predictions',
                    icon: '🎯',
                    isDark: isDark,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const QuizGameScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DiscoverActionTile(
                    title:
                        isTr ? 'Nereye İlerliyoruz?' : 'Where Are We Heading?',
                    subtitle:
                        isTr ? 'Ortak gelecek hayalleri' : 'Future alignment',
                    icon: '🧭',
                    isDark: isDark,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const FutureAlignmentScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: DiscoverActionTile(
              title: isTr ? 'Sevgi Dillerimiz' : 'Our Love Languages',
              subtitle:
                  isTr
                      ? 'Nasıl sevildiğini birbirinize gösterin'
                      : 'Learn how each of you feels loved',
              icon: '💞',
              isDark: isDark,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LoveLanguagesScreen(),
                  ),
                );
              },
            ),
          ),

          // Tab Bar
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorColor:
                isDark ? AppColors.blushPinkDeep : AppColors.deepBurgundy,
            labelColor:
                isDark ? AppColors.blushPinkDeep : AppColors.deepBurgundy,
            unselectedLabelColor:
                isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            labelStyle: AppTextStyles.labelLarge(
              isDark: isDark,
            ).copyWith(fontSize: 13),
            tabs: [
              Tab(text: isTr ? 'Ortak Kıvılcımlar' : 'Shared Sparks'),
              Tab(text: isTr ? 'Güzel Farklarımız' : 'Differences'),
              Tab(text: isTr ? 'Gelişim & Egzersizler' : 'Growth Hub'),
            ],
          ),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                // 1. Shared Sparks
                SharedSparksTabView(),

                // 2. Beautiful Differences
                DifferencesTabView(),

                // 3. Relationship Growth Hub
                GrowthHubTabView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Dedicated action tile for Discover sub-navigation.
class DiscoverActionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String icon;
  final bool isDark;
  final VoidCallback onTap;

  const DiscoverActionTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      onTap: onTap,
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.labelLarge(
                    isDark: isDark,
                  ).copyWith(fontSize: 12),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall(
                    isDark: isDark,
                  ).copyWith(fontSize: 10),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 12,
            color: AppColors.lightTextMuted,
          ),
        ],
      ),
    );
  }
}

/// Dedicated view for shared sparks tab.
class SharedSparksTabView extends StatelessWidget {
  const SharedSparksTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.select<AppStateProvider, bool>((p) => p.isDarkMode);
    final isTr = context.select<AppStateProvider, bool>((p) => p.isTurkish);
    final list = context.select<AppStateProvider, List<SharedInterestModel>>(
      (p) => p.sharedInterests.where((item) => item.bothEnjoy).toList(),
    );

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return SharedSparkCard(item: list[index], isDark: isDark, isTr: isTr);
      },
    );
  }
}

/// Dedicated card for a shared spark interest.
class SharedSparkCard extends StatelessWidget {
  final SharedInterestModel item;
  final bool isDark;
  final bool isTr;

  const SharedSparkCard({
    super.key,
    required this.item,
    required this.isDark,
    required this.isTr,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(item.icon, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.category.toUpperCase(),
                      style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
                        fontSize: 10,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w700,
                        color:
                            isDark
                                ? AppColors.blushPinkDeep
                                : AppColors.burgundyRose,
                      ),
                    ),
                    Text(
                      item.title(isTr),
                      style: AppTextStyles.titleMedium(
                        isDark: isDark,
                      ).copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.successGreen.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('💖', style: TextStyle(fontSize: 11)),
                    const SizedBox(width: 4),
                    Text(
                      isTr ? 'Ortak Tutku' : 'Mutual Spark',
                      style: const TextStyle(
                        color: AppColors.successGreen,
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
            item.description(isTr),
            style: AppTextStyles.bodyMedium(isDark: isDark),
          ),
          const SizedBox(height: 14),
          // Suggested Date Idea
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardElevated : AppColors.warmIvory,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: Row(
              children: [
                const Text('💡', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isTr
                            ? 'Önerilen Randevu Fikri:'
                            : 'Suggested Date Idea:',
                        style: AppTextStyles.bodySmall(
                          isDark: isDark,
                        ).copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.suggestedDate(isTr),
                        style: AppTextStyles.bodySmall(isDark: isDark),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Dedicated view for differences tab.
class DifferencesTabView extends StatelessWidget {
  const DifferencesTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.select<AppStateProvider, bool>((p) => p.isDarkMode);
    final isTr = context.select<AppStateProvider, bool>((p) => p.isTurkish);
    final list = context.select<AppStateProvider, List<SharedInterestModel>>(
      (p) => p.sharedInterests.where((item) => !item.bothEnjoy).toList(),
    );

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return DifferenceCard(item: list[index], isDark: isDark, isTr: isTr);
      },
    );
  }
}

/// Dedicated card for difference interest.
class DifferenceCard extends StatelessWidget {
  final SharedInterestModel item;
  final bool isDark;
  final bool isTr;

  const DifferenceCard({
    super.key,
    required this.item,
    required this.isDark,
    required this.isTr,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(item.icon, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  item.title(isTr),
                  style: AppTextStyles.titleMedium(
                    isDark: isDark,
                  ).copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.champagneGold.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isTr ? 'Tatlı Zıtlık' : 'Sweet Contrast',
                  style: const TextStyle(
                    color: AppColors.champagneGold,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            item.description(isTr),
            style: AppTextStyles.bodyMedium(isDark: isDark),
          ),
          const SizedBox(height: 14),

          // Bridge Conversation Box
          if (item.bridgeConv(isTr) != null) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color:
                    isDark
                        ? AppColors.darkCardElevated
                        : AppColors.blushPinkLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.blushPink,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('🕊️', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 8),
                      Text(
                        isTr
                            ? 'Birlikte Sohbet Başlatıcı:'
                            : 'Respectful Conversation Bridge:',
                        style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
                          fontWeight: FontWeight.w700,
                          color:
                              isDark
                                  ? AppColors.blushPinkDeep
                                  : AppColors.deepBurgundy,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.bridgeConv(isTr)!,
                    style: AppTextStyles.bodyMedium(
                      isDark: isDark,
                    ).copyWith(fontStyle: FontStyle.italic),
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

/// Dedicated view for relationship growth hub exercises.
class GrowthHubTabView extends StatelessWidget {
  const GrowthHubTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.select<AppStateProvider, bool>((p) => p.isDarkMode);
    final isTr = context.select<AppStateProvider, bool>((p) => p.isTurkish);

    final exercises = [
      {
        'titleEn': 'Emotional Validation & Safe Harbor',
        'titleTr': 'Duygusal Kabul & Güvenli Liman',
        'descEn':
            'Practice acknowledging your partner’s emotions without jumping into problem-solving.',
        'descTr':
            'Partnerinizin hislerini hemen düzeltmeye çalışmadan sadece şefkatle dinleme pratiği.',
        'icon': '🕊️',
        'promptEn':
            '“It makes complete sense why you feel that way, and I am right here with you.”',
        'promptTr':
            '“Böyle hissetmeni o kadar iyi anlıyorum ki... Yanındayım ve seni dinliyorum.”',
      },
      {
        'titleEn': 'Gentle Boundary Setting',
        'titleTr': 'Şefkatli Sınırlar & Kişisel Alan',
        'descEn':
            'Expressing personal recharging needs with love so space never feels like abandonment.',
        'descTr':
            'Kişisel dinlenme ihtiyacını sevgiyle ifade ederek yalnız kalmayı bir uzaklaşma değil tazelenme yapma sanatı.',
        'icon': '🌿',
        'promptEn':
            '“I love you deeply. I need 30 quiet minutes to recharge my energy so I can be fully present with you.”',
        'promptTr':
            '“Seni çok seviyorum. Birazdan seninle tüm kalbimle ilgilenebilmek için 30 dakika sakin bir zamana ihtiyacım var.”',
      },
      {
        'titleEn': 'Healthy Conflict & The 5-Minute Pause',
        'titleTr': 'Şefkatli Çözüm & 5 Dakikalık Mola',
        'descEn':
            'When conversations get heated, take a gentle pause before words leave unintended scars.',
        'descTr':
            'Tartışmalar hararetlendiğinde kalpler kırılmadan önce birbirine sarılıp mola verme kuralı.',
        'icon': '🕯️',
        'promptEn':
            '“We are on the same team against the problem, never against each other.”',
        'promptTr':
            '“Biz aynı takımdayız; sorunla birlikte mücadele ediyoruz, birbirimizle değil.”',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: exercises.length,
      itemBuilder: (context, index) {
        final ex = exercises[index];
        return GlassCard(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    ex['icon'] as String,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      isTr ? ex['titleTr'] as String : ex['titleEn'] as String,
                      style: AppTextStyles.titleMedium(
                        isDark: isDark,
                      ).copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                isTr ? ex['descTr'] as String : ex['descEn'] as String,
                style: AppTextStyles.bodyMedium(isDark: isDark),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color:
                      isDark ? AppColors.darkCardElevated : AppColors.warmCream,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  isTr ? ex['promptTr'] as String : ex['promptEn'] as String,
                  style: AppTextStyles.quote(
                    isDark: isDark,
                  ).copyWith(fontSize: 14),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
