import 'dart:convert';

class SupplierPakanItem {
  final int id;
  final List<String> imageUrl;
  final String judul;
  final String detail;
  final String khasiat;
  final List<int> kategori;
  final bool isStok;
  final int harga;
  final int noTlp;
  final String alamatOverview;
  final String alamat;
  final String mapsLink;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SupplierPakanItem({
    required this.id,
    required this.imageUrl,
    required this.judul,
    required this.detail,
    required this.khasiat,
    required this.kategori,
    required this.isStok,
    required this.harga,
    required this.noTlp,
    required this.alamatOverview,
    required this.alamat,
    required this.mapsLink,
    this.createdAt,
    this.updatedAt,
  });

  factory SupplierPakanItem.fromJson(Map<String, dynamic> json) {
    int kategoriId = json['kategori_id'] as int;
    return SupplierPakanItem(
      id: json['id'] as int,
      imageUrl: (json['image_url'] is String)
          ? List<String>.from(jsonDecode(json['image_url']))
          : List<String>.from(json['image_url']),
      judul: json['judul'] as String,
      detail: json['detail'] as String,
      khasiat: json['khasiat'] as String,
      kategori: [0, kategoriId],
      isStok: (json['is_stok'] == 1 || json['is_stok'] == true),
      harga: json['harga'] as int,
      noTlp: json['no_tlp'] as int,
      alamatOverview: json['alamat_overview'] as String,
      alamat: json['alamat'] as String,
      mapsLink: json['maps_link'] as String,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_url': jsonEncode(imageUrl),
      'judul': judul,
      'detail': detail,
      'khasiat': khasiat,
      'kategori': kategori,
      'is_stok': isStok ? 1 : 0,
      'harga': harga,
      'no_tlp': noTlp,
      'alamat_overview': alamatOverview,
      'alamat': alamat,
      'maps_link': mapsLink,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}