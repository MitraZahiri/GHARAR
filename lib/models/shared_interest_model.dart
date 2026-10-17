class SharedInterestModel {
  final String id;
  final String titleEn;
  final String titleTr;
  final String category; // 'Travel', 'Food', 'Culture', 'Outdoor', 'Cozy'
  final String descriptionEn;
  final String descriptionTr;
  final String suggestedDateEn;
  final String suggestedDateTr;
  final String icon;
  final bool bothEnjoy;
  final String? partner1PreferenceEn;
  final String? partner1PreferenceTr;
  final String? partner2PreferenceEn;
  final String? partner2PreferenceTr;
  final String? bridgeConversationEn;
  final String? bridgeConversationTr;

  const SharedInterestModel({
    required this.id,
    required this.titleEn,
    required this.titleTr,
    required this.category,
    required this.descriptionEn,
    required this.descriptionTr,
    required this.suggestedDateEn,
    required this.suggestedDateTr,
    required this.icon,
    this.bothEnjoy = true,
    this.partner1PreferenceEn,
    this.partner1PreferenceTr,
    this.partner2PreferenceEn,
    this.partner2PreferenceTr,
    this.bridgeConversationEn,
    this.bridgeConversationTr,
  });

  String title(bool isTr) => isTr ? titleTr : titleEn;
  String description(bool isTr) => isTr ? descriptionTr : descriptionEn;
  String suggestedDate(bool isTr) => isTr ? suggestedDateTr : suggestedDateEn;
  String? partner1Pref(bool isTr) =>
      isTr ? partner1PreferenceTr : partner1PreferenceEn;
  String? partner2Pref(bool isTr) =>
      isTr ? partner2PreferenceTr : partner2PreferenceEn;
  String? bridgeConv(bool isTr) =>
      isTr ? bridgeConversationTr : bridgeConversationEn;

  SharedInterestModel copyWith({
    String? id,
    String? titleEn,
    String? titleTr,
    String? category,
    String? descriptionEn,
    String? descriptionTr,
    String? suggestedDateEn,
    String? suggestedDateTr,
    String? icon,
    bool? bothEnjoy,
    String? partner1PreferenceEn,
    String? partner1PreferenceTr,
    String? partner2PreferenceEn,
    String? partner2PreferenceTr,
    String? bridgeConversationEn,
    String? bridgeConversationTr,
  }) {
    return SharedInterestModel(
      id: id ?? this.id,
      titleEn: titleEn ?? this.titleEn,
      titleTr: titleTr ?? this.titleTr,
      category: category ?? this.category,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      descriptionTr: descriptionTr ?? this.descriptionTr,
      suggestedDateEn: suggestedDateEn ?? this.suggestedDateEn,
      suggestedDateTr: suggestedDateTr ?? this.suggestedDateTr,
      icon: icon ?? this.icon,
      bothEnjoy: bothEnjoy ?? this.bothEnjoy,
      partner1PreferenceEn: partner1PreferenceEn ?? this.partner1PreferenceEn,
      partner1PreferenceTr: partner1PreferenceTr ?? this.partner1PreferenceTr,
      partner2PreferenceEn: partner2PreferenceEn ?? this.partner2PreferenceEn,
      partner2PreferenceTr: partner2PreferenceTr ?? this.partner2PreferenceTr,
      bridgeConversationEn: bridgeConversationEn ?? this.bridgeConversationEn,
      bridgeConversationTr: bridgeConversationTr ?? this.bridgeConversationTr,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'titleEn': titleEn,
        'titleTr': titleTr,
        'category': category,
        'descriptionEn': descriptionEn,
        'descriptionTr': descriptionTr,
        'suggestedDateEn': suggestedDateEn,
        'suggestedDateTr': suggestedDateTr,
        'icon': icon,
        'bothEnjoy': bothEnjoy,
        'partner1PreferenceEn': partner1PreferenceEn,
        'partner1PreferenceTr': partner1PreferenceTr,
        'partner2PreferenceEn': partner2PreferenceEn,
        'partner2PreferenceTr': partner2PreferenceTr,
        'bridgeConversationEn': bridgeConversationEn,
        'bridgeConversationTr': bridgeConversationTr,
      };

  factory SharedInterestModel.fromJson(Map<String, dynamic> json) {
    return SharedInterestModel(
      id: json['id'] as String,
      titleEn: json['titleEn'] as String,
      titleTr: json['titleTr'] as String,
      category: json['category'] as String,
      descriptionEn: json['descriptionEn'] as String,
      descriptionTr: json['descriptionTr'] as String,
      suggestedDateEn: json['suggestedDateEn'] as String,
      suggestedDateTr: json['suggestedDateTr'] as String,
      icon: json['icon'] as String? ?? '✨',
      bothEnjoy: json['bothEnjoy'] as bool? ?? true,
      partner1PreferenceEn: json['partner1PreferenceEn'] as String?,
      partner1PreferenceTr: json['partner1PreferenceTr'] as String?,
      partner2PreferenceEn: json['partner2PreferenceEn'] as String?,
      partner2PreferenceTr: json['partner2PreferenceTr'] as String?,
      bridgeConversationEn: json['bridgeConversationEn'] as String?,
      bridgeConversationTr: json['bridgeConversationTr'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SharedInterestModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          titleEn == other.titleEn &&
          titleTr == other.titleTr &&
          category == other.category &&
          descriptionEn == other.descriptionEn &&
          descriptionTr == other.descriptionTr &&
          suggestedDateEn == other.suggestedDateEn &&
          suggestedDateTr == other.suggestedDateTr &&
          icon == other.icon &&
          bothEnjoy == other.bothEnjoy &&
          partner1PreferenceEn == other.partner1PreferenceEn &&
          partner1PreferenceTr == other.partner1PreferenceTr &&
          partner2PreferenceEn == other.partner2PreferenceEn &&
          partner2PreferenceTr == other.partner2PreferenceTr &&
          bridgeConversationEn == other.bridgeConversationEn &&
          bridgeConversationTr == other.bridgeConversationTr;

  @override
  int get hashCode =>
      id.hashCode ^
      titleEn.hashCode ^
      titleTr.hashCode ^
      category.hashCode ^
      descriptionEn.hashCode ^
      descriptionTr.hashCode ^
      suggestedDateEn.hashCode ^
      suggestedDateTr.hashCode ^
      icon.hashCode ^
      bothEnjoy.hashCode ^
      partner1PreferenceEn.hashCode ^
      partner1PreferenceTr.hashCode ^
      partner2PreferenceEn.hashCode ^
      partner2PreferenceTr.hashCode ^
      bridgeConversationEn.hashCode ^
      bridgeConversationTr.hashCode;
}
