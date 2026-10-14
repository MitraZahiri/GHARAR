class UserModel {
  final String id;
  final String name;
  final String avatar;
  final String preferredLanguage; // 'en' or 'tr'
  final String relationshipStage;
  final List<String> selectedGoals;
  final DateTime joinedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.avatar,
    required this.preferredLanguage,
    required this.relationshipStage,
    required this.selectedGoals,
    required this.joinedAt,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? avatar,
    String? preferredLanguage,
    String? relationshipStage,
    List<String>? selectedGoals,
    DateTime? joinedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      relationshipStage: relationshipStage ?? this.relationshipStage,
      selectedGoals: selectedGoals ?? this.selectedGoals,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'avatar': avatar,
        'preferredLanguage': preferredLanguage,
        'relationshipStage': relationshipStage,
        'selectedGoals': selectedGoals,
        'joinedAt': joinedAt.toIso8601String(),
      };

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String? ?? '🌸',
      preferredLanguage: json['preferredLanguage'] as String? ?? 'en',
      relationshipStage: json['relationshipStage'] as String? ?? 'stageDating',
      selectedGoals: (json['selectedGoals'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      joinedAt: DateTime.tryParse(json['joinedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}
