class KeuanganItem {
  final int idKeuangan;
  final bool isPengeluaran;
  final int nominalTotal;
  final String dariTujuan;
  final int asetId;
  final String namaAset;
  final DateTime tglKeuangan;
  final String catatan;

  KeuanganItem({
    required this.idKeuangan,
    required this.isPengeluaran,
    required this.nominalTotal,
    required this.dariTujuan,
    required this.asetId,
    required this.namaAset,
    required this.tglKeuangan,
    required this.catatan,
  });

  factory KeuanganItem.fromJson(Map<String, dynamic> json) {
    return KeuanganItem(
      idKeuangan: json['id_keuangan'] as int,
      isPengeluaran: json['is_pengeluaran'] as bool,
      nominalTotal: json['nominal_total'] as int,
      dariTujuan: json['dari_tujuan'] as String,
      asetId: json['aset_id'] as int,
      namaAset: json['nama_aset'] as String,
      tglKeuangan: DateTime.parse(json['tgl_keuangan'] as String),
      catatan: json['catatan'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_keuangan': idKeuangan,
      'is_pengeluaran': isPengeluaran,
      'nominal_total': nominalTotal,
      'dari_tujuan': dariTujuan,
      'aset_id': asetId,
      'nama_aset': namaAset,
      'tgl_keuangan': tglKeuangan.toIso8601String(),
      'catatan': catatan,
    };
  }
}