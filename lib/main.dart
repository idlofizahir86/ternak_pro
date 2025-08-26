import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ternak_pro/cubit/konsultasi_page_cubit.dart';
import 'package:ternak_pro/cubit/tab_keuangan_cubit.dart';
import 'package:ternak_pro/ui_pages/asisten_virtual/asisten_virtual_page.dart';
import 'package:ternak_pro/ui_pages/keuangan/keuangan_page.dart';
import 'package:ternak_pro/ui_pages/keuangan/tambah_data_keuangan_page.dart';
import 'package:ternak_pro/ui_pages/rekomendasi_ternak/rekomendasi_ternak_page.dart';
import 'package:ternak_pro/ui_pages/tips_harian/tips_harian_page.dart';
import 'package:universal_html/html.dart' as html; // Untuk akses user agent di web
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ternak_pro/cubit/page_cubit.dart';
import 'package:ternak_pro/cubit/tab_ternak_cubit.dart';
import 'package:ternak_pro/ui_pages/data_ternak/list_data_ternak_tugas_page.dart';
import 'package:ternak_pro/ui_pages/data_ternak/tambah_data_ternak_page.dart';
import 'package:ternak_pro/ui_pages/forgot_password/forgot_password_page.dart';
import 'package:ternak_pro/ui_pages/forgot_password/new_password_page.dart';
import 'package:ternak_pro/ui_pages/onboarding/onboarding_1.dart';
import 'package:ternak_pro/ui_pages/data_ternak/tambah_data_tugas_page.dart';
import 'package:ternak_pro/ui_pages/main/main_page.dart';
import 'package:ternak_pro/shared/theme.dart';
import 'package:ternak_pro/ui_pages/forgot_password/new_password_success_page.dart';
import 'package:ternak_pro/ui_pages/login/login_page.dart';
import 'package:ternak_pro/ui_pages/onboarding/onboarding_2.dart';
import 'package:ternak_pro/ui_pages/onboarding/onboarding_3.dart';
import 'package:ternak_pro/ui_pages/onboarding/onboarding_4.dart';
import 'package:ternak_pro/ui_pages/register/register_page.dart';
import 'package:ternak_pro/ui_pages/splash_page.dart';
import 'package:flutter/services.dart';

import 'providers/auth_provider.dart';
import 'ui_pages/biaya_pakan/perkiraan_biaya_pakan_page.dart';
import 'ui_pages/harga_pasar/harga_pasar_page.dart';
import 'ui_pages/rekomendasi_ternak/hasil_rekomendasi_ternak_page.dart';
import 'ui_pages/tips_harian/tips_harian_detail_page.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init data locale untuk intl (wajib biar DateFormat 'id_ID' ga error)
  await initializeDateFormatting('id_ID', null);
  Intl.defaultLocale = 'id_ID'; // opsional

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  ));

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PageCubit()),
        BlocProvider(create: (context) => TabTernakCubit()),
        BlocProvider(create: (context) => TabKeuanganCubit()),
        BlocProvider(create: (context) => KonsultasiPageCubit()),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('id', 'ID'), // Bahasa Indonesia
          Locale('en', 'US'), // Bahasa Inggris
        ],

        debugShowCheckedModeBanner: false,
        title: 'Ternak Pro',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.bgLight),
        ),
        builder: (context, child) {
          return AspectRatioWrapper(child: child!);
        },
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashPage(),
          
          '/main': (context) => MainPage(),
          
          '/onboarding/1': (context) => const Onboarding1(),
          '/onboarding/2': (context) => const Onboarding2(),
          '/onboarding/3': (context) => const Onboarding3(),
          '/onboarding/4': (context) => const Onboarding4(),
          
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/forgot-password': (context) => const ForgotPasswordPage(),
          '/new-password': (context) => const NewPasswordPage(),
          '/new-password-success': (context) => const NewPasswordSuccessPage(),

          '/list-data-ternak-tugas': (context) => ListDataTernakTugasPage(),
          '/tambah-data-ternak': (context) => TambahDataTernakPage(),
          '/tambah-data-tugas': (context) => TambahDataTugasPage(),

          
          '/harga-pasar': (context) => HargaPasarPage(),
          '/perkiraan-biaya-pakan': (context) => PerkiraanBiayaPakanPage(),

          '/asisten-virtual': (context) => AsistenVirtualPage(),

          '/tips-harian': (context) => TipsHarianPage(),
          '/tips-harian-detail': (context) => TipsHarianDetailPage(),

          '/keuangan': (context) => KeuanganPage(),
          '/tambah-data-keuangan': (context) => TambahDataKeuanganPage(),

          '/rekomendasi-ternak-potensial': (context) => RekomendasiTernakPage(),
          '/hasil-rekomendasi-peternak': (context) => HasilRekomendasiTernakPage(),
        },
      ),
    );
  }
}

// Widget pembungkus untuk mengatur rasio aspek dan responsifitas berdasarkan ukuran layar
class AspectRatioWrapper extends StatelessWidget {
  final Widget child;

  const AspectRatioWrapper({super.key, required this.child});

  // Fungsi untuk mendeteksi apakah dijalankan di HP (bukan tablet/iPad) di web
  bool _isMobileDevice(BuildContext context) {
    if (!kIsWeb) return true; // Jika bukan web, anggap perangkat mobile
    final screenWidth = MediaQuery.of(context).size.width;
    final userAgent = html.window.navigator.userAgent.toLowerCase();

    // Kriteria untuk HP: lebar layar < 600 piksel dan user agent mengandung 'mobile'
    const mobileWidthThreshold = 600.0; // Lebar maksimum untuk HP
    const laptopWidthThreshold = 800.0; // Lebar maksimum untuk laptop kecil

    final isMobileUserAgent = userAgent.contains('mobile') &&
        !userAgent.contains('ipad') &&
        !userAgent.contains('tablet');

    // Deteksi apakah perangkat adalah HP atau laptop kecil
    return screenWidth < mobileWidthThreshold && isMobileUserAgent ||
           screenWidth < laptopWidthThreshold; // Untuk laptop kecil
  }

  @override
  Widget build(BuildContext context) {
    // Jika di HP atau laptop kecil, lewati batasan ukuran dan kembalikan child
    if (_isMobileDevice(context)) {
      return child;
    }

    // Jika di web pada desktop/tablet/iPad, terapkan rasio 9:18 dan maxHeight
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenHeight = constraints.maxHeight;
          
          const targetAspectRatio = 465 / 945; // Rasio 9:18
          const maxHeight = 945.0; // Batas tinggi maksimum (sesuaikan sesuai kebutuhan)
    
          // Hitung tinggi yang akan digunakan
          final effectiveHeight = screenHeight > maxHeight ? maxHeight : screenHeight;
          // Hitung lebar target berdasarkan rasio 9:18
          final targetWidth = effectiveHeight * targetAspectRatio;
    
          // Terapkan batasan ukuran hanya untuk non-HP di web
          return Center(
            child: Container(
              width: targetWidth,
              height: effectiveHeight,
              color: Colors.black, // Area kosong di sisi kiri-kanan
              child: AspectRatio(
                aspectRatio: targetAspectRatio,
                child: child,
              ),
            ),
          );
        },
      ),
    );
  }
}
