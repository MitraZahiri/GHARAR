import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/app_state_provider.dart';
import 'glass_card.dart';

/// Settings card for choosing between the device theme, light and dark.
class ThemeModeCard extends StatelessWidget {
  const ThemeModeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.select<AppStateProvider, bool>((p) => p.isDarkMode);
    final mode = context.select<AppStateProvider, ThemeMode>(
      (p) => p.themeMode,
    );
    final loc = AppLocalizations(
      context.select<AppStateProvider, Locale>((p) => p.locale),
    );

    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                size: 22,
              ),
              const SizedBox(width: 14),
              Text(
                loc.t('themeTitle'),
                style: AppTextStyles.titleMedium(
                  isDark: isDark,
                ).copyWith(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<ThemeMode>(
              showSelectedIcon: false,
              style: SegmentedButton.styleFrom(
                selectedBackgroundColor:
                    isDark ? AppColors.blushPinkDeep : AppColors.deepBurgundy,
                selectedForegroundColor:
                    isDark ? AppColors.darkBackground : Colors.white,
              ),
              segments: [
                ButtonSegment(
                  value: ThemeMode.system,
                  icon: const Icon(Icons.brightness_auto_rounded, size: 18),
                  label: Text(loc.t('themeSystem')),
                ),
                ButtonSegment(
                  value: ThemeMode.light,
                  icon: const Icon(Icons.light_mode_rounded, size: 18),
                  label: Text(loc.t('themeLight')),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  icon: const Icon(Icons.dark_mode_rounded, size: 18),
                  label: Text(loc.t('themeDark')),
                ),
              ],
              selected: {mode},
              onSelectionChanged: (selection) {
                context.read<AppStateProvider>().setThemeMode(selection.first);
              },
            ),
          ),
        ],
      ),
    );
  }
}
