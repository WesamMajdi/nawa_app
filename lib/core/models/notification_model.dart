class NotificationModel {
  final String id;
  final String type;
  final String title;
  final String text;
  final String? icon;
  final String? color;
  final bool isRead;
  final String? linkUrl;
  final DateTime? createdAt;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.text,
    this.icon,
    this.color,
    this.isRead = false,
    this.linkUrl,
    this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      text: json['text'] as String,
      icon: json['icon'] as String?,
      color: json['color'] as String?,
      isRead: json['isRead'] as bool? ?? false,
      linkUrl: json['linkUrl'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }
}
