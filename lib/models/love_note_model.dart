import 'package:flutter/foundation.dart';

@immutable
class LoveNoteModel {
  final String id;
  final String senderId;
  final String senderName;
  final String receiverId;
  final String text;
  final String paperColor; // 'rose', 'parchment', 'lavender', 'midnight'
  final String emoji;
  final DateTime createdAt;
  final bool isRead;
  final DateTime? readAt;

  const LoveNoteModel({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.receiverId,
    required this.text,
    this.paperColor = 'rose',
    this.emoji = '💌',
    required this.createdAt,
    this.isRead = false,
    this.readAt,
  });

  LoveNoteModel copyWith({
    String? id,
    String? senderId,
    String? senderName,
    String? receiverId,
    String? text,
    String? paperColor,
    String? emoji,
    DateTime? createdAt,
    bool? isRead,
    DateTime? readAt,
  }) {
    return LoveNoteModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      receiverId: receiverId ?? this.receiverId,
      text: text ?? this.text,
      paperColor: paperColor ?? this.paperColor,
      emoji: emoji ?? this.emoji,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'senderId': senderId,
    'senderName': senderName,
    'receiverId': receiverId,
    'text': text,
    'paperColor': paperColor,
    'emoji': emoji,
    'createdAt': createdAt.toIso8601String(),
    'isRead': isRead,
    'readAt': readAt?.toIso8601String(),
  };

  factory LoveNoteModel.fromJson(Map<String, dynamic> json) {
    return LoveNoteModel(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String? ?? 'Soulmate',
      receiverId: json['receiverId'] as String,
      text: json['text'] as String,
      paperColor: json['paperColor'] as String? ?? 'rose',
      emoji: json['emoji'] as String? ?? '💌',
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      isRead: json['isRead'] as bool? ?? false,
      readAt:
          json['readAt'] != null
              ? DateTime.tryParse(json['readAt'] as String)
              : null,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoveNoteModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          senderId == other.senderId &&
          senderName == other.senderName &&
          receiverId == other.receiverId &&
          text == other.text &&
          paperColor == other.paperColor &&
          emoji == other.emoji &&
          createdAt == other.createdAt &&
          isRead == other.isRead &&
          readAt == other.readAt;

  @override
  int get hashCode =>
      id.hashCode ^
      senderId.hashCode ^
      senderName.hashCode ^
      receiverId.hashCode ^
      text.hashCode ^
      paperColor.hashCode ^
      emoji.hashCode ^
      createdAt.hashCode ^
      isRead.hashCode ^
      readAt.hashCode;
}
