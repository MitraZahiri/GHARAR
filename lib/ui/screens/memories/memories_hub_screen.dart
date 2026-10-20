import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/journal_entry_model.dart';
import '../../../models/milestone_model.dart';
import '../../../providers/app_state_provider.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/romantic_app_bar.dart';
import 'add_memory_modal.dart';
import 'special_dates_screen.dart';

class MemoriesHubScreen extends StatefulWidget {
  const MemoriesHubScreen({super.key});

  @override
  State<MemoriesHubScreen> createState() => _MemoriesHubScreenState();
}

class _MemoriesHubScreenState extends State<MemoriesHubScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        title: isTr ? 'Anılar & Günlük' : 'Our Story & Memories',
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month_rounded),
            tooltip: isTr ? 'Özel Günler & Geri Sayım' : 'Special Dates',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SpecialDatesScreen(),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'memories_hub_fab',
        backgroundColor:
            isDark ? AppColors.blushPinkDeep : AppColors.deepBurgundy,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.favorite_rounded),
        label: Text(
          isTr ? 'Anı Ekle' : 'Add Memory',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => const AddMemoryModal(),
          );
        },
      ),
      body: Column(
        children: [
          // Tab bar
          TabBar(
            controller: _tabController,
            indicatorColor:
                isDark ? AppColors.blushPinkDeep : AppColors.deepBurgundy,
            labelColor:
                isDark ? AppColors.blushPinkDeep : AppColors.deepBurgundy,
            unselectedLabelColor:
                isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            labelStyle: AppTextStyles.labelLarge(isDark: isDark),
            tabs: [
              Tab(text: isTr ? 'Özel Çift Günlüğü' : 'Couple Journal'),
              Tab(text: isTr ? 'Zaman Çizelgesi' : 'Memory Timeline'),
            ],
          ),

          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                // 1. Couple Journal
                CoupleJournalTabView(),

                // 2. Timeline Milestones
                MemoryTimelineTabView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Dedicated view for couple journal entries with granular rebuilds.
class CoupleJournalTabView extends StatelessWidget {
  const CoupleJournalTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.select<AppStateProvider, bool>((p) => p.isDarkMode);
    final isTr = context.select<AppStateProvider, bool>((p) => p.isTurkish);
    final list = context.select<AppStateProvider, List<JournalEntryModel>>(
      (p) => p.journalEntries,
    );

    if (list.isEmpty) {
      return Center(
        child: Text(
          isTr
              ? 'Henüz bir günlük notu eklenmemiş.\nAşağıdaki butona dokunarak ilk sevgi notunuzu bırakın!'
              : 'No journal reflections yet.\nTap below to write your first love note!',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMedium(isDark: isDark),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 80),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return JournalEntryCard(entry: list[index], isDark: isDark);
      },
    );
  }
}

/// Dedicated card widget for an individual journal entry.
class JournalEntryCard extends StatelessWidget {
  final JournalEntryModel entry;
  final bool isDark;

  const JournalEntryCard({
    super.key,
    required this.entry,
    required this.isDark,
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
              Text(entry.moodEmoji, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.title,
                      style: AppTextStyles.titleMedium(
                        isDark: isDark,
                      ).copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      '${entry.authorName} • ${DateFormat('MMMM d, yyyy').format(entry.date)}',
                      style: AppTextStyles.bodySmall(isDark: isDark),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (entry.questionSnippet != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color:
                    isDark
                        ? AppColors.darkCardElevated
                        : AppColors.blushPinkLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '💬 "${entry.questionSnippet!}"',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySmall(
                  isDark: isDark,
                ).copyWith(fontSize: 11, fontStyle: FontStyle.italic),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Text(
            entry.notes,
            style: AppTextStyles.bodyMedium(
              isDark: isDark,
            ).copyWith(height: 1.5),
          ),
          if (entry.tags.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              children: [
                for (final t in entry.tags)
                  Text(
                    '#$t',
                    style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
                      fontSize: 11,
                      color:
                          isDark
                              ? AppColors.blushPinkDeep
                              : AppColors.burgundyRose,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Dedicated view for milestones timeline with granular rebuilds.
class MemoryTimelineTabView extends StatelessWidget {
  const MemoryTimelineTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.select<AppStateProvider, bool>((p) => p.isDarkMode);
    final isTr = context.select<AppStateProvider, bool>((p) => p.isTurkish);
    final list = context.select<AppStateProvider, List<MilestoneModel>>(
      (p) => p.milestones,
    );

    return ListView.builder(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 80),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return MilestoneTimelineItem(
          milestone: list[index],
          isLast: index == list.length - 1,
          isDark: isDark,
          isTr: isTr,
        );
      },
    );
  }
}

/// Dedicated timeline item widget for a milestone.
class MilestoneTimelineItem extends StatelessWidget {
  final MilestoneModel milestone;
  final bool isLast;
  final bool isDark;
  final bool isTr;

  const MilestoneTimelineItem({
    super.key,
    required this.milestone,
    required this.isLast,
    required this.isDark,
    required this.isTr,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline line + Node
        Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: AppColors.romanticLove,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.deepBurgundy.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  milestone.icon,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 80,
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
          ],
        ),

        const SizedBox(width: 14),

        // Milestone Card
        Expanded(
          child: GlassCard(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      DateFormat('MMM yyyy').format(milestone.milestoneDate),
                      style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
                        fontWeight: FontWeight.w700,
                        color:
                            isDark
                                ? AppColors.blushPinkDeep
                                : AppColors.deepBurgundy,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.champagneGold.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        milestone.badgeText(isTr),
                        style: const TextStyle(
                          color: AppColors.champagneGold,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  milestone.title(isTr),
                  style: AppTextStyles.titleMedium(
                    isDark: isDark,
                  ).copyWith(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                const SizedBox(height: 6),
                Text(
                  milestone.description(isTr),
                  style: AppTextStyles.bodyMedium(isDark: isDark),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
