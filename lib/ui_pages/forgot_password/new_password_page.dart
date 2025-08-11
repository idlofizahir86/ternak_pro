import 'package:flutter/material.dart';
import 'package:ternak_pro/shared/theme.dart';
import 'package:ternak_pro/shared/widgets/auth_primary_button.dart';

import '../../shared/widgets/register_app_textfield.dart';


class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({super.key});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> with SingleTickerProviderStateMixin {
  bool rememberMe = false;
  bool showPassword = false;
  bool showConfirmPassword = false;

  // Ganti: dua controller untuk password dan konfirmasi password
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool passwordError = false;
  bool confirmPasswordError = false;
  bool passwordFocused = false;
  bool confirmPasswordFocused = false;
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
    passwordController.dispose();
    confirmPasswordController.dispose();
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
          passwordError = false;
          confirmPasswordError = false;
        });
      }
    });
  }

  void validateAndLogin() {
    setState(() {
      passwordError = false;
      confirmPasswordError = false;
      errorMessage = null;

      String password = passwordController.text.trim();
      String confirmPassword = confirmPasswordController.text.trim();

      if (password.isEmpty || confirmPassword.isEmpty) {
        passwordError = password.isEmpty;
        confirmPasswordError = confirmPassword.isEmpty;
        showError("Oops! Isi form dengan lengkap dulu yah!");
        return;
      }
      if (password.length < 8) {
        passwordError = true;
        showError("Password minimal 8 karakter!");
        return;
      }
      if (password != confirmPassword) {
        confirmPasswordError = true;
        showError("Konfirmasi password tidak sama!");
        return;
      }
      // Jika valid, lakukan proses (dummy)
      errorMessage = null;
      // ...proses...
      Navigator.pushReplacementNamed(context, '/new-password-success');
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background gradient
          Container(
            height: width * 1.1,
            decoration: const BoxDecoration(
              gradient: AppColors.gradasi02, // Gradient from top to bottom
            ),
          ),

          
          Positioned(
            bottom: -317,
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
                  "Atur Password Baru",
                  textAlign: TextAlign.center,
                  style: AppTextStyle.extraBold.copyWith(
                    fontSize: 28,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                // Subtitle
                Text(
                  "Pastikan itu berbeda dari yang sebelumnya untuk keamanan",
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
                        color: Colors.black..withAlpha((0.07).round()),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      RegisterAppTextfield(
                        controller: passwordController,
                        label: "Password",
                        hintText: "Password minimal 8 karakter",
                        error: passwordError,
                        obscureText: !showPassword,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                              passwordFocused && !passwordError
                                  ? AppColors.black100
                                  : Colors.grey,
                              BlendMode.srcIn,
                            ),
                            child: Image.asset(
                              "assets/auth_assets/icons/ic_lock.png",
                              width: 12,
                              height: 12,
                            ),
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                              showPassword
                                  ? AppColors.primaryBlue
                                  : (passwordFocused && !passwordError
                                      ? AppColors.black100
                                      : Colors.grey),
                              BlendMode.srcIn,
                            ),
                            child: Image.asset(
                              showPassword
                                  ? "assets/auth_assets/icons/ic_eye_active.png"
                                  : "assets/auth_assets/icons/ic_eye_unactive.png",
                              width: 20,
                              height: 20,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                        ),
                        onFocusChange: (hasFocus) {
                          setState(() {
                            passwordFocused = hasFocus;
                          });
                        },
                      ),
                      SizedBox(height: 24,),
                      RegisterAppTextfield(
                        controller: confirmPasswordController,
                        label: "Konfirmasi Password",
                        hintText: "Password minimal 8 karakter",
                        error: confirmPasswordError,
                        obscureText: !showConfirmPassword,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                              confirmPasswordFocused && !confirmPasswordError
                                  ? AppColors.black100
                                  : Colors.grey,
                              BlendMode.srcIn,
                            ),
                            child: Image.asset(
                              "assets/auth_assets/icons/ic_lock.png",
                              width: 12,
                              height: 12,
                            ),
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                              showConfirmPassword
                                  ? AppColors.primaryBlue
                                  : (confirmPasswordFocused && !confirmPasswordError
                                      ? AppColors.black100
                                      : Colors.grey),
                              BlendMode.srcIn,
                            ),
                            child: Image.asset(
                              showConfirmPassword
                                  ? "assets/auth_assets/icons/ic_eye_active.png"
                                  : "assets/auth_assets/icons/ic_eye_unactive.png",
                              width: 20,
                              height: 20,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              showConfirmPassword = !showConfirmPassword;
                            });
                          },
                        ),
                        onFocusChange: (hasFocus) {
                          setState(() {
                            confirmPasswordFocused = hasFocus;
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