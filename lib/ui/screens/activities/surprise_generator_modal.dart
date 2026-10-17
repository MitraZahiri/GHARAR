import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../providers/app_state_provider.dart';
import '../../../services/seed_data_service.dart';
import '../../widgets/confetti_overlay.dart';
import '../../widgets/gradient_button.dart';

class SurpriseGeneratorModal extends StatefulWidget {
  const SurpriseGeneratorModal({super.key});

  @override
  State<SurpriseGeneratorModal> createState() => _SurpriseGeneratorModalState();
}

class _SurpriseGeneratorModalState extends State<SurpriseGeneratorModal> {
  int _currentSurpriseIndex = 0;
  bool _playConfetti = true;

  @override
  void initState() {
    super.initState();
    _rollNewSurprise();
  }

  void _rollNewSurprise() {
    final rand = Random();
    setState(() {
      _currentSurpriseIndex =
          rand.nextInt(SeedDataService.romanticSurpriseIdeasEn.length);
      _playConfetti = true;
    });
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) {
        setState(() {
          _playConfetti = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.select<AppStateProvider, bool>((p) => p.isDarkMode);
    final isTr = context.select<AppStateProvider, bool>((p) => p.isTurkish);

    final idea = isTr
        ? SeedDataService.romanticSurpriseIdeasTr[_currentSurpriseIndex]
        : SeedDataService.romanticSurpriseIdeasEn[_currentSurpriseIndex];

    return ConfettiOverlay(
      isPlaying: _playConfetti,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🎲', style: TextStyle(fontSize: 26)),
                  const SizedBox(width: 10),
                  Text(
                    isTr ? 'Romantik Sürpriz Çarkı' : 'Romantic Surprise Generator',
                    style: AppTextStyles.titleMedium(isDark: isDark).copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                isTr
                    ? 'Partnerinizi bugün mutlu edecek tatlı, spontane bir jest!'
                    : 'A gentle, spontaneous gesture to make your partner smile today!',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall(isDark: isDark),
              ),

              const SizedBox(height: 24),

              // Surprise Card
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: isDark
                      ? AppColors.darkCardGradient
                      : AppColors.intimateCardGradient,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark
                        ? AppColors.blushPinkDeep.withValues(alpha: 0.5)
                        : AppColors.deepBurgundy.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.deepBurgundy.withValues(alpha: 0.08),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text('💌', style: TextStyle(fontSize: 32)),
                    const SizedBox(height: 12),
                    Text(
                      idea,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.displaySmall(isDark: isDark).copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Roll Another Button
              GradientButton(
                text: isTr ? 'Yeni Bir Sürpriz Çek 🎲' : 'Roll Another Surprise 🎲',
                onPressed: _rollNewSurprise,
              ),

              const SizedBox(height: 12),

              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  isTr ? 'Bu Fikri Beğendim, Kapat' : 'I Love This Idea, Close',
                  style: AppTextStyles.bodyMedium(isDark: isDark).copyWith(
                    color: isDark
                        ? AppColors.lavenderAccent
                        : AppColors.burgundyRose,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
