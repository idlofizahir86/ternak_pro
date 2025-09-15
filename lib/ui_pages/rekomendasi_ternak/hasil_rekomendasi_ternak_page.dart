import 'package:flutter/material.dart';

import '../../shared/theme.dart';

class HasilRekomendasiTernakPage extends StatelessWidget {
  final Map<String, dynamic> recommendationData;

  const HasilRekomendasiTernakPage({super.key, required this.recommendationData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hasil Rekomendasi Ternak', style: AppTextStyle.semiBold),
        backgroundColor: AppColors.primaryWhite,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.blackText),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul Jenis Hewan
            Center(
              child: Text(
                recommendationData['jenis_hewan'] ?? 'Ternak',
                style: AppTextStyle.semiBold.copyWith(fontSize: 24),
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                recommendationData['alasan'] ?? 'Tidak ada alasan.',
                textAlign: TextAlign.center,
                style: AppTextStyle.regular.copyWith(fontSize: 14),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/rekomendasi_ternak_assets/icons/ic_money.png', width: 16, height: 16,),
                        const SizedBox(width: 4),
                        Text('Biaya Awal', style: AppTextStyle.medium.copyWith(fontSize: 14))
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('Rp ${recommendationData['biaya_awal']?.toStringAsFixed(0) ?? '0'}', style: AppTextStyle.semiBold.copyWith(fontSize: 16)),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/rekomendasi_ternak_assets/icons/ic_arrow_top.png', width: 16, height: 16,),
                        const SizedBox(width: 4),
                        Text('Potensi Untung', style: AppTextStyle.medium.copyWith(fontSize: 14))
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('Rp ${recommendationData['potensi_keuntungan']?.toStringAsFixed(0) ?? '0'}', style: AppTextStyle.semiBold.copyWith(fontSize: 16)),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/rekomendasi_ternak_assets/icons/ic_cheklist_no-fill.png', width: 16, height: 16,),
                        const SizedBox(width: 4),
                        Text('ROI', style: AppTextStyle.medium.copyWith(fontSize: 14))
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('${recommendationData['roi']?.toStringAsFixed(1) ?? '0'}%', style: AppTextStyle.semiBold.copyWith(fontSize: 16)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/rekomendasi_ternak_assets/icons/ic_checklist.png', width: 18, height: 18,),
                        const SizedBox(width: 4),
                        Text('Kesesuaian Kondisi', style: AppTextStyle.medium.copyWith(fontSize: 16))
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('${recommendationData['kesesuaian_kondisi']?.toStringAsFixed(1) ?? '0'}%', style: AppTextStyle.semiBold.copyWith(fontSize: 18)),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/rekomendasi_ternak_assets/icons/ic_minta.png', width: 18, height: 18,),
                        const SizedBox(width: 4),
                        Text('Permintaan Pasar', style: AppTextStyle.medium.copyWith(fontSize: 16))
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('${recommendationData['permintaan_pasar']?.toStringAsFixed(1) ?? '0'}%', style: AppTextStyle.semiBold.copyWith(fontSize: 18)),
                  ],
                ),

              ],
            ),
            SizedBox(height: 8,),
            Divider(),
            const SizedBox(height: 14),
            // Deskripsi
            Text(
              'Deskripsi',
              style: AppTextStyle.extraBold.copyWith(fontSize: 18),
            ),
            Text(
              recommendationData['deskripsi'] ?? 'Tidak ada deskripsi.',
              style: AppTextStyle.medium.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 16),
            // Kebutuhan Pakan
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/rekomendasi_ternak_assets/icons/ic_plant.png', width: 18, height: 18,),
                SizedBox(width: 4),
                Text(
                  'Kebutuhan Pakan',
                  style: AppTextStyle.extraBold.copyWith(fontSize: 18),
                ),
              ],
            ),
            ...(recommendationData['kebutuhan_pakan'] as List<dynamic>?)?.map((pakan) => Text(
                  '• $pakan',
                  style: AppTextStyle.regular.copyWith(fontSize: 16),
                )) ??
                [Text('Tidak ada data pakan.', style: AppTextStyle.regular)],
            const SizedBox(height: 16),
            // Resiko Kesehatan
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/rekomendasi_ternak_assets/icons/ic_danger.png', width: 20, height: 20,),
                SizedBox(width: 4),
                Text(
                  'Resiko Kesehatan',
                  style: AppTextStyle.extraBold.copyWith(fontSize: 18),
                ),
              ],
            ),
            ...(recommendationData['resiko_kesehatan'] as List<dynamic>?)?.map((resiko) => Text(
                  '• $resiko',
                  style: AppTextStyle.regular.copyWith(fontSize: 16),
                )) ??
                [Text('Tidak ada data resiko.', style: AppTextStyle.regular)],
            const SizedBox(height: 16),
            // Tips
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: AppColors.greenTips,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset('assets/rekomendasi_ternak_assets/icons/ic_lamp.png', width: 20, height: 20,),
                      SizedBox(width: 4),
                      Text(
                        'Tips Singkat',
                        style: AppTextStyle.extraBold.copyWith(fontSize: 18),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  ...(recommendationData['tips'] as List<dynamic>?)?.map((tip) => Text(
                  '• $tip',
                  style: AppTextStyle.regular.copyWith(fontSize: 16),
                )) ??
                [Text('Tidak ada tips.', style: AppTextStyle.regular)],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyle.regular.copyWith(fontSize: 16)),
          Text(value, style: AppTextStyle.semiBold.copyWith(fontSize: 16)),
        ],
      ),
    );
  }
}
