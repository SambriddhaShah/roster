// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:rooster_empployee/constants/appColors.dart';

// class AppTextStyles {
//   // Headings (Poppins)
//   static TextStyle headline1 = GoogleFonts.poppins(
//     fontSize: 28,
//     fontWeight: FontWeight.w600,
//     color: AppColors.textPrimary,
//   );

//     static TextStyle appBar = GoogleFonts.poppins(
//     fontSize: 24,
//     fontWeight: FontWeight.w500,
//     color: Colors.white,
//   );

//   static TextStyle headline2 = GoogleFonts.poppins(
//     fontSize: 24,
//     fontWeight: FontWeight.w500,
//     color: AppColors.textPrimary,
//   );
//   static TextStyle headline3 = GoogleFonts.poppins(
//     fontSize: 20,
//     fontWeight: FontWeight.w500,
//     color: AppColors.textPrimary,
//   );

//   // Body Text (Inter)
//   static TextStyle bodyLarge = GoogleFonts.inter(
//     fontSize: 16,
//     color: AppColors.textPrimary,
//     height: 1.5,
//   );

//   static TextStyle bodySmall = GoogleFonts.inter(
//     fontSize: 14,
//     color: AppColors.textSecondary,
//   );

//   // Buttons
//   static TextStyle button = GoogleFonts.inter(
//     fontSize: 16,
//     fontWeight: FontWeight.w600,
//     color: Colors.white,
//   );

//    // Captions
//   static TextStyle caption = GoogleFonts.inter(
//     fontSize: 12,
//     color: AppColors.textSecondary,
//   );
// }
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rooster_empployee/constants/appColors.dart';

class AppTextStyles {
  // Big hero headline on auth
  static TextStyle display = GoogleFonts.poppins(
    fontSize: 34,
    fontWeight: FontWeight.w700,
    height: 1.1,
    color: AppColors.textPrimary,
  );

  static TextStyle headline1 = GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle appBar = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle headline2 = GoogleFonts.poppins(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle headline3 = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static TextStyle headline4 = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  // Body
  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    height: 1.45,
    color: AppColors.textPrimary,
  );

  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  static TextStyle caption = GoogleFonts.inter(
    fontSize: 12,
    color: AppColors.textMuted,
  );

  // Buttons
  static TextStyle button = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}
