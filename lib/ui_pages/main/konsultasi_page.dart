import 'package:flutter/material.dart';
import 'package:ternak_pro/services/api_service.dart';
import 'package:ternak_pro/shared/theme.dart';
import 'package:ternak_pro/shared/widgets/konsultasi/konsultasi_item_card.dart';

import '../../shared/widgets/custom_image_view.dart';

class KonsultasiPage extends StatefulWidget {
  const KonsultasiPage({super.key});

  @override
  State<KonsultasiPage> createState() => _KonsultasiPageState();
}

class _KonsultasiPageState extends State<KonsultasiPage> {
  
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  String dataUser = '';
    Future<void> loadUserData() async {
      final credential = await _apiService.loadCredentials(); // Await the Future
      setState(() {
        dataUser = credential['name'] ?? ''; // Safe access with default value
      });
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(context, dataUser),
            _buildKonsultasiServices(context),
            SizedBox(height: 110), // Spacing at the bottom
          ],
        ),
      ),
    );
  }
}


Widget _buildHeaderSection(BuildContext context, String name) {
  double screenHeight = MediaQuery.of(context).size.height; // Mendapatkan tinggi layar
  double headerHeight = screenHeight * 0.33; // 33% dari tinggi layar untuk container
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
          top: 40,
          right: 15,
          child: Image.asset(
            'assets/konsultasi_assets/illustrations/img_person.png',
            height: 150,
          ),
        ),

        // Konten Utama
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 38, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Transform.rotate(
                angle: -0.0227, // 1.3 derajat dalam radian
                child: Text(
                  name,
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
                    'Ada yang bisa kami bantu ?',
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
                    'Kami siap membantumu',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              // Search bar
              Container(
                height: 48,
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/konsultasi_assets/icons/ic_search.png',
                      height: 24,
                      width: 24,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Temukan solusi instan dengan AI ✨',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

       
      ],
    ),
  );
}

Widget _buildKonsultasiServices(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 24, right: 24),
      transform: Matrix4.translationValues(0, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fitur Konsultasi',
            style: AppTextStyle.semiBold.copyWith(fontSize: 16),
          ),
          SizedBox(height: 8),
          KonsultasiItemCard(
            imagePath: 'assets/konsultasi_assets/icons/ic_konsul_1.png',
            title: 'Konsultasi Pakar',
            description: 'Konsultasi Pakan dan Kesehatan Dengan Para Pakar Dibidangnya',
            backgroundColor: AppColors.bgF1,
            bgDescColor: AppColors.bgDescF1,
            onPressed: () {
              // Aksi ketika tombol ditekan
              Navigator.pushNamed(context, '/konsultasi-pakan');
            },
          ),
          KonsultasiItemCard(
            imagePath: 'assets/konsultasi_assets/icons/ic_konsul_2.png',
            title: 'Perkiraan Biaya Pakan',
            description: 'Hitung Biaya Pengeluaran Pakan Untuk Ternakmu Jadi Lebih Mudah',
            backgroundColor: AppColors.bgF2,
            bgDescColor: AppColors.bgDescF2,
            onPressed: () {
              // Aksi ketika tombol ditekan
              Navigator.pushNamed(context, '/perkiraan-biaya-pakan');
            },
          ),
          KonsultasiItemCard(
            imagePath: 'assets/konsultasi_assets/icons/ic_konsul_3.png',
            title: 'Supplier Limbah Pakan',
            description: 'Cari Penyedia Limbah Pakan Untuk Ternakmu Lebih Mudah dan Hemat',
            backgroundColor: AppColors.bgF3,
            bgDescColor: AppColors.bgDescF3,
            onPressed: () {
              // Aksi ketika tombol ditekan
              Navigator.pushNamed(context, '/supplier-limbah-pakan');
            },
          ),
          KonsultasiItemCard(
            imagePath: 'assets/konsultasi_assets/icons/ic_konsul_4.png',
            title: 'Harga Pasar Hari Ini',
            description: 'Pantau Harga Standar Produk Ternak Dipasaran',
            backgroundColor: AppColors.bgF4,
            bgDescColor: AppColors.bgDescF4,
            onPressed: () {
              // Aksi ketika tombol ditekan
              Navigator.pushNamed(context, '/harga-pasar');
            },
          ),
          KonsultasiItemCard(
            imagePath: 'assets/konsultasi_assets/icons/ic_konsul_5.png',
            title: 'Rekomendasi Ternak Potensial',
            description: 'Cari tahu hewan ternak yang cocok dan potensial di wilayah kamu.',
            backgroundColor: AppColors.bgF5,
            bgDescColor: AppColors.bgDescF5,
            onPressed: () {
              // Aksi ketika tombol ditekan
              Navigator.pushNamed(context, '/rekomendasi-ternak-potensial');
            },
          ),          
          KonsultasiItemCard(
            imagePath: 'assets/konsultasi_assets/icons/ic_konsul_6.png',
            title: 'Asisten Virtual Peternak',
            description: 'Asisten AI Untuk Membantu Mengelola Ternakmu',
            backgroundColor: AppColors.bgF6,
            bgDescColor: AppColors.bgDescF6,
            onPressed: () {
              // Aksi ketika tombol ditekan
              Navigator.pushNamed(
                context,
                '/asisten-virtual',
                arguments: {
                  'initialText': null,
                  'externalInput': true,
                },
              );
            },
          ),
        ],
      ),
    );
  }