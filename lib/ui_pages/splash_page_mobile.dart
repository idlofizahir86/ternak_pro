import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ternak_pro/ui_pages/onboarding/onboarding_1.dart';
import '../../shared/theme.dart';
import '../services/api_service.dart';

class SplashPageMobile extends StatefulWidget {
  const SplashPageMobile({super.key});

  @override
  State<SplashPageMobile> createState() => _SplashPageMobileState();
}

class _SplashPageMobileState extends State<SplashPageMobile> {
  
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _resetBannerSeen();
    _checkLoginStatus(context);
  }

  Future<void> _resetBannerSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenBanner', false); // Reset banner flag
  }

  Future<void> _checkLoginStatus(BuildContext context) async {
    // Delay navigation for 3 seconds
    Timer(const Duration(seconds: 3), () async {
      final credential = await _apiService.loadCredentials();
      final token = credential['token'];
      final userId = credential['user_id']; // Memeriksa apakah user_id disimpan

      // Check if the widget is still mounted before using the context
      if (!mounted) return;

      if (token != null && userId != null) {
      // if(false) {
        // User is logged in, go to MainPage
        Navigator.pushReplacementNamed(context, '/main');
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Onboarding1()),
        );
        // User is not logged in, go to Onboarding1
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Responsif terhadap ukuran layar, mengatur padding dan gambar logo
    double logoWidth = screenWidth * 0.4; // 60% lebar layar untuk logo

    return Scaffold(
      body: Stack(
        children: [
          // Main content
          Container(
            decoration: BoxDecoration(
              gradient: AppColors.gradasi01, // Gradient background
            ),
            child: Center(
              child: Image.asset(
                "assets/splash_logo.png",
                key: const ValueKey('splash_logo'),
                width: logoWidth,
              ),
            ),
          ),
          // Copyright text at the bottom
          Positioned(
            bottom: 16.0, // Distance from the bottom of the screen
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                'Copyright © 2025\nAll rights reserved.',
                style: AppTextStyle.medium.copyWith(
                  color: AppColors.white100,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}