import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../providers/app_state_provider.dart';
import '../../widgets/concentric_soul_background.dart';
import '../../widgets/couple_qr_card.dart';
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
  int _activeTabIndex = 0; // 0: My QR & Code, 1: Enter Partner's Code

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

  void _onLinkPartnerPressed(bool isTr) {
    final code = _partnerCodeController.text.trim();
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Text(
            isTr
                ? 'Lütfen partnerinizin davet kodunu girin.'
                : 'Please enter your partner’s invite code.',
          ),
        ),
      );
      return;
    }

    final provider = context.read<AppStateProvider>();
    provider.linkPartner(partnerName: '');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppColors.terracotta,
        content: Text(
          isTr
              ? 'Ruh Eşinizle Bağlantı Kuruldu! Masalsı Alanınız Açılıyor... ✨'
              : 'Soulmate Connected! Opening Your Sacred Sanctuary... ✨',
        ),
      ),
    );

    _navigateToMain();
  }

  void _onSimulatePartnerJoined(bool isTr) {
    final provider = context.read<AppStateProvider>();
    provider.linkPartner(partnerName: '');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppColors.terracotta,
        content: Text(
          isTr
              ? 'Ruh Eşiniz Katıldı! Ortak Alanınız Açılıyor... 🕊️✨'
              : 'Soulmate Joined! Your Shared Sanctuary is Unlocking... 🕊️✨',
        ),
      ),
    );

    _navigateToMain();
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
              // Top Bar: Brand & Sign Out Option
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
                    InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        context.read<AppStateProvider>().signOut();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isDark
                                  ? AppColors.darkCardElevated
                                  : Colors.white.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color:
                                isDark
                                    ? AppColors.darkBorder
                                    : AppColors.parchmentBorder,
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.logout_rounded,
                              size: 14,
                              color:
                                  isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isTr ? 'Çıkış' : 'Sign Out',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color:
                                    isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
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

                      const SizedBox(height: 18),

                      Text(
                        isTr
                            ? 'İki Kalp, Tek Kutsal Alan'
                            : 'Two Hearts, One Sacred Space',
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
                      const SizedBox(height: 6),
                      Text(
                        isTr
                            ? 'GHARAR iki kişilik senkronize bir deneyimdir. Partneriniz bağlanmadan ortak kutsal alan açılamaz.'
                            : 'GHARAR is synchronized for two. The sanctuary unlocks only when both souls are joined.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium(
                          isDark: isDark,
                        ).copyWith(
                          fontSize: 13,
                          height: 1.45,
                          color:
                              isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Segmented Mode Switcher (Tab 0: My Code & QR | Tab 1: Enter Partner's Code)
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color:
                              isDark
                                  ? AppColors.darkCardElevated
                                  : AppColors.parchmentBorder.withValues(
                                    alpha: 0.45,
                                  ),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color:
                                isDark
                                    ? AppColors.darkBorder
                                    : AppColors.parchmentBorder,
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap:
                                    () => setState(() => _activeTabIndex = 0),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        _activeTabIndex == 0
                                            ? (isDark
                                                ? AppColors.terracotta
                                                : Colors.white)
                                            : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow:
                                        _activeTabIndex == 0
                                            ? [
                                              BoxShadow(
                                                color: Colors.black.withValues(
                                                  alpha: isDark ? 0.2 : 0.06,
                                                ),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ]
                                            : null,
                                  ),
                                  child: Center(
                                    child: Text(
                                      isTr
                                          ? 'QR & Kodum 📱'
                                          : 'My QR & Code 📱',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color:
                                            _activeTabIndex == 0
                                                ? (_activeTabIndex == 0 &&
                                                        isDark
                                                    ? Colors.white
                                                    : AppColors.inkCharcoal)
                                                : (isDark
                                                    ? AppColors
                                                        .darkTextSecondary
                                                    : AppColors
                                                        .lightTextSecondary),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap:
                                    () => setState(() => _activeTabIndex = 1),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        _activeTabIndex == 1
                                            ? (isDark
                                                ? AppColors.terracotta
                                                : Colors.white)
                                            : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow:
                                        _activeTabIndex == 1
                                            ? [
                                              BoxShadow(
                                                color: Colors.black.withValues(
                                                  alpha: isDark ? 0.2 : 0.06,
                                                ),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ]
                                            : null,
                                  ),
                                  child: Center(
                                    child: Text(
                                      isTr
                                          ? 'Partnerimin Kodu 🔑'
                                          : 'Enter Partner’s 🔑',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color:
                                            _activeTabIndex == 1
                                                ? (_activeTabIndex == 1 &&
                                                        isDark
                                                    ? Colors.white
                                                    : AppColors.inkCharcoal)
                                                : (isDark
                                                    ? AppColors
                                                        .darkTextSecondary
                                                    : AppColors
                                                        .lightTextSecondary),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Tab 0: Show QR Code & Invite Code
                      if (_activeTabIndex == 0) ...[
                        CoupleQrCard(
                          inviteCode: inviteCode,
                          isDark: isDark,
                          isTr: isTr,
                        ),
                        const SizedBox(height: 16),
                        InviteCodeDisplayCard(
                          inviteCode: inviteCode,
                          isDark: isDark,
                          isTr: isTr,
                        ),
                        const SizedBox(height: 14),
                        Text(
                          isTr
                              ? 'Ruh eşiniz bu QR kodu okuttuğunda veya davet kodunu girdiğinde odanız ikiniz için aynı anda açılacaktır.'
                              : 'When your soulmate scans this QR code or enters the invite code, your shared sanctuary will unlock simultaneously.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color:
                                isDark
                                    ? AppColors.darkTextMuted
                                    : AppColors.lightTextMuted,
                          ),
                        ),
                      ] else ...[
                        // Tab 1: Enter Partner's Code
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            isTr
                                ? 'Partnerinizin Kodunu Girin'
                                : 'Enter Partner’s Unique Code',
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
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Link Button
                        CustomPrimaryButton(
                          text:
                              isTr
                                  ? 'Bağlan & Odayı Aç 🕊️✨'
                                  : 'Connect & Unlock Sanctuary 🕊️✨',
                          height: 52,
                          borderRadius: 26,
                          backgroundColor:
                              isDark
                                  ? AppColors.terracotta
                                  : AppColors.inkCharcoal,
                          textColor: Colors.white,
                          onPressed: () => _onLinkPartnerPressed(isTr),
                        ),
                      ],

                      const SizedBox(height: 20),

                      // Live Simulation / Test Helper (Essential for Testing without 2 phones)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isDark
                                  ? AppColors.terracotta.withValues(alpha: 0.12)
                                  : AppColors.terracotta.withValues(
                                    alpha: 0.06,
                                  ),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color:
                                isDark
                                    ? AppColors.terracotta.withValues(
                                      alpha: 0.3,
                                    )
                                    : AppColors.terracotta.withValues(
                                      alpha: 0.25,
                                    ),
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              isTr
                                  ? 'Canlı Eşleşme Simülasyonu'
                                  : 'Live Pairing Simulation',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                                color:
                                    isDark
                                        ? AppColors.terracottaLight
                                        : AppColors.terracotta,
                              ),
                            ),
                            const SizedBox(height: 8),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () => _onSimulatePartnerJoined(isTr),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        isDark
                                            ? AppColors.terracotta
                                            : AppColors.deepBurgundy,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.favorite_rounded,
                                        size: 14,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        isTr
                                            ? 'Partnerin Girişini Simüle Et 💫'
                                            : 'Simulate Partner Connection 💫',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
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
