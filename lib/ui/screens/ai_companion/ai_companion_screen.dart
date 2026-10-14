import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/ai_message_model.dart';
import '../../../providers/app_state_provider.dart';

class AICompanionScreen extends StatefulWidget {
  const AICompanionScreen({super.key});

  @override
  State<AICompanionScreen> createState() => _AICompanionScreenState();
}

class _AICompanionScreenState extends State<AICompanionScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<String> _quickPromptsEn = [
    'Help me express my feelings gently',
    'Suggest a cozy at-home date for tonight',
    'How do we de-escalate small disagreements?',
    'Give us a deep late-night question',
  ];

  final List<String> _quickPromptsTr = [
    'Duygularımı incitmeden nasıl ifade edebilirim?',
    'Bu akşam için evde sıcak bir randevu öner',
    'Ufak tartışmaları nasıl şefkatle yatıştırırız?',
    'Bize bu gece için düşündürücü derin bir soru ver',
  ];

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppStateProvider>();
    final isDark = provider.isDarkMode;
    final isTr = provider.isTurkish;

    final messages = provider.aiMessages;
    final quickPrompts = isTr ? _quickPromptsTr : _quickPromptsEn;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: AppColors.sunsetGold,
                shape: BoxShape.circle,
              ),
              child: const Text('✨', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(width: 8),
            Text(
              'Noor • Companion',
              style: AppTextStyles.titleMedium(isDark: isDark).copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Gentle Disclaimer Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: isDark ? AppColors.darkCardElevated : AppColors.warmIvory,
            child: Row(
              children: [
                const Icon(Icons.shield_outlined,
                    size: 16, color: AppColors.champagneGold),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isTr
                        ? 'Noor; sevgi dolu iletişim ve randevu fikirleri sunar. Tıbbi terapi yerine geçmez.'
                        : 'Noor provides inspiration & communication tips. Not professional couples therapy.',
                    style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Chat messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isUser = msg.sender == MessageSender.user;

                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.82,
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: isUser
                          ? (isDark
                              ? AppColors.blushPinkDeep
                              : AppColors.deepBurgundy)
                          : (isDark
                              ? AppColors.darkCard
                              : Colors.white),
                      gradient: !isUser && !isDark
                          ? AppColors.intimateCardGradient
                          : null,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft: isUser
                            ? const Radius.circular(20)
                            : const Radius.circular(4),
                        bottomRight: isUser
                            ? const Radius.circular(4)
                            : const Radius.circular(20),
                      ),
                      border: !isUser
                          ? Border.all(
                              color: isDark
                                  ? AppColors.darkBorder
                                  : AppColors.lightBorder,
                            )
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isUser) ...[
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('✨', style: TextStyle(fontSize: 14)),
                              const SizedBox(width: 4),
                              Text(
                                'Noor',
                                style: AppTextStyles.bodySmall(isDark: isDark)
                                    .copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? AppColors.blushPinkDeep
                                      : AppColors.deepBurgundy,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                        ],
                        Text(
                          msg.content(isTr),
                          style:
                              AppTextStyles.bodyMedium(isDark: isDark).copyWith(
                            color: isUser
                                ? (isDark
                                    ? AppColors.burgundyWine
                                    : Colors.white)
                                : (isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.lightTextPrimary),
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          if (provider.isGeneratingAI) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isTr ? 'Noor düşünüyor...' : 'Noor is reflecting...',
                    style: AppTextStyles.bodySmall(isDark: isDark),
                  ),
                ],
              ),
            ),
          ],

          // Quick Prompt Suggestion Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                for (final prompt in quickPrompts) ...[
                  ActionChip(
                    backgroundColor: isDark
                        ? AppColors.darkCardElevated
                        : AppColors.blushPinkLight,
                    side: BorderSide(
                      color: isDark
                          ? AppColors.darkBorder
                          : AppColors.blushPink,
                    ),
                    label: Text(
                      prompt,
                      style: AppTextStyles.bodySmall(isDark: isDark).copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () {
                      provider.sendAIMessage(prompt);
                      _scrollToBottom();
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),

          // Message Input Field
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                border: Border(
                  top: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: isTr
                            ? 'Noor’a bir soru sorun...'
                            : 'Ask Noor for advice or prompts...',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                      onSubmitted: (val) {
                        if (val.trim().isNotEmpty) {
                          provider.sendAIMessage(val);
                          _textController.clear();
                          _scrollToBottom();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: AppColors.romanticLove,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_upward_rounded,
                          color: Colors.white, size: 20),
                    ),
                    onPressed: () {
                      if (_textController.text.trim().isNotEmpty) {
                        provider.sendAIMessage(_textController.text);
                        _textController.clear();
                        _scrollToBottom();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
