import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ternak_pro/ui_pages/onboarding/onboarding_1.dart';

import '../../shared/theme.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    _resetBannerSeen();
    _startTimer();
  }

  Future<void> _resetBannerSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenBanner', false); // set ke false setiap splash
  }

  void _startTimer() {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Onboarding1()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Responsif terhadap ukuran layar, mengatur padding dan gambar logo
    double logoWidth = screenWidth * 0.4; // 60% lebar layar untuk logo
    double logoHeight = logoWidth * 0.4; // Menyesuaikan tinggi dengan rasio gambar

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.gradasi01, // Gradient background
        ),
        child: Center(
          child: Image.asset(
            "assets/ic_full.png",
            key: const ValueKey('splash_logo'),
            width: logoWidth,
            height: logoHeight,
          ),
        ),
      ),
    );
  }
}
