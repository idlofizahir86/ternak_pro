class Ternakitem {
  final int idTernak;
  final String tagId;
  final String namaTernak;
  final String jenisHewan;
  final String iconPath;
  final double berat;
  final int usia;
  final String kondisiTernak;
  final String jenisKelamin;
  final String tglMulai;
  final String catatan;

  Ternakitem({
    required this.idTernak,
    required this.tagId,
    required this.namaTernak,
    required this.jenisHewan,
    required this.iconPath,
    required this.berat,
    required this.usia,
    required this.kondisiTernak,
    required this.jenisKelamin,
    required this.tglMulai,
    required this.catatan,
  });

  factory Ternakitem.fromJson(Map<String, dynamic> json) {
    return Ternakitem(
      idTernak: json['id_ternak'],
      tagId: json['tag_id'],
      namaTernak: json['nama_ternak'],
      jenisHewan: json['jenis_hewan'],
      iconPath: json['icon_path'],
      berat: (json['berat'] as num).toDouble(),
      usia: json['usia'],
      kondisiTernak: json['kondisi_ternak'],
      jenisKelamin: json['jenis_kelamin'],
      tglMulai: json['tgl_mulai'],
      catatan: json['catatan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_ternak': idTernak,
      'tag_id': tagId,
      'nama_ternak': namaTernak,
      'jenis_hewan': jenisHewan,
      'icon_path': iconPath,
      'berat': berat,
      'usia': usia,
      'kondisi_ternak': kondisiTernak,
      'jenis_kelamin': jenisKelamin,
      'tgl_mulai': tglMulai,
      'catatan': catatan,
    };
  }
}