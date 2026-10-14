import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../providers/app_state_provider.dart';
import '../../widgets/gradient_button.dart';
import 'partner_invite_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final TextEditingController _nameController =
      TextEditingController(text: 'Mitra');
  String _selectedAvatar = '🌸';
  String _selectedStage = 'stageDating';
  final List<String> _selectedGoals = [
    'goalDeeperConversations',
    'goalSpontaneousRomance',
  ];

  final List<String> _avatars = ['🌸', '🌿', '🕊️', '👑', '✨', '🌺', '☕', '🌟'];

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppStateProvider>();
    final isDark = provider.isDarkMode;
    final isTr = provider.isTurkish;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with Language Selector & Progress Dots
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Text(
                    'GHARAR',
                    style: AppTextStyles.displaySmall(isDark: isDark).copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                      fontSize: 18,
                      color: isDark
                          ? AppColors.blushPinkDeep
                          : AppColors.deepBurgundy,
                    ),
                  ),
                  const Spacer(),
                  // Language Switcher Chip
                  ActionChip(
                    avatar: const Icon(Icons.language_rounded, size: 16),
                    label: Text(isTr ? 'Türkçe' : 'English'),
                    onPressed: () {
                      provider.setLocale(
                        isTr ? const Locale('en') : const Locale('tr'),
                      );
                    },
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
                  _buildWelcomeSlide(isDark, isTr),

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
                    provider.completeOnboarding(
                      name: _nameController.text.trim().isEmpty
                          ? 'Mitra'
                          : _nameController.text.trim(),
                      avatar: _selectedAvatar,
                      relationshipStage: _selectedStage,
                      goals: _selectedGoals,
                      languageCode: provider.locale.languageCode,
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

  Widget _buildWelcomeSlide(bool isDark, bool isTr) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              gradient: AppColors.romanticLove,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.deepBurgundy.withValues(alpha: 0.28),
                  blurRadius: 28,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Center(
              child: Text('🕊️', style: TextStyle(fontSize: 54)),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            isTr
                ? 'İkinize Özel Masalsı Bir Alan'
                : 'A Sacred Sanctuary Just for the Two of You',
            textAlign: TextAlign.center,
            style: AppTextStyles.displayMedium(isDark: isDark).copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isTr
                ? 'GHARAR; ilişkinizi derinleştirmek, birbirinizi yargılamadan anlamak, gizli sorularla heyecanı canlı tutmak ve ömürlük anılar biriktirmek için tasarlandı.'
                : 'GHARAR is exclusively designed to deepen your bond, understand each other without judgment, spark romance with private questions, and cherish every moment.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyLarge(isDark: isDark),
          ),
        ],
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
              hintText: isTr ? 'Örn: Mitra' : 'e.g. Mitra',
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
                GestureDetector(
                  onTap: () => setState(() => _selectedAvatar = av),
                  child: Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: _selectedAvatar == av
                          ? (isDark
                              ? AppColors.blushPinkDeep.withValues(alpha: 0.3)
                              : AppColors.blushPinkLight)
                          : (isDark
                              ? AppColors.darkCard
                              : Colors.white),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _selectedAvatar == av
                            ? (isDark
                                ? AppColors.blushPinkDeep
                                : AppColors.deepBurgundy)
                            : (isDark
                                ? AppColors.darkBorder
                                : AppColors.lightBorder),
                        width: _selectedAvatar == av ? 2.5 : 1.0,
                      ),
                    ),
                    child: Center(
                      child: Text(av, style: const TextStyle(fontSize: 26)),
                    ),
                  ),
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
            InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => setState(() => _selectedStage = s['key']!),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: _selectedStage == s['key']
                      ? (isDark
                          ? AppColors.blushPinkDeep.withValues(alpha: 0.18)
                          : AppColors.blushPinkLight)
                      : (isDark ? AppColors.darkCard : Colors.white),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: _selectedStage == s['key']
                        ? (isDark
                            ? AppColors.blushPinkDeep
                            : AppColors.deepBurgundy)
                        : (isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder),
                    width: _selectedStage == s['key'] ? 2.0 : 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    Text(s['icon']!, style: const TextStyle(fontSize: 22)),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        isTr ? s['labelTr']! : s['labelEn']!,
                        style: AppTextStyles.titleMedium(isDark: isDark).copyWith(
                          fontWeight: _selectedStage == s['key']
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                    if (_selectedStage == s['key'])
                      Icon(
                        Icons.check_circle_rounded,
                        color: isDark
                            ? AppColors.blushPinkDeep
                            : AppColors.deepBurgundy,
                      ),
                  ],
                ),
              ),
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
                return InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedGoals.remove(g['key']);
                      } else {
                        _selectedGoals.add(g['key']!);
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
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
                        Text(g['icon']!, style: const TextStyle(fontSize: 22)),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            isTr ? g['labelTr']! : g['labelEn']!,
                            style: AppTextStyles.titleMedium(isDark: isDark)
                                .copyWith(
                              fontWeight:
                                  isSelected ? FontWeight.w700 : FontWeight.w500,
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
                          onChanged: (val) {
                            setState(() {
                              if (val == true) {
                                _selectedGoals.add(g['key']!);
                              } else {
                                _selectedGoals.remove(g['key']);
                              }
                            });
                          },
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
