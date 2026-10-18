enum MessageSender { user, noor }

class AIMessageModel {
  final String id;
  final MessageSender sender;
  final String contentEn;
  final String contentTr;
  final DateTime timestamp;
  final String? suggestedActionPrompt;

  const AIMessageModel({
    required this.id,
    required this.sender,
    required this.contentEn,
    required this.contentTr,
    required this.timestamp,
    this.suggestedActionPrompt,
  });

  String content(bool isTr) => isTr ? contentTr : contentEn;

  AIMessageModel copyWith({
    String? id,
    MessageSender? sender,
    String? contentEn,
    String? contentTr,
    DateTime? timestamp,
    String? suggestedActionPrompt,
  }) {
    return AIMessageModel(
      id: id ?? this.id,
      sender: sender ?? this.sender,
      contentEn: contentEn ?? this.contentEn,
      contentTr: contentTr ?? this.contentTr,
      timestamp: timestamp ?? this.timestamp,
      suggestedActionPrompt:
          suggestedActionPrompt ?? this.suggestedActionPrompt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'sender': sender.name,
    'contentEn': contentEn,
    'contentTr': contentTr,
    'timestamp': timestamp.toIso8601String(),
    'suggestedActionPrompt': suggestedActionPrompt,
  };

  factory AIMessageModel.fromJson(Map<String, dynamic> json) {
    return AIMessageModel(
      id: json['id'] as String,
      sender:
          json['sender'] == 'user' ? MessageSender.user : MessageSender.noor,
      contentEn: json['contentEn'] as String,
      contentTr: json['contentTr'] as String,
      timestamp:
          DateTime.tryParse(json['timestamp'] as String? ?? '') ??
          DateTime.now(),
      suggestedActionPrompt: json['suggestedActionPrompt'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AIMessageModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          sender == other.sender &&
          contentEn == other.contentEn &&
          contentTr == other.contentTr &&
          timestamp == other.timestamp &&
          suggestedActionPrompt == other.suggestedActionPrompt;

  @override
  int get hashCode =>
      id.hashCode ^
      sender.hashCode ^
      contentEn.hashCode ^
      contentTr.hashCode ^
      timestamp.hashCode ^
      suggestedActionPrompt.hashCode;
}
