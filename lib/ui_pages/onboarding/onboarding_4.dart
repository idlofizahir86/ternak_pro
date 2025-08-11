import 'package:flutter/material.dart';

import '../../shared/theme.dart';
import '../../shared/widgets/onboarding_buttom.dart';

class Onboarding4 extends StatelessWidget {
  const Onboarding4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: Stack(
        children: [
          // Gambar latar belakang di bagian bawah
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final availableWidth = constraints.maxWidth;
                final bannerHeight = availableWidth * 0.4; // Tinggi gambar latar relatif
                return Image.asset(
                  'assets/banner_bottom_2.png',
                  width: availableWidth,
                  height: bannerHeight,
                  fit: BoxFit.cover, // Mengisi lebar dengan proporsi terjaga
                );
              },
            ),
          ),
          // Konten utama
          LayoutBuilder(
            builder: (context, constraints) {
              // Ambil ukuran yang tersedia dalam batasan AspectRatioWrapper
              final availableHeight = constraints.maxHeight;
              final availableWidth = constraints.maxWidth;

              // Hitung ukuran relatif
              final imageWidth = availableWidth * 0.6; // Header image 60% dari lebar
              final illustrationHeight = availableWidth * 0.7; // Illustration 70% dari lebar
              final fontSize = availableWidth * 0.04; // Font size relatif
              final padding = availableWidth * 0.05; // Padding relatif
              final buttonHeight = availableHeight * 0.05; // Tinggi tombol relatif
              final spacing = availableHeight * 0.02; // Spasi antar elemen relatif

              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distribusi merata
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: spacing * 2), // Jarak kecil dari atas
                  Image.asset(
                    "assets/onboarding_assets/header/4.png",
                    width: imageWidth,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: spacing),
                  Image.asset(
                    "assets/onboarding_assets/illustrations/4.png",
                    height: illustrationHeight,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: spacing),
                  Text(
                    "Siap Untuk Beternak Dengan Mudah ?",
                    style: AppTextStyle.semiBold.copyWith(
                      color: AppColors.black100,
                      fontSize: fontSize.clamp(14.0, 16.0), // Batas ukuran font
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: spacing * 2),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding * 2.7),
                    child: Column(
                      children: [
                        OnboardingButton(
                          previous: false,
                          text: "Masuk",
                          width: double.infinity,
                          height: buttonHeight,
                          onClick: () => Navigator.pushNamed(context, '/login'),
                        ),
                        SizedBox(height: spacing),
                        OnboardingButton(
                          previous: true,
                          text: "Daftar",
                          width: double.infinity,
                          height: buttonHeight,
                          onClick: () => Navigator.pushNamed(context, '/register'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: spacing * 4), // Jarak bawah untuk menghindari tumpang tindih dengan banner
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}