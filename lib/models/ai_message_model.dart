enum MessageSender { user, noor }

class AIMessageModel {
  final String id;
  final MessageSender sender;
  final String contentEn;
  final String contentTr;
  final DateTime timestamp;
  final String? suggestedActionPrompt;

  AIMessageModel({
    required this.id,
    required this.sender,
    required this.contentEn,
    required this.contentTr,
    required this.timestamp,
    this.suggestedActionPrompt,
  });

  String content(bool isTr) => isTr ? contentTr : contentEn;

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
      sender: json['sender'] == 'user'
          ? MessageSender.user
          : MessageSender.noor,
      contentEn: json['contentEn'] as String,
      contentTr: json['contentTr'] as String,
      timestamp:
          DateTime.tryParse(json['timestamp'] as String? ?? '') ?? DateTime.now(),
      suggestedActionPrompt: json['suggestedActionPrompt'] as String?,
    );
  }
}
