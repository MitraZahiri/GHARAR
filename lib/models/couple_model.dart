import 'user_model.dart';

/// Whether the couple lives close by or in a long-distance relationship.
enum DistanceMode {
  together,
  longDistance;

  static DistanceMode fromName(String? name) =>
      values.where((m) => m.name == name).firstOrNull ?? together;
}

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
  final DistanceMode distanceMode;
  final DateTime? nextMeetingDate;

  /// Partner's UTC offset in minutes, used for the long-distance clock.
  final int? partnerUtcOffsetMinutes;

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
    this.distanceMode = DistanceMode.together,
    this.nextMeetingDate,
    this.partnerUtcOffsetMinutes,
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
    DistanceMode? distanceMode,
    DateTime? nextMeetingDate,
    bool clearNextMeetingDate = false,
    int? partnerUtcOffsetMinutes,
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
      distanceMode: distanceMode ?? this.distanceMode,
      nextMeetingDate:
          clearNextMeetingDate
              ? null
              : (nextMeetingDate ?? this.nextMeetingDate),
      partnerUtcOffsetMinutes:
          partnerUtcOffsetMinutes ?? this.partnerUtcOffsetMinutes,
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
    'distanceMode': distanceMode.name,
    'nextMeetingDate': nextMeetingDate?.toIso8601String(),
    'partnerUtcOffsetMinutes': partnerUtcOffsetMinutes,
  };

  factory CoupleModel.fromJson(Map<String, dynamic> json) {
    return CoupleModel(
      id: json['id'] as String,
      partner1: UserModel.fromJson(json['partner1'] as Map<String, dynamic>),
      partner2:
          json['partner2'] != null
              ? UserModel.fromJson(json['partner2'] as Map<String, dynamic>)
              : null,
      inviteCode: json['inviteCode'] as String? ?? 'GHARAR-7842-LOVE',
      anniversaryDate:
          DateTime.tryParse(json['anniversaryDate'] as String? ?? '') ??
          DateTime.now().subtract(const Duration(days: 365)),
      connectionStreak: (json['connectionStreak'] as num?)?.toInt() ?? 1,
      streakLastMaintained:
          json['streakLastMaintained'] != null
              ? DateTime.tryParse(json['streakLastMaintained'] as String)
              : null,
      isLinked: json['isLinked'] as bool? ?? true,
      isPremium: json['isPremium'] as bool? ?? false,
      distanceMode: DistanceMode.fromName(json['distanceMode'] as String?),
      nextMeetingDate:
          json['nextMeetingDate'] != null
              ? DateTime.tryParse(json['nextMeetingDate'] as String)
              : null,
      partnerUtcOffsetMinutes:
          (json['partnerUtcOffsetMinutes'] as num?)?.toInt(),
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
          isPremium == other.isPremium &&
          distanceMode == other.distanceMode &&
          nextMeetingDate == other.nextMeetingDate &&
          partnerUtcOffsetMinutes == other.partnerUtcOffsetMinutes;

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
      isPremium.hashCode ^
      distanceMode.hashCode ^
      nextMeetingDate.hashCode ^
      partnerUtcOffsetMinutes.hashCode;
}
