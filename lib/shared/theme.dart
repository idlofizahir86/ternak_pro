import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppSpacing {
  static const double defaultMargin = 24.0;
}

class AppColors {
  static const Color bgLight = Color(0xFFFEFEFE);
  static const Color primaryWhite = Color(0xFFFFFFFF);

  static const Color black100 = Color(0xFF272727);
  static const Color black50 = Color(0x80272727); // 50% opacity
  static const Color black01 = Color(0xFF737373);
  static const Color black10 = Color(0x19000000); // 10% opacity
  static const Color black03 = Color(0xFF404040);
  static const Color black04 = Color(0xFF262626);

  static const Color white100 = Color(0xFFFFFFFF);
  static const Color white06 = Color(0xFFA3A3A3);
  static const Color white50 = Color(0x80FFFFFF); // 50% opacity

  static const Color primaryRed = Color(0xFFE02D3C);
static const Color red600 = Color(0xFFDC2626);

  static const Color red = Color(0xFFE53935);
  static const Color redBg = Color(0xFFFF4116);

  static const Color blue = Color(0xFF1F73FF);
  static const Color greyText = Color(0xFF6B7280);
  static const Color divider = Color(0xFFE5E7EB);
  static const Color chipBgRed = Color(0xFFFFE6E4);
  static const Color chipBgBlue = Color(0xFFE7F0FF);

  static const Color primaryBlue = Color(0xFF0057D6);
  static const Color blue02 = Color(0xFF2972FF);

  static const Color primaryYellow = Color(0xFFFF9900);
  static const Color yellow500 = Color(0xFFEAB308);

  static const Color purple = Color(0xFFF103B1);
  
  static const Color brown = Color(0xFF606060);
  static const Color grey = Color(0xFF6C7278);
  static const Color grey2 = Color(0xFF595959);
  static const Color grey3 = Color(0xFFDBDBDB);
  static const Color grey20 = Color(0x336C7278); // 20% opacity
  static const Color transparent = Colors.transparent;
  static const Color blackText = Color(0xFF454545);

  static const Color blue01 = Color(0xFF298FBB);
  static const Color blue0120 = Color(0x33298FBB); // 20% opacity
  static const Color green01 = Color(0xFF0EBCB1);
  static const Color green0110 = Color(0x190EBCB1 ); // 10% opacity

  static const Color green02 = Color(0xFFC2ECEB);
  static const Color green03 = Color(0xFF02C789);

  // New colors for livestock management theme
  static const Color orange = Color(0xFFFFA500);
  static const Color lightGreen = Color(0xFFD4E8D4);
  static const Color darkGreen = Color(0xFF065627);

  static const Color bgF1 = Color(0xFF298FBB);
  static const Color bgDescF1 = Color(0xFFECF8FF);

  static const Color bgF2 = Color(0xFFFFC616);
  static const Color bgDescF2 = Color(0xFFFFF9EB);

  static const Color bgF3 = Color(0xFFFF4116);
  static const Color bgDescF3 = Color(0xFFFFF2EB);

  static const Color bgF4 = Color(0xFF22BF7C);
  static const Color bgDescF4 = Color(0xFFECFFED);

  static const Color bgF5 = Color(0xFF0EBCB1);
  static const Color bgDescF5 = Color(0xFFECFFFB);

  static const Color bgF6 = Color(0xFF1FA2DB);
  static const Color bgDescF6 = Color(0xFFD6F8FF);
  
  

  /// 💡 Gradient yang bisa langsung dipanggil
  static const LinearGradient gradasi01 = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [blue01, green01],
  );
  static LinearGradient gradasi01WithOpacity20 = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      blue01.withAlpha((255 * 0.2).round()),
      green01.withAlpha((255 * 0.2).round()),
    ],
  );
  static const LinearGradient gradasi02 = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [blue01, green01],
  );
  static const LinearGradient gradasi03 = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [lightGreen, darkGreen],
  );

  static const LinearGradient gradasiFitur1 = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.73], // 0% dan 73%
    colors: [
      Color(0xFF7FDEFC), // 100% opacity
      Color(0xFF0F7DDA),
    ],
  );

  static const LinearGradient gradasiFitur2 = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.7], // 0% dan 70%
    colors: [
      Color(0xFFFD921C),
      Color(0xFFEE0E02),
    ],
  );

  static const LinearGradient gradasiFitur4 = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.88], // 0% dan 88%
    colors: [
      Color(0xFFFFBE2D),
      Color(0xFFFB6C02),
    ],
  );

  static const LinearGradient gradasiAIchat = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 1], // 0% dan 88%
    colors: [
      Color(0xFF7FF7FF),
      Color(0xFFC9F1E6),
    ],
  );
}

class AppTextStyle {
  static final TextStyle semiBold = GoogleFonts.inter(
    fontWeight: FontWeight.w600,
  );

  static final TextStyle extraBold = GoogleFonts.inter(
    fontWeight: FontWeight.w800,
  );

  static final TextStyle regular = GoogleFonts.inter(
    fontWeight: FontWeight.w400,
  );

  static final TextStyle medium = GoogleFonts.inter(
    fontWeight: FontWeight.w500,
  );

  // Montserrat variants
  static final TextStyle montserratSemiBold = GoogleFonts.montserrat(
    fontWeight: FontWeight.w600,
  );

  static final TextStyle montserratExtraBold = GoogleFonts.montserrat(
    fontWeight: FontWeight.w800,
  );

  static final TextStyle montserratRegular = GoogleFonts.montserrat(
    fontWeight: FontWeight.w400,
  );

  static final TextStyle montserratMedium = GoogleFonts.montserrat(
    fontWeight: FontWeight.w500,
  );

  // New text styles for consultation page
  static TextStyle heading = GoogleFonts.inter(
    fontWeight: FontWeight.w700,
    fontSize: 20,
    color: AppColors.black100,
  );

  static TextStyle subheading = GoogleFonts.inter(
    fontWeight: FontWeight.w500,
    fontSize: 16,
    color: AppColors.grey,
  );

  static TextStyle dataValue = GoogleFonts.inter(
    fontWeight: FontWeight.w600,
    fontSize: 14,
    color: AppColors.blackText,
  );
}