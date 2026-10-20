import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// An aesthetic QR Code presentation card designed for couple pairing in GHARAR.
///
/// Encodes the unique pairing invitation deep link and displays the formatted code.
class CoupleQrCard extends StatelessWidget {
  final String inviteCode;
  final bool isDark;
  final bool isTr;

  const CoupleQrCard({
    super.key,
    required this.inviteCode,
    required this.isDark,
    required this.isTr,
  });

  String get _deepLinkUrl => 'https://gharar.love/pair?code=$inviteCode';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardElevated : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.parchmentBorder,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isTr ? 'QR Kodu Okutun 📷' : 'Scan with Partner Phone 📷',
            style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              letterSpacing: 1.2,
              color: isDark ? AppColors.terracottaLight : AppColors.terracotta,
            ),
          ),
          const SizedBox(height: 14),

          // High-contrast white canvas for reliable QR scanning
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFE8DFC8).withValues(alpha: 0.8),
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: QrImageView(
              data: _deepLinkUrl,
              version: QrVersions.auto,
              size: 160.0,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: Color(0xFF6B1D2F), // AppColors.deepBurgundy
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.circle,
                color: Color(0xFF2B2625), // AppColors.inkCharcoal
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Code Capsule
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color:
                  isDark
                      ? AppColors.darkCard
                      : AppColors.warmParchment.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color:
                    isDark ? AppColors.darkBorder : AppColors.parchmentBorder,
                width: 1.0,
              ),
            ),
            child: Text(
              inviteCode,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 14,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.warmPeach : AppColors.deepBurgundy,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
