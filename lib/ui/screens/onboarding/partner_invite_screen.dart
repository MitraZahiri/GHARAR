import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../providers/app_state_provider.dart';
import '../../widgets/concentric_soul_background.dart';
import '../../widgets/custom_primary_button.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/soul_connection_art.dart';
import '../main_navigation_shell.dart';

class PartnerInviteScreen extends StatefulWidget {
  const PartnerInviteScreen({super.key});

  @override
  State<PartnerInviteScreen> createState() => _PartnerInviteScreenState();
}

class _PartnerInviteScreenState extends State<PartnerInviteScreen> {
  final TextEditingController _partnerCodeController = TextEditingController();

  @override
  void dispose() {
    _partnerCodeController.dispose();
    super.dispose();
  }

  void _navigateToMain() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const MainNavigationShell()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.select<AppStateProvider, bool>((p) => p.isDarkMode);
    final isTr = context.select<AppStateProvider, bool>((p) => p.isTurkish);
    final inviteCode = context.select<AppStateProvider, String>(
      (p) => p.couple?.inviteCode ?? 'GHARAR-7842-LOVE',
    );

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: ConcentricSoulBackground(
        isDark: isDark,
        child: SafeArea(
          child: Column(
            children: [
              // Header Row
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'GHARAR',
                      style: AppTextStyles.displaySmall(
                        isDark: isDark,
                      ).copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2.0,
                        fontSize: 18,
                        color:
                            isDark
                                ? AppColors.blushPinkDeep
                                : AppColors.deepBurgundy,
                      ),
                    ),
                    TextButton(
                      onPressed: _navigateToMain,
                      style: TextButton.styleFrom(
                        foregroundColor:
                            isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                        textStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: Text(isTr ? 'Atla ➔' : 'Skip ➔'),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isDark
                                  ? AppColors.darkCardElevated.withValues(
                                    alpha: 0.6,
                                  )
                                  : Colors.white.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color:
                                isDark
                                    ? AppColors.darkBorder
                                    : AppColors.parchmentBorder,
                            width: 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(
                                alpha: isDark ? 0.2 : 0.04,
                              ),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const SoulConnectionArt(
                          width: 220,
                          height: 165,
                          animateGlow: true,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        isTr
                            ? 'İki Kalp, Tek Ortak Alan'
                            : 'Two Hearts, One Shared Space',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.displaySmall(
                          isDark: isDark,
                        ).copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 24,
                          letterSpacing: -0.4,
                          color:
                              isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.inkCharcoal,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isTr
                            ? 'GHARAR iki kişilik senkronize bir deneyimdir. Partnerinizi bu özel kodla davet edin veya partnerinizin kodunu girin.'
                            : 'GHARAR is a synchronized sanctuary designed exclusively for two. Invite your partner with this unique code or enter theirs.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium(
                          isDark: isDark,
                        ).copyWith(
                          fontSize: 14,
                          height: 1.45,
                          color:
                              isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Your Invite Code Card
                      InviteCodeDisplayCard(
                        inviteCode: inviteCode,
                        isDark: isDark,
                        isTr: isTr,
                      ),

                      const SizedBox(height: 22),

                      // Or Enter Partner's Code
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          isTr
                              ? 'Veya Partnerinizin Kodunu Girin'
                              : 'Or Enter Partner’s Code',
                          style: AppTextStyles.labelLarge(
                            isDark: isDark,
                          ).copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color:
                              isDark
                                  ? AppColors.darkCardElevated
                                  : Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color:
                                isDark
                                    ? AppColors.darkBorder
                                    : AppColors.parchmentBorder,
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(
                                alpha: isDark ? 0.15 : 0.03,
                              ),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          controller: _partnerCodeController,
                          textAlign: TextAlign.center,
                          textCapitalization: TextCapitalization.characters,
                          style: TextStyle(
                            fontSize: 15,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w700,
                            color:
                                isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.inkCharcoal,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: 'GHARAR-XXXX-LOVE',
                            hintStyle: TextStyle(
                              letterSpacing: 1.0,
                              fontWeight: FontWeight.w500,
                              color:
                                  isDark
                                      ? AppColors.darkTextMuted
                                      : AppColors.lightTextMuted,
                              fontSize: 13,
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.arrow_forward_rounded),
                              color:
                                  isDark
                                      ? AppColors.terracottaLight
                                      : AppColors.terracotta,
                              onPressed: () {
                                if (_partnerCodeController.text
                                    .trim()
                                    .isNotEmpty) {
                                  context.read<AppStateProvider>().linkPartner(
                                    partnerName:
                                        isTr ? 'Partneriniz' : 'Partner',
                                  );
                                  _navigateToMain();
                                }
                              },
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Proceed to Couple Space Button
                      CustomPrimaryButton(
                        text:
                            isTr
                                ? 'Çift Alanımıza Başla ✨'
                                : 'Enter Our Couple Sanctuary ✨',
                        height: 52,
                        borderRadius: 26,
                        backgroundColor:
                            isDark
                                ? AppColors.terracotta
                                : AppColors.inkCharcoal,
                        textColor: Colors.white,
                        onPressed: _navigateToMain,
                      ),

                      const SizedBox(height: 12),

                      TextButton(
                        onPressed: _navigateToMain,
                        child: Text(
                          isTr
                              ? 'Şimdilik Tek Başıma Başla'
                              : 'Explore Sanctuary Solo for Now',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color:
                                isDark
                                    ? AppColors.terracottaLight
                                    : AppColors.terracotta,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InviteCodeDisplayCard extends StatelessWidget {
  final String inviteCode;
  final bool isDark;
  final bool isTr;

  const InviteCodeDisplayCard({
    super.key,
    required this.inviteCode,
    required this.isDark,
    required this.isTr,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(22),
      borderRadius: 24,
      gradient:
          isDark ? AppColors.darkCardGradient : AppColors.intimateCardGradient,
      child: Column(
        children: [
          Text(
            isTr ? 'SİZE ÖZEL ÇİFT KODU' : 'YOUR UNIQUE COUPLE CODE',
            style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
              letterSpacing: 1.5,
              fontWeight: FontWeight.w800,
              fontSize: 12,
              color: isDark ? AppColors.blushPinkDeep : AppColors.burgundyRose,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardElevated : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color:
                    isDark ? AppColors.darkBorder : AppColors.parchmentBorder,
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: SelectableText(
                inviteCode,
                style: AppTextStyles.displaySmall(isDark: isDark).copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                  fontSize: 20,
                  color: isDark ? AppColors.warmPeach : AppColors.deepBurgundy,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              side: BorderSide(
                color:
                    isDark ? AppColors.darkBorder : AppColors.parchmentBorder,
                width: 1.2,
              ),
            ),
            icon: const Icon(Icons.copy_rounded, size: 17),
            label: Text(
              isTr ? 'Kodu Kopyala' : 'Copy Invite Code',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: inviteCode));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  content: Text(
                    isTr
                        ? 'Davet kodu kopyalandı! Partnerinize WhatsApp veya SMS ile gönderin.'
                        : 'Invite code copied! Send to your partner via WhatsApp or SMS.',
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
