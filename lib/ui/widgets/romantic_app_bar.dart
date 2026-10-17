import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/user_model.dart';
import '../../providers/app_state_provider.dart';
import '../screens/ai_companion/ai_companion_screen.dart';

class RomanticAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showPartnerSwitcher;
  final bool showAIButton;
  final List<Widget>? actions;

  const RomanticAppBar({
    super.key,
    this.title,
    this.showPartnerSwitcher = true,
    this.showAIButton = true,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(68);

  @override
  Widget build(BuildContext context) {
    final isDark = context.select<AppStateProvider, bool>((p) => p.isDarkMode);
    final tagline = context.select<AppStateProvider, String>((p) => p.currentLanguage.tagline);

    return AppBar(
      toolbarHeight: 68,
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleSpacing: 16,
      title: Row(
        children: [
          // App Logo / Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title ?? 'GHARAR',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.displaySmall(isDark: isDark).copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    fontSize: 20,
                    color: isDark ? AppColors.blushPinkDeep : AppColors.deepBurgundy,
                  ),
                ),
                Text(
                  tagline,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
                    fontSize: 10,
                    letterSpacing: 0.5,
                    color: isDark ? AppColors.lavenderAccent : AppColors.burgundyRose,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Interactive Partner Switcher Pill
          if (showPartnerSwitcher) const PartnerSwitcherPill(),

          const SizedBox(width: 4),

          // AI Companion "Noor" Shortcut
          if (showAIButton)
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  gradient: AppColors.romanticLove,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.deepBurgundy.withValues(alpha: 0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Text('✨', style: TextStyle(fontSize: 14)),
              ),
              tooltip: 'Noor • Relationship Companion',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AICompanionScreen(),
                  ),
                );
              },
            ),

          if (actions != null) ...actions!,
        ],
      ),
    );
  }
}

/// Dedicated widget for switching active partner with granular rebuilds.
class PartnerSwitcherPill extends StatelessWidget {
  const PartnerSwitcherPill({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.select<AppStateProvider, bool>((p) => p.isDarkMode);
    final active = context.select<AppStateProvider, UserModel>((p) => p.activePartner);

    return GestureDetector(
      onTap: () {
        final provider = context.read<AppStateProvider>();
        provider.switchActivePartner();
        final newActive = provider.activePartner;
        final isTr = provider.isTurkish;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(milliseconds: 1400),
            backgroundColor: AppColors.deepBurgundy,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            content: Row(
              children: [
                Text(newActive.avatar, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isTr
                        ? 'Artık ${newActive.name} olarak görüntülüyorsunuz'
                        : 'Now viewing as ${newActive.name}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCardElevated : AppColors.blushPinkLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark
                ? AppColors.darkBorder
                : AppColors.blushPinkDeep.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(active.avatar, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 4),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 68),
              child: Text(
                active.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.deepBurgundy,
                ),
              ),
            ),
            const SizedBox(width: 3),
            Icon(
              Icons.swap_horiz_rounded,
              size: 15,
              color: isDark ? AppColors.blushPinkDeep : AppColors.burgundyRose,
            ),
          ],
        ),
      ),
    );
  }
}
