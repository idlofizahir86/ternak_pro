import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:ternak_pro/shared/theme.dart';
import '../../shared/widgets/tips_harian/custom_app_bar.dart';

class TipsHarianDetailPage extends StatefulWidget {
  const TipsHarianDetailPage({super.key});

  @override
  State<TipsHarianDetailPage> createState() => _TipsHarianDetailPageState();
}

class _TipsHarianDetailPageState extends State<TipsHarianDetailPage> {
  String? tipsId;
  bool isLoading = true;
  Map<String, dynamic>? detailData;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final id = args?['id']?.toString();
      if (id != null) _fetchDetail(id);
    });
  }

  Future<void> _fetchDetail(String id) async {
    // Contoh dummy: ganti dengan fetch dari API
    await Future.delayed(const Duration(seconds: 1)); // simulasi loading

    final dummyResponse = {
      'tips_id': id,
      'imageUrl': "assets/home_assets/images/dummy_1.png",
      'title':
          'Tips Menjaga Kesehatan Ternak Agar Tidak Mudah Sakit, Biar Makin Profit',
      'kategori_detail': 'Kesehatan Ternak',
      'created_at': '10 Agustus 2025',
      'author': 'Idlofi',
      'content': '''
<p><strong>Ternak Pro, Jakarta</strong> — Menjaga kesehatan ternak bukan hanya soal kepedulian terhadap hewan, tapi juga kunci keberhasilan usaha peternakan. Ternak yang sehat tumbuh optimal, produktif, dan tentu saja menguntungkan. Sebaliknya, ternak yang sering sakit bisa menggerus keuntungan karena biaya pengobatan dan penurunan produksi. Berikut ini beberapa tips praktis yang bisa diterapkan peternak agar ternaknya tetap sehat dan hasil ternak pun makin cuan:</p>

<h3>1. Perhatikan Kebersihan Kandang</h3>
<p>Kandang yang kotor adalah sumber penyakit. Pastikan kandang dibersihkan secara rutin, kotoran dibuang setiap hari, dan sirkulasi udara cukup baik. Gunakan alas kandang yang mudah dibersihkan dan kering untuk mencegah infeksi.</p>

<h3>2. Berikan Pakan Bergizi &amp; Berkualitas</h3>
<p>Pakan yang bergizi akan memperkuat sistem imun ternak. Pastikan pakan mengandung karbohidrat, protein, vitamin, dan mineral yang cukup. Hindari pakan basi atau tercemar jamur karena bisa menyebabkan keracunan atau penyakit pencernaan.</p>
'''
    };

    setState(() {
      detailData = dummyResponse;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (detailData == null) {
      return const Scaffold(
        body: Center(child: Text("Data tidak ditemukan")),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: CustomAppBar(detailData!['kategori_detail']),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              detailData!['title'],
              style: AppTextStyle.semiBold.copyWith(
                fontSize: 20,
                color: AppColors.black03,
              ),
            ),
            const SizedBox(height: 13),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.green01),
                      ),
                      child: Text(
                        detailData!['kategori_detail'],
                        style: AppTextStyle.regular.copyWith(
                          fontSize: 12,
                          color: AppColors.green01,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      detailData!['created_at'],
                      style: AppTextStyle.regular.copyWith(
                        fontSize: 12,
                        color: AppColors.black04,
                      ),
                    ),
                  ],
                ),
                Text(
                  detailData!['author'],
                  style: AppTextStyle.regular.copyWith(
                    fontSize: 12,
                    color: AppColors.black01,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                detailData!['imageUrl'],
                width: double.infinity,
                height: 215,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Html(
              data: detailData!['content'],
              style: {
                "p": Style(
                  color: AppColors.black04,
                  fontSize: FontSize(14),
                  lineHeight: LineHeight.number(1.5),
                  margin: Margins.only(bottom: 12),
                ),
                "h3": Style(
                  color: AppColors.black03,
                  fontWeight: FontWeight.w700,
                  fontSize: FontSize(18),
                  margin: Margins.only(top: 12, bottom: 8),
                ),
              },
            ),
          ],
        ),
      ),
    );
  }
}
