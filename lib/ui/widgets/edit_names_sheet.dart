import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/person_name.dart';
import '../../providers/app_state_provider.dart';
import 'gradient_button.dart';

/// Bottom sheet for entering both partners' real names.
class EditNamesSheet extends StatefulWidget {
  const EditNamesSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const EditNamesSheet(),
    );
  }

  @override
  State<EditNamesSheet> createState() => _EditNamesSheetState();
}

class _EditNamesSheetState extends State<EditNamesSheet> {
  late final TextEditingController _mine;
  late final TextEditingController _partner;

  @override
  void initState() {
    super.initState();
    final provider = context.read<AppStateProvider>();
    _mine = TextEditingController(text: provider.activePartner.name);
    _partner = TextEditingController(text: provider.otherPartner.name);
  }

  @override
  void dispose() {
    _mine.dispose();
    _partner.dispose();
    super.dispose();
  }

  void _save(AppLocalizations loc) {
    HapticFeedback.lightImpact();
    context.read<AppStateProvider>().renameCouple(
      myName: _mine.text,
      partnerName: _partner.text,
    );
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    if (navigator.canPop()) navigator.pop();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.deepBurgundy,
        content: Text(loc.t('editNamesSaved')),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.select<AppStateProvider, bool>((p) => p.isDarkMode);
    final loc = AppLocalizations(
      context.select<AppStateProvider, Locale>((p) => p.locale),
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        8,
        20,
        MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            loc.t('editNamesTitle'),
            style: AppTextStyles.titleMedium(
              isDark: isDark,
            ).copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 16),
          TextField(
            key: const ValueKey('my-name'),
            controller: _mine,
            maxLength: kMaxPersonNameLength,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: loc.t('editNamesMine'),
              hintText: loc.t('nameYou'),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            key: const ValueKey('partner-name'),
            controller: _partner,
            maxLength: kMaxPersonNameLength,
            textCapitalization: TextCapitalization.words,
            onSubmitted: (_) => _save(loc),
            decoration: InputDecoration(
              labelText: loc.t('editNamesPartner'),
              hintText: loc.t('nameYourSoulmate'),
            ),
          ),
          const SizedBox(height: 16),
          GradientButton(
            text: loc.t('editNamesSave'),
            gradient: AppColors.sunsetGold,
            onPressed: () => _save(loc),
          ),
        ],
      ),
    );
  }
}
