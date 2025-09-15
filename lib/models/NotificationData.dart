// Data model untuk notifikasi
class NotificationData {
  final int id;
  final String title;
  final String message;
  final String iconPath;
  bool isRead;

  NotificationData({
    required this.id,
    required this.title,
    required this.message,
    required this.iconPath,
    this.isRead = false,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      id: json['id'] ,
      title: json['title'] ?? '',
      message: json['content'] ?? '',
      iconPath: json['iconPath'] ?? '',
      isRead: false,
    );
  }
}