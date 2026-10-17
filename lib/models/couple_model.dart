import 'user_model.dart';

class CoupleModel {
  final String id;
  final UserModel partner1;
  final UserModel? partner2;
  final String inviteCode;
  final DateTime anniversaryDate;
  final int connectionStreak;
  final DateTime? streakLastMaintained;
  final bool isLinked;
  final bool isPremium;

  const CoupleModel({
    required this.id,
    required this.partner1,
    this.partner2,
    required this.inviteCode,
    required this.anniversaryDate,
    this.connectionStreak = 1,
    this.streakLastMaintained,
    this.isLinked = true,
    this.isPremium = false,
  });

  String get partnerNames {
    if (partner2 != null) {
      return '${partner1.name} & ${partner2!.name}';
    }
    return partner1.name;
  }

  CoupleModel copyWith({
    String? id,
    UserModel? partner1,
    UserModel? partner2,
    String? inviteCode,
    DateTime? anniversaryDate,
    int? connectionStreak,
    DateTime? streakLastMaintained,
    bool? isLinked,
    bool? isPremium,
  }) {
    return CoupleModel(
      id: id ?? this.id,
      partner1: partner1 ?? this.partner1,
      partner2: partner2 ?? this.partner2,
      inviteCode: inviteCode ?? this.inviteCode,
      anniversaryDate: anniversaryDate ?? this.anniversaryDate,
      connectionStreak: connectionStreak ?? this.connectionStreak,
      streakLastMaintained: streakLastMaintained ?? this.streakLastMaintained,
      isLinked: isLinked ?? this.isLinked,
      isPremium: isPremium ?? this.isPremium,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'partner1': partner1.toJson(),
        'partner2': partner2?.toJson(),
        'inviteCode': inviteCode,
        'anniversaryDate': anniversaryDate.toIso8601String(),
        'connectionStreak': connectionStreak,
        'streakLastMaintained': streakLastMaintained?.toIso8601String(),
        'isLinked': isLinked,
        'isPremium': isPremium,
      };

  factory CoupleModel.fromJson(Map<String, dynamic> json) {
    return CoupleModel(
      id: json['id'] as String,
      partner1: UserModel.fromJson(json['partner1'] as Map<String, dynamic>),
      partner2: json['partner2'] != null
          ? UserModel.fromJson(json['partner2'] as Map<String, dynamic>)
          : null,
      inviteCode: json['inviteCode'] as String? ?? 'GHARAR-7842-LOVE',
      anniversaryDate:
          DateTime.tryParse(json['anniversaryDate'] as String? ?? '') ??
              DateTime.now().subtract(const Duration(days: 365)),
      connectionStreak: (json['connectionStreak'] as num?)?.toInt() ?? 1,
      streakLastMaintained: json['streakLastMaintained'] != null
          ? DateTime.tryParse(json['streakLastMaintained'] as String)
          : null,
      isLinked: json['isLinked'] as bool? ?? true,
      isPremium: json['isPremium'] as bool? ?? false,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoupleModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          partner1 == other.partner1 &&
          partner2 == other.partner2 &&
          inviteCode == other.inviteCode &&
          anniversaryDate == other.anniversaryDate &&
          connectionStreak == other.connectionStreak &&
          streakLastMaintained == other.streakLastMaintained &&
          isLinked == other.isLinked &&
          isPremium == other.isPremium;

  @override
  int get hashCode =>
      id.hashCode ^
      partner1.hashCode ^
      partner2.hashCode ^
      inviteCode.hashCode ^
      anniversaryDate.hashCode ^
      connectionStreak.hashCode ^
      streakLastMaintained.hashCode ^
      isLinked.hashCode ^
      isPremium.hashCode;
}
