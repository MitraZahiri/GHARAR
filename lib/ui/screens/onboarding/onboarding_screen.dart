import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/localization/app_language.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../providers/app_state_provider.dart';
import '../../widgets/concentric_soul_background.dart';
import '../../widgets/custom_primary_button.dart';
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

  static const List<String> _avatars = [
    '🌸',
    '🌿',
    '🕊️',
    '👑',
    '✨',
    '🌺',
    '☕',
    '🌟',
  ];

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

  void _onNextPressed(bool isTr) {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      final appState = context.read<AppStateProvider>();
      appState.completeOnboarding(
        name: _nameController.text,
        avatar: _selectedAvatar,
        relationshipStage: _selectedStage,
        goals: _selectedGoals,
        languageCode: appState.locale.languageCode,
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const PartnerInviteScreen()),
      );
    }
  }

  void _onPreviousPressed() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showLanguagePickerSheet(
    BuildContext context,
    bool isDark,
    AppLanguage currentLang,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (ctx) => OnboardingLanguagePickerSheet(
            isDark: isDark,
            currentLang: currentLang,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.select<AppStateProvider, bool>((p) => p.isDarkMode);
    final isTr = context.select<AppStateProvider, bool>((p) => p.isTurkish);
    final currentLanguage = context.select<AppStateProvider, AppLanguage>(
      (p) => p.currentLanguage,
    );

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: ConcentricSoulBackground(
        isDark: isDark,
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar: Brand, Back navigation & Multilingual selector
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    if (_currentPage > 0)
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 18,
                          color:
                              isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.inkCharcoal,
                        ),
                        onPressed: _onPreviousPressed,
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    if (_currentPage > 0) const SizedBox(width: 8),
                    Text(
                      'GHARAR',
                      style: AppTextStyles.displaySmall(
                        isDark: isDark,
                      ).copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2.0,
                        fontSize: 18,
                        color:
                            isDark
                                ? AppColors.blushPinkDeep
                                : AppColors.deepBurgundy,
                      ),
                    ),
                    const Spacer(),
                    // Multilingual Language Switcher Chip
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap:
                          () => _showLanguagePickerSheet(
                            context,
                            isDark,
                            currentLanguage,
                          ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isDark
                                  ? AppColors.darkCardElevated
                                  : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color:
                                isDark
                                    ? AppColors.darkBorder
                                    : AppColors.parchmentBorder,
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              currentLanguage.flag,
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              currentLanguage.nativeName,
                              style: AppTextStyles.bodySmall(
                                isDark: isDark,
                              ).copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 2),
                            Icon(
                              Icons.arrow_drop_down_rounded,
                              size: 16,
                              color:
                                  isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Segmented Horizontal Progress Bars
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 6,
                ),
                child: Row(
                  children: [
                    for (int i = 0; i < 4; i++)
                      Expanded(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: 4.5,
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                            color:
                                _currentPage >= i
                                    ? (isDark
                                        ? AppColors.terracottaLight
                                        : AppColors.terracotta)
                                    : (isDark
                                        ? AppColors.darkBorder
                                        : AppColors.parchmentBorder),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

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
                    OnboardingProfileSlide(
                      nameController: _nameController,
                      avatars: _avatars,
                      selectedAvatar: _selectedAvatar,
                      isDark: isDark,
                      isTr: isTr,
                      onAvatarSelected:
                          (av) => setState(() => _selectedAvatar = av),
                    ),

                    // 3. Relationship Stage
                    OnboardingStageSlide(
                      selectedStage: _selectedStage,
                      isDark: isDark,
                      isTr: isTr,
                      onStageSelected:
                          (stage) => setState(() => _selectedStage = stage),
                    ),

                    // 4. Goals & Intentions
                    OnboardingGoalsSlide(
                      selectedGoals: _selectedGoals,
                      isDark: isDark,
                      isTr: isTr,
                      onToggleGoal: (key) {
                        setState(() {
                          if (_selectedGoals.contains(key)) {
                            _selectedGoals.remove(key);
                          } else {
                            _selectedGoals.add(key);
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),

              // Bottom Navigation CTA
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                child: CustomPrimaryButton(
                  text:
                      _currentPage == 3
                          ? (isTr
                              ? 'Partnerimi Davet Et 💌'
                              : 'Invite My Partner 💌')
                          : (isTr ? 'Devam Et ➔' : 'Continue ➔'),
                  height: 52,
                  borderRadius: 26,
                  backgroundColor:
                      isDark ? AppColors.terracotta : AppColors.inkCharcoal,
                  textColor: Colors.white,
                  onPressed: () => _onNextPressed(isTr),
                ),
              ),
            ],
          ),
        ),
      ),
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
            Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
              decoration: BoxDecoration(
                color:
                    isDark
                        ? AppColors.darkCardElevated.withValues(alpha: 0.6)
                        : Colors.white.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color:
                      isDark ? AppColors.darkBorder : AppColors.parchmentBorder,
                  width: 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const SoulConnectionArt(
                width: 240,
                height: 180,
                animateGlow: true,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              isTr
                  ? 'İkinize Özel Masalsı Bir Alan'
                  : 'A Sacred Sanctuary Just for the Two of You',
              textAlign: TextAlign.center,
              style: AppTextStyles.displayMedium(isDark: isDark).copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 24,
                letterSpacing: -0.4,
                color:
                    isDark ? AppColors.darkTextPrimary : AppColors.inkCharcoal,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              isTr
                  ? 'GHARAR; ilişkinizi derinleştirmek, birbirinizi yargılamadan anlamak, gizli sorularla heyecanı canlı tutmak ve ömürlük anılar biriktirmek için tasarlandı.'
                  : 'GHARAR is exclusively designed to deepen your bond, understand each other without judgment, spark romance with private questions, and cherish every moment.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLarge(isDark: isDark).copyWith(
                fontSize: 14,
                height: 1.5,
                color:
                    isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          color:
              isSelected
                  ? (isDark
                      ? AppColors.terracotta.withValues(alpha: 0.25)
                      : AppColors.blushPinkLight)
                  : (isDark ? AppColors.darkCardElevated : Colors.white),
          shape: BoxShape.circle,
          border: Border.all(
            color:
                isSelected
                    ? (isDark
                        ? AppColors.terracottaLight
                        : AppColors.terracotta)
                    : (isDark
                        ? AppColors.darkBorder
                        : AppColors.parchmentBorder),
            width: isSelected ? 2.5 : 1.0,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: AppColors.terracotta.withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                  : null,
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
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? (isDark
                      ? AppColors.terracotta.withValues(alpha: 0.16)
                      : AppColors.terracotta.withValues(alpha: 0.08))
                  : (isDark ? AppColors.darkCardElevated : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                isSelected
                    ? (isDark
                        ? AppColors.terracottaLight
                        : AppColors.terracotta)
                    : (isDark
                        ? AppColors.darkBorder
                        : AppColors.parchmentBorder),
            width: isSelected ? 1.8 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
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
                  fontSize: 15,
                  color:
                      isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.inkCharcoal,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color:
                    isDark ? AppColors.terracottaLight : AppColors.terracotta,
                size: 22,
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
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? (isDark
                      ? AppColors.terracotta.withValues(alpha: 0.16)
                      : AppColors.terracotta.withValues(alpha: 0.08))
                  : (isDark ? AppColors.darkCardElevated : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                isSelected
                    ? (isDark
                        ? AppColors.terracottaLight
                        : AppColors.terracotta)
                    : (isDark
                        ? AppColors.darkBorder
                        : AppColors.parchmentBorder),
            width: isSelected ? 1.8 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
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
                  fontSize: 14,
                  color:
                      isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.inkCharcoal,
                ),
              ),
            ),
            Checkbox(
              value: isSelected,
              activeColor:
                  isDark ? AppColors.terracottaLight : AppColors.terracotta,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingProfileSlide extends StatelessWidget {
  final TextEditingController nameController;
  final List<String> avatars;
  final String selectedAvatar;
  final bool isDark;
  final bool isTr;
  final ValueChanged<String> onAvatarSelected;

  const OnboardingProfileSlide({
    super.key,
    required this.nameController,
    required this.avatars,
    required this.selectedAvatar,
    required this.isDark,
    required this.isTr,
    required this.onAvatarSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isTr ? 'Kendinizi Tanıtın' : 'Create Your Profile',
            style: AppTextStyles.displaySmall(isDark: isDark).copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 24,
              color: isDark ? AppColors.darkTextPrimary : AppColors.inkCharcoal,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isTr
                ? 'Partnerinizin ekranda göreceği adınızı ve sevimli avatarınızı seçin.'
                : 'Choose your name and avatar as it will appear in your shared space.',
            style: AppTextStyles.bodyMedium(isDark: isDark).copyWith(
              color:
                  isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 24),

          // Name Input in Pill Field
          Text(
            isTr ? 'Adınız:' : 'What should your partner call you?',
            style: AppTextStyles.labelLarge(
              isDark: isDark,
            ).copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardElevated : Colors.white,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color:
                    isDark ? AppColors.darkBorder : AppColors.parchmentBorder,
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            child: TextField(
              controller: nameController,
              style: TextStyle(
                fontSize: 15,
                color:
                    isDark ? AppColors.darkTextPrimary : AppColors.inkCharcoal,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: isTr ? 'Adınızı girin' : 'Enter your name',
                hintStyle: TextStyle(
                  color:
                      isDark
                          ? AppColors.darkTextMuted
                          : AppColors.lightTextMuted,
                  fontSize: 14,
                ),
                icon: Icon(
                  Icons.person_outline_rounded,
                  color:
                      isDark ? AppColors.terracottaLight : AppColors.terracotta,
                ),
              ),
            ),
          ),

          const SizedBox(height: 28),

          // Avatar Picker
          Text(
            isTr ? 'Avatarınızı Seçin:' : 'Pick Your Romantic Avatar:',
            style: AppTextStyles.labelLarge(
              isDark: isDark,
            ).copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final av in avatars)
                AvatarOptionBubble(
                  avatar: av,
                  isSelected: selectedAvatar == av,
                  isDark: isDark,
                  onTap: () => onAvatarSelected(av),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class OnboardingStageSlide extends StatelessWidget {
  final String selectedStage;
  final bool isDark;
  final bool isTr;
  final ValueChanged<String> onStageSelected;

  const OnboardingStageSlide({
    super.key,
    required this.selectedStage,
    required this.isDark,
    required this.isTr,
    required this.onStageSelected,
  });

  @override
  Widget build(BuildContext context) {
    const stages = [
      {
        'key': 'stageDating',
        'labelEn': 'Dating & Exploring',
        'labelTr': 'Flört & Tanıma',
        'icon': '🌱',
      },
      {
        'key': 'stageEngaged',
        'labelEn': 'Engaged & Planning',
        'labelTr': 'Nişanlı & Evlilik Hazırlığı',
        'icon': '💍',
      },
      {
        'key': 'stageNewlywed',
        'labelEn': 'Newlyweds (1st Years)',
        'labelTr': 'Yeni Evli (İlk Yıllar)',
        'icon': '🥂',
      },
      {
        'key': 'stageLongTerm',
        'labelEn': 'Long-term Companions',
        'labelTr': 'Uzun Süreli Birliktelik',
        'icon': '🌿',
      },
      {
        'key': 'stageMarriedWithKids',
        'labelEn': 'Married with Children',
        'labelTr': 'Çocuklu Evli Çift',
        'icon': '🏡',
      },
      {
        'key': 'stageLongDistance',
        'labelEn': 'Long Distance Love',
        'labelTr': 'Uzak Mesafe Aşkı',
        'icon': '✈️',
      },
    ];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isTr ? 'İlişkiniz Hangi Evrede?' : 'Where Are You in Love?',
            style: AppTextStyles.displaySmall(isDark: isDark).copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 24,
              color: isDark ? AppColors.darkTextPrimary : AppColors.inkCharcoal,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isTr
                ? 'Soruları ve randevu önerilerini sizin döneminize göre kişiselleştirelim.'
                : 'This helps GHARAR tailor questions and activities specifically to your journey.',
            style: AppTextStyles.bodyMedium(isDark: isDark).copyWith(
              color:
                  isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 20),

          for (final s in stages)
            RelationshipStageCard(
              icon: s['icon']!,
              label: isTr ? s['labelTr']! : s['labelEn']!,
              isSelected: selectedStage == s['key'],
              isDark: isDark,
              onTap: () => onStageSelected(s['key']!),
            ),
        ],
      ),
    );
  }
}

class OnboardingGoalsSlide extends StatelessWidget {
  final List<String> selectedGoals;
  final bool isDark;
  final bool isTr;
  final ValueChanged<String> onToggleGoal;

  const OnboardingGoalsSlide({
    super.key,
    required this.selectedGoals,
    required this.isDark,
    required this.isTr,
    required this.onToggleGoal,
  });

  @override
  Widget build(BuildContext context) {
    const goals = [
      {
        'key': 'goalDeeperConversations',
        'labelEn': 'Deeper Conversations',
        'labelTr': 'Daha Derin Sohbetler',
        'icon': '💬',
      },
      {
        'key': 'goalSpontaneousRomance',
        'labelEn': 'Spontaneous Romance',
        'labelTr': 'Spontane Romantizm',
        'icon': '🌹',
      },
      {
        'key': 'goalUnderstandingNeeds',
        'labelEn': 'Understanding Emotional Needs',
        'labelTr': 'Duygusal İhtiyaçları Anlamak',
        'icon': '🕊️',
      },
      {
        'key': 'goalFuturePlanning',
        'labelEn': 'Aligning on Future Dreams',
        'labelTr': 'Gelecek Hayallerinde Uyum',
        'icon': '✨',
      },
      {
        'key': 'goalFunAdventures',
        'labelEn': 'Playful Fun & Date Adventures',
        'labelTr': 'Eğlenceli Randevular & Macera',
        'icon': '🎉',
      },
      {
        'key': 'goalConflictResolution',
        'labelEn': 'Gentle Conflict Resolution',
        'labelTr': 'Şefkatli İletişim & Çözüm',
        'icon': '🕯️',
      },
    ];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isTr
                ? 'Birlikte Neyi Büyütmek İstersiniz?'
                : 'What Would You Like to Nurture?',
            style: AppTextStyles.displaySmall(isDark: isDark).copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 24,
              color: isDark ? AppColors.darkTextPrimary : AppColors.inkCharcoal,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isTr
                ? 'En çok önemsediğiniz hedefleri seçin (birden fazla seçebilirsiniz).'
                : 'Select all intentions that resonate with your love story right now.',
            style: AppTextStyles.bodyMedium(isDark: isDark).copyWith(
              color:
                  isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 20),

          for (final g in goals)
            GoalSelectionCard(
              icon: g['icon']!,
              label: isTr ? g['labelTr']! : g['labelEn']!,
              isSelected: selectedGoals.contains(g['key']),
              isDark: isDark,
              onTap: () => onToggleGoal(g['key']!),
              onChanged: (_) => onToggleGoal(g['key']!),
            ),
        ],
      ),
    );
  }
}

class OnboardingLanguagePickerSheet extends StatelessWidget {
  final bool isDark;
  final AppLanguage currentLang;

  const OnboardingLanguagePickerSheet({
    super.key,
    required this.isDark,
    required this.currentLang,
  });

  @override
  Widget build(BuildContext context) {
    final isTr = currentLang.code == 'tr';

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.78,
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
              color: isDark ? AppColors.darkBorder : AppColors.parchmentBorder,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                Icon(
                  Icons.language_rounded,
                  color:
                      isDark ? AppColors.terracottaLight : AppColors.terracotta,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Text(
                  isTr ? 'Dil Seçimi' : 'Choose Language',
                  style: AppTextStyles.titleMedium(
                    isDark: isDark,
                  ).copyWith(fontWeight: FontWeight.w800, fontSize: 18),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? (isDark
                                  ? AppColors.terracotta.withValues(alpha: 0.18)
                                  : AppColors.terracotta.withValues(
                                    alpha: 0.08,
                                  ))
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color:
                            isSelected
                                ? (isDark
                                    ? AppColors.terracottaLight
                                    : AppColors.terracotta)
                                : (isDark
                                    ? AppColors.darkBorder.withValues(
                                      alpha: 0.5,
                                    )
                                    : AppColors.parchmentBorder),
                        width: isSelected ? 1.8 : 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(lang.flag, style: const TextStyle(fontSize: 26)),
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
                                      isDark: isDark,
                                    ).copyWith(
                                      fontWeight:
                                          isSelected
                                              ? FontWeight.w800
                                              : FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '(${lang.name})',
                                    style: AppTextStyles.bodySmall(
                                      isDark: isDark,
                                    ).copyWith(
                                      fontSize: 12,
                                      color:
                                          isDark
                                              ? AppColors.darkTextSecondary
                                              : AppColors.lightTextMuted,
                                    ),
                                  ),
                                  if (lang.isRtl) ...[
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.champagneGold
                                            .withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(6),
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
                                  isDark: isDark,
                                ).copyWith(
                                  fontSize: 11,
                                  fontStyle: FontStyle.italic,
                                  color:
                                      isDark
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
                            color:
                                isDark
                                    ? AppColors.terracottaLight
                                    : AppColors.terracotta,
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
  }
}
