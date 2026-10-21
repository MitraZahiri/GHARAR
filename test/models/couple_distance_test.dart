import 'package:flutter_test/flutter_test.dart';
import 'package:gharar/models/couple_model.dart';
import 'package:gharar/models/user_model.dart';

void main() {
  final partner1 = UserModel(
    id: 'user_1',
    name: 'Kerem',
    avatar: '🕊️',
    preferredLanguage: 'tr',
    relationshipStage: 'married',
    selectedGoals: const [],
    joinedAt: DateTime(2026, 1, 1),
  );

  final couple = CoupleModel(
    id: 'couple_1',
    partner1: partner1,
    inviteCode: 'GHARAR-1234-LOVE',
    anniversaryDate: DateTime(2025, 2, 14),
  );

  group('CoupleModel distance mode', () {
    test('defaults to together with no meeting date or time zone', () {
      expect(couple.distanceMode, DistanceMode.together);
      expect(couple.nextMeetingDate, isNull);
      expect(couple.partnerUtcOffsetMinutes, isNull);
    });

    test('long-distance settings survive a JSON round trip', () {
      final ldr = couple.copyWith(
        distanceMode: DistanceMode.longDistance,
        nextMeetingDate: DateTime(2026, 12, 24),
        partnerUtcOffsetMinutes: -300,
      );
      final revived = CoupleModel.fromJson(ldr.toJson());
      expect(revived, equals(ldr));
      expect(revived.distanceMode, DistanceMode.longDistance);
      expect(revived.nextMeetingDate, DateTime(2026, 12, 24));
      expect(revived.partnerUtcOffsetMinutes, -300);
    });

    test('legacy JSON without distance fields reads as together', () {
      final json =
          couple.toJson()
            ..remove('distanceMode')
            ..remove('nextMeetingDate')
            ..remove('partnerUtcOffsetMinutes');
      final revived = CoupleModel.fromJson(json);
      expect(revived.distanceMode, DistanceMode.together);
      expect(revived.nextMeetingDate, isNull);
    });

    test('copyWith can clear the meeting date', () {
      final withDate = couple.copyWith(nextMeetingDate: DateTime(2026, 11, 1));
      final cleared = withDate.copyWith(clearNextMeetingDate: true);
      expect(cleared.nextMeetingDate, isNull);
      expect(withDate.nextMeetingDate, DateTime(2026, 11, 1));
    });
  });
}
