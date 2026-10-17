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

  const MilestoneModel({
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

  MilestoneModel copyWith({
    String? id,
    String? titleEn,
    String? titleTr,
    String? descriptionEn,
    String? descriptionTr,
    DateTime? milestoneDate,
    String? icon,
    String? badgeTextEn,
    String? badgeTextTr,
    bool? isCelebrated,
  }) {
    return MilestoneModel(
      id: id ?? this.id,
      titleEn: titleEn ?? this.titleEn,
      titleTr: titleTr ?? this.titleTr,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      descriptionTr: descriptionTr ?? this.descriptionTr,
      milestoneDate: milestoneDate ?? this.milestoneDate,
      icon: icon ?? this.icon,
      badgeTextEn: badgeTextEn ?? this.badgeTextEn,
      badgeTextTr: badgeTextTr ?? this.badgeTextTr,
      isCelebrated: isCelebrated ?? this.isCelebrated,
    );
  }

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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MilestoneModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          titleEn == other.titleEn &&
          titleTr == other.titleTr &&
          descriptionEn == other.descriptionEn &&
          descriptionTr == other.descriptionTr &&
          milestoneDate == other.milestoneDate &&
          icon == other.icon &&
          badgeTextEn == other.badgeTextEn &&
          badgeTextTr == other.badgeTextTr &&
          isCelebrated == other.isCelebrated;

  @override
  int get hashCode =>
      id.hashCode ^
      titleEn.hashCode ^
      titleTr.hashCode ^
      descriptionEn.hashCode ^
      descriptionTr.hashCode ^
      milestoneDate.hashCode ^
      icon.hashCode ^
      badgeTextEn.hashCode ^
      badgeTextTr.hashCode ^
      isCelebrated.hashCode;
}
