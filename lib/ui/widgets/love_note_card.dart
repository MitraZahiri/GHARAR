import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/love_note_model.dart';
import '../../models/user_model.dart';
import '../../providers/app_state_provider.dart';
import 'glass_card.dart';
import 'note_image.dart';
import 'write_love_note_modal.dart';

class LoveNoteCard extends StatelessWidget {
  const LoveNoteCard({super.key});

  String _formatNoteDate(DateTime date, bool isTr) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      final mins = difference.inMinutes;
      if (mins <= 1) return isTr ? 'Az önce' : 'Just now';
      return isTr ? '$mins dk önce' : '$mins min ago';
    } else if (difference.inHours < 24 && now.day == date.day) {
      final hourFormat = DateFormat('HH:mm');
      return isTr
          ? 'Bugün ${hourFormat.format(date)}'
          : 'Today ${hourFormat.format(date)}';
    } else {
      final format = DateFormat('d MMM, HH:mm');
      return format.format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.select<AppStateProvider, bool>((p) => p.isDarkMode);
    final isTr = context.select<AppStateProvider, bool>((p) => p.isTurkish);

    final otherPartner = context.select<AppStateProvider, UserModel>(
      (p) => p.otherPartner,
    );
    final demoTools = context.select<AppStateProvider, bool>(
      (p) => p.demoToolsEnabled,
    );

    final receivedNote = context.select<AppStateProvider, LoveNoteModel?>(
      (p) => p.latestNoteForActivePartner,
    );
    final sentNote = context.select<AppStateProvider, LoveNoteModel?>(
      (p) => p.latestNoteSentByActivePartner,
    );

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
          // Section Title & Gold Pin
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('📌', style: TextStyle(fontSize: 15)),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        isTr ? 'SEVGİ NOTU TAHTASI' : 'LOVE NOTE BOARD',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
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
              ),
              const SizedBox(width: 6),
              // Write Note Quick Action Capsule
              FittedBox(
                fit: BoxFit.scaleDown,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => WriteLoveNoteModal.show(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isDark
                              ? AppColors.darkCardElevated
                              : Colors.white.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color:
                            isDark
                                ? AppColors.darkBorder
                                : AppColors.lightBorder,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.edit_note_rounded,
                          size: 15,
                          color: AppColors.champagneGold,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isTr ? 'Yeni Not Yaz' : 'Write Note',
                          style: AppTextStyles.bodySmall(
                            isDark: isDark,
                          ).copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.champagneGold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Main Content
          if (receivedNote != null) ...[
            if (!receivedNote.isRead)
              // Unopened Wax-Sealed Surprise Envelope
              _UnopenedWaxSealLetter(
                note: receivedNote,
                isDark: isDark,
                isTr: isTr,
                onOpen: () {
                  HapticFeedback.mediumImpact();
                  context.read<AppStateProvider>().markLoveNoteAsRead(
                    receivedNote.id,
                  );
                },
              )
            else
              // Opened Aesthetic Post-It Love Note
              _OpenedPostItNote(
                note: receivedNote,
                dateText: _formatNoteDate(receivedNote.createdAt, isTr),
                isDark: isDark,
                isTr: isTr,
                onReply: () => WriteLoveNoteModal.show(context),
              ),
          ] else if (sentNote != null) ...[
            // You sent a note, waiting on partner's main page
            _PendingSentNoteView(
              note: sentNote,
              partnerName: context.read<AppStateProvider>().displayNameOf(
                otherPartner,
              ),
              isDark: isDark,
              isTr: isTr,
              onWriteNew: () => WriteLoveNoteModal.show(context),
              onSimulateReceive:
                  demoTools
                      ? () =>
                          context
                              .read<AppStateProvider>()
                              .simulatePartnerLoveNote()
                      : null,
            ),
          ] else ...[
            // Neither has sent a note yet
            _EmptyLoveNoteBoardView(
              partnerName: context.read<AppStateProvider>().displayNameOf(
                otherPartner,
              ),
              isDark: isDark,
              isTr: isTr,
              onWrite: () => WriteLoveNoteModal.show(context),
              onSimulate:
                  demoTools
                      ? () =>
                          context
                              .read<AppStateProvider>()
                              .simulatePartnerLoveNote()
                      : null,
            ),
          ],

          if (defaultTargetPlatform == TargetPlatform.android)
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton.icon(
                icon: const Icon(Icons.widgets_rounded, size: 16),
                label: Text(
                  AppLocalizations(
                    context.select<AppStateProvider, Locale>((p) => p.locale),
                  ).t('widgetAddToHome'),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.champagneGold,
                  minimumSize: const Size(48, 48),
                ),
                onPressed:
                    () =>
                        context.read<AppStateProvider>().requestPinHomeWidget(),
              ),
            ),
        ],
      ),
    );
  }
}

class _UnopenedWaxSealLetter extends StatelessWidget {
  final LoveNoteModel note;
  final bool isDark;
  final bool isTr;
  final VoidCallback onOpen;

  const _UnopenedWaxSealLetter({
    required this.note,
    required this.isDark,
    required this.isTr,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onOpen,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCardElevated : const Color(0xFFFAF5EE),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.champagneGold.withValues(alpha: 0.6),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.champagneGold.withValues(alpha: 0.2),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Red/Gold Wax Seal in Center
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF8B1E2B), Color(0xFF560D17)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
                border: Border.all(
                  color: AppColors.champagneGold.withValues(alpha: 0.6),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(note.emoji, style: const TextStyle(fontSize: 24)),
              ),
            ),
            const SizedBox(height: 12),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                isTr
                    ? '${context.read<AppStateProvider>().displayNameFor(id: note.senderId, name: note.senderName)} Sana Bir Sevgi Notu Bıraktı! 💌'
                    : '${context.read<AppStateProvider>().displayNameFor(id: note.senderId, name: note.senderName)} Left You a Love Note! 💌',
                style: AppTextStyles.titleMedium(
                  isDark: isDark,
                ).copyWith(fontWeight: FontWeight.w800, fontSize: 15),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isTr
                  ? 'Telefonun kapalıyken ana sayfana iliştirdi. Mührü açmak için dokun ✨'
                  : 'Pinned to your main page while away. Tap to break the seal ✨',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
                fontSize: 11,
                color:
                    isDark ? AppColors.lavenderAccent : AppColors.burgundyRose,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OpenedPostItNote extends StatelessWidget {
  final LoveNoteModel note;
  final String dateText;
  final bool isDark;
  final bool isTr;
  final VoidCallback onReply;

  const _OpenedPostItNote({
    required this.note,
    required this.dateText,
    required this.isDark,
    required this.isTr,
    required this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    final paper = getPaperOption(note.paperColor);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: paper.backgroundColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: paper.borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header of note: Emoji, sender, and timestamp
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(note.emoji, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isTr
                            ? '${context.read<AppStateProvider>().displayNameFor(id: note.senderId, name: note.senderName)}’den Not'
                            : 'From ${context.read<AppStateProvider>().displayNameFor(id: note.senderId, name: note.senderName)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: paper.textColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: paper.textColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  dateText,
                  style: TextStyle(
                    color: paper.textColor.withValues(alpha: 0.75),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          if (note.hasImage) ...[
            NoteImage(
              path: note.imagePath!,
              isPhoto: note.kind == LoveNoteKind.photo,
              semanticLabel: note.text.isEmpty ? note.emoji : note.text,
            ),
            if (note.text.isNotEmpty) const SizedBox(height: 10),
          ],

          // Note message text
          if (note.text.isNotEmpty)
            Text(
              note.text,
              style: TextStyle(
                color: paper.textColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 1.45,
              ),
            ),

          const SizedBox(height: 14),

          // Footer action: Reply button
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.reply_rounded, size: 16),
                label: Text(
                  isTr ? 'Cevap Notu Yaz ✍️' : 'Reply with Note ✍️',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: paper.textColor,
                  visualDensity: VisualDensity.compact,
                ),
                onPressed: onReply,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PendingSentNoteView extends StatelessWidget {
  final LoveNoteModel note;
  final String partnerName;
  final bool isDark;
  final bool isTr;
  final VoidCallback onWriteNew;
  final VoidCallback? onSimulateReceive; // demo builds only

  const _PendingSentNoteView({
    required this.note,
    required this.partnerName,
    required this.isDark,
    required this.isTr,
    required this.onWriteNew,
    this.onSimulateReceive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
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
              const Text('💌', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isTr
                      ? '$partnerName’in ana sayfasına iliştirdiğin not:'
                      : 'Your note pinned to $partnerName’s page:',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall(
                    isDark: isDark,
                  ).copyWith(fontWeight: FontWeight.w700, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (note.hasImage)
            SizedBox(
              width: 120,
              child: NoteImage(
                path: note.imagePath!,
                isPhoto: note.kind == LoveNoteKind.photo,
                semanticLabel: note.text.isEmpty ? note.emoji : note.text,
              ),
            )
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFBF0EF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '"${note.text}"',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF4A1E24),
                  fontStyle: FontStyle.italic,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    note.isRead
                        ? Icons.done_all_rounded
                        : Icons.schedule_rounded,
                    size: 14,
                    color:
                        note.isRead
                            ? AppColors.successGreen
                            : AppColors.champagneGold,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    note.isRead
                        ? (isTr ? 'Okundu ✨' : 'Read ✨')
                        : (isTr
                            ? 'Telefonunu açınca görecek'
                            : 'Waiting for unlock'),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color:
                          note.isRead
                              ? AppColors.successGreen
                              : AppColors.champagneGold,
                    ),
                  ),
                ],
              ),
              if (onSimulateReceive != null)
                OutlinedButton.icon(
                  icon: const Icon(Icons.bolt_rounded, size: 14),
                  label: Text(
                    isTr ? 'Partnerden Not Simüle Et' : 'Simulate Partner Note',
                    style: const TextStyle(fontSize: 10),
                  ),
                  style: OutlinedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                  onPressed: onSimulateReceive,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyLoveNoteBoardView extends StatelessWidget {
  final String partnerName;
  final bool isDark;
  final bool isTr;
  final VoidCallback onWrite;
  final VoidCallback? onSimulate; // demo builds only

  const _EmptyLoveNoteBoardView({
    required this.partnerName,
    required this.isDark,
    required this.isTr,
    required this.onWrite,
    this.onSimulate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
        children: [
          const Text('💌', style: TextStyle(fontSize: 26)),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              isTr
                  ? '$partnerName’in Ana Sayfasına Bir Not Bırak 📌'
                  : 'Pin a Note on $partnerName’s Main Page 📌',
              style: AppTextStyles.titleMedium(
                isDark: isDark,
              ).copyWith(fontWeight: FontWeight.w700, fontSize: 14),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isTr
                ? 'Telefonu kapalıyken bile GHARAR’ı açtığında ilk göreceği şey senin sıcak sevgi notun olsun.'
                : 'Even with their phone locked, this will greet them the moment they enter your sanctuary.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall(
              isDark: isDark,
            ).copyWith(fontSize: 11),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.push_pin_rounded, size: 15),
                label: Text(
                  isTr ? 'Sevgi Notu İliştir ✍️' : 'Pin a Love Note ✍️',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.deepBurgundy,
                  foregroundColor: Colors.white,
                ),
                onPressed: onWrite,
              ),
              if (onSimulate != null)
                OutlinedButton.icon(
                  icon: const Icon(Icons.bolt_rounded, size: 14),
                  label: Text(
                    isTr
                        ? 'Partnerden Not Simüle Et (Test)'
                        : 'Simulate Note (Demo)',
                    style: const TextStyle(fontSize: 11),
                  ),
                  onPressed: onSimulate,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
