import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/localization/app_language.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../providers/app_state_provider.dart';
import '../../widgets/glass_card.dart';
import 'subscription_screen.dart';

class ProfileSettingsScreen extends StatelessWidget {
  const ProfileSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppStateProvider>();
    final isDark = provider.isDarkMode;
    final isTr = provider.isTurkish;
    final loc = AppLocalizations.of(context);

    final couple = provider.couple;
    final partner1 = couple?.partner1 ?? provider.activePartner;
    final partner2 = couple?.partner2 ?? provider.otherPartner;
    final active = provider.activePartner;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isTr ? 'Çift Alanı & Ayarlar' : 'Couple Profile & Settings',
          style: AppTextStyles.titleMedium(isDark: isDark).copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Couple Profile Card
            GlassCard(
              padding: const EdgeInsets.all(22),
              gradient: isDark
                  ? AppColors.darkCardGradient
                  : AppColors.intimateCardGradient,
              child: Column(
                children: [
                  // Avatars in Heart Shape
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildAvatarBubble(partner1.avatar, partner1.name, isDark),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          '💖',
                          style: TextStyle(
                            fontSize: 24,
                            shadows: [
                              BoxShadow(
                                color: AppColors.blushPinkDeep.withValues(alpha: 0.6),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                      _buildAvatarBubble(partner2.avatar, partner2.name, isDark),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${partner1.name} & ${partner2.name}',
                    style: AppTextStyles.displaySmall(isDark: isDark).copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (couple != null)
                    Text(
                      isTr
                          ? 'Yıldönümümüz: ${DateFormat('d MMMM yyyy').format(couple.anniversaryDate)}'
                          : 'Together since ${DateFormat('MMMM d, yyyy').format(couple.anniversaryDate)}',
                      style: AppTextStyles.bodySmall(isDark: isDark),
                    ),

                  const SizedBox(height: 16),

                  // Couple Invite Code Pill
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkCardElevated
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.key_rounded,
                            size: 16, color: AppColors.champagneGold),
                        const SizedBox(width: 8),
                        Text(
                          couple?.inviteCode ?? 'GHARAR-7842-LOVE',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(ClipboardData(
                                text: couple?.inviteCode ?? 'GHARAR-7842-LOVE'));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(isTr
                                    ? 'Davet kodu kopyalandı!'
                                    : 'Invite code copied to clipboard!'),
                              ),
                            );
                          },
                          child: const Icon(Icons.copy_rounded,
                              size: 16, color: AppColors.deepBurgundy),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Active Partner Switcher (Interactive Simulation Mode)
            Text(
              isTr ? 'Aktif Partner Görünümü' : 'Active Partner Perspective',
              style: AppTextStyles.labelLarge(isDark: isDark),
            ),
            const SizedBox(height: 8),
            GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Text(active.avatar, style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isTr
                              ? 'Şu anda ${active.name} olarak bakıyorsunuz'
                              : 'Viewing as ${active.name}',
                          style: AppTextStyles.titleMedium(isDark: isDark)
                              .copyWith(fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          isTr
                              ? 'Karşılıklı cevapları test etmek için partnerinizi değiştirin.'
                              : 'Switch partner to simulate answers & test mutual reveal.',
                          style: AppTextStyles.bodySmall(isDark: isDark)
                              .copyWith(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      provider.switchActivePartner();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: const Duration(milliseconds: 1000),
                          content: Text(
                            isTr
                                ? 'Artık ${provider.activePartner.name} olarak bakıyorsunuz'
                                : 'Now viewing as ${provider.activePartner.name}',
                          ),
                        ),
                      );
                    },
                    child: Text(isTr ? 'Değiştir' : 'Switch'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Premium Banner
            GlassCard(
              gradient: isDark
                  ? const LinearGradient(
                      colors: [Color(0xFF33202C), Color(0xFF241520)],
                    )
                  : AppColors.sunsetGold,
              padding: const EdgeInsets.all(18),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SubscriptionScreen(),
                  ),
                );
              },
              child: Row(
                children: [
                  const Text('👑', style: TextStyle(fontSize: 32)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'GHARAR Premium',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isTr
                              ? 'Sınırsız sorular, Noor AI yoldaşı & özel anılar'
                              : 'Unlimited questions, Noor AI companion & memories',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded,
                      color: Colors.white, size: 14),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // General Settings
            Text(
              isTr ? 'Uygulama Tercihleri' : 'Preferences & Privacy',
              style: AppTextStyles.labelLarge(isDark: isDark),
            ),
            const SizedBox(height: 8),

            // Multi-Language Localization Selector (8 Languages & RTL)
            GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              onTap: () => _showLanguagePickerSheet(context, provider),
              child: Row(
                children: [
                  const Icon(Icons.language_rounded, size: 22),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isTr ? 'Uygulama Dili (8 Dil)' : 'App Language (8 Languages)',
                          style: AppTextStyles.titleMedium(isDark: isDark)
                              .copyWith(fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          provider.currentLanguage.tagline,
                          style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
                            fontSize: 11,
                            color: isDark ? AppColors.lavenderAccent : AppColors.burgundyRose,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkCardElevated
                          : AppColors.blushPinkLight,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.blushPinkDeep.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${provider.currentLanguage.flag} ${provider.currentLanguage.nativeName}',
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                        ),
                        if (provider.currentLanguage.isRtl) ...[
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                            decoration: BoxDecoration(
                              color: AppColors.champagneGold.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'RTL',
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                                color: AppColors.champagneGold,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_drop_down_rounded, size: 18),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Theme Toggle
            GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    size: 22,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isTr ? 'Romantik Tema Modu' : 'Romantic Theme',
                          style: AppTextStyles.titleMedium(isDark: isDark)
                              .copyWith(fontSize: 14),
                        ),
                        Text(
                          isDark
                              ? (isTr ? 'Kadife Bordo (Karanlık)' : 'Velvet Burgundy (Dark)')
                              : (isTr ? 'Krem & Pudra Pembe (Aydınlık)' : 'Cream & Blush Pink (Light)'),
                          style: AppTextStyles.bodySmall(isDark: isDark)
                              .copyWith(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  Switch.adaptive(
                    value: isDark,
                    activeColor: AppColors.blushPinkDeep,
                    onChanged: (val) {
                      provider.toggleTheme();
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Export Memories
            GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              onTap: () {
                _exportMemories(context, provider, isTr);
              },
              child: Row(
                children: [
                  const Icon(Icons.download_rounded, size: 22),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isTr ? 'Çift Anılarını Dışa Aktar' : 'Export Couple Memories',
                          style: AppTextStyles.titleMedium(isDark: isDark)
                              .copyWith(fontSize: 14),
                        ),
                        Text(
                          isTr
                              ? 'Paylaşılan cevapları ve günlüğü metin olarak kopyalayın'
                              : 'Copy shared reflections and journal to clipboard',
                          style: AppTextStyles.bodySmall(isDark: isDark)
                              .copyWith(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.copy_all_rounded,
                      size: 18, color: AppColors.lightTextMuted),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Account & Security / Connected Profile
            Text(
              loc?.translate('authAccountInfo') ?? (isTr ? 'Giriş & Güvenlik' : 'Account & Security'),
              style: AppTextStyles.labelLarge(isDark: isDark).copyWith(
                fontWeight: FontWeight.w700,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextMuted,
              ),
            ),
            const SizedBox(height: 8),
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkCardElevated
                              : AppColors.blushPinkLight,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            provider.authProvider == 'apple' ? '' : '✉️',
                            style: TextStyle(
                              fontSize: provider.authProvider == 'apple' ? 22 : 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              provider.authProvider == 'apple'
                                  ? (isTr ? 'Apple Kimliği ile Bağlı' : 'Apple ID Connected')
                                  : (isTr ? 'E-posta ile Bağlı' : 'Email Connected'),
                              style: AppTextStyles.labelLarge(isDark: isDark).copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              (provider.userEmail != null && provider.userEmail!.isNotEmpty)
                                  ? provider.userEmail!
                                  : (provider.authProvider == 'apple'
                                      ? 'mitra@privaterelay.appleid.com'
                                      : 'mitra@gharar.love'),
                              style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
                                fontSize: 12,
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: provider.authProvider == 'apple'
                              ? (isDark ? Colors.white : Colors.black)
                              : AppColors.blushPinkDeep.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          provider.authProvider == 'apple'
                              ? ' Apple'
                              : (provider.authProvider == 'email'
                                  ? 'Email'
                                  : 'Demo'),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: provider.authProvider == 'apple'
                                ? (isDark ? Colors.black : Colors.white)
                                : (isDark
                                    ? AppColors.blushPinkDeep
                                    : AppColors.deepBurgundy),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Divider(
                    height: 1,
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _showSignOutDialog(context, provider),
                      icon: const Icon(Icons.logout_rounded, size: 16),
                      label: Text(
                        loc?.translate('signOutBtn') ?? (isTr ? 'Çıkış Yap' : 'Sign Out'),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.burgundyRose,
                        side: BorderSide(
                          color: AppColors.burgundyRose.withValues(alpha: 0.4),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Danger & Reset Section
            Center(
              child: TextButton.icon(
                icon: const Icon(Icons.restart_alt_rounded, size: 18),
                label: Text(
                  isTr
                      ? 'Demo Çift Verilerini Yeniden Yükle'
                      : 'Reset to Sample Couple (Mitra & Deniz)',
                ),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.burgundyRose,
                ),
                onPressed: () {
                  provider.resetToDemo();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isTr
                          ? 'Demo çift verileri başarıyla sıfırlandı!'
                          : 'Sample couple data refreshed!'),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarBubble(String avatar, String name, bool isDark) {
    return Column(
      children: [
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCardElevated : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark ? AppColors.blushPinkDeep : AppColors.deepBurgundy,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(avatar, style: const TextStyle(fontSize: 28)),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          name,
          style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  void _exportMemories(
      BuildContext context, AppStateProvider provider, bool isTr) {
    final buffer = StringBuffer();
    buffer.writeln('=== GHARAR COUPLE JOURNAL & MEMORIES ===');
    buffer.writeln(
        'Couple: ${provider.couple?.partnerNames ?? "Mitra & Deniz"}');
    buffer.writeln('Date: ${DateTime.now()}\n');

    buffer.writeln('--- JOURNAL ENTRIES ---');
    for (final j in provider.journalEntries) {
      buffer.writeln('[${j.date.toIso8601String()}] ${j.title} (${j.moodEmoji})');
      buffer.writeln('Author: ${j.authorName}');
      buffer.writeln('${j.notes}\n');
    }

    buffer.writeln('--- COMPLETED ACTIVITIES ---');
    for (final a in provider.activities.where((item) => item.isCompleted)) {
      buffer.writeln('• ${a.title(isTr)} (${a.category(isTr)})');
    }

    Clipboard.setData(ClipboardData(text: buffer.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.successGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Text(
          isTr
              ? 'Tüm çift anılarınız ve günlüğünüz panoya kopyalandı! 📋'
              : 'All memories and journal copied to clipboard! 📋',
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context, AppStateProvider provider) {
    final isDark = provider.isDarkMode;
    final loc = AppLocalizations.of(context);
    final isTr = provider.isTurkish;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkCardElevated : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Text('🔒', style: TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Text(
              loc?.translate('signOutBtn') ?? (isTr ? 'Çıkış Yap' : 'Sign Out'),
              style: AppTextStyles.titleMedium(isDark: isDark).copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        content: Text(
          loc?.translate('signOutConfirm') ??
              (isTr
                  ? 'Oturumunuzu kapatmak istediğinize emin misiniz? Çift alanınıza tekrar girmek için Apple ID veya e-postanızla giriş yapabilirsiniz.'
                  : 'Are you sure you want to sign out? You can sign back in anytime with your Apple ID or email.'),
          style: AppTextStyles.bodyMedium(isDark: isDark),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              loc?.translate('cancel') ?? (isTr ? 'İptal' : 'Cancel'),
              style: TextStyle(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextMuted,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              provider.signOut();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.burgundyRose,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(loc?.translate('signOutBtn') ?? (isTr ? 'Çıkış Yap' : 'Sign Out')),
          ),
        ],
      ),
    );
  }

  void _showLanguagePickerSheet(
      BuildContext context, AppStateProvider provider) {
    final isDark = provider.isDarkMode;
    final currentLang = provider.currentLanguage;
    final isTr = provider.isTurkish;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(ctx).size.height * 0.78,
          ),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCardElevated : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Text('🌍', style: TextStyle(fontSize: 26)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isTr ? 'Uygulama Dili Seçin' : 'Choose App Language',
                            style: AppTextStyles.titleMedium(isDark: isDark).copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            isTr
                                ? 'Anında canlı dil ve yazı yönü değişimi (LTR & RTL)'
                                : 'Live instant language and script direction switching',
                            style: AppTextStyles.bodySmall(isDark: isDark),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Divider(
                height: 1,
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: AppLanguage.supportedLanguages.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (ctx, index) {
                    final lang = AppLanguage.supportedLanguages[index];
                    final isSelected = lang.code == currentLang.code;

                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        provider.setLanguageCode(lang.code);
                        Navigator.of(ctx).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isDark
                                  ? AppColors.blushPinkDeep
                                      .withValues(alpha: 0.22)
                                  : AppColors.blushPinkLight)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? (isDark
                                    ? AppColors.blushPinkDeep
                                    : AppColors.deepBurgundy)
                                : (isDark
                                    ? AppColors.darkBorder
                                        .withValues(alpha: 0.5)
                                    : AppColors.lightBorder),
                            width: isSelected ? 1.8 : 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(lang.flag,
                                style: const TextStyle(fontSize: 28)),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        lang.nativeName,
                                        style: AppTextStyles.titleMedium(
                                                isDark: isDark)
                                            .copyWith(
                                          fontWeight: isSelected
                                              ? FontWeight.w800
                                              : FontWeight.w600,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '(${lang.name})',
                                        style: AppTextStyles.bodySmall(
                                                isDark: isDark)
                                            .copyWith(
                                          fontSize: 12,
                                          color: isDark
                                              ? AppColors.darkTextSecondary
                                              : AppColors.lightTextMuted,
                                        ),
                                      ),
                                      if (lang.isRtl) ...[
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppColors.champagneGold
                                                .withValues(alpha: 0.2),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: const Text(
                                            'RTL',
                                            style: TextStyle(
                                              fontSize: 9,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.champagneGold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    lang.tagline,
                                    style: AppTextStyles.bodySmall(
                                            isDark: isDark)
                                        .copyWith(
                                      fontSize: 11,
                                      fontStyle: FontStyle.italic,
                                      color: isDark
                                          ? AppColors.lavenderAccent
                                          : AppColors.burgundyRose,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_circle_rounded,
                                color: isDark
                                    ? AppColors.blushPinkDeep
                                    : AppColors.deepBurgundy,
                                size: 22,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
