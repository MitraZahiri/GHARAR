enum ActivityBudget { free, low, medium, luxury }
enum ActivitySetting { atHome, indoor, outdoor }
enum ActivityVibe { romantic, adventurous, relaxing, playful }

class ActivityModel {
  final String id;
  final String titleEn;
  final String titleTr;
  final String descriptionEn;
  final String descriptionTr;
  final String categoryEn;
  final String categoryTr;
  final ActivityBudget budget;
  final ActivitySetting setting;
  final ActivityVibe vibe;
  final String duration; // e.g. '1-2 hrs', '<1 hr'
  final String icon;
  final List<String> tipsEn;
  final List<String> tipsTr;
  final bool isCompleted;
  final bool isSaved;
  final DateTime? completedAt;

  ActivityModel({
    required this.id,
    required this.titleEn,
    required this.titleTr,
    required this.descriptionEn,
    required this.descriptionTr,
    required this.categoryEn,
    required this.categoryTr,
    required this.budget,
    required this.setting,
    required this.vibe,
    required this.duration,
    required this.icon,
    required this.tipsEn,
    required this.tipsTr,
    this.isCompleted = false,
    this.isSaved = false,
    this.completedAt,
  });

  String title(bool isTr) => isTr ? titleTr : titleEn;
  String description(bool isTr) => isTr ? descriptionTr : descriptionEn;
  String category(bool isTr) => isTr ? categoryTr : categoryEn;
  List<String> tips(bool isTr) => isTr ? tipsTr : tipsEn;

  String get budgetDisplay {
    switch (budget) {
      case ActivityBudget.free:
        return 'Free';
      case ActivityBudget.low:
        return r'$ (Low)';
      case ActivityBudget.medium:
        return r'$$ (Moderate)';
      case ActivityBudget.luxury:
        return r'$$$ (Splurge)';
    }
  }

  String settingDisplay(bool isTr) {
    if (isTr) {
      switch (setting) {
        case ActivitySetting.atHome:
          return 'Evde Sıcak';
        case ActivitySetting.indoor:
          return 'Kapalı Mekan';
        case ActivitySetting.outdoor:
          return 'Açık Hava & Doğa';
      }
    }
    switch (setting) {
      case ActivitySetting.atHome:
        return 'At Home';
      case ActivitySetting.indoor:
        return 'Indoor';
      case ActivitySetting.outdoor:
        return 'Outdoors';
    }
  }

  String vibeDisplay(bool isTr) {
    if (isTr) {
      switch (vibe) {
        case ActivityVibe.romantic:
          return 'Romantik & İntim';
        case ActivityVibe.adventurous:
          return 'Maceracı';
        case ActivityVibe.relaxing:
          return 'Huzurlu & Sakin';
        case ActivityVibe.playful:
          return 'Neşeli & Oyun';
      }
    }
    switch (vibe) {
      case ActivityVibe.romantic:
        return 'Romantic';
      case ActivityVibe.adventurous:
        return 'Adventurous';
      case ActivityVibe.relaxing:
        return 'Relaxing';
      case ActivityVibe.playful:
        return 'Playful';
    }
  }

  ActivityModel copyWith({
    String? id,
    String? titleEn,
    String? titleTr,
    String? descriptionEn,
    String? descriptionTr,
    String? categoryEn,
    String? categoryTr,
    ActivityBudget? budget,
    ActivitySetting? setting,
    ActivityVibe? vibe,
    String? duration,
    String? icon,
    List<String>? tipsEn,
    List<String>? tipsTr,
    bool? isCompleted,
    bool? isSaved,
    DateTime? completedAt,
  }) {
    return ActivityModel(
      id: id ?? this.id,
      titleEn: titleEn ?? this.titleEn,
      titleTr: titleTr ?? this.titleTr,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      descriptionTr: descriptionTr ?? this.descriptionTr,
      categoryEn: categoryEn ?? this.categoryEn,
      categoryTr: categoryTr ?? this.categoryTr,
      budget: budget ?? this.budget,
      setting: setting ?? this.setting,
      vibe: vibe ?? this.vibe,
      duration: duration ?? this.duration,
      icon: icon ?? this.icon,
      tipsEn: tipsEn ?? this.tipsEn,
      tipsTr: tipsTr ?? this.tipsTr,
      isCompleted: isCompleted ?? this.isCompleted,
      isSaved: isSaved ?? this.isSaved,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'titleEn': titleEn,
        'titleTr': titleTr,
        'descriptionEn': descriptionEn,
        'descriptionTr': descriptionTr,
        'categoryEn': categoryEn,
        'categoryTr': categoryTr,
        'budget': budget.name,
        'setting': setting.name,
        'vibe': vibe.name,
        'duration': duration,
        'icon': icon,
        'tipsEn': tipsEn,
        'tipsTr': tipsTr,
        'isCompleted': isCompleted,
        'isSaved': isSaved,
        'completedAt': completedAt?.toIso8601String(),
      };

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['id'] as String,
      titleEn: json['titleEn'] as String,
      titleTr: json['titleTr'] as String,
      descriptionEn: json['descriptionEn'] as String,
      descriptionTr: json['descriptionTr'] as String,
      categoryEn: json['categoryEn'] as String,
      categoryTr: json['categoryTr'] as String,
      budget: ActivityBudget.values.firstWhere(
        (b) => b.name == json['budget'],
        orElse: () => ActivityBudget.low,
      ),
      setting: ActivitySetting.values.firstWhere(
        (s) => s.name == json['setting'],
        orElse: () => ActivitySetting.atHome,
      ),
      vibe: ActivityVibe.values.firstWhere(
        (v) => v.name == json['vibe'],
        orElse: () => ActivityVibe.romantic,
      ),
      duration: json['duration'] as String? ?? '1-2 hrs',
      icon: json['icon'] as String? ?? '🕯️',
      tipsEn: (json['tipsEn'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      tipsTr: (json['tipsTr'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      isCompleted: json['isCompleted'] as bool? ?? false,
      isSaved: json['isSaved'] as bool? ?? false,
      completedAt: json['completedAt'] != null
          ? DateTime.tryParse(json['completedAt'] as String)
          : null,
    );
  }
}
