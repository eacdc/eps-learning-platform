class ChatMessageModel {
  final String role;
  final String content;
  final bool isAudio;
  final String? audioFileId;
  final String? messageId;
  final String id;
  final String timestamp;

  ChatMessageModel({
    required this.role,
    required this.content,
    required this.isAudio,
    this.audioFileId,
    this.messageId,
    required this.id,
    required this.timestamp,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      role: json['role'] ?? '',
      content: json['content'] ?? '',
      isAudio: json['isAudio'] ?? false,
      audioFileId: json['audioFileId'],
      messageId: json['messageId'],
      id: json['_id'] ?? '',
      timestamp: json['timestamp'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'content': content,
      'isAudio': isAudio,
      'audioFileId': audioFileId,
      'messageId': messageId,
      '_id': id,
      'timestamp': timestamp,
    };
  }
}
