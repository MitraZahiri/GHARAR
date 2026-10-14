class JournalEntryModel {
  final String id;
  final String title;
  final String notes;
  final String authorId;
  final String authorName;
  final DateTime date;
  final String moodEmoji;
  final String? questionId;
  final String? questionSnippet;
  final String? imagePlaceholder; // icon or color token representation
  final List<String> tags;

  JournalEntryModel({
    required this.id,
    required this.title,
    required this.notes,
    required this.authorId,
    required this.authorName,
    required this.date,
    this.moodEmoji = '💖',
    this.questionId,
    this.questionSnippet,
    this.imagePlaceholder,
    this.tags = const [],
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'notes': notes,
        'authorId': authorId,
        'authorName': authorName,
        'date': date.toIso8601String(),
        'moodEmoji': moodEmoji,
        'questionId': questionId,
        'questionSnippet': questionSnippet,
        'imagePlaceholder': imagePlaceholder,
        'tags': tags,
      };

  factory JournalEntryModel.fromJson(Map<String, dynamic> json) {
    return JournalEntryModel(
      id: json['id'] as String,
      title: json['title'] as String,
      notes: json['notes'] as String,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String? ?? 'Partner',
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      moodEmoji: json['moodEmoji'] as String? ?? '💖',
      questionId: json['questionId'] as String?,
      questionSnippet: json['questionSnippet'] as String?,
      imagePlaceholder: json['imagePlaceholder'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          [],
    );
  }
}

class MilestoneModel {
  final String id;
  final String titleEn;
  final String titleTr;
  final String descriptionEn;
  final String descriptionTr;
  final DateTime milestoneDate;
  final String icon;
  final String badgeTextEn;
  final String badgeTextTr;
  final bool isCelebrated;

  MilestoneModel({
    required this.id,
    required this.titleEn,
    required this.titleTr,
    required this.descriptionEn,
    required this.descriptionTr,
    required this.milestoneDate,
    required this.icon,
    required this.badgeTextEn,
    required this.badgeTextTr,
    this.isCelebrated = false,
  });

  String title(bool isTr) => isTr ? titleTr : titleEn;
  String description(bool isTr) => isTr ? descriptionTr : descriptionEn;
  String badgeText(bool isTr) => isTr ? badgeTextTr : badgeTextEn;

  Map<String, dynamic> toJson() => {
        'id': id,
        'titleEn': titleEn,
        'titleTr': titleTr,
        'descriptionEn': descriptionEn,
        'descriptionTr': descriptionTr,
        'milestoneDate': milestoneDate.toIso8601String(),
        'icon': icon,
        'badgeTextEn': badgeTextEn,
        'badgeTextTr': badgeTextTr,
        'isCelebrated': isCelebrated,
      };

  factory MilestoneModel.fromJson(Map<String, dynamic> json) {
    return MilestoneModel(
      id: json['id'] as String,
      titleEn: json['titleEn'] as String,
      titleTr: json['titleTr'] as String,
      descriptionEn: json['descriptionEn'] as String,
      descriptionTr: json['descriptionTr'] as String,
      milestoneDate:
          DateTime.tryParse(json['milestoneDate'] as String? ?? '') ??
              DateTime.now(),
      icon: json['icon'] as String? ?? '🌟',
      badgeTextEn: json['badgeTextEn'] as String? ?? 'Milestone',
      badgeTextTr: json['badgeTextTr'] as String? ?? 'Dönüm Noktası',
      isCelebrated: json['isCelebrated'] as bool? ?? false,
    );
  }
}
