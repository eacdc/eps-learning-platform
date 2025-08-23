class AllNotificationModel {
  String? id;
  String? userId;
  String? title;
  String? message;
  String? seenStatus;
  String? createdAt;
  String? templateId;
  String? type;
  String? category;
  String? priority;
  int? v;

  AllNotificationModel({
    this.id,
    this.userId,
    this.title,
    this.message,
    this.seenStatus,
    this.createdAt,
    this.templateId,
    this.type,
    this.category,
    this.priority,
    this.v,
  });

  factory AllNotificationModel.fromJson(Map<String, dynamic> json) {
    return AllNotificationModel(
      id: json['_id'] as String?,
      userId: json['userId'] as String?,
      title: json['title'] as String?,
      message: json['message'] as String?,
      seenStatus: json['seen_status'] as String?,
      createdAt: json['created_at'] as String?,
      templateId: json['templateId'] as String?,
      type: json['type'] as String?,
      category: json['category'] as String?,
      priority: json['priority'] as String?,
      v: json['__v'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'title': title,
      'message': message,
      'seen_status': seenStatus,
      'created_at': createdAt,
      'templateId': templateId,
      'type': type,
      'category': category,
      'priority': priority,
      '__v': v,
    };
  }
}
