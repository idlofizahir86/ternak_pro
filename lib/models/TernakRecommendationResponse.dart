class TernakRecommendationResponse {
  final String jenisHewan;
  final String alasan;
  final num biayaAwal;
  final num potensiKeuntungan;
  final double roi;                // persen (sudah di-round by controller)
  final double kesesuaianKondisi;  // persen
  final double permintaanPasar;    // persen
  final String deskripsi;
  final List<String> kebutuhanPakan;
  final List<String> resikoKesehatan;
  final List<String> tips;

  TernakRecommendationResponse({
    required this.jenisHewan,
    required this.alasan,
    required this.biayaAwal,
    required this.potensiKeuntungan,
    required this.roi,
    required this.kesesuaianKondisi,
    required this.permintaanPasar,
    required this.deskripsi,
    required this.kebutuhanPakan,
    required this.resikoKesehatan,
    required this.tips,
  });

  factory TernakRecommendationResponse.fromJson(Map<String, dynamic> json) {
    return TernakRecommendationResponse(
      jenisHewan: json['jenis_hewan']?.toString() ?? '',
      alasan: json['alasan']?.toString() ?? '',
      biayaAwal: (json['biaya_awal'] ?? 0) as num,
      potensiKeuntungan: (json['potensi_keuntungan'] ?? 0) as num,
      roi: (json['roi'] is int)
          ? (json['roi'] as int).toDouble()
          : (json['roi'] as num?)?.toDouble() ?? 0.0,
      kesesuaianKondisi: (json['kesesuaian_kondisi'] is int)
          ? (json['kesesuaian_kondisi'] as int).toDouble()
          : (json['kesesuaian_kondisi'] as num?)?.toDouble() ?? 0.0,
      permintaanPasar: (json['permintaan_pasar'] is int)
          ? (json['permintaan_pasar'] as int).toDouble()
          : (json['permintaan_pasar'] as num?)?.toDouble() ?? 0.0,
      deskripsi: json['deskripsi']?.toString() ?? '',
      kebutuhanPakan: (json['kebutuhan_pakan'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      resikoKesehatan: (json['resiko_kesehatan'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      tips: (json['tips'] as List?)?.map((e) => e.toString()).toList() ?? const [],
    );
  }
}