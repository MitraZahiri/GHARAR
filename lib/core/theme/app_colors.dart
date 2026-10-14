import 'package:flutter/material.dart';

/// GHARAR romantic, sophisticated color palette
/// Curated with soft blush pink, warm cream, muted lavender, deep burgundy,
/// subtle peach accents, and warm golden highlights.
class AppColors {
  AppColors._();

  // Romantic Signature Palette
  static const Color blushPink = Color(0xFFF9D8DE);
  static const Color blushPinkLight = Color(0xFFFFF0F3);
  static const Color blushPinkDeep = Color(0xFFF09AB0);

  static const Color warmCream = Color(0xFFFFF9F5);
  static const Color warmIvory = Color(0xFFFAF3EE);
  static const Color softAlabaster = Color(0xFFF5EFEA);

  static const Color mutedLavender = Color(0xFFE8E0F0);
  static const Color lavenderAccent = Color(0xFFC7B8DF);
  static const Color lavenderDeep = Color(0xFF8E79B2);

  static const Color deepBurgundy = Color(0xFF6B1D2F);
  static const Color burgundyWine = Color(0xFF4A0E1B);
  static const Color burgundyRose = Color(0xFF8E2A40);

  static const Color subtlePeach = Color(0xFFFFD8CC);
  static const Color warmPeach = Color(0xFFFFAC91);
  static const Color coralGold = Color(0xFFE07A5F);

  static const Color champagneGold = Color(0xFFE2B774);
  static const Color softGold = Color(0xFFF4D06F);

  // Status & Connection Streaks
  static const Color streakFlame = Color(0xFFFF7043);
  static const Color streakFlameGlow = Color(0xFFFFAB91);
  static const Color successGreen = Color(0xFF4E937A);
  static const Color gentleIndigo = Color(0xFF5C6BC0);

  // Light Mode Surfaces
  static const Color lightBackground = Color(0xFFFAF4F0);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightCardElevated = Color(0xFFFFFDFC);
  static const Color lightTextPrimary = Color(0xFF2C1E23);
  static const Color lightTextSecondary = Color(0xFF755B63);
  static const Color lightTextMuted = Color(0xFFA8969D);
  static const Color lightBorder = Color(0xFFEEDCD7);

  // Dark Romantic Mode Surfaces
  static const Color darkBackground = Color(0xFF191116);
  static const Color darkCard = Color(0xFF251A22);
  static const Color darkCardElevated = Color(0xFF33232F);
  static const Color darkTextPrimary = Color(0xFFFDF6F7);
  static const Color darkTextSecondary = Color(0xFFD4BFC6);
  static const Color darkTextMuted = Color(0xFF8F7680);
  static const Color darkBorder = Color(0xFF422D3B);

  // Romantic Gradients
  static const LinearGradient romanticLove = LinearGradient(
    colors: [Color(0xFF8E2A40), Color(0xFF6B1D2F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient blushGlow = LinearGradient(
    colors: [Color(0xFFFFF0F3), Color(0xFFF9D8DE)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient sunsetGold = LinearGradient(
    colors: [Color(0xFFFFAC91), Color(0xFFE2B774)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient lavenderDream = LinearGradient(
    colors: [Color(0xFFE8E0F0), Color(0xFFD4BFC6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient intimateCardGradient = LinearGradient(
    colors: [Color(0xFFFFF9F5), Color(0xFFFFF0F3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0xFF2A1C26), Color(0xFF1E141B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
