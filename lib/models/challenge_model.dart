class ChallengeModel {
  final String id;
  final int weekNumber;
  final String titleEn;
  final String titleTr;
  final String descriptionEn;
  final String descriptionTr;
  final String rewardBadge;
  final String badgeNameEn;
  final String badgeNameTr;
  final String encouragementEn;
  final String encouragementTr;
  final bool isCompleted;
  final DateTime? completedAt;

  const ChallengeModel({
    required this.id,
    required this.weekNumber,
    required this.titleEn,
    required this.titleTr,
    required this.descriptionEn,
    required this.descriptionTr,
    required this.rewardBadge,
    required this.badgeNameEn,
    required this.badgeNameTr,
    required this.encouragementEn,
    required this.encouragementTr,
    this.isCompleted = false,
    this.completedAt,
  });

  String title(bool isTr) => isTr ? titleTr : titleEn;
  String description(bool isTr) => isTr ? descriptionTr : descriptionEn;
  String badgeName(bool isTr) => isTr ? badgeNameTr : badgeNameEn;
  String encouragement(bool isTr) => isTr ? encouragementTr : encouragementEn;

  ChallengeModel copyWith({
    String? id,
    int? weekNumber,
    String? titleEn,
    String? titleTr,
    String? descriptionEn,
    String? descriptionTr,
    String? rewardBadge,
    String? badgeNameEn,
    String? badgeNameTr,
    String? encouragementEn,
    String? encouragementTr,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return ChallengeModel(
      id: id ?? this.id,
      weekNumber: weekNumber ?? this.weekNumber,
      titleEn: titleEn ?? this.titleEn,
      titleTr: titleTr ?? this.titleTr,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      descriptionTr: descriptionTr ?? this.descriptionTr,
      rewardBadge: rewardBadge ?? this.rewardBadge,
      badgeNameEn: badgeNameEn ?? this.badgeNameEn,
      badgeNameTr: badgeNameTr ?? this.badgeNameTr,
      encouragementEn: encouragementEn ?? this.encouragementEn,
      encouragementTr: encouragementTr ?? this.encouragementTr,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'weekNumber': weekNumber,
    'titleEn': titleEn,
    'titleTr': titleTr,
    'descriptionEn': descriptionEn,
    'descriptionTr': descriptionTr,
    'rewardBadge': rewardBadge,
    'badgeNameEn': badgeNameEn,
    'badgeNameTr': badgeNameTr,
    'encouragementEn': encouragementEn,
    'encouragementTr': encouragementTr,
    'isCompleted': isCompleted,
    'completedAt': completedAt?.toIso8601String(),
  };

  factory ChallengeModel.fromJson(Map<String, dynamic> json) {
    return ChallengeModel(
      id: json['id'] as String,
      weekNumber: (json['weekNumber'] as num?)?.toInt() ?? 1,
      titleEn: json['titleEn'] as String,
      titleTr: json['titleTr'] as String,
      descriptionEn: json['descriptionEn'] as String,
      descriptionTr: json['descriptionTr'] as String,
      rewardBadge: json['rewardBadge'] as String? ?? '🏆',
      badgeNameEn: json['badgeNameEn'] as String? ?? 'Couple Spark',
      badgeNameTr: json['badgeNameTr'] as String? ?? 'Çift Kıvılcımı',
      encouragementEn: json['encouragementEn'] as String? ?? '',
      encouragementTr: json['encouragementTr'] as String? ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
      completedAt:
          json['completedAt'] != null
              ? DateTime.tryParse(json['completedAt'] as String)
              : null,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChallengeModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          weekNumber == other.weekNumber &&
          titleEn == other.titleEn &&
          titleTr == other.titleTr &&
          descriptionEn == other.descriptionEn &&
          descriptionTr == other.descriptionTr &&
          rewardBadge == other.rewardBadge &&
          badgeNameEn == other.badgeNameEn &&
          badgeNameTr == other.badgeNameTr &&
          encouragementEn == other.encouragementEn &&
          encouragementTr == other.encouragementTr &&
          isCompleted == other.isCompleted &&
          completedAt == other.completedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      weekNumber.hashCode ^
      titleEn.hashCode ^
      titleTr.hashCode ^
      descriptionEn.hashCode ^
      descriptionTr.hashCode ^
      rewardBadge.hashCode ^
      badgeNameEn.hashCode ^
      badgeNameTr.hashCode ^
      encouragementEn.hashCode ^
      encouragementTr.hashCode ^
      isCompleted.hashCode ^
      completedAt.hashCode;
}
