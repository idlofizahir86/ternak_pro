import 'package:flutter/material.dart';
import 'package:ternak_pro/shared/theme.dart';
import '../../shared/widgets/tips_harian/custom_app_bar.dart';

class TipsHarianPage extends StatefulWidget {
  const TipsHarianPage({super.key});

  @override
  State<TipsHarianPage> createState() => _TipsHarianPageState();
}

class _TipsHarianPageState extends State<TipsHarianPage> {
  // --- DATA DUMMY (sesuai punyamu) ---
  final List<Map<String, String>> kategoriList = const [
    {'kategori_id': 'K001', 'kategori_name': 'Semua'},
    {'kategori_id': 'K002', 'kategori_name': 'Kesehatan'},
    {'kategori_id': 'K003', 'kategori_name': 'Perawatan'},
    {'kategori_id': 'K004', 'kategori_name': 'Bisnis'},
  ];

  final List<Map<String, dynamic>> tipsList = [
    {
      'tips_id': '001',
      'imageUrl': "assets/home_assets/images/dummy_1.png",
      'title':
          'Tips Menjaga Kesehatan Ternak Agar Tidak Mudah Sakit, Biar Makin Profit',
      'kategori': ['K001', 'K002', 'K003'],
      'kategori_detail': 'Kesehatan Ternak',
    },
    {
      'tips_id': '002',
      'imageUrl': "assets/home_assets/images/dummy_2.png",
      'title': 'Bagaimana Perawatan Ternak Yang Baik Menurut Para Ahli',
      'kategori': ['K001', 'K004'],
      'kategori_detail': 'Manajemen Peternakan',
    },
    {
      'tips_id': '003',
      'imageUrl': "assets/home_assets/images/dummy_2.png",
      'title':
          'Kunci Peternakan Tertib: Cara Atur Data, Jadwal, dan Biaya Harian Ternak',
      'kategori': ['K001', 'K003', 'K004'],
      'kategori_detail': 'Teknologi Peternakan',
    },
    {
      'tips_id': '004',
      'imageUrl': "assets/home_assets/images/dummy_2.png",
      'title':
          'Inovasi Tanpa Ribet: Cara Gunakan Teknologi untuk Bantu Urus Ternak Harian',
      'kategori': ['K001', 'K004', 'K003'],
      'kategori_detail': 'Kesehatan Ternak',
    },
    {
      'tips_id': '005',
      'imageUrl': "assets/home_assets/images/dummy_2.png",
      'title': 'Jadwal Vaksinasi & Vitamin Ternak: Panduan Wajib Peternak',
      'kategori': ['K001', 'K002', 'K003'],
      'kategori_detail': 'Kesehatan Ternak',
    },
    {
      'tips_id': '006',
      'imageUrl': "assets/home_assets/images/dummy_2.png",
      'title':
          'Rahasia Peternak Sukses: Cara Mengubah Ternak Jadi Aset Menguntungkan',
      'kategori': ['K001', 'K004', 'K003'],
      'kategori_detail': 'Bisnis Peternakan',
    },
    {
      'tips_id': '007',
      'imageUrl': "assets/home_assets/images/dummy_2.png",
      'title':
          'Rahasia Peternak Sukses: Cara Mengubah Ternak Jadi Aset Menguntungkan',
      'kategori': ['K001', 'K002'],
      'kategori_detail': 'Kesehatan Ternak',
    },
  ];

  // --- STATE: default pilih "Semua" ---
  String selectedKategoriId = 'K001';

  List<Map<String, dynamic>> get _filteredTips {
    // Jika "Semua", tampilkan semua
    if (selectedKategoriId == 'K001') return tipsList;
    // Selain itu, filter berdasarkan array 'kategori'
    return tipsList
        .where((t) => (t['kategori'] as List).contains(selectedKategoriId))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: CustomAppBar('Tips Harian'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- KATEGORI (horizontal) ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: kategoriList.map((k) {
                  final id = k['kategori_id']!;
                  final name = k['kategori_name']!;
                  return GestureDetector(
                    onTap: () => setState(() => selectedKategoriId = id),
                    child: TipsKategoriItem(
                      isActive: selectedKategoriId == id,
                      title: name,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // --- LIST ITEM TIPS (mengikuti kategori terpilih) ---
          Expanded(
            child: ListView.builder(
              itemCount: _filteredTips.length,
              itemBuilder: (context, index) {
                final item = _filteredTips[index];
                return TipsOnlyItem(
                  imageUrl: item['imageUrl'] as String,
                  kategori: item['kategori_detail'] as String,
                  title: item['title'] as String,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/tips-harian-detail',
                      arguments: {'id': item['tips_id'].toString()}, // contoh: {'id': '007'}
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


class TipsOnlyItem extends StatelessWidget {
  final String imageUrl;
  final String kategori;
  final String title;
  final VoidCallback? onTap;
  const TipsOnlyItem({
    super.key, 
    required this.imageUrl, 
    required this.kategori, 
    required this.title, 
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(
          left: 24,
          top: 13,
          bottom: 30,
        ),
        decoration: BoxDecoration(
          border: BoxBorder.fromLTRB(
            bottom: BorderSide(
              color: AppColors.black10,
              style: BorderStyle.solid
            )
          )
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 6),
            
            // Expanded biar teks menyesuaikan sisa ruang
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 3),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.blue0120,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      kategori,
                      style: AppTextStyle.regular.copyWith(
                        fontSize: 12,
                        color: AppColors.blue01,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 13),
                  Text(
                    title,
                    style: AppTextStyle.regular.copyWith(
                      fontSize: 12,
                      color: AppColors.black04,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TipsKategoriItem extends StatelessWidget {
  final bool isActive;
  final String title;
  const TipsKategoriItem({
    super.key, 
    required this.isActive, 
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.green01,
        ),
        color: isActive? AppColors.green01 : AppColors.bgLight,
      ),
      child: Text(
        title, 
        style: AppTextStyle.regular.copyWith(
          fontSize: 12,
          color: isActive ? AppColors.bgLight : AppColors.green01,
        ),
      ),
    );
  }
}
