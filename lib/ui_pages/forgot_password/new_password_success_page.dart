import 'package:flutter/material.dart';
import 'package:ternak_pro/shared/theme.dart';
import 'package:ternak_pro/shared/widgets/onboarding_buttom.dart';

class NewPasswordSuccessPage extends StatelessWidget {
  const NewPasswordSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/auth_assets/illustrations/1.png",
              width: MediaQuery.of(context).size.width * 0.7,
            ),
            SizedBox(height: 24,),
            Text(
              "Berhasil\nDipulihkan",
              style: AppTextStyle.extraBold.copyWith(fontSize: 32),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              "Lupa Password ? Jangan Khawatir\nKami Akan Membantumu Masuk Kembali",
              textAlign: TextAlign.center,
              style: AppTextStyle.regular.copyWith(fontSize: 14),
            ),
            const SizedBox(height: 32),
            OnboardingButton(previous: false, text: "Selesai", 
            
            onClick: () {
              Navigator.pushReplacementNamed(context, '/login');
            }),
            
          ],
        ),
      ),
    );
  }
}