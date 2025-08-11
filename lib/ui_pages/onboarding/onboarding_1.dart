import 'package:flutter/material.dart';
import '../../shared/theme.dart';
import '../../shared/widgets/onboarding_buttom.dart';
import '../../shared/widgets/onboarding_slider_indicator.dart';

class Onboarding1 extends StatelessWidget {
  const Onboarding1({super.key});

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
                // Tombol Skip di pojok kanan atas
                Positioned(
                  right: 24,
                  top: 24,
                  child: InkWell(
                    onTap: () => Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/onboarding/4',
                      (route) => false,
                    ),
                    child: Image.asset(
                      "assets/onboarding_assets/ic_skip.png",
                      height: height * 0.025,
                    ),
                  ),
                ),

                // Konten utama
                Column(
                  children: [
                    SizedBox(height: height * 0.08),
                    Center(
                      child: Image.asset(
                        "assets/onboarding_assets/header/1.png",
                        width: width * 0.6,
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    Center(
                      child: Image.asset(
                        "assets/onboarding_assets/illustrations/1.png",
                        width: width * 0.9,
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                      child: Text(
                        "Catat jumlah, umur, dan kondisi ternak Anda tanpa ribet. Semua data harian bisa disimpan langsung dari HP.",
                        style: AppTextStyle.montserratMedium.copyWith(
                          color: AppColors.brown,
                          fontSize: width < 400 ? 14 : 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                    const OnboardingSliderIndicator(
                      total: 3,
                      current: 0,
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
                              isActive: false,
                            ),
                          ),
                          SizedBox(width: width * 0.03),
                          Expanded(
                            child: OnboardingButton(
                              previous: false,
                              text: "Selanjutnya",
                              onClick: () => Navigator.pushNamed(context, '/onboarding/2'),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
