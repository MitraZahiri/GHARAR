import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/app_state_provider.dart';

/// Ends the connection with the partner after a confirmation. Shown only
/// while a partner is linked.
class UnlinkPartnerButton extends StatelessWidget {
  const UnlinkPartnerButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isLinked = context.select<AppStateProvider, bool>(
      (p) => p.isPartnerLinked,
    );
    if (!isLinked) return const SizedBox.shrink();
    final loc = AppLocalizations(
      context.select<AppStateProvider, Locale>((p) => p.locale),
    );

    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        onPressed: () => _confirm(context, loc),
        icon: const Icon(Icons.link_off_rounded, size: 16),
        label: Text(loc.t('unlinkBtn')),
        style: TextButton.styleFrom(
          foregroundColor: AppColors.burgundyRose,
          minimumSize: const Size.fromHeight(48),
        ),
      ),
    );
  }

  Future<void> _confirm(BuildContext context, AppLocalizations loc) async {
    final isDark = context.read<AppStateProvider>().isDarkMode;
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(
              loc.t('unlinkBtn'),
              style: AppTextStyles.titleMedium(
                isDark: isDark,
              ).copyWith(fontWeight: FontWeight.w800),
            ),
            content: Text(
              loc.t('unlinkConfirm'),
              style: AppTextStyles.bodyMedium(isDark: isDark),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text(loc.t('unlinkCancel')),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.burgundyRose,
                  foregroundColor: Colors.white,
                ),
                child: Text(loc.t('unlinkAction')),
              ),
            ],
          ),
    );
    if (confirmed != true || !context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    await context.read<AppStateProvider>().unlinkPartner();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(loc.t('unlinkDone')),
      ),
    );
  }
}
