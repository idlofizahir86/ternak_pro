import 'package:flutter/material.dart';
import '../../models/SupplierPakanItem.dart';
import '../../services/api_service.dart';
import '../../shared/custom_loading.dart';
import '../../shared/theme.dart';
import '../../shared/widgets/custom_image_view.dart';
import '../../shared/widgets/supplier_pakan.dart/search_section.dart';
import '../../shared/widgets/supplier_pakan.dart/supplier_pakan_list.dart' hide SupplierPakanItem;

class SupplierLimbahPakanPage extends StatefulWidget {
  const SupplierLimbahPakanPage({super.key});

  @override
  SupplierLimbahPakanPageState createState() => SupplierLimbahPakanPageState();
}

class SupplierLimbahPakanPageState extends State<SupplierLimbahPakanPage> {
  bool _isSearchSectionVisible = true;

  // ---- state untuk search & filter ----
  String _query = '';
  final ApiService _apiService = ApiService();
  late Future<List<Map<String, dynamic>>> _kategoriFuture;
  String selectedKategoriId = '0';

  @override
  void initState() {
    super.initState();
    _kategoriFuture = _apiService.getAllKategoriSuplierPakan();
  }

  List<SupplierPakanItem> _filterSupplierPakan(List<SupplierPakanItem> SupplierPakan) {
    if (selectedKategoriId == '0') return SupplierPakan;
    return SupplierPakan
        .where((item) => item.kategori.contains(int.parse(selectedKategoriId)))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.12),
        child: _buildHeaderSection(context),  // Menggunakan header yang sudah dibuat
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollUpdateNotification &&
              scrollNotification.metrics.axis == Axis.vertical &&
              scrollNotification.scrollDelta != null) {
            final dy = scrollNotification.scrollDelta!;
            // hide saat scroll turun, show saat scroll naik
            if (dy > 0 && _isSearchSectionVisible) {
              setState(() => _isSearchSectionVisible = false);
            } else if (dy < 0 && !_isSearchSectionVisible) {
              setState(() => _isSearchSectionVisible = true);
            }
          }
          return false; // biar notifikasi tetap bubble up
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isSearchSectionVisible) 
              SearchSection(
                onQueryChanged: (q) => setState(() => _query = q),
              ),
            if (_isSearchSectionVisible) 
              // --- KATEGORI (horizontal) ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _kategoriFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: TernakProBoxLoading());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('Tidak ada data kategori'));
                    }

                    final kategoriList = snapshot.data!;
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: kategoriList.map((k) {
                          final id = k['kategori_id'].toString();
                          final name = k['kategori_name'] as String;
                          return GestureDetector(
                            onTap: () => setState(() => selectedKategoriId = id),
                            child: SupplierPakanKategoriItem(
                              isActive: selectedKategoriId == id,
                              title: name,
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),
          const SizedBox(height: 8),
            Expanded(
              child: SupplierPakanList(
                searchQuery: _query,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Header dengan ikon back
Widget _buildHeaderSection(BuildContext context) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.12,
    width: double.infinity,
    decoration: BoxDecoration(
      gradient: AppColors.gradasi01,
    ),
    child: Stack(
      children: [
        CustomImageView(
          imagePath: "assets/home_assets/images/img_star.png",
          height: MediaQuery.of(context).size.height * 0.12,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Positioned(
          top: 60,
          left: 24,
          right: 24,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Back Icon Button
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Image.asset(
                  'assets/data_ternak_assets/icons/ic_back.png',
                  width: 24,
                  height: 24,
                ),
              ),
              SizedBox(width: 10),
              // Title Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Data Supplier Limbah Pakan',
                    style: AppTextStyle.medium.copyWith(fontSize: 20, color: AppColors.white100),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class SupplierPakanKategoriItem extends StatelessWidget {
  final bool isActive;
  final String title;

  const SupplierPakanKategoriItem({
    super.key,
    required this.isActive,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.green01),
        color: isActive ? AppColors.green01 : AppColors.bgLight,
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