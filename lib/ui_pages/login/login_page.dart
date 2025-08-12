import 'package:flutter/material.dart';
import 'package:ternak_pro/shared/theme.dart';

import '../../shared/widgets/login_app_textfield.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  bool rememberMe = false;
  bool showPassword = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool emailError = false;
  bool passwordError = false;
  bool emailFocused = false;
  bool passwordFocused = false;
  String? errorMessage;

  final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");

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
      passwordError = false;
      errorMessage = null;

      String email = emailController.text.trim();
      String password = passwordController.text;

      if (email.isEmpty || password.isEmpty) {
        emailError = email.isEmpty;
        passwordError = password.isEmpty;
        showError("Oops! Isi form dengan lengkap dulu yah!");
        return;
      }
      if (!emailRegex.hasMatch(email)) {
        emailError = true;
        showError("Format email tidak valid!");
        return;
      }
      if (password.length < 8) {
        passwordError = true;
        showError("Password minimal 8 karakter!");
        return;
      }
      // Jika valid, lakukan login (dummy)
      errorMessage = null;
      // ...proses login...
      Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Gradient latar belakang
              LayoutBuilder(
                builder: (context, constraints) {
                  final availableHeight = constraints.maxHeight;
                  return Container(
                    height: availableHeight * 0.5, // Gradient menutupi 50% tinggi layar
                    decoration: const BoxDecoration(
                      gradient: AppColors.gradasi02,
                    ),
                  );
                },
              ),
              // Gambar banner di bagian bawah
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final availableWidth = constraints.maxWidth;
                    final bannerHeight = availableWidth * 0.4; // Tinggi banner relatif
                    return Image.asset(
                      'assets/banner_bottom.png',
                      width: availableWidth,
                      height: bannerHeight,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              // Konten utama
              LayoutBuilder(
                builder: (context, constraints) {
                  final availableHeight = constraints.maxHeight;
                  final availableWidth = constraints.maxWidth;
          
                  // Hitung ukuran relatif
                  final logoSize = availableWidth * 0.14; // Logo 14% dari lebar
                  final fontSizeTitle = availableWidth * 0.07; // Font judul relatif
                  final fontSizeSubtitle = availableWidth * 0.035; // Font subtitle relatif
                  final padding = availableWidth * 0.05; // Padding relatif
                  final buttonHeight = availableHeight * 0.06; // Tinggi tombol relatif
                  final spacing = availableHeight * 0.02; // Spasi antar elemen relatif
                  final cardPadding = availableWidth * 0.05; // Padding kartu relatif
          
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: spacing * 2),
                      // Logo
                      Image.asset(
                        "assets/ic_launcher.png",
                        width: logoSize,
                        height: logoSize,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: spacing),
                      // Title
                      Text(
                        "Masuk Ke\nAkun Kamu",
                        textAlign: TextAlign.center,
                        style: AppTextStyle.extraBold.copyWith(
                          fontSize: fontSizeTitle.clamp(20.0, 28.0),
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: spacing * 0.5),
                      // Subtitle
                      Text(
                        "Masukkan email dan password kamu untuk Login",
                        textAlign: TextAlign.center,
                        style: AppTextStyle.regular.copyWith(
                          fontSize: fontSizeSubtitle.clamp(12.0, 14.0),
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: spacing * 2),
                      // Card
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: padding),
                        padding: EdgeInsets.symmetric(
                          vertical: cardPadding,
                          horizontal: cardPadding,
                        ),
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
                            // Google Button
                            SizedBox(
                              width: double.infinity,
                              height: buttonHeight,
                              child: OutlinedButton.icon(
                                icon: Image.asset(
                                  "assets/auth_assets/icons/ic_google.png",
                                  width: logoSize * 0.5,
                                  height: logoSize * 0.5,
                                ),
                                label: Text(
                                  "Masuk Dengan Google",
                                  style: AppTextStyle.semiBold.copyWith(
                                    color: AppColors.black100,
                                    fontSize: fontSizeSubtitle.clamp(14.0, 16.0),
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: cardPadding * 0.5),
                                  backgroundColor: Colors.white,
                                  side: const BorderSide(color: Color(0xFFE0E0E0)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () {},
                              ),
                            ),
                            SizedBox(height: spacing),
                            // Divider with text
                            Row(
                              children: [
                                const Expanded(
                                  child: Divider(thickness: 1, color: Color(0xFFE0E0E0)),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: cardPadding * 0.5),
                                  child: Text(
                                    "Atau login dengan",
                                    style: AppTextStyle.regular.copyWith(
                                      color: Colors.grey[500],
                                      fontSize: fontSizeSubtitle.clamp(12.0, 13.0),
                                    ),
                                  ),
                                ),
                                const Expanded(
                                  child: Divider(thickness: 1, color: Color(0xFFE0E0E0)),
                                ),
                              ],
                            ),
                            SizedBox(height: spacing),
                            // Email Field
                            LoginAppTextfield(
                              controller: emailController,
                              hintText: "Masukkan email kamu",
                              error: emailError,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(cardPadding * 0.5),
                                child: ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                    emailFocused && !emailError
                                        ? AppColors.black100
                                        : Colors.grey,
                                    BlendMode.srcIn,
                                  ),
                                  child: Image.asset(
                                    "assets/auth_assets/icons/ic_mail.png",
                                    width: logoSize * 0.05,
                                    height: logoSize * 0.05,
                                  ),
                                ),
                              ),
                              onFocusChange: (hasFocus) {
                                setState(() {
                                  emailFocused = hasFocus;
                                });
                              },
                            ),
                            SizedBox(height: spacing * 0.7),
                            // Password Field
                            LoginAppTextfield(
                              controller: passwordController,
                              hintText: "Masukkan password kamu",
                              error: passwordError,
                              obscureText: !showPassword,
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(cardPadding * 0.5),
                                child: ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                    passwordFocused && !passwordError
                                        ? AppColors.black100
                                        : Colors.grey,
                                    BlendMode.srcIn,
                                  ),
                                  child: Image.asset(
                                    "assets/auth_assets/icons/ic_lock.png",
                                    width: logoSize * 0.5,
                                    height: logoSize * 0.5,
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
                                    width: logoSize * 0.5,
                                    height: logoSize * 0.5,
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
                            SizedBox(height: spacing * 0.5),
                            // Remember me & Forgot password
                            Row(
                              children: [
                                Checkbox(
                                  value: rememberMe,
                                  onChanged: (val) {
                                    setState(() {
                                      rememberMe = val ?? false;
                                    });
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                Text(
                                  "Ingat Saya",
                                  style: AppTextStyle.regular.copyWith(
                                    fontSize: fontSizeSubtitle.clamp(12.0, 13.0),
                                  ),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/forgot-password');
                                  },
                                  child: Text(
                                    "Lupa Password ?",
                                    style: AppTextStyle.semiBold.copyWith(
                                      color: AppColors.blue01,
                                      fontSize: fontSizeSubtitle.clamp(12.0, 13.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: spacing * 0.5),
                            // Login Button
                            SizedBox(
                              width: double.infinity,
                              height: buttonHeight,
                              child: ElevatedButton(
                                key: const Key('login_button'),
                                onPressed: validateAndLogin,
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: cardPadding * 0.5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 0,
                                  backgroundColor: const Color(0xFFFF9900),
                                ),
                                child: Text(
                                  "Masuk",
                                  key: const ValueKey('login_button_text'),
                                  style: AppTextStyle.semiBold.copyWith(
                                    fontSize: fontSizeSubtitle.clamp(14.0, 16.0),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: spacing * 0.5),
                            // Register
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Belum punya akun ?",
                                  style: AppTextStyle.regular.copyWith(
                                    fontSize: fontSizeSubtitle.clamp(12.0, 13.0),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/register');
                                  },
                                  child: Text(
                                    "Daftar",
                                    style: AppTextStyle.semiBold.copyWith(
                                      color: AppColors.blue01,
                                      fontSize: fontSizeSubtitle.clamp(12.0, 13.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: spacing * 4), // Jarak bawah untuk menghindari tumpang tindih
                    ],
                  );
                },
              ),
              // Back button
              Positioned(
                top: 16,
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
              // Error message overlay
              if (errorMessage != null)
                Positioned(
                  top: 16,
                  left: 0,
                  right: 0,
                  child: IgnorePointer(
                    ignoring: true,
                    child: FadeTransition(
                      opacity: _notifOpacity!,
                      child: Material(
                        color: Colors.transparent,
                        elevation: 20,
                        child: Container(
                          color: AppColors.primaryRed,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Text(
                            errorMessage!,
                            style: AppTextStyle.semiBold.copyWith(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}