import 'package:flutter/material.dart';

/// GHARAR Organic Soul & Earth Connection Palette
/// Inspired by intimate minimalist line art of two souls holding hands:
/// - Earthy Terracotta (Burnt Clay & Warm Heart)
/// - Organic Slate (Muted Umber & Contemplative Charcoal)
/// - Radiant Heart Gold (Solar Yellow Soul Bridge)
/// - Warm Parchment & Linen (Raw Canvas & Textured Sand)
class AppColors {
  AppColors._();

  // ==========================================
  // Core Earth & Soul Connection Palette
  // ==========================================
  /// Terracotta contour from left soul silhouette
  static const Color terracotta = Color(0xFFC85A32);
  static const Color terracottaDeep = Color(0xFFA33D1A);
  static const Color terracottaLight = Color(0xFFF2DDD4);
  static const Color terracottaSubtle = Color(0xFFFAF0EB);

  /// Earth slate charcoal from right soul silhouette
  static const Color earthSlate = Color(0xFF48454D);
  static const Color earthSlateDeep = Color(0xFF2E2B33);
  static const Color earthSlateLight = Color(0xFFE3DFE6);

  /// Radiant golden heart core & connecting soul bridge
  static const Color heartGold = Color(0xFFF5AC1F);
  static const Color heartGoldGlow = Color(0xFFFFCB52);

  /// Warm organic parchment & linen background
  static const Color warmParchment = Color(0xFFFAF4EB);
  static const Color parchmentSand = Color(0xFFF3ECE0);
  static const Color agedPaper = Color(0xFFE2D6C0);
  static const Color parchmentBorder = Color(0xFFE5DAC7);

  /// Deep organic ink for readable, expressive typography
  static const Color inkCharcoal = Color(0xFF252227);
  static const Color inkMuted = Color(0xFF6B656F);

  // ==========================================
  // Light Mode Surfaces (Warm Parchment)
  // ==========================================
  static const Color lightBackground = Color(0xFFFAF4EB);
  static const Color lightCard = Color(0xFFFFFDF9);
  static const Color lightTextPrimary = Color(0xFF252227);
  static const Color lightTextSecondary = Color(0xFF6B656F);
  static const Color lightTextMuted = Color(0xFF9A929E);
  static const Color lightBorder = Color(0xFFE4D8C5);

  // ==========================================
  // Dark Mode Surfaces (Deep Earth Charcoal Night)
  // ==========================================
  static const Color darkBackground = Color(0xFF1B191D);
  static const Color darkCard = Color(0xFF262329);
  static const Color darkCardElevated = Color(0xFF332F37);
  static const Color darkTextPrimary = Color(0xFFFAF4EB);
  static const Color darkTextSecondary = Color(0xFFC7BFAF);
  static const Color darkTextMuted = Color(0xFF888075);
  static const Color darkBorder = Color(0xFF403B45);

  // Status & Connection Streaks
  static const Color streakFlame = Color(0xFFC85A32);
  static const Color successGreen = Color(0xFF4C826A);

  // ==========================================
  // Backward-Compatible Aliases
  // ==========================================
  static const Color blushPink = terracottaLight;
  static const Color blushPinkLight = terracottaSubtle;
  static const Color blushPinkDeep = terracotta;

  static const Color warmCream = warmParchment;
  static const Color warmIvory = parchmentSand;

  static const Color lavenderAccent = earthSlate;
  static const Color lavenderDeep = earthSlateDeep;

  static const Color deepBurgundy = terracottaDeep;
  static const Color burgundyWine = inkCharcoal;
  static const Color burgundyRose = terracotta;

  static const Color warmPeach = Color(0xFFEAA07E);
  static const Color coralGold = heartGold;

  static const Color champagneGold = heartGold;

  // ==========================================
  // Organic Signature Gradients
  // ==========================================
  static const LinearGradient romanticLove = LinearGradient(
    colors: [terracotta, terracottaDeep],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient sunsetGold = LinearGradient(
    colors: [terracotta, heartGold],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient intimateCardGradient = LinearGradient(
    colors: [Color(0xFFFFFDF9), Color(0xFFF5EFE5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0xFF2B2730), Color(0xFF201D24)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
