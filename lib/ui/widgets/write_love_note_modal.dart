import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/love_note_model.dart';
import '../../models/user_model.dart';
import '../../providers/app_state_provider.dart';
import 'gradient_button.dart';
import 'handwriting_canvas.dart';
import 'note_image.dart';

class NotePaperOption {
  final String key;
  final String nameTr;
  final String nameEn;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;

  const NotePaperOption({
    required this.key,
    required this.nameTr,
    required this.nameEn,
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
  });

  String name(bool isTr) => isTr ? nameTr : nameEn;
}

const List<NotePaperOption> kNotePaperOptions = [
  NotePaperOption(
    key: 'rose',
    nameTr: 'Gül Kurusu',
    nameEn: 'Desert Rose',
    backgroundColor: Color(0xFFFBF0EF),
    textColor: Color(0xFF4A1E24),
    borderColor: Color(0xFFE8C5C8),
  ),
  NotePaperOption(
    key: 'parchment',
    nameTr: 'Sıcak Parşömen',
    nameEn: 'Warm Ivory',
    backgroundColor: Color(0xFFFAF6EE),
    textColor: Color(0xFF382E1E),
    borderColor: Color(0xFFE2D6BE),
  ),
  NotePaperOption(
    key: 'lavender',
    nameTr: 'Lavanta Rüyası',
    nameEn: 'Lavender Mist',
    backgroundColor: Color(0xFFF5F0FA),
    textColor: Color(0xFF302046),
    borderColor: Color(0xFFD7C8E8),
  ),
  NotePaperOption(
    key: 'midnight',
    nameTr: 'Gece Yıldızı',
    nameEn: 'Midnight Glow',
    backgroundColor: Color(0xFF1E1E28),
    textColor: Color(0xFFF2E6D8),
    borderColor: Color(0xFF4A4058),
  ),
];

NotePaperOption getPaperOption(String? key) {
  return kNotePaperOptions.where((p) => p.key == key).firstOrNull ??
      kNotePaperOptions.first;
}

class WriteLoveNoteModal extends StatefulWidget {
  final bool isDark;
  final bool isTr;

  const WriteLoveNoteModal({
    super.key,
    required this.isDark,
    required this.isTr,
  });

  static Future<void> show(BuildContext context) {
    final isDark = context.read<AppStateProvider>().isDarkMode;
    final isTr = context.read<AppStateProvider>().isTurkish;

    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => WriteLoveNoteModal(isDark: isDark, isTr: isTr),
    );
  }

  @override
  State<WriteLoveNoteModal> createState() => _WriteLoveNoteModalState();
}

class _WriteLoveNoteModalState extends State<WriteLoveNoteModal> {
  final TextEditingController _controller = TextEditingController();
  final HandwritingController _ink = HandwritingController();
  String _selectedPaperKey = 'rose';
  String _selectedEmoji = '💌';
  LoveNoteKind _mode = LoveNoteKind.text;
  int _inkIndex = 0;
  Size _canvasSize = const Size(320, 220);
  String? _photoPath;
  bool _isSending = false;

  final List<String> _emojis = ['💌', '💖', '☕', '☀️', '🫂', '🕊️', '🍰', '✨'];

  final List<String> _quickPromptsTr = [
    'Günaydın birtanem, telefonunu açtığında bu notla uyan ☀️💖',
    'Bugün toplantın harika geçecek, aklım kalbim seninle! ☕',
    'Akşam sana sarılmak için sabırsızlanıyorum 🫂',
    'Seni her geçen gün daha çok seviyorum 🕊️✨',
  ];

  final List<String> _quickPromptsEn = [
    'Good morning my love, wanted you to wake up to this note ☀️💖',
    'Your meetings will go great today, my heart is with you! ☕',
    'Can’t wait to hold you tight tonight 🫂',
    'I fall in love with you more every single day 🕊️✨',
  ];

  @override
  void dispose() {
    _controller.dispose();
    _ink.dispose();
    super.dispose();
  }

  AppLocalizations get _loc =>
      AppLocalizations(context.read<AppStateProvider>().locale);

  List<Color> _inkPalette(NotePaperOption paper) => [
    paper.textColor,
    AppColors.terracotta,
    AppColors.earthSlate,
  ];

  void _selectPaper(String key) {
    setState(() => _selectedPaperKey = key);
    _ink.inkColor = _inkPalette(getPaperOption(key))[_inkIndex];
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Text(text),
      ),
    );
  }

  Future<void> _pickPhoto(ImageSource source) async {
    try {
      final file = await ImagePicker().pickImage(
        source: source,
        maxWidth: 1600,
        imageQuality: 85,
      );
      if (file != null && mounted) setState(() => _photoPath = file.path);
    } on PlatformException {
      if (mounted) _showMessage(_loc.t('photoPickError'));
    }
  }

  Future<void> _onSend(UserModel partner) async {
    if (_mode == LoveNoteKind.text) {
      _onSaveNote(partner);
      return;
    }
    final loc = _loc;
    final provider = context.read<AppStateProvider>();
    final paper = getPaperOption(_selectedPaperKey);
    final photoPath = _photoPath;
    if ((_mode == LoveNoteKind.drawing && _ink.isEmpty) ||
        (_mode == LoveNoteKind.photo && photoPath == null)) {
      _showMessage(loc.t('visualNoteEmpty'));
      return;
    }

    setState(() => _isSending = true);
    final posted = await provider.postVisualNote(
      kind: _mode,
      imageBytes:
          _mode == LoveNoteKind.drawing
              ? await _ink.toPngBytes(
                _canvasSize,
                background: paper.backgroundColor,
              )
              : null,
      sourceImagePath: _mode == LoveNoteKind.photo ? photoPath : null,
      caption: _controller.text,
      paperColor: _selectedPaperKey,
      emoji: _selectedEmoji,
    );
    if (!mounted) return;
    if (!posted) {
      setState(() => _isSending = false);
      _showMessage(loc.t('visualNoteSaveError'));
      return;
    }

    HapticFeedback.lightImpact();
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.deepBurgundy,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Text(
          loc.format('visualNoteSent', {
            'name': context.read<AppStateProvider>().displayNameOf(partner),
          }),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _onSaveNote(UserModel partner) {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Text(
            widget.isTr
                ? 'Lütfen önce partnerinize sevgi notunuzu yazın.'
                : 'Please write a loving note for your partner first.',
          ),
        ),
      );
      return;
    }

    HapticFeedback.lightImpact();
    context.read<AppStateProvider>().postLoveNote(
      text: text,
      paperColor: _selectedPaperKey,
      emoji: _selectedEmoji,
    );

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.deepBurgundy,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Row(
          children: [
            Text(_selectedEmoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.isTr
                    ? '${context.read<AppStateProvider>().displayNameOf(partner)}’in ana sayfasına not iliştirildi! Telefonunu açtığında görecek 📌✨'
                    : 'Note pinned to ${context.read<AppStateProvider>().displayNameOf(partner)}’s main page! They’ll see it when unlocking 📌✨',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final partner = context.select<AppStateProvider, UserModel>(
      (p) => p.otherPartner,
    );
    final selectedPaper = getPaperOption(_selectedPaperKey);
    final prompts = widget.isTr ? _quickPromptsTr : _quickPromptsEn;
    final loc = AppLocalizations(
      context.select<AppStateProvider, Locale>((p) => p.locale),
    );

    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        14,
        20,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.darkCard : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(
          top: BorderSide(
            color: widget.isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Header Title
            Row(
              children: [
                const Text('📌', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.isTr
                            ? '${context.read<AppStateProvider>().displayNameOf(partner)}’in Ana Sayfasına Not Bırak'
                            : 'Pin a Note on ${context.read<AppStateProvider>().displayNameOf(partner)}’s Main Page',
                        style: AppTextStyles.titleMedium(
                          isDark: widget.isDark,
                        ).copyWith(fontWeight: FontWeight.w800),
                      ),
                      Text(
                        widget.isTr
                            ? 'Telefonu kapalıyken bile açtığında ilk göreceği sevgi mektubunuz.'
                            : 'The first thing they see when they unlock their phone & open GHARAR.',
                        style: AppTextStyles.bodySmall(
                          isDark: widget.isDark,
                        ).copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Drawings and photos are files on the phone; browsers get text.
            if (!kIsWeb) ...[
              _NoteModeSelector(
                mode: _mode,
                isDark: widget.isDark,
                loc: loc,
                onChanged: (mode) => setState(() => _mode = mode),
              ),

              const SizedBox(height: 12),
            ],

            // Interactive Note Canvas Preview
            if (_mode == LoveNoteKind.text)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: selectedPaper.backgroundColor,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: selectedPaper.borderColor,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _selectedEmoji,
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              widget.isTr
                                  ? 'Senden ${context.read<AppStateProvider>().displayNameOf(partner)}’e Not'
                                  : 'From You to ${context.read<AppStateProvider>().displayNameOf(partner)}',
                              style: TextStyle(
                                color: selectedPaper.textColor.withValues(
                                  alpha: 0.7,
                                ),
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const Icon(
                          Icons.push_pin_rounded,
                          size: 16,
                          color: AppColors.champagneGold,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _controller,
                      maxLines: 4,
                      maxLength: 240,
                      style: TextStyle(
                        color: selectedPaper.textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        counterStyle: TextStyle(
                          color: selectedPaper.textColor.withValues(alpha: 0.6),
                          fontSize: 10,
                        ),
                        hintText:
                            widget.isTr
                                ? 'Gününün güzel geçmesi için sıcacık bir şeyler yaz...'
                                : 'Write something heartfelt to make them smile today...',
                        hintStyle: TextStyle(
                          color: selectedPaper.textColor.withValues(
                            alpha: 0.45,
                          ),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else ...[
              if (_mode == LoveNoteKind.drawing)
                _DrawingPad(
                  controller: _ink,
                  paper: selectedPaper,
                  palette: _inkPalette(selectedPaper),
                  inkIndex: _inkIndex,
                  loc: loc,
                  onInkSelected: (index) {
                    setState(() => _inkIndex = index);
                    _ink.inkColor = _inkPalette(selectedPaper)[index];
                  },
                  onSizeChanged: (size) => _canvasSize = size,
                )
              else
                _PhotoPad(
                  photoPath: _photoPath,
                  paper: selectedPaper,
                  isDark: widget.isDark,
                  loc: loc,
                  onPick: _pickPhoto,
                ),
              const SizedBox(height: 10),
              TextField(
                controller: _controller,
                maxLength: 120,
                decoration: InputDecoration(
                  hintText: loc.t('photoCaptionHint'),
                  isDense: true,
                ),
              ),
            ],

            const SizedBox(height: 12),

            // Paper Style Selector
            Text(
              widget.isTr ? 'Kağıt Teması:' : 'Paper Mood Style:',
              style: AppTextStyles.bodySmall(
                isDark: widget.isDark,
              ).copyWith(fontWeight: FontWeight.w700, fontSize: 11),
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: kNotePaperOptions.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (ctx, idx) {
                  final paper = kNotePaperOptions[idx];
                  final isSelected = _selectedPaperKey == paper.key;

                  return InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => _selectPaper(paper.key),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: paper.backgroundColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color:
                              isSelected
                                  ? AppColors.terracotta
                                  : paper.borderColor,
                          width: isSelected ? 2.0 : 1.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          if (isSelected) ...[
                            const Icon(
                              Icons.check_rounded,
                              size: 14,
                              color: AppColors.terracotta,
                            ),
                            const SizedBox(width: 4),
                          ],
                          Text(
                            paper.name(widget.isTr),
                            style: TextStyle(
                              color: paper.textColor,
                              fontSize: 11,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.w800
                                      : FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // Sticker / Emoji Selector
            Text(
              widget.isTr ? 'Zarf Emojisi:' : 'Envelope Sticker:',
              style: AppTextStyles.bodySmall(
                isDark: widget.isDark,
              ).copyWith(fontWeight: FontWeight.w700, fontSize: 11),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                for (final emoji in _emojis)
                  InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => setState(() => _selectedEmoji = emoji),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color:
                            _selectedEmoji == emoji
                                ? AppColors.terracotta.withValues(alpha: 0.15)
                                : (widget.isDark
                                    ? AppColors.darkCardElevated
                                    : AppColors.lightBackground),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color:
                              _selectedEmoji == emoji
                                  ? AppColors.terracotta
                                  : (widget.isDark
                                      ? AppColors.darkBorder
                                      : AppColors.lightBorder),
                        ),
                      ),
                      child: Text(emoji, style: const TextStyle(fontSize: 18)),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 14),

            // Quick Prompts Chips
            Text(
              widget.isTr ? 'İlham Verici Cümleler:' : 'Sweet Ideas:',
              style: AppTextStyles.bodySmall(
                isDark: widget.isDark,
              ).copyWith(fontWeight: FontWeight.w700, fontSize: 11),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final prompt in prompts)
                  ActionChip(
                    label: Text(prompt, style: const TextStyle(fontSize: 11)),
                    backgroundColor:
                        widget.isDark
                            ? AppColors.darkCardElevated
                            : AppColors.lightBackground,
                    onPressed: () {
                      _controller.text = prompt;
                      setState(() {});
                    },
                  ),
              ],
            ),

            const SizedBox(height: 18),

            // Submit Button
            GradientButton(
              text:
                  _mode != LoveNoteKind.text
                      ? loc.t('visualNoteSend')
                      : widget.isTr
                      ? 'Ana Sayfasına İliştir 📌 (Açtığında Görsün)'
                      : 'Pin to Main Page 📌 (Will see upon unlock)',
              gradient: AppColors.sunsetGold,
              isLoading: _isSending,
              onPressed: _isSending ? null : () => _onSend(partner),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoteModeSelector extends StatelessWidget {
  final LoveNoteKind mode;
  final bool isDark;
  final AppLocalizations loc;
  final ValueChanged<LoveNoteKind> onChanged;

  const _NoteModeSelector({
    required this.mode,
    required this.isDark,
    required this.loc,
    required this.onChanged,
  });

  static const _icons = {
    LoveNoteKind.text: Icons.notes_rounded,
    LoveNoteKind.drawing: Icons.gesture_rounded,
    LoveNoteKind.photo: Icons.photo_camera_rounded,
  };

  static const _labelKeys = {
    LoveNoteKind.text: 'noteModeText',
    LoveNoteKind.drawing: 'noteModeDraw',
    LoveNoteKind.photo: 'noteModePhoto',
  };

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final kind in LoveNoteKind.values) ...[
          if (kind != LoveNoteKind.values.first) const SizedBox(width: 8),
          Expanded(
            child: Semantics(
              button: true,
              selected: kind == mode,
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  HapticFeedback.selectionClick();
                  onChanged(kind);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  constraints: const BoxConstraints(minHeight: 48),
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    gradient: kind == mode ? AppColors.sunsetGold : null,
                    color:
                        kind == mode
                            ? null
                            : (isDark
                                ? AppColors.darkCardElevated
                                : AppColors.lightBackground),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color:
                          kind == mode
                              ? Colors.transparent
                              : (isDark
                                  ? AppColors.darkBorder
                                  : AppColors.lightBorder),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _icons[kind],
                        size: 16,
                        color:
                            kind == mode
                                ? Colors.white
                                : AppColors.champagneGold,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          loc.t(_labelKeys[kind]!),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodySmall(
                            isDark: isDark,
                          ).copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                            color: kind == mode ? Colors.white : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _DrawingPad extends StatelessWidget {
  final HandwritingController controller;
  final NotePaperOption paper;
  final List<Color> palette;
  final int inkIndex;
  final AppLocalizations loc;
  final ValueChanged<int> onInkSelected;
  final ValueChanged<Size> onSizeChanged;

  const _DrawingPad({
    required this.controller,
    required this.paper,
    required this.palette,
    required this.inkIndex,
    required this.loc,
    required this.onInkSelected,
    required this.onSizeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: paper.backgroundColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: paper.borderColor, width: 1.5),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 220,
            child: LayoutBuilder(
              builder: (context, constraints) {
                onSizeChanged(constraints.biggest);
                return Stack(
                  children: [
                    Positioned.fill(
                      child: ListenableBuilder(
                        listenable: controller,
                        builder:
                            (context, _) =>
                                controller.isEmpty
                                    ? Center(
                                      child: Text(
                                        loc.t('drawHint'),
                                        style: TextStyle(
                                          color: paper.textColor.withValues(
                                            alpha: 0.4,
                                          ),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    )
                                    : const SizedBox.shrink(),
                      ),
                    ),
                    Positioned.fill(
                      child: HandwritingCanvas(
                        controller: controller,
                        semanticLabel: loc.t('drawHint'),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Divider(height: 1, color: paper.borderColor),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              children: [
                for (var i = 0; i < palette.length; i++)
                  Semantics(
                    button: true,
                    selected: i == inkIndex,
                    child: InkResponse(
                      radius: 24,
                      onTap: () => onInkSelected(i),
                      child: SizedBox(
                        width: 44,
                        height: 48,
                        child: Center(
                          child: Container(
                            width: i == inkIndex ? 24 : 18,
                            height: i == inkIndex ? 24 : 18,
                            decoration: BoxDecoration(
                              color: palette[i],
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.champagneGold,
                                width: i == inkIndex ? 2 : 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                const Spacer(),
                IconButton(
                  tooltip: loc.t('drawUndo'),
                  icon: Icon(Icons.undo_rounded, color: paper.textColor),
                  onPressed: controller.undo,
                ),
                IconButton(
                  tooltip: loc.t('drawClear'),
                  icon: Icon(
                    Icons.delete_sweep_rounded,
                    color: paper.textColor,
                  ),
                  onPressed: controller.clear,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoPad extends StatelessWidget {
  final String? photoPath;
  final NotePaperOption paper;
  final bool isDark;
  final AppLocalizations loc;
  final ValueChanged<ImageSource> onPick;

  const _PhotoPad({
    required this.photoPath,
    required this.paper,
    required this.isDark,
    required this.loc,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    final path = photoPath;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: paper.backgroundColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: paper.borderColor, width: 1.5),
      ),
      child: Column(
        children: [
          if (path != null) ...[
            NoteImage(
              path: path,
              isPhoto: true,
              semanticLabel: loc.t('noteModePhoto'),
            ),
            const SizedBox(height: 10),
          ],
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.photo_camera_rounded, size: 18),
                  label: Text(loc.t('photoCamera')),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: paper.textColor,
                    minimumSize: const Size(0, 48),
                  ),
                  onPressed: () => onPick(ImageSource.camera),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.photo_library_rounded, size: 18),
                  label: Text(loc.t('photoGallery')),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: paper.textColor,
                    minimumSize: const Size(0, 48),
                  ),
                  onPressed: () => onPick(ImageSource.gallery),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
