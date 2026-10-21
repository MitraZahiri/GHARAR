import 'package:flutter/foundation.dart';

/// What a love note carries: typed text, a finger-drawn note or a photo.
enum LoveNoteKind {
  text,
  drawing,
  photo;

  static LoveNoteKind fromName(String? name) =>
      values.where((k) => k.name == name).firstOrNull ?? text;
}

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
  final LoveNoteKind kind;

  /// Local file path of the drawing/photo; null for text notes.
  final String? imagePath;

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
    this.kind = LoveNoteKind.text,
    this.imagePath,
  });

  bool get hasImage => imagePath != null && kind != LoveNoteKind.text;

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
    LoveNoteKind? kind,
    String? imagePath,
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
      kind: kind ?? this.kind,
      imagePath: imagePath ?? this.imagePath,
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
    'kind': kind.name,
    'imagePath': imagePath,
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
      kind: LoveNoteKind.fromName(json['kind'] as String?),
      imagePath: json['imagePath'] as String?,
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
          readAt == other.readAt &&
          kind == other.kind &&
          imagePath == other.imagePath;

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
      readAt.hashCode ^
      kind.hashCode ^
      imagePath.hashCode;
}
