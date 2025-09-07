import 'package:intl/intl.dart';

class TipsItem {
  final int id;
  final String imageUrl;
  final String judul;
  final String author;
  final String konten;
  final List<int> kategori;
  final String kategoriDetail;
  final DateTime createdAt;
  final DateTime updatedAt;

  TipsItem({
    required this.id,
    required this.imageUrl,
    required this.judul,
    required this.author,
    required this.konten,
    required this.kategori,
    required this.kategoriDetail,
    required this.createdAt,
    required this.updatedAt,
  });

  String get formattedCreatedAt => DateFormat('dd MMMM yyyy', 'id_ID').format(createdAt);
  String get formattedUpdatedAt => DateFormat('dd MMMM yyyy', 'id_ID').format(updatedAt);

  factory TipsItem.fromJson(Map<String, dynamic> json) {
    return TipsItem(
      id: json['id'],
      imageUrl: json['image_url'],
      judul: json['judul'],
      author: json['author'],
      konten: json['konten'],
      kategori: List<int>.from(json['kategori']),
      kategoriDetail: json['kategori_detail'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // Convert to JSON for caching
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'judul': judul,
      'author': author,
      'konten': konten,
      'kategori': kategori,
      'kategoriDetail': kategoriDetail,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

}

// Contoh data
final tipsItemExample = TipsItem.fromJson({
  "id": 1,
  "image_url": "https://pbs.twimg.com/media/GzFjjgTbIAAFoUi.jpg",
  "judul": "Dari Unggas hingga Sapi Perah, Industrial Lectures 2025 Kupas Tren Peternakan",
  "author": "Satria",
  "konten": "<p><strong>Fapet UGM, Yogyakarta</strong> — Fakultas Peternakan UGM menggelar Industrial Lectures 2025 untuk membahas tren peternakan dari unggas hingga sapi perah. Acara ini bertujuan memperkenalkan perkembangan industri ternak nasional dan global.</p><h3>1. Wawasan Ahli dan Keterlibatan Profesional</h3><p>Acara menghadirkan profesional dari perusahaan ternak terkemuka untuk berbagi pengetahuan tentang peluang bisnis dan tren di sektor poultry.</p><h3>2. Peran Insinyur Peternakan</h3><p>Ditekankan peran penting insinyur peternakan dalam transformasi sektor untuk mencapai Indonesia Emas 2045 melalui inovasi dan kolaborasi.</p>",
  "kategori": [1, 4],
  "kategori_detail": "Bisnis Peternakan",
  "created_at": "2025-08-24T15:26:33.000000Z",
  "updated_at": "2025-08-24T15:26:33.000000Z"
});
