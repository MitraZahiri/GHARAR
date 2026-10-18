import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../providers/app_state_provider.dart';
import '../../widgets/gradient_button.dart';

class AddMemoryModal extends StatefulWidget {
  const AddMemoryModal({super.key});

  @override
  State<AddMemoryModal> createState() => _AddMemoryModalState();
}

class _AddMemoryModalState extends State<AddMemoryModal> {
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  String _selectedMood = '💖';
  final List<String> _moods = ['💖', '🥰', '✨', '🕊️', '🥂', '☕', '🌟'];

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.select<AppStateProvider, bool>((p) => p.isDarkMode);
    final isTr = context.select<AppStateProvider, bool>((p) => p.isTurkish);

    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isTr ? 'Yeni Sevgi Notu / Anı Ekle' : 'Add Love Note / Memory',
              style: AppTextStyles.titleMedium(
                isDark: isDark,
              ).copyWith(fontWeight: FontWeight.w700, fontSize: 18),
            ),
            const SizedBox(height: 16),

            // Mood Selector
            Text(
              isTr ? 'Anın Hissi & Emojisi:' : 'Mood & Feeling:',
              style: AppTextStyles.labelLarge(isDark: isDark),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final m in _moods)
                    MoodPickerItem(
                      emoji: m,
                      isSelected: _selectedMood == m,
                      isDark: isDark,
                      onTap: () => setState(() => _selectedMood = m),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Title
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: isTr ? 'Anı Başlığı' : 'Memory Title',
                hintText:
                    isTr
                        ? 'Örn: Mum ışığında balkonda ilk kahvemiz...'
                        : 'e.g. First quiet coffee on the balcony...',
              ),
            ),

            const SizedBox(height: 14),

            // Reflection Notes
            TextField(
              controller: _notesController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: isTr ? 'Kalbinizden Geçenler' : 'Heartfelt Notes',
                hintText:
                    isTr
                        ? 'Bu anı unutulmaz kılan duygularınızı ve sevginizi buraya fısıldayın...'
                        : 'Write what made this moment feel unforgettable and tender...',
              ),
            ),

            const SizedBox(height: 24),

            GradientButton(
              text:
                  isTr
                      ? 'Anıyı Çift Günlüğüne Kaydet 📖'
                      : 'Save to Couple Journal 📖',
              onPressed: () {
                if (_titleController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isTr
                            ? 'Lütfen bir anı başlığı yazın.'
                            : 'Please enter a title for this memory.',
                      ),
                    ),
                  );
                  return;
                }

                context.read<AppStateProvider>().addJournalEntry(
                  title: _titleController.text.trim(),
                  notes: _notesController.text.trim(),
                  moodEmoji: _selectedMood,
                  tags: ['Personal Note', 'Shared Sanctuary'],
                );

                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.deepBurgundy,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    content: Text(
                      isTr
                          ? 'Yeni anınız sevgiyle günlüğe kaydedildi! 💖'
                          : 'Memory lovingly saved to your Couple Journal! 💖',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MoodPickerItem extends StatelessWidget {
  final String emoji;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const MoodPickerItem({
    super.key,
    required this.emoji,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? (isDark
                      ? AppColors.blushPinkDeep.withValues(alpha: 0.25)
                      : AppColors.blushPinkLight)
                  : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color:
                isSelected
                    ? (isDark
                        ? AppColors.blushPinkDeep
                        : AppColors.deepBurgundy)
                    : Colors.transparent,
          ),
        ),
        child: Text(emoji, style: const TextStyle(fontSize: 22)),
      ),
    );
  }
}
