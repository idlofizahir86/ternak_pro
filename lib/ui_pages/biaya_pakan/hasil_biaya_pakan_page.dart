import 'package:flutter/material.dart';
import '../../shared/theme.dart';
import '../../shared/widgets/custom_image_view.dart';
import '../../shared/widgets/onboarding_buttom.dart';

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
                    'Perkiraan Biaya Pakan',
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

// Halaman Utama
class HasilBiayaPakanPage extends StatelessWidget {
  const HasilBiayaPakanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.12),
        child: _buildHeaderSection(context),  // Menggunakan header yang sudah dibuat
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(14),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.green0110,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Image.asset(
                        "assets/biaya_pakan_assets/icons/ic_lamp.png",
                        width: 24,
                      ),
                      SizedBox(width: 10),
                      Text('Hasil Perhitungan Pakan',
                      style: AppTextStyle.extraBold.copyWith(fontSize: 16),)
                    ],
                  ),
                  SizedBox(height: 13),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Image.asset(
                        "assets/biaya_pakan_assets/icons/ayam.png",
                        width: 24,
                      ),
                      SizedBox(width: 10),
                      Text('Jenis Peternak : Ayam Petelur',
                      style: AppTextStyle.medium.copyWith(fontSize: 14),)
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Image.asset(
                        "assets/biaya_pakan_assets/icons/ic_plus.png",
                        width: 24,
                      ),
                      SizedBox(width: 10),
                      Text('Jumlah Ternak : 5 Ekor',
                      style: AppTextStyle.medium.copyWith(fontSize: 14),)
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Image.asset(
                        "assets/biaya_pakan_assets/icons/ic_calender.png",
                        width: 24,
                      ),
                      SizedBox(width: 10),
                      Text('Usia Ternak : 12 Bulan',
                      style: AppTextStyle.medium.copyWith(fontSize: 14),)
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),

            SizedBox(height: 20),

            Container(
              padding: EdgeInsets.only(
                top: 21,
                bottom: 21,
                left: 15,
                right: 15,
              ),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.black10,
                )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Kebutuhan Pakan Harian (Estimasi)',
                    style: AppTextStyle.extraBold.copyWith(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 13),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Jenis Pakan',
                            style: AppTextStyle.extraBold.copyWith(
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 13),
                          Text('Dedak',
                            style: AppTextStyle.medium.copyWith(
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text('Dedak',
                            style: AppTextStyle.medium.copyWith(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Kebutuhan',
                            style: AppTextStyle.extraBold.copyWith(
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 13),
                          Row(
                            children: [
                              Image.asset(
                                'assets/biaya_pakan_assets/icons/ic_plus_minus.png',
                                width: 9,
                              ),
                              SizedBox(width: 2),
                              Text("1,2 kg / Hari",
                                style: AppTextStyle.medium.copyWith(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Image.asset(
                                'assets/biaya_pakan_assets/icons/ic_plus_minus.png',
                                width: 9,
                              ),
                              SizedBox(width: 2),
                              Text("0,5 kg / Hari",
                                style: AppTextStyle.medium.copyWith(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Harga',
                            style: AppTextStyle.extraBold.copyWith(
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 13),
                          Text('Rp. 6.000',
                            style: AppTextStyle.medium.copyWith(
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text('Rp. 3.250',
                            style: AppTextStyle.medium.copyWith(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total Biaya Harian',
                            style: AppTextStyle.extraBold.copyWith(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 13),
                          Text('Estimasi Biaya Mingguan',
                            style: AppTextStyle.medium.copyWith(
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text('Estimasi Biaya Bulanan',
                            style: AppTextStyle.medium.copyWith(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Rp. 9.250',
                            style: AppTextStyle.extraBold.copyWith(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 13),
                          Text('Rp.64.750',
                            style: AppTextStyle.extraBold.copyWith(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text('Rp.277.500',
                            style: AppTextStyle.extraBold.copyWith(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 30),

            OnboardingButton(
              previous: false,
              text: "Selesai",
              width: double.infinity,
              onClick: () {
                int count = 0;
                Navigator.popUntil(context, (_) => count++ >= 2);
              },
            ),
          ],
        ),
      ),
    );
  }
}