import 'package:flutter/material.dart';

import '../../theme.dart';
import 'harga_filter.dart';

class CustomHargaPasarItem extends StatelessWidget {
  final String lokasi;
  final String imageUrl;
  final String name;
  final int harga;
  final String kondisi;

  const CustomHargaPasarItem({
    super.key,
    required this.lokasi,
    required this.imageUrl,
    required this.name,
    required this.harga,
    required this.kondisi,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusIcon;
    switch (kondisi.toLowerCase()) {
      case 'naik':
        statusColor = AppColors.red600;
        statusIcon = 'assets/harga_pasar_assets/icons/ic_arrow_up.png';
        break;
      case 'stabil':
        statusColor = AppColors.blue01;
        statusIcon = 'assets/harga_pasar_assets/icons/ic_strip.png';
        break;
      case 'turun':
        statusColor = AppColors.green03;
        statusIcon = 'assets/harga_pasar_assets/icons/ic_arrow_down.png';
        break;
      default:
        statusColor = AppColors.blue01;
        statusIcon = 'assets/harga_pasar_assets/icons/ic_strip.png';
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;

        return Card(
          color: AppColors.bgLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
            side: BorderSide(color: AppColors.grey20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 14, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
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
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    imageUrl.startsWith('http')
                    ? Image.network(
                        imageUrl,
                        width: cardWidth * 0.5,
                      )
                    : Image.asset(
                        imageUrl,
                        width: cardWidth * 0.5,
                      ),
                  ],
                ),
              ),
              
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: Text(
                      name,
                      style: AppTextStyle.regular,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'RP. ${harga.toStringAsFixed(0)}/kg',
                      textAlign: TextAlign.left,
                      style: AppTextStyle.semiBold.copyWith(fontSize: 16),
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16.0),
                    bottomRight: Radius.circular(16.0),
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    statusIcon.startsWith('http')
                    ? Image.network(
                        statusIcon,
                        width: 12.0,
                        height: 12.0,
                      )
                    : Image.asset(
                        statusIcon,
                        width: 12.0,
                        height: 12.0,
                      ),
                    SizedBox(width: 4.0),
                    Text(
                      'Harga $kondisi',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class HargaPasarList extends StatelessWidget {
  final String searchQuery;
  final HargaFilter filter;

  HargaPasarList({
    super.key,
    this.searchQuery = '',
    this.filter = HargaFilter.semua,
  });

  final List<Map<String, dynamic>> items = [
    {'imageUrl':'assets/harga_pasar_assets/images/dagi_sapi.png','name':'Daging Sapi Kualitas 1','harga':130850,'kondisi':'Naik','lokasi':'Nasional'},
    {'imageUrl':'assets/harga_pasar_assets/images/daging_ayam.png','name':'Daging Ayam','harga':130850,'kondisi':'Stabil','lokasi':'Nasional'},
    {'imageUrl':'assets/harga_pasar_assets/images/susu_kambing.png','name':'Susu Kambing Etawa','harga':130850,'kondisi':'Stabil','lokasi':'Nasional'},
    {'imageUrl':'assets/harga_pasar_assets/images/telur.png','name':'Telur Ayam','harga':130850,'kondisi':'Turun','lokasi':'Nasional'},
    {'imageUrl':'assets/harga_pasar_assets/images/susu_kambing.png','name':'Susu Kambing Etawa','harga':130850,'kondisi':'Stabil','lokasi':'Nasional'},
    {'imageUrl':'assets/harga_pasar_assets/images/telur.png','name':'Telur Ayam','harga':130850,'kondisi':'Turun','lokasi':'Nasional'},
  ];

  bool _matchFilter(String kondisi) {
    switch (filter) {
      case HargaFilter.semua:  return true;
      case HargaFilter.naik:   return kondisi.toLowerCase() == 'naik';
      case HargaFilter.turun:  return kondisi.toLowerCase() == 'turun';
      case HargaFilter.stabil: return kondisi.toLowerCase() == 'stabil';
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = searchQuery.trim().toLowerCase();

    final filtered = items.where((it) {
      final name = (it['name'] as String).toLowerCase();
      final kondisi = (it['kondisi'] as String);
      final okQuery = q.isEmpty || name.contains(q);
      final okFilter = _matchFilter(kondisi);
      return okQuery && okFilter;
    }).toList();

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 50), // bottom 50
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 0.75,
      ),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final item = filtered[index];
        return CustomHargaPasarItem(
          lokasi: item['lokasi'],
          imageUrl: item['imageUrl'],
          name: item['name'],
          harga: item['harga'],
          kondisi: item['kondisi'],
        );
      },
    );
  }
}
