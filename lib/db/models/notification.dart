class Notification {
  final String id;
  final String userId;
  final String type;
  final String message;
  final DateTime? seenAt;
  final DateTime createdAt;

  Notification({
    required this.id,
    required this.userId,
    required this.type,
    required this.message,
    this.seenAt,
    required this.createdAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'],
      userId: json['user_id'],
      type: json['type'],
      message: json['message'],
      seenAt: json['seen_at'] != null ? DateTime.parse(json['seen_at']) : null,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'message': message,
      'seen_at': seenAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class NotificationPreview {
  final String id;
  final String type;
  final String message;
  final bool seen;
  final DateTime createdAt;

  NotificationPreview({
    required this.id,
    required this.type,
    required this.message,
    required this.seen,
    required this.createdAt,
  });

  factory NotificationPreview.fromJson(Map<String, dynamic> json) {
    return NotificationPreview(
      id: json['id'],
      type: json['type'],
      message: json['message'],
      seen: json['seen'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'message': message,
      'seen': seen,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
