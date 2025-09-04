import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Tambahkan import ini
import 'package:ternak_pro/shared/widgets/custom_button.dart';
import 'package:ternak_pro/shared/widgets/onboarding_buttom.dart';
import 'package:ternak_pro/shared/widgets/supplier_pakan.dart/hubungi_button.dart';

import '../../../ui_pages/supplier_pakan/supplier_limbah_pakan_detail_page.dart';
import '../../theme.dart';

class SupplierPakanItem extends StatelessWidget {
  final String lokasi;
  final String imageUrl;
  final String name;
  final String noTelepon;
  final int harga;
  final bool isStok;
  final VoidCallback? onTap;

  const SupplierPakanItem({
    super.key,
    required this.lokasi,
    required this.imageUrl,
    required this.noTelepon,
    required this.name,
    required this.harga,
    required this.isStok, 
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
      child: AspectRatio(
        aspectRatio: 0.65, // Sesuaikan dengan childAspectRatio di GridView
        child: Card(
          color: AppColors.bgLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
            side: BorderSide(color: AppColors.grey20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.12,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                  image: DecorationImage(
                    image: AssetImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                  child: SizedBox(
                    height: 32, // kira-kira tinggi 2 baris teks
                    child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      name,
                      style: AppTextStyle.semiBold.copyWith(fontSize: 12),
                      textAlign: TextAlign.left,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    ),
                  ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'RP ${formatRupiah(harga)}', // gunakan formatRupiah
                      textAlign: TextAlign.left,
                      style: AppTextStyle.semiBold.copyWith(
                      fontSize: 16,
                      color: AppColors.blue01,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: RichText(
                      text: TextSpan(
                      children: [
                        TextSpan(
                        text: 'Stok: ',
                        style: AppTextStyle.medium.copyWith(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                        ),
                        TextSpan(
                        text: isStok ? "Tersedia" : "Habis",
                        style: AppTextStyle.medium.copyWith(
                          color: isStok
                            ? Colors.green
                            : Colors.red,
                          fontSize: 12,
                        ),
                        ),
                      ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/harga_pasar_assets/icons/ic_location.png',
                          width: 16.0,
                          height: 16.0,
                        ),
                        SizedBox(width: 4.0),
                        Text(lokasi),
                      ],
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 15.0, left: 8.0, right: 8.0),
      
                      child: FractionallySizedBox(
                        alignment: Alignment.center,
                        child: HubungiButton(text: 'Hubungi Penjual')
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SupplierPakanList extends StatelessWidget {
  final String searchQuery;

  SupplierPakanList({
    super.key,
    this.searchQuery = '',
  });

  final List<Map<String, dynamic>> items = [
    {
      'id': 1,
      'image_url': 'assets/supplier_pakan_assets/images/sekam.png;assets/supplier_pakan_assets/images/sekam2.png',
      'judul': 'SEKAM MENTAH PREMIUM 1 KARUNG / 50 KG',
      'detail': 'Sekam padi kualitas premium cocok untuk bedding ternak.Sekam padi kualitas premium cocok untuk bedding ternak.Sekam padi kualitas premium cocok untuk bedding ternak.Sekam padi kualitas premium cocok untuk bedding ternak.Sekam padi kualitas premium cocok untuk bedding ternak.Sekam padi kualitas premium cocok untuk bedding ternak.Sekam padi kualitas premium cocok untuk bedding ternak.',
      'khasiat':
        'Sumber Serat Terbaik: Jerami jagung kaya akan serat kasar yang sangat penting untuk sistem pencernaan ruminansia. Serat membantu merangsang pergerakan lambung dan mencegah masalah pencernaan seperti kembung.;Pakan Tambahan Ekonomis: Sebagai pakan tambahan, jerami jagung dapat membantu mengurangi biaya pakan konsentrat tanpa mengorbankan nutrisi esensial.;Meningkatkan Nafsu Makan: Aroma alami dari jerami jagung seringkali disukai oleh ternak, sehingga dapat meningkatkan nafsu makan dan mendorong asupan nutrisi yang lebih baik.',
      'kategori_id': 1,
      'is_stok': 1,
      'is_nego': 1,
      'harga': 130850,
      'no_tlp': 6281234567890,
      'alamat_overview': 'Nasional',
      'alamat': 'Jl. Raya Pakan No. 123, Jakarta',
      'maps_link': 'https://maps.google.com/?q=-6.200000,106.816666',
      'created_at': DateTime.now().toString(),
      'updated_at': DateTime.now().toString(),
    },
    {
      'id': 2,
      'image_url': 'assets/harga_pasar_assets/images/daging_ayam.png;assets/harga_pasar_assets/images/daging_ayam2.png',
      'judul': 'Daging Ayam Segar',
      'detail': 'Daging ayam potong segar kualitas premium.',
      'khasiat':
        'Sumber protein tinggi untuk tubuh.;Baik untuk pertumbuhan otot.;Meningkatkan stamina.',
      'kategori_id': 2,
      'is_stok': 0,
      'is_nego': 0,
      'harga': 75000,
      'no_tlp': 6281234567891,
      'alamat_overview': 'Nasional',
      'alamat': 'Jl. Pasar Hewan No. 45, Bandung',
      'maps_link': 'https://maps.google.com/?q=-6.914744,107.609810',
      'created_at': DateTime.now().toString(),
      'updated_at': DateTime.now().toString(),
    },
    {
      'id': 3,
      'image_url': 'assets/harga_pasar_assets/images/susu_kambing.png;assets/harga_pasar_assets/images/susu_kambing2.png',
      'judul': 'Susu Kambing Etawa',
      'detail': 'Susu kambing Etawa segar langsung dari peternak.Sekam padi kualitas premium cocok untuk bedding ternak.Sekam padi kualitas premium cocok untuk bedding ternak.',
      'khasiat':
        'Meningkatkan stamina.;Baik untuk pencernaan.;Membantu menjaga daya tahan tubuh.',
      'kategori_id': 3,
      'is_stok': 1,
      'is_nego': 1,
      'harga': 35000,
      'no_tlp': 6281234567892,
      'alamat_overview': 'Nasional',
      'alamat': 'Jl. Ternak Makmur No. 88, Yogyakarta',
      'maps_link': 'https://maps.google.com/?q=-7.795580,110.369490',
      'created_at': DateTime.now().toString(),
      'updated_at': DateTime.now().toString(),
    },
  ];



  @override
  Widget build(BuildContext context) {
    final q = searchQuery.trim().toLowerCase();

    final filtered = items.where((it) {
      final name = (it['judul'] as String).toLowerCase();
      final okQuery = q.isEmpty || name.contains(q);
      return okQuery;
    }).toList();

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 50),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 0.65, // Pastikan sama dengan AspectRatio di Card
      ),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final item = filtered[index];
        return SupplierPakanItem(
          lokasi: item['alamat_overview'],
          imageUrl:(item['image_url'] as String).split(';').first,
          noTelepon: item['no_tlp'].toString(),
          name: item['judul'],
          harga: item['harga'],
          isStok: item['is_stok'] == 1 ? true : false,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SupplierLimbahPakanDetailPage.fromMap(item),
              ),
            );
          },
        );
      },
    );
  }
}