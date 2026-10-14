import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class StreakBadge extends StatefulWidget {
  final int streakDays;
  final VoidCallback? onTap;

  const StreakBadge({
    super.key,
    required this.streakDays,
    this.onTap,
  });

  @override
  State<StreakBadge> createState() => _StreakBadgeState();
}

class _StreakBadgeState extends State<StreakBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.96, end: 1.04).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.streakFlame.withValues(alpha: isDark ? 0.25 : 0.15),
                    AppColors.coralGold.withValues(alpha: isDark ? 0.35 : 0.2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.streakFlame.withValues(alpha: 0.4),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.streakFlame.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '🔥',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${widget.streakDays}',
                    style: AppTextStyles.titleMedium(isDark: isDark).copyWith(
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.warmPeach : AppColors.deepBurgundy,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Days',
                    style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.warmPeach : AppColors.deepBurgundy,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
