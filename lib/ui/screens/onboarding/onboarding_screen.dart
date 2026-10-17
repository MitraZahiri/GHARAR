import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/localization/app_language.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../providers/app_state_provider.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/soul_connection_art.dart';
import 'partner_invite_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final TextEditingController _nameController = TextEditingController();
  String _selectedAvatar = '🌸';
  String _selectedStage = 'stageDating';
  final List<String> _selectedGoals = [
    'goalDeeperConversations',
    'goalSpontaneousRomance',
  ];

  final List<String> _avatars = ['🌸', '🌿', '🕊️', '👑', '✨', '🌺', '☕', '🌟'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final provider = context.read<AppStateProvider>();
      final existingName = provider.currentUser?.name;
      if (existingName != null && existingName.isNotEmpty) {
        _nameController.text = existingName;
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.select<AppStateProvider, bool>((p) => p.isDarkMode);
    final isTr = context.select<AppStateProvider, bool>((p) => p.isTurkish);
    final currentLanguage = context.select<AppStateProvider, AppLanguage>((p) => p.currentLanguage);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with Language Selector & Progress Dots
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Text(
                    'GHARAR',
                    style: AppTextStyles.displaySmall(isDark: isDark).copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                      fontSize: 18,
                      color: isDark
                          ? AppColors.blushPinkDeep
                          : AppColors.deepBurgundy,
                    ),
                  ),
                  const Spacer(),
                  // Multilingual Language Switcher Chip (8 Languages & RTL)
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => _showLanguagePickerSheet(context, isDark, currentLanguage),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkCardElevated
                            : AppColors.blushPinkLight,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.blushPinkDeep.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(currentLanguage.flag,
                              style: const TextStyle(fontSize: 15)),
                          const SizedBox(width: 5),
                          Text(
                            currentLanguage.nativeName,
                            style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Icon(
                            Icons.arrow_drop_down_rounded,
                            size: 16,
                            color: isDark ? AppColors.blushPinkDeep : AppColors.deepBurgundy,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Page Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < 4; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == i ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == i
                          ? (isDark
                              ? AppColors.blushPinkDeep
                              : AppColors.deepBurgundy)
                          : (isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 12),

            // PageView Content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (idx) {
                  setState(() => _currentPage = idx);
                },
                children: [
                  // 1. Welcome Slide
                  OnboardingWelcomeSlide(isDark: isDark, isTr: isTr),

                  // 2. Profile Setup (Name & Avatar)
                  _buildProfileSlide(isDark, isTr),

                  // 3. Relationship Stage
                  _buildRelationshipStageSlide(isDark, isTr),

                  // 4. Goals & Intentions
                  _buildGoalsSlide(isDark, isTr),
                ],
              ),
            ),

            // Bottom Navigation CTA
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: GradientButton(
                text: _currentPage == 3
                    ? (isTr
                        ? 'Partnerimi Davet Et 💌'
                        : 'Invite My Partner 💌')
                    : (isTr ? 'Devam Et ➔' : 'Continue ➔'),
                onPressed: () {
                  if (_currentPage < 3) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    final appState = context.read<AppStateProvider>();
                    appState.completeOnboarding(
                      name: _nameController.text.trim().isEmpty
                          ? (isTr ? 'Ben' : 'You')
                          : _nameController.text.trim(),
                      avatar: _selectedAvatar,
                      relationshipStage: _selectedStage,
                      goals: _selectedGoals,
                      languageCode: appState.locale.languageCode,
                    );

                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const PartnerInviteScreen(),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSlide(bool isDark, bool isTr) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isTr ? 'Kendinizi Tanıtın' : 'Create Your Profile',
            style: AppTextStyles.displaySmall(isDark: isDark).copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isTr
                ? 'Partnerinizin ekranda göreceği adınızı ve sevimli avatarınızı seçin.'
                : 'Choose your name and avatar as it will appear in your shared space.',
            style: AppTextStyles.bodyMedium(isDark: isDark),
          ),
          const SizedBox(height: 24),

          // Name Input
          Text(isTr ? 'Adınız:' : 'What should your partner call you?',
              style: AppTextStyles.labelLarge(isDark: isDark)),
          const SizedBox(height: 8),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: isTr ? 'Adınızı girin' : 'Enter your name',
              prefixIcon: const Icon(Icons.person_rounded),
            ),
          ),

          const SizedBox(height: 24),

          // Avatar Picker
          Text(isTr ? 'Avatarınızı Seçin:' : 'Pick Your Romantic Avatar:',
              style: AppTextStyles.labelLarge(isDark: isDark)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final av in _avatars)
                AvatarOptionBubble(
                  avatar: av,
                  isSelected: _selectedAvatar == av,
                  isDark: isDark,
                  onTap: () => setState(() => _selectedAvatar = av),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRelationshipStageSlide(bool isDark, bool isTr) {
    final stages = [
      {'key': 'stageDating', 'labelEn': 'Dating & Exploring', 'labelTr': 'Flört & Tanıma', 'icon': '🌱'},
      {'key': 'stageEngaged', 'labelEn': 'Engaged & Planning', 'labelTr': 'Nişanlı & Evlilik Hazırlığı', 'icon': '💍'},
      {'key': 'stageNewlywed', 'labelEn': 'Newlyweds (1st Years)', 'labelTr': 'Yeni Evli (İlk Yıllar)', 'icon': '🥂'},
      {'key': 'stageLongTerm', 'labelEn': 'Long-term Companions', 'labelTr': 'Uzun Süreli Birliktelik', 'icon': '🌿'},
      {'key': 'stageMarriedWithKids', 'labelEn': 'Married with Children', 'labelTr': 'Çocuklu Evli Çift', 'icon': '🏡'},
      {'key': 'stageLongDistance', 'labelEn': 'Long Distance Love', 'labelTr': 'Uzak Mesafe Aşkı', 'icon': '✈️'},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isTr ? 'İlişkiniz Hangi Evrede?' : 'Where Are You in Love?',
            style: AppTextStyles.displaySmall(isDark: isDark).copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isTr
                ? 'Soruları ve randevu önerilerini sizin döneminize göre kişiselleştirelim.'
                : 'This helps GHARAR tailor questions and activities specifically to your journey.',
            style: AppTextStyles.bodyMedium(isDark: isDark),
          ),
          const SizedBox(height: 20),

          for (final s in stages) ...[
            RelationshipStageCard(
              icon: s['icon']!,
              label: isTr ? s['labelTr']! : s['labelEn']!,
              isSelected: _selectedStage == s['key'],
              isDark: isDark,
              onTap: () => setState(() => _selectedStage = s['key']!),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGoalsSlide(bool isDark, bool isTr) {
    final goals = [
      {'key': 'goalDeeperConversations', 'labelEn': 'Deeper Conversations', 'labelTr': 'Daha Derin Sohbetler', 'icon': '💬'},
      {'key': 'goalSpontaneousRomance', 'labelEn': 'Spontaneous Romance', 'labelTr': 'Spontane Romantizm', 'icon': '🌹'},
      {'key': 'goalUnderstandingNeeds', 'labelEn': 'Understanding Emotional Needs', 'labelTr': 'Duygusal İhtiyaçları Anlamak', 'icon': '🕊️'},
      {'key': 'goalFuturePlanning', 'labelEn': 'Aligning on Future Dreams', 'labelTr': 'Gelecek Hayallerinde Uyum', 'icon': '✨'},
      {'key': 'goalFunAdventures', 'labelEn': 'Playful Fun & Date Adventures', 'labelTr': 'Eğlenceli Randevular & Macera', 'icon': '🎉'},
      {'key': 'goalConflictResolution', 'labelEn': 'Gentle Conflict Resolution', 'labelTr': 'Şefkatli İletişim & Çözüm', 'icon': '🕯️'},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isTr ? 'Birlikte Neyi Büyütmek İstersiniz?' : 'What Would You Like to Nurture?',
            style: AppTextStyles.displaySmall(isDark: isDark).copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isTr
                ? 'En çok önemsediğiniz hedefleri seçin (birden fazla seçebilirsiniz).'
                : 'Select all intentions that resonate with your love story right now.',
            style: AppTextStyles.bodyMedium(isDark: isDark),
          ),
          const SizedBox(height: 20),

          for (final g in goals)
            Builder(
              builder: (context) {
                final isSelected = _selectedGoals.contains(g['key']);
                return GoalSelectionCard(
                  icon: g['icon']!,
                  label: isTr ? g['labelTr']! : g['labelEn']!,
                  isSelected: isSelected,
                  isDark: isDark,
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedGoals.remove(g['key']);
                      } else {
                        _selectedGoals.add(g['key']!);
                      }
                    });
                  },
                  onChanged: (val) {
                    setState(() {
                      if (val == true) {
                        _selectedGoals.add(g['key']!);
                      } else {
                        _selectedGoals.remove(g['key']);
                      }
                    });
                  },
                );
              },
            ),
        ],
      ),
    );
  }

  void _showLanguagePickerSheet(
      BuildContext context, bool isDark, AppLanguage currentLang) {
    final isTr = currentLang.code == 'tr';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(ctx).size.height * 0.78,
          ),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCardElevated : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Text('🌍', style: TextStyle(fontSize: 26)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isTr ? 'Uygulama Dili Seçin' : 'Choose App Language',
                            style: AppTextStyles.titleMedium(isDark: isDark).copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            isTr
                                ? '8 dil desteği ve sağdan sola (RTL) tam uyum'
                                : '8 languages supported with full RTL & LTR script harmony',
                            style: AppTextStyles.bodySmall(isDark: isDark),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Divider(
                height: 1,
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: AppLanguage.supportedLanguages.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (ctx, index) {
                    final lang = AppLanguage.supportedLanguages[index];
                    final isSelected = lang.code == currentLang.code;

                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        context.read<AppStateProvider>().setLanguageCode(lang.code);
                        Navigator.of(ctx).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isDark
                                  ? AppColors.blushPinkDeep
                                      .withValues(alpha: 0.22)
                                  : AppColors.blushPinkLight)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? (isDark
                                    ? AppColors.blushPinkDeep
                                    : AppColors.deepBurgundy)
                                : (isDark
                                    ? AppColors.darkBorder
                                        .withValues(alpha: 0.5)
                                    : AppColors.lightBorder),
                            width: isSelected ? 1.8 : 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(lang.flag,
                                style: const TextStyle(fontSize: 28)),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        lang.nativeName,
                                        style: AppTextStyles.titleMedium(
                                                isDark: isDark)
                                            .copyWith(
                                          fontWeight: isSelected
                                              ? FontWeight.w800
                                              : FontWeight.w600,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '(${lang.name})',
                                        style: AppTextStyles.bodySmall(
                                                isDark: isDark)
                                            .copyWith(
                                          fontSize: 12,
                                          color: isDark
                                              ? AppColors.darkTextSecondary
                                              : AppColors.lightTextMuted,
                                        ),
                                      ),
                                      if (lang.isRtl) ...[
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppColors.champagneGold
                                                .withValues(alpha: 0.2),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: const Text(
                                            'RTL',
                                            style: TextStyle(
                                              fontSize: 9,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.champagneGold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    lang.tagline,
                                    style: AppTextStyles.bodySmall(
                                            isDark: isDark)
                                        .copyWith(
                                      fontSize: 11,
                                      fontStyle: FontStyle.italic,
                                      color: isDark
                                          ? AppColors.lavenderAccent
                                          : AppColors.burgundyRose,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_circle_rounded,
                                color: isDark
                                    ? AppColors.blushPinkDeep
                                    : AppColors.deepBurgundy,
                                size: 22,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}

class OnboardingWelcomeSlide extends StatelessWidget {
  final bool isDark;
  final bool isTr;

  const OnboardingWelcomeSlide({
    super.key,
    required this.isDark,
    required this.isTr,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SoulConnectionArt(
              width: 240,
              height: 190,
              animateGlow: true,
            ),
            const SizedBox(height: 20),
            Text(
              isTr
                  ? 'İkinize Özel Masalsı Bir Alan'
                  : 'A Sacred Sanctuary Just for the Two of You',
              textAlign: TextAlign.center,
              style: AppTextStyles.displayMedium(isDark: isDark).copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              isTr
                  ? 'GHARAR; ilişkinizi derinleştirmek, birbirinizi yargılamadan anlamak, gizli sorularla heyecanı canlı tutmak ve ömürlük anılar biriktirmek için tasarlandı.'
                  : 'GHARAR is exclusively designed to deepen your bond, understand each other without judgment, spark romance with private questions, and cherish every moment.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLarge(isDark: isDark).copyWith(
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AvatarOptionBubble extends StatelessWidget {
  final String avatar;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const AvatarOptionBubble({
    super.key,
    required this.avatar,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                  ? AppColors.blushPinkDeep.withValues(alpha: 0.3)
                  : AppColors.blushPinkLight)
              : (isDark
                  ? AppColors.darkCard
                  : Colors.white),
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected
                ? (isDark
                    ? AppColors.blushPinkDeep
                    : AppColors.deepBurgundy)
                : (isDark
                    ? AppColors.darkBorder
                    : AppColors.lightBorder),
            width: isSelected ? 2.5 : 1.0,
          ),
        ),
        child: Center(
          child: Text(avatar, style: const TextStyle(fontSize: 26)),
        ),
      ),
    );
  }
}

class RelationshipStageCard extends StatelessWidget {
  final String icon;
  final String label;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const RelationshipStageCard({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                  ? AppColors.blushPinkDeep.withValues(alpha: 0.18)
                  : AppColors.blushPinkLight)
              : (isDark ? AppColors.darkCard : Colors.white),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? (isDark
                    ? AppColors.blushPinkDeep
                    : AppColors.deepBurgundy)
                : (isDark
                    ? AppColors.darkBorder
                    : AppColors.lightBorder),
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.titleMedium(isDark: isDark).copyWith(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: isDark
                    ? AppColors.blushPinkDeep
                    : AppColors.deepBurgundy,
              ),
          ],
        ),
      ),
    );
  }
}

class GoalSelectionCard extends StatelessWidget {
  final String icon;
  final String label;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;
  final ValueChanged<bool?> onChanged;

  const GoalSelectionCard({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                  ? AppColors.blushPinkDeep.withValues(alpha: 0.18)
                  : AppColors.blushPinkLight)
              : (isDark ? AppColors.darkCard : Colors.white),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? (isDark
                    ? AppColors.blushPinkDeep
                    : AppColors.deepBurgundy)
                : (isDark
                    ? AppColors.darkBorder
                    : AppColors.lightBorder),
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.titleMedium(isDark: isDark).copyWith(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
            Checkbox(
              value: isSelected,
              activeColor: isDark
                  ? AppColors.blushPinkDeep
                  : AppColors.deepBurgundy,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
