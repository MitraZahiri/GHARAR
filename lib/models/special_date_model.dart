class SpecialDateModel {
  final String id;
  final String titleEn;
  final String titleTr;
  final DateTime date;
  final String category; // 'Anniversary', 'Birthday', 'Trip', 'Date Night', 'Milestone'
  final String icon;
  final String notes;
  final bool reminderEnabled;

  SpecialDateModel({
    required this.id,
    required this.titleEn,
    required this.titleTr,
    required this.date,
    required this.category,
    required this.icon,
    this.notes = '',
    this.reminderEnabled = true,
  });

  String title(bool isTr) => isTr ? titleTr : titleEn;

  int get daysUntil {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    // Find next recurrence if anniversary or birthday
    var target = DateTime(today.year, date.month, date.day);
    if (target.isBefore(today)) {
      target = DateTime(today.year + 1, date.month, date.day);
    }
    return target.difference(today).inDays;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'titleEn': titleEn,
        'titleTr': titleTr,
        'date': date.toIso8601String(),
        'category': category,
        'icon': icon,
        'notes': notes,
        'reminderEnabled': reminderEnabled,
      };

  factory SpecialDateModel.fromJson(Map<String, dynamic> json) {
    return SpecialDateModel(
      id: json['id'] as String,
      titleEn: json['titleEn'] as String,
      titleTr: json['titleTr'] as String,
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      category: json['category'] as String? ?? 'Anniversary',
      icon: json['icon'] as String? ?? '🎉',
      notes: json['notes'] as String? ?? '',
      reminderEnabled: json['reminderEnabled'] as bool? ?? true,
    );
  }
}
