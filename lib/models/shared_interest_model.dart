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

  SharedInterestModel({
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
}
