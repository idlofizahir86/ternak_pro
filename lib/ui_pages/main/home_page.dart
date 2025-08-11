import 'package:flutter/material.dart';

import '../../shared/theme.dart';
import '../../shared/widgets/home/daily_task.dart';
import '../../shared/widgets/custom_image_view.dart';
import '../../shared/widgets/daily_tip_card.dart';
import '../../shared/widgets/featured_service_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data defined in HomePage
    List<DailyTaskItem> tasks = [
      DailyTaskItem(
        title: 'Pemberian Pakan & Air',
        status: 'Sudah',
        time: '07:00 AM',
        iconPath: "assets/home_assets/icons/ic_snack.png",
      ),
      DailyTaskItem(
        title: 'Vaksin Ternak',
        status: 'Tertunda',
        time: '07:00 AM',
        iconPath: "assets/home_assets/icons/ic_shield.png",
      ),
    ];

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeaderSection(context),
            _buildStatsCard(context),
            _buildFeaturedServices(context),
            buildDailyTasks(context, tasks),
            _buildDailyTips(context),
            SizedBox(height: 110), // Spacing at the bottom
          ],
        ),
      ),
    );
  }
}

Widget _buildHeaderSection(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;

  // Ukuran dinamis berdasarkan ukuran layar
  double headerHeight = screenHeight * 0.25; // Menyesuaikan tinggi header
  double imageHeight = screenHeight * 0.2; // Menyesuaikan tinggi gambar
  double fontSizeSmall = (screenWidth * 0.05).clamp(16.0, 20.0); // Responsif untuk ukuran font
  double fontSizeLarge = (screenWidth * 0.06).clamp(18.0, 22.0); // Responsif untuk ukuran font besar
  double iconSize = (screenWidth * 0.08).clamp(20.0, 36.0); // Responsif untuk ukuran ikon

  return Container(
    height: headerHeight,
    width: double.infinity,
    decoration: BoxDecoration(
      gradient: AppColors.gradasi01,
    ),
    child: Stack(
      children: [
        CustomImageView(
          imagePath: "assets/home_assets/images/img_star.png",
          height: imageHeight,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Positioned(
          top: 58,
          left: 24,
          right: 24,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hai Selamat Pagi,',
                    style: AppTextStyle.medium.copyWith(fontSize: fontSizeSmall, color: AppColors.white100),
                  ),
                  Text(
                    'Khoiru Rizki Bani Adam',
                    style: AppTextStyle.extraBold.copyWith(fontSize: fontSizeLarge, color: AppColors.white100),
                  ),
                ],
              ),
              Container(
                width: iconSize,
                height: iconSize,
                decoration: BoxDecoration(
                  color: AppColors.white100,
                  borderRadius: BorderRadius.circular(iconSize / 2),
                ),
                child: Center(
                  child: CustomImageView(
                    imagePath: "assets/home_assets/icons/ic_bell.png",
                    height: iconSize * 0.6,
                    width: iconSize * 0.6,
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 110,
          left: 24,
          right: 24,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.white100,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        CustomImageView(
                          imagePath: "assets/home_assets/icons/ic_location.png",
                          height: 24,
                          width: 24,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Tambahkan Lokasi',
                          style: AppTextStyle.medium.copyWith(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  CustomImageView(
                    imagePath: "assets/home_assets/images/img_amelia_1_2.png",
                    height: 36,
                    width: 32,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Kamis,07 Juli 2026',
                    style: AppTextStyle.medium.copyWith(
                      fontSize: fontSizeSmall*0.6,
                      color: AppColors.white100,
                    ),
                  ),
                  SizedBox(height: 42),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Row(
            children: [
              Column(
                children: [
                  SizedBox(height: 12),
                  CustomImageView(
                    imagePath: "assets/home_assets/images/img_amelia_1_3.png",
                    height: 28,
                    width: 32,
                  ),
                ],
              ),
              SizedBox(width: 8),
              CustomImageView(
                imagePath: "assets/home_assets/images/img_amelia_1_4.png",
                height: 40,
                width: 32,
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: CustomImageView(
            imagePath: "assets/home_assets/images/img_amelia_1_1.png",
            height: 40,
            width: 28,
          ),
        ),
      ],
    ),
  );
}


  

  Widget _buildStatsCard(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth;

        // Ukuran dinamis
        double fontSizeSmall = (maxWidth * 0.01).clamp(10.0, 14.0);
        double fontSizeLarge = (maxWidth * 0.04).clamp(14.0, 18.0);
        double iconSmall = (maxWidth * 0.05).clamp(16.0, 24.0);
        double iconLarge = (maxWidth * 0.08).clamp(24.0, 36.0);
        double verticalSpacing = (maxWidth * 0.02).clamp(6.0, 12.0);
        double dividerHeight = (maxWidth * 0.12).clamp(40.0, 60.0);

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          transform: Matrix4.translationValues(0, -24, 0),
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: verticalSpacing,
              horizontal: 10,
            ),
            decoration: BoxDecoration(
              color: AppColors.white100,
              border: Border.all(color: AppColors.grey20),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Kolom 1: Jumlah Ternak
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Jumlah Ternak",
                            style: AppTextStyle.semiBold.copyWith(
                              fontSize: fontSizeSmall,
                              color: AppColors.blackText,
                            ),
                          ),
                          SizedBox(height: verticalSpacing),
                          Row(
                            children: [
                              Image.asset(
                                "assets/home_assets/icons/ic_cow.png",
                                height: iconSmall,
                                width: iconSmall,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "-",
                                style: AppTextStyle.extraBold.copyWith(
                                  fontSize: fontSizeLarge,
                                  color: AppColors.blackText,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),

                      // Kolom 2: Pakan Harian
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Pakan Harian",
                            style: AppTextStyle.semiBold.copyWith(
                              fontSize: fontSizeSmall,
                              color: AppColors.blackText,
                            ),
                          ),
                          SizedBox(height: verticalSpacing),
                          Row(
                            children: [
                              Image.asset(
                                "assets/home_assets/icons/ic_snack.png",
                                height: iconSmall,
                                width: iconSmall,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "-",
                                style: AppTextStyle.extraBold.copyWith(
                                  fontSize: fontSizeLarge,
                                  color: AppColors.primaryRed,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),

                      // Divider vertikal
                      Container(
                        height: dividerHeight,
                        width: 1,
                        color: AppColors.grey20,
                      ),

                      // Kolom 3: Update Data Harian (tombol)
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/list-data-ternak-tugas');
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/home_assets/icons/ic_update.png",
                              height: iconLarge,
                              width: iconLarge,
                            ),
                            SizedBox(height: verticalSpacing / 2),
                            Text(
                              "Update Data\nHarian",
                              textAlign: TextAlign.center,
                              style: AppTextStyle.semiBold.copyWith(
                                fontSize: fontSizeSmall,
                                color: AppColors.blackText,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Kolom 4: Tambah Data Ternak (tombol)
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/tambah-data-ternak');
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/home_assets/icons/ic_plus.png",
                              height: iconLarge,
                              width: iconLarge,
                            ),
                            SizedBox(height: verticalSpacing / 2),
                            Text(
                              "Tambah Data\nTernak",
                              textAlign: TextAlign.center,
                              style: AppTextStyle.semiBold.copyWith(
                                fontSize: fontSizeSmall,
                                color: AppColors.blackText,
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
          ),
        );
      },
    );
  }



 Widget _buildFeaturedServices(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      transform: Matrix4.translationValues(0, -10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fitur Unggulan',
            style: AppTextStyle.semiBold.copyWith(fontSize: 16),
          ),
          SizedBox(height: 8),
          FeaturedServiceCardWidget(
            iconPath: "assets/home_assets/icons/ic_ai_agent.png",
            title: 'Asisten Virtual Peternak',
            description: 'Asisten AI Untuk Membantu Mengelola Ternakmu',
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFF298FBB), Color(0xFF298FBB)],
            ),
            onTap: () {
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
          SizedBox(height: 8),
          FeaturedServiceCardWidget(
            iconPath: "assets/home_assets/icons/ic_invest.png",
            title: 'Harga Pasar Hari Ini',
            description: 'Pantau Harga Standar Produk Ternak Dipasaran',
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFF0EBCB1), Color(0xFF065627)],
            ),
            onTap: () {
              Navigator.pushNamed(context, '/harga-pasar');
            },
          ),
        ],
      ),
    );
  }


  Widget _buildDailyTips(BuildContext context) {
    List<Map<String, String>> tips = [
      {
        'image': "assets/home_assets/images/dummy_1.png",
        'title':
            'Tips Menjaga Kesehatan Ternak Agar Tidak Mudah Sakit, Biar Makin Profit',
        'author': 'By RecyClean - 1 bulan lalu',
      },
      {
        'image': "assets/home_assets/images/dummy_2.png",
        'title': 'Bagaimana Perawatan Ternak Yang Baik Menurut Para Ahli',
        'author': 'By RecyClean - 2 bulan lalu',
      },
    ];

    return Container(
      margin: EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text(
              'Tips Harian Kamu',
              style: AppTextStyle.semiBold.copyWith(fontSize: 16),
            ),
          ),
          SizedBox(height: 8),
          SizedBox(
            height: 135,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tips.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    if (index == 0) SizedBox(width: 24), // Tambah jarak di awal
                    DailyTipCardWidget(
                      imagePath: tips[index]['image'] ?? '',
                      title: tips[index]['title'] ?? '',
                      author: tips[index]['author'] ?? '',
                    ),
                    SizedBox(width: 8), // Jarak antar card (opsional)
                  ],
                );
              },
            ),
          ),
        SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/tips-harian');
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: AppColors.gradasi01WithOpacity20,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Lihat Lainnya →',
                    style: AppTextStyle.semiBold.copyWith(
                      color: AppColors.green01,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        ],
      ),
    );
  }