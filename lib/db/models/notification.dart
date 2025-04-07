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
}
