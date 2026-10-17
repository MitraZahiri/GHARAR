import 'package:flutter/foundation.dart';

class UserModel {
  final String id;
  final String name;
  final String avatar;
  final String preferredLanguage; // 'en', 'tr', 'ar', etc.
  final String relationshipStage;
  final List<String> selectedGoals;
  final DateTime joinedAt;
  final String? email;
  final String? authProvider; // 'apple', 'email', 'demo'

  const UserModel({
    required this.id,
    required this.name,
    required this.avatar,
    required this.preferredLanguage,
    required this.relationshipStage,
    required this.selectedGoals,
    required this.joinedAt,
    this.email,
    this.authProvider,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? avatar,
    String? preferredLanguage,
    String? relationshipStage,
    List<String>? selectedGoals,
    DateTime? joinedAt,
    String? email,
    String? authProvider,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      relationshipStage: relationshipStage ?? this.relationshipStage,
      selectedGoals: selectedGoals ?? this.selectedGoals,
      joinedAt: joinedAt ?? this.joinedAt,
      email: email ?? this.email,
      authProvider: authProvider ?? this.authProvider,
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
        'email': email,
        'authProvider': authProvider,
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
          const [],
      joinedAt: DateTime.tryParse(json['joinedAt'] as String? ?? '') ??
          DateTime.now(),
      email: json['email'] as String?,
      authProvider: json['authProvider'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          avatar == other.avatar &&
          preferredLanguage == other.preferredLanguage &&
          relationshipStage == other.relationshipStage &&
          listEquals(selectedGoals, other.selectedGoals) &&
          joinedAt == other.joinedAt &&
          email == other.email &&
          authProvider == other.authProvider;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      avatar.hashCode ^
      preferredLanguage.hashCode ^
      relationshipStage.hashCode ^
      Object.hashAll(selectedGoals) ^
      joinedAt.hashCode ^
      email.hashCode ^
      authProvider.hashCode;
}
