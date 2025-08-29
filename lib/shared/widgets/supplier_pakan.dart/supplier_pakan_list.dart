import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Tambahkan import ini
import 'package:ternak_pro/shared/widgets/custom_button.dart';
import 'package:ternak_pro/shared/widgets/onboarding_buttom.dart';
import 'package:ternak_pro/shared/widgets/supplier_pakan.dart/hubungi_button.dart';

import '../../theme.dart';

class SupplierPakanItem extends StatelessWidget {
  final String lokasi;
  final String imageUrl;
  final String name;
  final int harga;
  final bool isStok;

  const SupplierPakanItem({
    super.key,
    required this.lokasi,
    required this.imageUrl,
    required this.name,
    required this.harga,
    required this.isStok,
  });

  String formatRupiah(int value) {
    final formatter = NumberFormat('#,###', 'id_ID');
    return formatter.format(value).replaceAll(',', '.');
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
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
    {'imageUrl':'assets/supplier_pakan_assets/images/sekam.png','name':'SEKAM MENTAH PREMIUM 1 KARUNG / 50 KG','harga':130850,'isStok': true,'lokasi':'Nasional'},
    {'imageUrl':'assets/harga_pasar_assets/images/daging_ayam.png','name':'Daging Ayam','harga':130850,'isStok': false,'lokasi':'Nasional'},
    {'imageUrl':'assets/harga_pasar_assets/images/susu_kambing.png','name':'Susu Kambing Etawa','harga':130850,'isStok': false,'lokasi':'Nasional'},
    {'imageUrl':'assets/harga_pasar_assets/images/telur.png','name':'Telur Ayam','harga':130850,'isStok': true,'lokasi':'Nasional'},
    {'imageUrl':'assets/harga_pasar_assets/images/susu_kambing.png','name':'Susu Kambing Etawa','harga':130850,'isStok': false,'lokasi':'Nasional'},
    {'imageUrl':'assets/harga_pasar_assets/images/telur.png','name':'Telur Ayam','harga':130850,'isStok': true,'lokasi':'Nasional'},
  ];


  @override
  Widget build(BuildContext context) {
    final q = searchQuery.trim().toLowerCase();

    final filtered = items.where((it) {
      final name = (it['name'] as String).toLowerCase();
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
          lokasi: item['lokasi'],
          imageUrl: item['imageUrl'],
          name: item['name'],
          harga: item['harga'],
          isStok: item['isStok'],
        );
      },
    );
  }
}