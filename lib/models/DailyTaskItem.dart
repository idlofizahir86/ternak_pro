class DailyTaskItem {
  final String title;
  final String status;
  final String catatan;
  final String time;
  final String iconPath;

  DailyTaskItem({
    required this.title,
    required this.status,
    required this.catatan,
    required this.time,
    required this.iconPath,
  });

  // Fungsi untuk membuat objek DailyTaskItem dari JSON
  factory DailyTaskItem.fromJson(Map<String, dynamic> json) {
    return DailyTaskItem(
      title: json['nama_tugas'] ?? 'No Title',
      status: json['status_tugas'] ?? 'No Status',
      time: json['waktu_tugas'] ?? 'No Time',
      catatan: json['catatan'] ?? 'No Catatan',
      iconPath: json['icon_path'] ?? 'assets/home_assets/icons/ic_default.png',
    );
  }

  // Fungsi untuk mengonversi DailyTaskItem kembali ke Map<String, dynamic>
  Map<String, dynamic> toJson() {
    return {
      'nama_tugas': title,
      'status_tugas': status,
      'catatan': catatan,
      'waktu_tugas': time,
      'icon_path': iconPath,
    };
  }
}
