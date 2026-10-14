import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../providers/app_state_provider.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_button.dart';
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

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppStateProvider>();
    final isDark = provider.isDarkMode;
    final isTr = provider.isTurkish;

    final inviteCode = provider.couple?.inviteCode ?? 'GHARAR-7842-LOVE';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isTr ? 'Partnerinizi Bağlayın' : 'Link Your Partner',
          style: AppTextStyles.titleMedium(isDark: isDark).copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Romantic Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: AppColors.romanticLove,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.deepBurgundy.withValues(alpha: 0.3),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Center(
                child: Text('💌', style: TextStyle(fontSize: 38)),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              isTr ? 'İki Kalp, Tek Ortak Alan' : 'Two Hearts, One Shared Space',
              textAlign: TextAlign.center,
              style: AppTextStyles.displaySmall(isDark: isDark).copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isTr
                  ? 'GHARAR iki kişilik senkronize bir deneyimdir. Partnerinizi bu özel kodla davet edin veya partnerinizin kodunu girin.'
                  : 'GHARAR is a synchronized sanctuary designed exclusively for two. Invite your partner with this unique code or enter theirs.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium(isDark: isDark),
            ),

            const SizedBox(height: 28),

            // Your Invite Code Card
            GlassCard(
              padding: const EdgeInsets.all(22),
              gradient: isDark
                  ? AppColors.darkCardGradient
                  : AppColors.intimateCardGradient,
              child: Column(
                children: [
                  Text(
                    isTr ? 'SİZE ÖZEL ÇİFT KODU' : 'YOUR UNIQUE COUPLE CODE',
                    style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.blushPinkDeep
                          : AppColors.burgundyRose,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkCardElevated
                          : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder,
                      ),
                    ),
                    child: SelectableText(
                      inviteCode,
                      style: AppTextStyles.displaySmall(isDark: isDark).copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2.0,
                        color: isDark
                            ? AppColors.warmPeach
                            : AppColors.deepBurgundy,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.copy_rounded, size: 18),
                    label: Text(isTr ? 'Kodu Kopyala' : 'Copy Invite Code'),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: inviteCode));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(isTr
                              ? 'Davet kodu kopyalandı! Partnerinize WhatsApp veya SMS ile gönderin.'
                              : 'Invite code copied! Send to your partner via WhatsApp or SMS.'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Or Enter Partner's Code
            Text(
              isTr ? 'Veya Partnerinizin Kodunu Girin' : 'Or Enter Partner’s Code',
              style: AppTextStyles.labelLarge(isDark: isDark),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _partnerCodeController,
              textAlign: TextAlign.center,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                hintText: 'GHARAR-XXXX-LOVE',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward_rounded),
                  onPressed: () {
                    if (_partnerCodeController.text.trim().isNotEmpty) {
                      provider.linkPartner(partnerName: 'Deniz');
                      _navigateToMain();
                    }
                  },
                ),
              ),
            ),

            const SizedBox(height: 28),

            // Proceed to Couple Space Button
            GradientButton(
              text: isTr
                  ? 'Çift Alanımıza Başla ✨'
                  : 'Enter Our Couple Sanctuary ✨',
              onPressed: () {
                // Seed partner link so full interactive experience is immediately alive
                if (provider.couple?.partner2 == null) {
                  provider.linkPartner(partnerName: 'Deniz');
                }
                _navigateToMain();
              },
            ),

            const SizedBox(height: 14),

            // Partner Simulator Quick Option
            TextButton.icon(
              icon: const Icon(Icons.bolt_rounded, size: 18),
              label: Text(
                isTr
                    ? 'Demo Modu: Mitra & Deniz ile Hemen Başla'
                    : 'Demo Mode: Explore with Mitra & Deniz',
              ),
              onPressed: () {
                provider.seedDemoCouple();
                _navigateToMain();
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _navigateToMain() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const MainNavigationShell()),
      (route) => false,
    );
  }
}
