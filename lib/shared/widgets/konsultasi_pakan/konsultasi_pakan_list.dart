import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ternak_pro/shared/theme.dart';

import '../../../ui_pages/konsultasi_pakan/konsultasi_pakan_detail_page.dart'; // Tambahkan import ini

class KonsultasiPakanItem extends StatelessWidget {
  final String imageUrl;
  final String nama;
  final String spealis; // ejaan mengikuti field map
  final String pukulMulai; // "HH:mm:ss"
  final String pukulAkhir; // "HH:mm:ss"
  final int harga;
  final int durasi; // menit / jam sesuai datamu
  final VoidCallback? onTap;

  const KonsultasiPakanItem({
    super.key,
    required this.imageUrl,
    required this.nama,
    required this.spealis,
    required this.pukulMulai,
    required this.pukulAkhir,
    required this.harga,
    required this.durasi,
    this.onTap,
  });

  String formatRupiah(int value) {
    final formatter = NumberFormat('#,###', 'id_ID');
    return formatter.format(value).replaceAll(',', '.');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.blue01,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
               // kalau pakai CircleAvatar (harus radius = diameter / 2)
                CircleAvatar(
                  radius: 37.5, // diameter = 75
                  backgroundColor: AppColors.green01,
                  backgroundImage: AssetImage(imageUrl),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nama,
                      style: AppTextStyle.semiBold.copyWith(
                        fontSize: 14,
                        color: AppColors.black100,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      spealis,
                      style: AppTextStyle.semiBold.copyWith(
                        fontSize: 14,
                        color: AppColors.blue01,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Image.asset(
                        'assets/konsultasi_pakan_assets/icons/ic_time.png',
                        width: 14,
                        height: 14,),
                        SizedBox(width: 5),
                        Text(
                          "$pukulMulai - $pukulAkhir" ' WIB',
                          style: AppTextStyle.medium.copyWith(
                            fontSize: 14,
                            color: AppColors.black100,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
                          
              ],
            ),
            SizedBox(height: 17),
            GestureDetector(
                onTap: onTap,
                child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppColors.gradasi01,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                child: Text(
                      'Jadwalkan Konsultasi',
                      style: AppTextStyle.medium.copyWith(
                        color: AppColors.white100,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    ),
                  ),
              ),
          ],
        ),
      ),
    );
  }
}

class KonsultasiPakanList extends StatelessWidget {
  final String searchQuery;

  KonsultasiPakanList({
    super.key,
    this.searchQuery = '',
  });

  final List<Map<String, dynamic>> items = [
  {
      'id': 1,
      'image_url': 'assets/supplier_pakan_assets/images/sekam.png',
      'nama': 'Dr. Dopi',
      'kategori': [1, 2],
      'harga': 130850,
      'durasi': 3,
      'no_tlp': 6281234567890,
      'spealis': 'Pakan Ternak Ruminansia',
      'lokasi_praktik': 'Jl. Raya Pakan No. 123, Jakarta',
      'pukul_mulai': '08:00',
      'pukul_akhir': '12:00',
      'pendidikan': 'S1 Kedokteran Hewan - IPB;S2 Nutrisi Ternak - UGM;Pelatihan Formulasi Pakan Internasional',
      'pengalaman': '5 tahun pengalaman konsultasi pakan sapi dan kambing',
      'fokus_konsultasi': 'Formulasi pakan dan nutrisi',
      'created_at': DateTime.now().toString(),
      'updated_at': DateTime.now().toString(),
    },
    {
      'id': 2,
      'image_url': 'assets/konsultasi_pakan_assets/images/team.png',
      'nama': 'Dr. Rina',
      'kategori': [1, 3],
      'harga': 150000,
      'durasi': 2,
      'no_tlp': 6285678901234,
      'spealis': 'Unggas & Perunggasan',
      'lokasi_praktik': 'Jl. Ternak Ayam No. 45, Bandung',
      'pukul_mulai': '09:30',
      'pukul_akhir': '14:00',
      'pendidikan': 'S1 Peternakan - UNPAD;S2 Nutrisi Unggas - IPB;Workshop Manajemen Broiler',
      'pengalaman': '8 tahun pengalaman di bidang unggas',
      'fokus_konsultasi': 'Manajemen pakan ayam broiler & layer',
      'created_at': DateTime.now().toString(),
      'updated_at': DateTime.now().toString(),
    },
    {
      'id': 3,
      'image_url': 'assets/konsultasi_pakan_assets/images/team.png',
      'nama': 'Dr. Budi',
      'kategori': [1, 2],
      'harga': 100000,
      'durasi': 1,
      'no_tlp': 6289123456789,
      'spealis': 'Kambing & Domba',
      'lokasi_praktik': 'Jl. Peternakan Sejahtera No. 88, Yogyakarta',
      'pukul_mulai': '07:00',
      'pukul_akhir': '10:30',
      'pendidikan': 'S1 Peternakan - UGM;Kursus Nutrisi Ruminansia;Sertifikasi Manajemen Domba',
      'pengalaman': '3 tahun pengalaman konsultasi kambing dan domba',
      'fokus_konsultasi': 'Efisiensi pakan kambing & domba',
      'created_at': DateTime.now().toString(),
      'updated_at': DateTime.now().toString(),
    },
  ];



  @override
    Widget build(BuildContext context) {
      return ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final it = items[index];

          return KonsultasiPakanItem(
            imageUrl: it['image_url'] as String,
            nama: it['nama'] as String,
            spealis: it['spealis'] as String,
            pukulMulai: it['pukul_mulai'] as String,
            pukulAkhir: it['pukul_akhir'] as String,
            harga: (it['harga'] as int),
            durasi: (it['durasi'] as int),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => KonsultasiPakanDetailPage.fromMap(it),
                ),
              );
            },
          );
        },
      );
    }

}