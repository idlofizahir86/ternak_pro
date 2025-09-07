class DailyTaskItem {
  final int idTugas;
  final String title;
  final String status;
  final int statusId;
  final String catatan;
  final String time;
  final String tglTugas;
  final String iconPath;

  DailyTaskItem({
    required this.idTugas,
    required this.title,
    required this.status,
    required this.statusId,
    required this.catatan,
    required this.time,
    required this.tglTugas, 
    required this.iconPath,
  });

  // Fungsi untuk membuat objek DailyTaskItem dari JSON
  factory DailyTaskItem.fromJson(Map<String, dynamic> json) {
    return DailyTaskItem(
      idTugas: json['id_tugas'] ?? 0,
      title: json['nama_tugas'] ?? 'No Title',
      statusId: json['status_tugas_id'] ?? 0,
      status: json['status_tugas'] ?? 'No Status',
      time: json['waktu_tugas'] ?? 'No Time',
      tglTugas: json['tgl_tugas'] ?? '2025-01-01',
      catatan: json['catatan'] ?? '',
      iconPath: json['icon_path'] ?? 'assets/home_assets/icons/ic_default.png',
    );
  }

  // Fungsi untuk mengonversi DailyTaskItem kembali ke Map<String, dynamic>
  Map<String, dynamic> toJson() {
    return {
      'id_tugas': idTugas,
      'nama_tugas': title,
      'status_tugas_id': statusId,
      'status_tugas': status,
      'catatan': catatan,
      'waktu_tugas': time,
      'tgl_tugas': tglTugas,
      'icon_path': iconPath,
    };
  }
}
