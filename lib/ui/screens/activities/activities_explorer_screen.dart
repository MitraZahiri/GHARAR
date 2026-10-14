import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/activity_model.dart';
import '../../../providers/app_state_provider.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/romantic_app_bar.dart';
import 'surprise_generator_modal.dart';
import 'weekly_challenges_screen.dart';

class ActivitiesExplorerScreen extends StatefulWidget {
  const ActivitiesExplorerScreen({super.key});

  @override
  State<ActivitiesExplorerScreen> createState() =>
      _ActivitiesExplorerScreenState();
}

class _ActivitiesExplorerScreenState extends State<ActivitiesExplorerScreen> {
  ActivityBudget? _budgetFilter;
  ActivitySetting? _settingFilter;
  ActivityVibe? _vibeFilter;
  bool _onlySaved = false;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppStateProvider>();
    final isDark = provider.isDarkMode;
    final isTr = provider.isTurkish;

    var filtered = provider.activities;
    if (_budgetFilter != null) {
      filtered = filtered.where((a) => a.budget == _budgetFilter).toList();
    }
    if (_settingFilter != null) {
      filtered = filtered.where((a) => a.setting == _settingFilter).toList();
    }
    if (_vibeFilter != null) {
      filtered = filtered.where((a) => a.vibe == _vibeFilter).toList();
    }
    if (_onlySaved) {
      filtered = filtered.where((a) => a.isSaved).toList();
    }

    return Scaffold(
      appBar: RomanticAppBar(
        title: isTr ? 'Randevu & Deneyimler' : 'Couple Activities',
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor:
            isDark ? AppColors.blushPinkDeep : AppColors.deepBurgundy,
        foregroundColor: Colors.white,
        icon: const Text('🎲', style: TextStyle(fontSize: 18)),
        label: Text(
          isTr ? 'Sürpriz Üretici' : 'Surprise Idea',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => const SurpriseGeneratorModal(),
          );
        },
      ),
      body: Column(
        children: [
          // Weekly Challenges Quick Access Banner
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              gradient: isDark
                  ? AppColors.darkCardGradient
                  : AppColors.intimateCardGradient,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const WeeklyChallengesScreen(),
                  ),
                );
              },
              child: Row(
                children: [
                  const Text('🏆', style: TextStyle(fontSize: 26)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isTr
                              ? 'Haftalık Çift Görevleri & Rozetler'
                              : 'Weekly Challenges & Badges',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.titleMedium(isDark: isDark)
                              .copyWith(fontWeight: FontWeight.w700, fontSize: 14),
                        ),
                        Text(
                          isTr
                              ? 'Bu haftanın romantik görevini tamamlayın'
                              : 'Complete this week’s love mission',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodySmall(isDark: isDark)
                              .copyWith(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.arrow_forward_ios_rounded,
                      size: 14, color: AppColors.lightTextMuted),
                ],
              ),
            ),
          ),

          // Filters Carousel
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                // Saved Filter
                FilterChip(
                  avatar: Icon(
                    _onlySaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                    size: 16,
                  ),
                  label: Text(isTr ? 'Kaydedilenler' : 'Saved'),
                  selected: _onlySaved,
                  onSelected: (val) {
                    setState(() {
                      _onlySaved = val;
                    });
                  },
                ),
                const SizedBox(width: 8),

                // Setting Filters
                _buildFilterChip<ActivitySetting>(
                  label: isTr ? 'Evde' : 'At Home',
                  value: ActivitySetting.atHome,
                  current: _settingFilter,
                  onChanged: (v) => setState(() => _settingFilter = v),
                ),
                const SizedBox(width: 8),
                _buildFilterChip<ActivitySetting>(
                  label: isTr ? 'Açık Hava' : 'Outdoors',
                  value: ActivitySetting.outdoor,
                  current: _settingFilter,
                  onChanged: (v) => setState(() => _settingFilter = v),
                ),
                const SizedBox(width: 8),

                // Budget Filters
                _buildFilterChip<ActivityBudget>(
                  label: isTr ? 'Ücretsiz' : 'Free',
                  value: ActivityBudget.free,
                  current: _budgetFilter,
                  onChanged: (v) => setState(() => _budgetFilter = v),
                ),
                const SizedBox(width: 8),
                _buildFilterChip<ActivityBudget>(
                  label: r'$ Düşük',
                  value: ActivityBudget.low,
                  current: _budgetFilter,
                  onChanged: (v) => setState(() => _budgetFilter = v),
                ),
                const SizedBox(width: 8),

                // Vibe Filters
                _buildFilterChip<ActivityVibe>(
                  label: isTr ? 'Romantik' : 'Romantic',
                  value: ActivityVibe.romantic,
                  current: _vibeFilter,
                  onChanged: (v) => setState(() => _vibeFilter = v),
                ),
                const SizedBox(width: 8),
                _buildFilterChip<ActivityVibe>(
                  label: isTr ? 'Oyun & Neşe' : 'Playful',
                  value: ActivityVibe.playful,
                  current: _vibeFilter,
                  onChanged: (v) => setState(() => _vibeFilter = v),
                ),
                const SizedBox(width: 8),
                if (_budgetFilter != null ||
                    _settingFilter != null ||
                    _vibeFilter != null ||
                    _onlySaved)
                  ActionChip(
                    label: Text(isTr ? 'Filtreleri Temizle' : 'Clear Filters'),
                    onPressed: () {
                      setState(() {
                        _budgetFilter = null;
                        _settingFilter = null;
                        _vibeFilter = null;
                        _onlySaved = false;
                      });
                    },
                  ),
              ],
            ),
          ),

          const Divider(height: 16),

          // Activities List
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text(
                      isTr
                          ? 'Bu kriterlere uygun randevu fikri bulunamadı.'
                          : 'No activities match these filters.',
                      style: AppTextStyles.bodyMedium(isDark: isDark),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 4, bottom: 80),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final act = filtered[index];
                      return _buildActivityCard(
                          act, provider, isDark, isTr, context);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip<T>({
    required String label,
    required T value,
    required T? current,
    required ValueChanged<T?> onChanged,
  }) {
    final isSelected = current == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        onChanged(selected ? value : null);
      },
    );
  }

  Widget _buildActivityCard(
    ActivityModel act,
    AppStateProvider provider,
    bool isDark,
    bool isTr,
    BuildContext context,
  ) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkCardElevated
                      : AppColors.blushPinkLight,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(act.icon, style: const TextStyle(fontSize: 22)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            act.category(isTr).toUpperCase(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
                              fontSize: 10,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? AppColors.blushPinkDeep
                                  : AppColors.burgundyRose,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        // Bookmark icon
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            act.isSaved
                                ? Icons.bookmark_rounded
                                : Icons.bookmark_border_rounded,
                            color: act.isSaved
                                ? AppColors.champagneGold
                                : (isDark
                                    ? AppColors.darkTextMuted
                                    : AppColors.lightTextMuted),
                            size: 22,
                          ),
                          onPressed: () {
                            provider.toggleSaveActivity(act.id);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      act.title(isTr),
                      style: AppTextStyles.titleMedium(isDark: isDark).copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            act.description(isTr),
            style: AppTextStyles.bodyMedium(isDark: isDark),
          ),

          const SizedBox(height: 12),

          // Attribute Pills: Setting, Vibe, Budget, Duration
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _buildTag(act.settingDisplay(isTr), isDark),
              _buildTag(act.vibeDisplay(isTr), isDark),
              _buildTag(act.budgetDisplay, isDark),
              _buildTag('⏱️ ${act.duration}', isDark),
            ],
          ),

          if (act.tips(isTr).isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardElevated : AppColors.warmCream,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final tip in act.tips(isTr))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Expanded(
                            child: Text(
                              tip,
                              style: AppTextStyles.bodySmall(isDark: isDark)
                                  .copyWith(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],

          const Divider(height: 20),

          // Completion status button
          Align(
            alignment: Alignment.centerRight,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: TextButton.icon(
                icon: Icon(
                  act.isCompleted
                      ? Icons.check_circle_rounded
                      : Icons.circle_outlined,
                  color: act.isCompleted
                      ? AppColors.successGreen
                      : (isDark
                          ? AppColors.darkTextMuted
                          : AppColors.lightTextMuted),
                ),
                label: Text(
                  act.isCompleted
                      ? (isTr ? 'Bunu Yaptık! ✨' : 'Completed Together! ✨')
                      : (isTr ? 'Yaptık Olarak İşaretle' : 'Mark as Done'),
                  style: TextStyle(
                    color: act.isCompleted
                        ? AppColors.successGreen
                        : (isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.deepBurgundy),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onPressed: () {
                  provider.toggleCompleteActivity(act.id);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardElevated : AppColors.warmIvory,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 0.8,
        ),
      ),
      child: Text(
        text,
        style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
