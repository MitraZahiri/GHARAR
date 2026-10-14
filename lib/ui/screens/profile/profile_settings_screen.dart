import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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

            // Language Toggle
            GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.language_rounded, size: 22),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      isTr ? 'Uygulama Dili' : 'App Language',
                      style: AppTextStyles.titleMedium(isDark: isDark)
                          .copyWith(fontSize: 14),
                    ),
                  ),
                  DropdownButton<String>(
                    value: provider.locale.languageCode,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(
                        value: 'en',
                        child: Text('English 🇬🇧'),
                      ),
                      DropdownMenuItem(
                        value: 'tr',
                        child: Text('Türkçe 🇹🇷'),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        provider.setLocale(Locale(val));
                      }
                    },
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
}
