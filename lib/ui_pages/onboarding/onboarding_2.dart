import 'package:flutter/material.dart';

import '../../shared/theme.dart';
import '../../shared/widgets/onboarding_buttom.dart';
import '../../shared/widgets/onboarding_slider_indicator.dart';

class Onboarding2 extends StatelessWidget {
  const Onboarding2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double width = constraints.maxWidth;
            double height = constraints.maxHeight;

            return Stack(
              children: [
                // Icon skip di pojok kanan atas
                Positioned(
                  right: 24,
                  top: 24,
                  child: InkWell(
                    onTap: () => Navigator.pushNamedAndRemoveUntil(
                      context, '/onboarding/4', (route) => false),
                    child: Image.asset(
                      "assets/onboarding_assets/ic_skip.png",
                      height: height * 0.025,
                    ),
                  ),
                ),
                // Konten utama di bawah icon skip
                Column(
                  children: [
                    SizedBox(height: height * 0.08), // Jarak cukup dari atas (skip icon) ke gambar
                    Center(
                      child: Image.asset(
                        "assets/onboarding_assets/header/2.png",
                       width: width * 0.6,
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    Center(
                      child: Image.asset(
                        "assets/onboarding_assets/illustrations/2.png",
                        width: width * 0.9,
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Text("Dapatkan notifikasi perawatan, dan lihat harga pasar hari ini. Biar nggak telat kasih makan atau jual rugi.",
                      style: AppTextStyle.montserratMedium.copyWith(
                        color: AppColors.brown,
                        fontSize: width < 400 ? 14 : 16,
                      ),
                      textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                    // Tambahkan slider indicator di sini
                    const OnboardingSliderIndicator(
                      total: 3,
                      current: 1,
                    ),
                    SizedBox(height: height * 0.03),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.08),
                      child: Row(
                        children: [
                          Expanded(
                            child: OnboardingButton(
                              previous: true,
                              text: "Sebelumnya",
                              onClick: () => Navigator.pushNamed(context, '/onboarding/1'),
                            ),
                          ),
                          SizedBox(width: 12), // Spasi antar tombol
                          Expanded(
                            child: OnboardingButton(
                              previous: false,
                              text: "Selanjutnya",
                              onClick: () => Navigator.pushNamed(context, '/onboarding/3'),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}

