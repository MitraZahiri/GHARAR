import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/partner_display_name.dart';
import '../../models/couple_model.dart';
import '../../providers/app_state_provider.dart';
import 'glass_card.dart';

/// Formats a UTC offset in minutes as `UTC+3`, `UTC-9:30` or `UTC+5:45`.
String formatUtcOffset(int minutes) {
  final sign = minutes < 0 ? '-' : '+';
  final abs = minutes.abs();
  final hours = abs ~/ 60;
  final mins = abs % 60;
  return mins == 0
      ? 'UTC$sign$hours'
      : 'UTC$sign$hours:${mins.toString().padLeft(2, '0')}';
}

/// Every whole-hour offset plus the common half/quarter-hour zones
/// (e.g. Iran +3:30, India +5:30, Nepal +5:45).
final List<int> kUtcOffsets = [
  for (var h = -12; h <= 14; h++) h * 60,
  -570,
  -210,
  210,
  270,
  330,
  345,
  390,
  525,
  570,
  630,
  765,
  825,
]..sort();

/// Home card that adapts to how far apart the couple lives:
/// a reunion countdown and partner clock for long distance, or a small
/// shared ritual when they are close by.
class DistanceModeCard extends StatelessWidget {
  const DistanceModeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.select<AppStateProvider, bool>((p) => p.isDarkMode);
    final locale = context.select<AppStateProvider, Locale>((p) => p.locale);
    final mode = context.select<AppStateProvider, DistanceMode>(
      (p) => p.distanceMode,
    );
    final loc = AppLocalizations(locale);
    final isNarrow = MediaQuery.sizeOf(context).width <= 360;

    return GlassCard(
      padding: EdgeInsets.all(isNarrow ? 14 : 18),
      gradient:
          isDark ? AppColors.darkCardGradient : AppColors.intimateCardGradient,
      borderColor:
          isDark
              ? AppColors.darkBorder
              : AppColors.heartGold.withValues(alpha: 0.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('📍', style: TextStyle(fontSize: 15)),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  loc.t('distanceTitle'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                    fontSize: 10,
                    color:
                        isDark
                            ? AppColors.blushPinkDeep
                            : AppColors.deepBurgundy,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _DistanceToggle(mode: mode, isDark: isDark, loc: loc),
          const SizedBox(height: 14),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child:
                mode == DistanceMode.longDistance
                    ? _LongDistanceView(
                      key: const ValueKey('ldr'),
                      isDark: isDark,
                      loc: loc,
                    )
                    : _TogetherView(
                      key: const ValueKey('together'),
                      isDark: isDark,
                      loc: loc,
                    ),
          ),
        ],
      ),
    );
  }
}

/// One-line distance summary for the home header ("✈ 14:32 · 12 days").
/// Tapping it opens the full [DistanceModeCard] in a bottom sheet.
class DistanceChip extends StatelessWidget {
  const DistanceChip({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.select<AppStateProvider, bool>((p) => p.isDarkMode);
    final loc = AppLocalizations(
      context.select<AppStateProvider, Locale>((p) => p.locale),
    );
    final mode = context.select<AppStateProvider, DistanceMode>(
      (p) => p.distanceMode,
    );
    final daysLeft = context.select<AppStateProvider, int?>(
      (p) => p.daysUntilNextMeeting(),
    );
    final hasOffset = context.select<AppStateProvider, bool>(
      (p) => p.partnerUtcOffsetMinutes != null,
    );
    final partnerTime = context.read<AppStateProvider>().partnerLocalTime();

    final parts = <String>[];
    if (mode == DistanceMode.longDistance) {
      if (hasOffset && partnerTime != null) {
        parts.add(DateFormat.Hm().format(partnerTime));
      }
      if (daysLeft != null) {
        parts.add(
          daysLeft == 0
              ? loc.t('ldrMeetingToday')
              : loc.format('ldrDaysLeft', {'days': '$daysLeft'}),
        );
      }
    }
    final label =
        parts.isNotEmpty
            ? parts.join(' · ')
            : loc.t(
              mode == DistanceMode.longDistance
                  ? 'distanceLong'
                  : 'distanceTogether',
            );
    final color = isDark ? AppColors.blushPinkDeep : AppColors.deepBurgundy;

    return Semantics(
      button: true,
      child: InkWell(
        key: const ValueKey('home-distance-chip'),
        borderRadius: BorderRadius.circular(20),
        onTap:
            () => showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              showDragHandle: true,
              builder:
                  (_) => const SafeArea(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: DistanceModeCard(),
                    ),
                  ),
            ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                mode == DistanceMode.longDistance
                    ? Icons.flight_takeoff_rounded
                    : Icons.home_rounded,
                size: 16,
                color: color,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall(
                    isDark: isDark,
                  ).copyWith(fontWeight: FontWeight.w700, color: color),
                ),
              ),
              Icon(Icons.expand_more_rounded, size: 16, color: color),
            ],
          ),
        ),
      ),
    );
  }
}

class _DistanceToggle extends StatelessWidget {
  final DistanceMode mode;
  final bool isDark;
  final AppLocalizations loc;

  const _DistanceToggle({
    required this.mode,
    required this.isDark,
    required this.loc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color:
            isDark
                ? AppColors.darkCardElevated
                : Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        children: [
          for (final option in DistanceMode.values)
            Expanded(
              child: _ToggleSegment(
                label:
                    option == DistanceMode.together
                        ? loc.t('distanceTogether')
                        : loc.t('distanceLong'),
                icon:
                    option == DistanceMode.together
                        ? Icons.home_rounded
                        : Icons.flight_takeoff_rounded,
                selected: option == mode,
                isDark: isDark,
                onTap: () {
                  HapticFeedback.selectionClick();
                  context.read<AppStateProvider>().setDistanceMode(option);
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _ToggleSegment extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final bool isDark;
  final VoidCallback onTap;

  const _ToggleSegment({
    required this.label,
    required this.icon,
    required this.selected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final foreground =
        selected
            ? Colors.white
            : (isDark ? AppColors.darkTextSecondary : AppColors.inkMuted);

    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          constraints: const BoxConstraints(minHeight: 48),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            gradient: selected ? AppColors.sunsetGold : null,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: foreground),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                    color: foreground,
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

class _TogetherView extends StatefulWidget {
  final bool isDark;
  final AppLocalizations loc;

  const _TogetherView({super.key, required this.isDark, required this.loc});

  @override
  State<_TogetherView> createState() => _TogetherViewState();
}

class _TogetherViewState extends State<_TogetherView> {
  static const _ritualCount = 4;
  int _ritualIndex = DateTime.now().day % _ritualCount;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final loc = widget.loc;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.t('togetherHeadline'),
          style: AppTextStyles.titleMedium(
            isDark: isDark,
          ).copyWith(fontWeight: FontWeight.w800, fontSize: 15),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color:
                isDark
                    ? AppColors.darkCardElevated
                    : AppColors.terracottaSubtle,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loc.t('togetherRitualLabel'),
                style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                  color: AppColors.champagneGold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                loc.t('togetherRitual${_ritualIndex + 1}'),
                key: const ValueKey('together-ritual'),
                style: AppTextStyles.bodyMedium(
                  isDark: isDark,
                ).copyWith(fontWeight: FontWeight.w600, height: 1.4),
              ),
            ],
          ),
        ),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: TextButton.icon(
            icon: const Icon(Icons.autorenew_rounded, size: 16),
            label: Text(loc.t('togetherNextIdea')),
            style: TextButton.styleFrom(
              foregroundColor:
                  isDark ? AppColors.blushPinkDeep : AppColors.deepBurgundy,
              minimumSize: const Size(48, 48),
            ),
            onPressed:
                () => setState(
                  () => _ritualIndex = (_ritualIndex + 1) % _ritualCount,
                ),
          ),
        ),
      ],
    );
  }
}

class _LongDistanceView extends StatefulWidget {
  final bool isDark;
  final AppLocalizations loc;

  const _LongDistanceView({super.key, required this.isDark, required this.loc});

  @override
  State<_LongDistanceView> createState() => _LongDistanceViewState();
}

class _LongDistanceViewState extends State<_LongDistanceView> {
  Timer? _clockTimer;

  @override
  void initState() {
    super.initState();
    // Keep the partner's clock current without rebuilding every second.
    _clockTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => setState(() {}),
    );
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    super.dispose();
  }

  Future<void> _pickMeetingDate() async {
    final provider = context.read<AppStateProvider>();
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: provider.nextMeetingDate ?? now.add(const Duration(days: 7)),
      firstDate: DateUtils.dateOnly(now),
      lastDate: now.add(const Duration(days: 365 * 3)),
    );
    if (picked != null) provider.setNextMeetingDate(picked);
  }

  Future<void> _pickUtcOffset() async {
    final provider = context.read<AppStateProvider>();
    final current = provider.partnerUtcOffsetMinutes;
    final picked = await showModalBottomSheet<int>(
      context: context,
      showDragHandle: true,
      builder:
          (sheetContext) => SafeArea(
            child: ListView(
              children: [
                for (final offset in kUtcOffsets)
                  ListTile(
                    title: Text(formatUtcOffset(offset)),
                    trailing: Text(
                      DateFormat.Hm().format(
                        DateTime.now().toUtc().add(Duration(minutes: offset)),
                      ),
                    ),
                    selected: offset == current,
                    onTap: () => Navigator.of(sheetContext).pop(offset),
                  ),
              ],
            ),
          ),
    );
    if (picked != null) provider.setPartnerUtcOffset(picked);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final loc = widget.loc;
    final isTr = context.select<AppStateProvider, bool>((p) => p.isTurkish);
    final partnerName = context.select<AppStateProvider, String>(
      (p) => p.otherPartner.name,
    );
    final offset = context.select<AppStateProvider, int?>(
      (p) => p.partnerUtcOffsetMinutes,
    );
    final daysLeft = context.select<AppStateProvider, int?>(
      (p) => p.daysUntilNextMeeting(),
    );
    final partnerTime = context.read<AppStateProvider>().partnerLocalTime();

    final String countdown;
    if (daysLeft == null) {
      countdown = '—';
    } else if (daysLeft == 0) {
      countdown = loc.t('ldrMeetingToday');
    } else {
      countdown = loc.format('ldrDaysLeft', {'days': '$daysLeft'});
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _InfoTile(
              isDark: isDark,
              icon: Icons.schedule_rounded,
              label: loc.format('ldrPartnerTime', {
                'name': partnerDisplayName(partnerName, isTurkish: isTr),
              }),
              value:
                  partnerTime == null
                      ? '--:--'
                      : DateFormat.Hm().format(partnerTime),
              footer:
                  offset == null
                      ? loc.t('ldrSetTimezone')
                      : formatUtcOffset(offset),
              onTap: _pickUtcOffset,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _InfoTile(
              isDark: isDark,
              icon: Icons.favorite_rounded,
              label: loc.t('ldrUntilMeeting'),
              value: countdown,
              footer: daysLeft == null ? loc.t('ldrSetMeeting') : null,
              onTap: _pickMeetingDate,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final String label;
  final String value;
  final String? footer;
  final VoidCallback onTap;

  const _InfoTile({
    required this.isDark,
    required this.icon,
    required this.label,
    required this.value,
    required this.footer,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final footerText = footer;
    return Semantics(
      button: true,
      label: '$label, $value',
      excludeSemantics: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color:
                isDark
                    ? AppColors.darkCardElevated
                    : Colors.white.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 14, color: AppColors.champagneGold),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall(
                        isDark: isDark,
                      ).copyWith(fontWeight: FontWeight.w700, fontSize: 11),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  value,
                  style: AppTextStyles.displaySmall(
                    isDark: isDark,
                  ).copyWith(fontWeight: FontWeight.w800, fontSize: 24),
                ),
              ),
              if (footerText != null) ...[
                const SizedBox(height: 6),
                Text(
                  footerText,
                  style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.champagneGold,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
