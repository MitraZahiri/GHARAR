import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/love_note_model.dart';
import '../../../providers/app_state_provider.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_button.dart';

/// Letters to the partner that stay sealed until a chosen day.
class TimeCapsuleScreen extends StatelessWidget {
  const TimeCapsuleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.select<AppStateProvider, bool>((p) => p.isDarkMode);
    final isTr = context.select<AppStateProvider, bool>((p) => p.isTurkish);
    final received = context.select<AppStateProvider, List<LoveNoteModel>>(
      (p) => p.timeCapsulesForActivePartner,
    );
    final sent = context.select<AppStateProvider, List<LoveNoteModel>>(
      (p) => p.timeCapsulesSentByActivePartner,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isTr ? 'Zaman Kapsülü' : 'Time Capsule',
          style: AppTextStyles.titleMedium(
            isDark: isDark,
          ).copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          TimeCapsuleComposer(isDark: isDark, isTr: isTr),
          const SizedBox(height: 24),
          TimeCapsuleSectionTitle(
            text: isTr ? 'Sana gelenler' : 'Waiting for you',
            isDark: isDark,
          ),
          if (received.isEmpty)
            TimeCapsuleEmptyHint(
              text:
                  isTr
                      ? 'Henüz sana mühürlenmiş bir kapsül yok.'
                      : 'No capsules have been sealed for you yet.',
              isDark: isDark,
            ),
          for (final capsule in received)
            TimeCapsuleCard(
              capsule: capsule,
              isMine: false,
              isDark: isDark,
              isTr: isTr,
            ),
          const SizedBox(height: 16),
          TimeCapsuleSectionTitle(
            text: isTr ? 'Senin mühürlediklerin' : 'Sealed by you',
            isDark: isDark,
          ),
          if (sent.isEmpty)
            TimeCapsuleEmptyHint(
              text:
                  isTr
                      ? 'İlk mektubunu yaz, gelecekte açılsın.'
                      : 'Write your first letter for the future.',
              isDark: isDark,
            ),
          for (final capsule in sent)
            TimeCapsuleCard(
              capsule: capsule,
              isMine: true,
              isDark: isDark,
              isTr: isTr,
            ),
        ],
      ),
    );
  }
}

/// Text field, opening-delay choice and the seal button.
class TimeCapsuleComposer extends StatefulWidget {
  final bool isDark;
  final bool isTr;

  const TimeCapsuleComposer({
    super.key,
    required this.isDark,
    required this.isTr,
  });

  @override
  State<TimeCapsuleComposer> createState() => _TimeCapsuleComposerState();
}

class _TimeCapsuleComposerState extends State<TimeCapsuleComposer> {
  static const _delaysInDays = [30, 180, 365];

  final _controller = TextEditingController();
  int _delayInDays = _delaysInDays.first;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _delayLabel(int days) {
    final isTr = widget.isTr;
    return switch (days) {
      30 => isTr ? '1 ay' : '1 month',
      180 => isTr ? '6 ay' : '6 months',
      _ => isTr ? '1 yıl' : '1 year',
    };
  }

  void _seal() {
    final provider = context.read<AppStateProvider>();
    final sealed = provider.sendTimeCapsule(
      text: _controller.text,
      opensAt: provider.now.add(Duration(days: _delayInDays)),
    );
    final isTr = widget.isTr;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          sealed
              ? (isTr
                  ? 'Kapsül mühürlendi ⏳ ${_delayLabel(_delayInDays)} sonra açılacak.'
                  : 'Capsule sealed ⏳ It opens in ${_delayLabel(_delayInDays)}.')
              : (isTr
                  ? 'Önce kapsüle bir şeyler yaz.'
                  : 'Write something in the capsule first.'),
        ),
      ),
    );
    if (sealed) _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final isTr = widget.isTr;

    return GlassCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            isTr
                ? 'Bugünden geleceğe bir mektup ⏳'
                : 'A letter from today to the future ⏳',
            style: AppTextStyles.titleMedium(
              isDark: isDark,
            ).copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            isTr
                ? 'Partnerin mektubu ancak seçtiğin gün okuyabilir.'
                : 'Your partner can only read it on the day you choose.',
            style: AppTextStyles.bodySmall(isDark: isDark),
          ),
          const SizedBox(height: 14),
          TextField(
            key: const ValueKey('time-capsule-text'),
            controller: _controller,
            minLines: 3,
            maxLines: 6,
            maxLength: 1000,
            decoration: InputDecoration(
              hintText:
                  isTr
                      ? 'Şu an neler hissediyorsun? Gelecekteki bize ne söylemek istersin?'
                      : 'How do you feel right now? What would you tell our future selves?',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isTr ? 'Ne zaman açılsın?' : 'When should it open?',
            style: AppTextStyles.bodySmall(
              isDark: isDark,
            ).copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final days in _delaysInDays)
                ChoiceChip(
                  key: ValueKey('time-capsule-delay-$days'),
                  label: Text(_delayLabel(days)),
                  selected: _delayInDays == days,
                  onSelected: (_) => setState(() => _delayInDays = days),
                ),
            ],
          ),
          const SizedBox(height: 16),
          GradientButton(
            key: const ValueKey('time-capsule-seal'),
            text: isTr ? 'Kapsülü Mühürle' : 'Seal the Capsule',
            onPressed: _seal,
          ),
        ],
      ),
    );
  }
}

/// One capsule: locked with a countdown, or open with its letter.
class TimeCapsuleCard extends StatelessWidget {
  final LoveNoteModel capsule;
  final bool isMine;
  final bool isDark;
  final bool isTr;

  const TimeCapsuleCard({
    super.key,
    required this.capsule,
    required this.isMine,
    required this.isDark,
    required this.isTr,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.read<AppStateProvider>();
    final sealed = provider.isSealed(capsule);
    final opensAt = capsule.opensAt ?? capsule.createdAt;
    final daysLeft = opensAt.difference(provider.now).inHours / 24;
    final daysText = daysLeft.ceil().clamp(1, 100000);
    final dateText = DateFormat('MMM d, yyyy').format(opensAt);
    // The sender always sees their own words; the receiver waits.
    final showText = isMine || !sealed;

    return GlassCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(sealed ? '🔒' : '💌', style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  sealed
                      ? (isTr
                          ? '$daysText gün sonra açılır'
                          : 'Opens in $daysText days')
                      : (isTr
                          ? '$dateText tarihinde açıldı'
                          : 'Opened $dateText'),
                  style: AppTextStyles.labelLarge(isDark: isDark).copyWith(
                    color:
                        isDark
                            ? AppColors.blushPinkDeep
                            : AppColors.burgundyRose,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            showText
                ? capsule.text
                : (isTr
                    ? 'Bu mektup $dateText tarihine kadar mühürlü.'
                    : 'This letter stays sealed until $dateText.'),
            style:
                showText
                    ? AppTextStyles.bodyMedium(isDark: isDark)
                    : AppTextStyles.bodySmall(
                      isDark: isDark,
                    ).copyWith(fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}

class TimeCapsuleSectionTitle extends StatelessWidget {
  final String text;
  final bool isDark;

  const TimeCapsuleSectionTitle({
    super.key,
    required this.text,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(text, style: AppTextStyles.headline(isDark: isDark)),
    );
  }
}

class TimeCapsuleEmptyHint extends StatelessWidget {
  final String text;
  final bool isDark;

  const TimeCapsuleEmptyHint({
    super.key,
    required this.text,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(text, style: AppTextStyles.bodySmall(isDark: isDark)),
    );
  }
}
