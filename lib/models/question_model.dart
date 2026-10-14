enum QuestionIntensity {
  icebreaker,
  meaningful,
  deepSoul,
}

enum QuestionCategory {
  love,
  emotionalIntimacy,
  childhood,
  memories,
  communication,
  futureDreams,
  coreValues,
  fun,
  romance,
  personalGrowth,
  lifestyle,
  deepConversations,
}

class QuestionModel {
  final String id;
  final String textEn;
  final String textTr;
  final QuestionCategory category;
  final QuestionIntensity intensity;
  final List<String>? optionsEn;
  final List<String>? optionsTr;
  final String? inspirationTipEn;
  final String? inspirationTipTr;

  QuestionModel({
    required this.id,
    required this.textEn,
    required this.textTr,
    required this.category,
    required this.intensity,
    this.optionsEn,
    this.optionsTr,
    this.inspirationTipEn,
    this.inspirationTipTr,
  });

  String text(bool isTurkish) => isTurkish ? textTr : textEn;
  List<String>? options(bool isTurkish) => isTurkish ? optionsTr : optionsEn;
  String? inspirationTip(bool isTurkish) =>
      isTurkish ? inspirationTipTr : inspirationTipEn;

  String get categoryIcon {
    switch (category) {
      case QuestionCategory.love:
        return '💖';
      case QuestionCategory.emotionalIntimacy:
        return '🕊️';
      case QuestionCategory.childhood:
        return '🧸';
      case QuestionCategory.memories:
        return '📸';
      case QuestionCategory.communication:
        return '💬';
      case QuestionCategory.futureDreams:
        return '✨';
      case QuestionCategory.coreValues:
        return '🧭';
      case QuestionCategory.fun:
        return '🎉';
      case QuestionCategory.romance:
        return '🌹';
      case QuestionCategory.personalGrowth:
        return '🌱';
      case QuestionCategory.lifestyle:
        return '☕';
      case QuestionCategory.deepConversations:
        return '🌌';
    }
  }

  String categoryName(bool isTurkish) {
    if (isTurkish) {
      switch (category) {
        case QuestionCategory.love:
          return 'Aşk & Şefkat';
        case QuestionCategory.emotionalIntimacy:
          return 'Duygusal Yakınlık';
        case QuestionCategory.childhood:
          return 'Çocukluk & Kökler';
        case QuestionCategory.memories:
          return 'Unutulmaz Anılar';
        case QuestionCategory.communication:
          return 'İletişim & Diller';
        case QuestionCategory.futureDreams:
          return 'Gelecek Hayalleri';
        case QuestionCategory.coreValues:
          return 'Değerler & İnanç';
        case QuestionCategory.fun:
          return 'Neşeli & Eğlenceli';
        case QuestionCategory.romance:
          return 'Tutku & Romantizm';
        case QuestionCategory.personalGrowth:
          return 'Kişisel Gelişim';
        case QuestionCategory.lifestyle:
          return 'Yaşam & Alışkanlıklar';
        case QuestionCategory.deepConversations:
          return 'Gece Sohbetleri';
      }
    } else {
      switch (category) {
        case QuestionCategory.love:
          return 'Love & Affection';
        case QuestionCategory.emotionalIntimacy:
          return 'Emotional Intimacy';
        case QuestionCategory.childhood:
          return 'Childhood & Roots';
        case QuestionCategory.memories:
          return 'Cherished Memories';
        case QuestionCategory.communication:
          return 'Communication';
        case QuestionCategory.futureDreams:
          return 'Future Dreams';
        case QuestionCategory.coreValues:
          return 'Core Values';
        case QuestionCategory.fun:
          return 'Playful & Fun';
        case QuestionCategory.romance:
          return 'Romance & Passion';
        case QuestionCategory.personalGrowth:
          return 'Personal Growth';
        case QuestionCategory.lifestyle:
          return 'Lifestyle & Rhythm';
        case QuestionCategory.deepConversations:
          return 'Midnight Deep Dive';
      }
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'textEn': textEn,
        'textTr': textTr,
        'category': category.name,
        'intensity': intensity.name,
        'optionsEn': optionsEn,
        'optionsTr': optionsTr,
        'inspirationTipEn': inspirationTipEn,
        'inspirationTipTr': inspirationTipTr,
      };

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] as String,
      textEn: json['textEn'] as String,
      textTr: json['textTr'] as String,
      category: QuestionCategory.values.firstWhere(
        (c) => c.name == json['category'],
        orElse: () => QuestionCategory.love,
      ),
      intensity: QuestionIntensity.values.firstWhere(
        (i) => i.name == json['intensity'],
        orElse: () => QuestionIntensity.meaningful,
      ),
      optionsEn: (json['optionsEn'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      optionsTr: (json['optionsTr'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      inspirationTipEn: json['inspirationTipEn'] as String?,
      inspirationTipTr: json['inspirationTipTr'] as String?,
    );
  }
}

class AnswerModel {
  final String id;
  final String questionId;
  final String authorId;
  final String authorName;
  final String answerText;
  final int? selectedOptionIndex;
  final DateTime answeredAt;
  final String? reactionEmoji; // e.g. ❤️, 🥰, ✨

  AnswerModel({
    required this.id,
    required this.questionId,
    required this.authorId,
    required this.authorName,
    required this.answerText,
    this.selectedOptionIndex,
    required this.answeredAt,
    this.reactionEmoji,
  });

  AnswerModel copyWith({
    String? id,
    String? questionId,
    String? authorId,
    String? authorName,
    String? answerText,
    int? selectedOptionIndex,
    DateTime? answeredAt,
    String? reactionEmoji,
  }) {
    return AnswerModel(
      id: id ?? this.id,
      questionId: questionId ?? this.questionId,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      answerText: answerText ?? this.answerText,
      selectedOptionIndex: selectedOptionIndex ?? this.selectedOptionIndex,
      answeredAt: answeredAt ?? this.answeredAt,
      reactionEmoji: reactionEmoji ?? this.reactionEmoji,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'questionId': questionId,
        'authorId': authorId,
        'authorName': authorName,
        'answerText': answerText,
        'selectedOptionIndex': selectedOptionIndex,
        'answeredAt': answeredAt.toIso8601String(),
        'reactionEmoji': reactionEmoji,
      };

  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      id: json['id'] as String,
      questionId: json['questionId'] as String,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String? ?? 'Partner',
      answerText: json['answerText'] as String,
      selectedOptionIndex: json['selectedOptionIndex'] as int?,
      answeredAt: DateTime.tryParse(json['answeredAt'] as String? ?? '') ??
          DateTime.now(),
      reactionEmoji: json['reactionEmoji'] as String?,
    );
  }
}
