import 'package:flutter/foundation.dart';

class JournalEntryModel {
  final String id;
  final String title;
  final String notes;
  final String authorId;
  final String authorName;
  final DateTime date;
  final String moodEmoji;
  final String? questionId;
  final String? questionSnippet;
  final String? imagePlaceholder; // icon or color token representation
  final List<String> tags;

  const JournalEntryModel({
    required this.id,
    required this.title,
    required this.notes,
    required this.authorId,
    required this.authorName,
    required this.date,
    this.moodEmoji = '💖',
    this.questionId,
    this.questionSnippet,
    this.imagePlaceholder,
    this.tags = const [],
  });

  JournalEntryModel copyWith({
    String? id,
    String? title,
    String? notes,
    String? authorId,
    String? authorName,
    DateTime? date,
    String? moodEmoji,
    String? questionId,
    String? questionSnippet,
    String? imagePlaceholder,
    List<String>? tags,
  }) {
    return JournalEntryModel(
      id: id ?? this.id,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      date: date ?? this.date,
      moodEmoji: moodEmoji ?? this.moodEmoji,
      questionId: questionId ?? this.questionId,
      questionSnippet: questionSnippet ?? this.questionSnippet,
      imagePlaceholder: imagePlaceholder ?? this.imagePlaceholder,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'notes': notes,
        'authorId': authorId,
        'authorName': authorName,
        'date': date.toIso8601String(),
        'moodEmoji': moodEmoji,
        'questionId': questionId,
        'questionSnippet': questionSnippet,
        'imagePlaceholder': imagePlaceholder,
        'tags': tags,
      };

  factory JournalEntryModel.fromJson(Map<String, dynamic> json) {
    return JournalEntryModel(
      id: json['id'] as String,
      title: json['title'] as String,
      notes: json['notes'] as String,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String? ?? 'Partner',
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      moodEmoji: json['moodEmoji'] as String? ?? '💖',
      questionId: json['questionId'] as String?,
      questionSnippet: json['questionSnippet'] as String?,
      imagePlaceholder: json['imagePlaceholder'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          const [],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JournalEntryModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          notes == other.notes &&
          authorId == other.authorId &&
          authorName == other.authorName &&
          date == other.date &&
          moodEmoji == other.moodEmoji &&
          questionId == other.questionId &&
          questionSnippet == other.questionSnippet &&
          imagePlaceholder == other.imagePlaceholder &&
          listEquals(tags, other.tags);

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      notes.hashCode ^
      authorId.hashCode ^
      authorName.hashCode ^
      date.hashCode ^
      moodEmoji.hashCode ^
      questionId.hashCode ^
      questionSnippet.hashCode ^
      imagePlaceholder.hashCode ^
      Object.hashAll(tags);
}
