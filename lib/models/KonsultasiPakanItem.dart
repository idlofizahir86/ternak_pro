import 'package:intl/intl.dart';

final _timeFormat = DateFormat.Hms(); // "HH:mm:ss"

// Helper: terima "08:00:00" atau "1970-01-01T08:00:00Z" dst.
DateTime _parseTimeToDateTime(String? v) {
  if (v == null || v.isEmpty) {
    return DateTime(1970, 1, 1, 0, 0, 0);
  }
  final s = v.trim();

  // Jika sudah ISO lengkap → langsung parse
  if (RegExp(r'\d{4}-\d{2}-\d{2}').hasMatch(s)) {
    return DateTime.tryParse(s) ?? DateTime(1970, 1, 1, 0, 0, 0);
  }

  // Jika hanya "HH:mm" atau "HH:mm:ss" → tempel tanggal dummy
  final hhmmss = RegExp(r'^\d{2}:\d{2}(:\d{2})?$');
  if (hhmmss.hasMatch(s)) {
    final withSec = s.length == 5 ? '$s:00' : s; // "HH:mm" → "HH:mm:ss"
    return DateTime.tryParse('1970-01-01 $withSec') ??
        DateTime(1970, 1, 1, 0, 0, 0);
  }

  // Fallback aman
  return DateTime(1970, 1, 1, 0, 0, 0);
}


class KonsultasiPakanItem {
  final int id;
  final String imageUrl;
  final String nama;
  final List<int> kategori;
  final int harga;
  final int durasi;
  final String noTlp;
  final String spealis;
  final String lokasiPraktik;
  final DateTime pukulMulai;
  final DateTime pukulAkhir;
  final String pendidikan;
  final String pengalaman;
  final String fokusKonsultasi;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  KonsultasiPakanItem({
    required this.id,
    required this.imageUrl,
    required this.nama,
    required this.kategori,
    required this.harga,
    required this.durasi,
    required this.noTlp,
    required this.spealis,
    required this.lokasiPraktik,
    required this.pukulMulai,
    required this.pukulAkhir,
    required this.pendidikan,
    required this.pengalaman,
    required this.fokusKonsultasi,
    this.createdAt,
    this.updatedAt,
  });

  /// Factory untuk parsing dari JSON Map
  factory KonsultasiPakanItem.fromJson(Map<String, dynamic> json) {
    int kategoriId = json['kategori_id'] as int;
    return KonsultasiPakanItem(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      imageUrl: json['image_url'] ?? '',
      nama: json['nama'] ?? '',
      kategori: [0, kategoriId],
      harga: json['harga'] is int
          ? json['harga']
          : int.tryParse(json['harga'].toString()) ?? 0,
      durasi: json['durasi'] is int
          ? json['durasi']
          : int.tryParse(json['durasi'].toString()) ?? 0,
      noTlp: json['no_tlp'].toString(),
      spealis: json['spealis'] ?? '',
      lokasiPraktik: json['lokasi_praktik'] ?? '',
      pukulMulai: _parseTimeToDateTime(json['pukul_mulai']?.toString()),
      pukulAkhir: _parseTimeToDateTime(json['pukul_akhir']?.toString()),
      pendidikan: json['pendidikan'] ?? '',
      pengalaman: json['pengalaman'] ?? '',
      fokusKonsultasi: json['fokus_konsultasi'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }

  /// Ubah ke JSON Map (untuk post/put)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_url': imageUrl,
      'nama': nama,
      'kategori': kategori,
      'harga': harga,
      'durasi': durasi,
      'no_tlp': noTlp,
      'spealis': spealis,
      'lokasi_praktik': lokasiPraktik,
      'pukul_mulai': _timeFormat.format(pukulMulai),
      'pukul_akhir': _timeFormat.format(pukulAkhir),
      'pendidikan': pendidikan,
      'pengalaman': pengalaman,
      'fokus_konsultasi': fokusKonsultasi,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
