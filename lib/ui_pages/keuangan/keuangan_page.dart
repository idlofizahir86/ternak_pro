import 'package:flutter/material.dart';
import 'package:ternak_pro/shared/widgets/keuangan/keuangan_riwayat_section.dart';

import '../../shared/theme.dart';
import '../../shared/widgets/custom_image_view.dart';
import '../../shared/widgets/keuangan/income_expense_donut_card.dart';

class KeuanganPage extends StatelessWidget {
  const KeuanganPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // konten scroll
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderSection(context),
                _buildKeuanganContent(context),
                const SizedBox(height: 150), // ruang untuk bottom nav
              ],
            ),
          ),

          // tombol melayang
          Positioned(
            right: 20,
            bottom: 85, // sudah aman karena ada SizedBox 110 di konten
            child: _FloatingAddButton(
              onTap: () => Navigator.pushNamed(context, '/tambah-data-keuangan'),
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingAddButton extends StatelessWidget {
  final VoidCallback onTap;
  const _FloatingAddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    // ukuran responsif biar mirip tombol AI kamu
    final double size = (MediaQuery.of(context).size.width * 0.18).clamp(56.0, 68.0);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          image: DecorationImage(
                  image: AssetImage('assets/keuangan_assets/icons/ic_add.png'),
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }
}


Widget _buildHeaderSection(BuildContext context) {
  double screenHeight = MediaQuery.of(context).size.height; // Mendapatkan tinggi layar
  double headerHeight = screenHeight * 0.25; // 33% dari tinggi layar untuk container
  double imageHeight = screenHeight * 0.33; // 33% dari tinggi layar untuk gambar

  return Container(
    height: headerHeight ,
    width: double.infinity,
    decoration: BoxDecoration(
      gradient: AppColors.gradasi01,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(24),
        bottomRight: Radius.circular(24),
      ),
    ),
    child: Stack(
      children: [
        // Gambar latar belakang bintang (jika dibutuhkan)
        CustomImageView(
          imagePath: "assets/home_assets/images/img_star.png",
          height: imageHeight ,
          width: double.infinity,
          fit: BoxFit.cover,
        ),

         Positioned(
          bottom: 0,
          right: 0,
          child: Image.asset(
            'assets/keuangan_assets/images/header_main.png',
            height: 170,
          ),
        ),

        // Konten Utama
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 80, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Transform.rotate(
                angle: -0.0227, // 1.3 derajat dalam radian
                child: Text(
                  'Halo Khoiru Rizki Bani Adam',
                  style: AppTextStyle.semiBold.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                  )
                ),
              ),
              const SizedBox(height: 8),
              Transform.rotate(
                angle: -0.0227, // 1.3 derajat dalam radian
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(1),
                  ),
                  child: Text(
                    'Cara Sederhana Mengelola',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Transform.rotate(
                angle: -0.0227, // 1.3 derajat
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(1),
                  ),
                  child: Text(
                    'Keuangan Peternakanmu',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              
            ],
          ),
        ),

       
      ],
    ),
  );
}

Widget _buildKeuanganContent(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 24, right: 24),
      transform: Matrix4.translationValues(0, 0, 0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Catatan Keuanganmu',
              style: AppTextStyle.semiBold.copyWith(fontSize: 16),
            ),
            SizedBox(height: 16),
            IncomeExpenseDonutCard(
              totalPendapatan: 8000000, // 6.000.000
              totalPengeluaran: 1200000, // 1.200.000
            ),
            SizedBox(height: 24),
            KeuanganRiwayatSection(),
          ],
        ),
      ),
    );
  }