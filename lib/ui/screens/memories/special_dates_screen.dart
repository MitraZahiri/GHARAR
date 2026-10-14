import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../providers/app_state_provider.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_button.dart';

class SpecialDatesScreen extends StatelessWidget {
  const SpecialDatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppStateProvider>();
    final isDark = provider.isDarkMode;
    final isTr = provider.isTurkish;

    final dates = provider.specialDates;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isTr ? 'Özel Günlerimiz & Geri Sayım' : 'Special Dates & Countdowns',
          style: AppTextStyles.titleMedium(isDark: isDark).copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            tooltip: isTr ? 'Özel Gün Ekle' : 'Add Special Date',
            onPressed: () => _showAddDateModal(context, provider, isDark, isTr),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: dates.length,
        itemBuilder: (context, index) {
          final item = dates[index];
          final days = item.daysUntil;

          return GlassCard(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkCardElevated
                        : AppColors.blushPinkLight,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(item.icon, style: const TextStyle(fontSize: 24)),
                  ),
                ),
                const SizedBox(width: 14),
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
                          color: isDark
                              ? AppColors.blushPinkDeep
                              : AppColors.burgundyRose,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.title(isTr),
                        style: AppTextStyles.titleMedium(isDark: isDark).copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('MMMM d, yyyy').format(item.date),
                        style: AppTextStyles.bodySmall(isDark: isDark),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Days Countdown Pill
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: days <= 14
                        ? AppColors.sunsetGold
                        : (isDark
                            ? AppColors.darkCardGradient
                            : AppColors.intimateCardGradient),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: days <= 14
                          ? AppColors.streakFlame
                          : (isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$days',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: days <= 14
                              ? Colors.white
                              : (isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.deepBurgundy),
                        ),
                      ),
                      Text(
                        isTr ? 'gün kaldı' : 'days left',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: days <= 14
                              ? Colors.white.withValues(alpha: 0.9)
                              : (isDark
                                  ? AppColors.darkTextMuted
                                  : AppColors.lightTextMuted),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showAddDateModal(BuildContext context, AppStateProvider provider,
      bool isDark, bool isTr) {
    final titleController = TextEditingController();
    DateTime selectedDate = DateTime.now().add(const Duration(days: 30));
    String category = 'Anniversary';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isTr ? 'Özel Gün / Yıldönümü Ekle' : 'Add Special Date',
                    style: AppTextStyles.titleMedium(isDark: isDark).copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: isTr ? 'Etkinlik / Gün Adı' : 'Event / Date Title',
                      hintText: isTr
                          ? 'Örn: Paris Tatilimiz 🗼'
                          : 'e.g. Paris Getaway 🗼',
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.calendar_month_rounded, size: 18),
                          label: Text(
                            DateFormat('MMM d, yyyy').format(selectedDate),
                          ),
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2040),
                            );
                            if (picked != null) {
                              setModalState(() {
                                selectedDate = picked;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  GradientButton(
                    text: isTr ? 'Geri Sayımı Başlat ⏳' : 'Start Countdown ⏳',
                    onPressed: () {
                      if (titleController.text.trim().isEmpty) return;
                      provider.addSpecialDate(
                        titleEn: titleController.text.trim(),
                        titleTr: titleController.text.trim(),
                        date: selectedDate,
                        category: category,
                        icon: '🎉',
                      );
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
