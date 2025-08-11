import 'package:flutter/material.dart';
import 'package:ternak_pro/shared/theme.dart';
import 'package:ternak_pro/shared/widgets/auth_primary_button.dart';

import '../../shared/widgets/register_app_textfield.dart';


class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> with SingleTickerProviderStateMixin {
  bool rememberMe = false;
  bool showPassword = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool emailError = false;
  bool passwordError = false;
  bool emailFocused = false;
  bool passwordFocused = false;
  String? errorMessage;

  final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

  AnimationController? _notifAnimController;
  Animation<double>? _notifOpacity;

  @override
  void initState() {
    super.initState();
    _notifAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
      reverseDuration: const Duration(milliseconds: 350),
      value: 1,
    );
    _notifOpacity = CurvedAnimation(
      parent: _notifAnimController!,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _notifAnimController?.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void showError(String msg) {
    setState(() {
      errorMessage = msg;
      _notifAnimController?.forward(from: 0);
    });
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && errorMessage == msg) {
        _closeError();
        
      }
    });
  }

  void _closeError() {
    _notifAnimController?.reverse();
    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) {
        setState(() {
          errorMessage = null;
          emailError = false;
          passwordError = false;
        });
      }
    });
  }

  void validateAndLogin() {
    setState(() {
      emailError = false;
      errorMessage = null;

      String email = emailController.text.trim();

      if (email.isEmpty) {
        emailError = email.isEmpty;
        showError("Oops! Isi form dengan lengkap dulu yah!");
        return;
      }
      if (!emailRegex.hasMatch(email)) {
        emailError = true;
        showError("Format email tidak valid!");
        return;
      }
      // Jika valid, lakukan login (dummy)
      errorMessage = null;
      // ...proses login...
      
                        Navigator.pushNamed(context, '/new-password');
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: Stack(
        clipBehavior: Clip.none, // Tambahkan ini agar Positioned bisa keluar dari Stack
        children: [
          // Background gradient
          Container(
            height: width * 1.1,
            decoration: const BoxDecoration(
              gradient: AppColors.gradasi02, // Gradient from top to bottom
            ),
          ),

          
          Positioned(
            bottom: -435,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'assets/banner_bottom.png',
                width: MediaQuery.of(context).size.width, // Gambar mengikuti lebar layar
                fit: BoxFit.fill, // Mengisi ruang tanpa merusak proporsi
              ),
            ),
          ),
          

          
          
          // Content
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 56),
                // Logo
                Image.asset(
                  "assets/ic_launcher.png",
                  width: 56,
                  height: 56,
                ),
                const SizedBox(height: 16),
                // Title
                Text(
                  "Lupa Password",
                  textAlign: TextAlign.center,
                  style: AppTextStyle.extraBold.copyWith(
                    fontSize: 28,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                // Subtitle
                Text(
                  "Jangan khawatir kami akan membantu kamu",
                  textAlign: TextAlign.center,
                  style: AppTextStyle.regular.copyWith(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                // Card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha((0.07).round()),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      RegisterAppTextfield(
                        controller: emailController,
                        label: "Email",
                        hintText: "Masukkan Email Kamu",
                        error: emailError,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                              emailFocused && !emailError
                                  ? AppColors.black100
                                  : Colors.grey,
                              BlendMode.srcIn,
                            ),
                            child: Image.asset(
                              "assets/auth_assets/icons/ic_mail.png",
                              width: 12,
                              height: 12,
                            ),
                          ),
                        ),
                        onFocusChange: (hasFocus) {
                          setState(() {
                            emailFocused = hasFocus;
                          });
                        },
                      ),
                const SizedBox(height: 24),
                      
                AuthPrimaryButton(text: "Lanjutkan", onPressed: () {
                        validateAndLogin();
                      }, color: AppColors.primaryYellow, fontSize: 16),
                      const SizedBox(height: 16),],
                  ),
                ),
              ],
            ),
          ),

          // Back button
          Positioned(
            top: 40,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Image.asset(
                "assets/auth_assets/icons/ic_back.png",
                width: 28,
                height: 28,
              ),
            ),
          ),

          // Error message overlay (selalu di atas semua konten)
          if (errorMessage != null)
            Positioned(
              top: 56, // Geser lebih ke atas agar benar-benar di atas semua
              left: 0,
              right: 0,
              child: IgnorePointer(
                ignoring: true, // Supaya tidak menghalangi gesture konten lain
                child: FadeTransition(
                  opacity: _notifOpacity!,
                  child: Material(
                    color: Colors.transparent,
                    elevation: 20, // Pastikan elevation tinggi
                    child: Container(
                      color: AppColors.primaryRed,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              errorMessage!,
                              style: AppTextStyle.semiBold.copyWith(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          // Tidak ada tombol close karena auto hilang
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}