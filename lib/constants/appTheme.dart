// import 'package:flutter/material.dart';
// import 'package:rooster_empployee/constants/appColors.dart';
// import 'package:rooster_empployee/constants/appTextStyles.dart';

// final ThemeData appTheme = ThemeData(
//   colorScheme: const ColorScheme.light(
//     primary: AppColors.primary,
//     primaryContainer: AppColors.primaryDark,
//     secondary: AppColors.secondary,
//     surface: AppColors.surface,
//     error: AppColors.error,
//   ),
//   textTheme: TextTheme(
//     displayLarge: AppTextStyles.headline1,
//     displayMedium: AppTextStyles.headline2,
//     bodyLarge: AppTextStyles.bodyLarge,
//     bodyMedium: AppTextStyles.bodySmall,
//     labelLarge: AppTextStyles.button,
//     bodySmall: AppTextStyles.caption,
//   ),
//   elevatedButtonTheme: ElevatedButtonThemeData(
//     style: ElevatedButton.styleFrom(
//       backgroundColor: AppColors.primary,
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//     ),
//   ),
//   textButtonTheme: TextButtonThemeData(
//     style: TextButton.styleFrom(
//       foregroundColor: AppColors.primary,
//       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//     ),
//   ),
//   inputDecorationTheme: InputDecorationTheme(
//     labelStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryDark),
//     filled: true,
//     fillColor: AppColors.surface,
//     border: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(8),
//       borderSide: const BorderSide(color: AppColors.border),
//     ),
//     focusedBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(8),
//       borderSide: const BorderSide(color: AppColors.primary, width: 2),
//     ),
//   ),
//   appBarTheme: AppBarTheme(
//     backgroundColor: AppColors.primary,
//     titleTextStyle: AppTextStyles.appBar,
//     iconTheme: const IconThemeData(color: Colors.white),
//   ),
// );

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rooster_empployee/constants/appColors.dart';
import 'package:rooster_empployee/constants/appTextStyles.dart';

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: AppColors.background,
  colorScheme: const ColorScheme.light(
    primary: AppColors.primary,
    onPrimary: Colors.white,
    secondary: AppColors.textSecondary,
    surface: AppColors.surface,
    onSurface: AppColors.textPrimary,
    error: AppColors.error,
  ),
  textTheme: TextTheme(
    displayLarge: AppTextStyles.display,
    displayMedium: AppTextStyles.headline1,
    bodyLarge: AppTextStyles.bodyLarge,
    bodyMedium: AppTextStyles.bodySmall,
    labelLarge: AppTextStyles.button,
    bodySmall: AppTextStyles.caption,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.primary,
    elevation: 0,
    centerTitle: false,
    titleTextStyle: AppTextStyles.appBar,
    iconTheme: const IconThemeData(color: Colors.white),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      minimumSize: const Size.fromHeight(56),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      textStyle: AppTextStyles.button,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primary,
      textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    isDense: true,
    filled: true,
    fillColor: AppColors.surface,
    contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
    hintStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
    labelStyle: AppTextStyles.bodySmall,
    prefixIconColor: AppColors.icon,
    suffixIconColor: AppColors.icon,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.error),
    ),
  ),
  checkboxTheme: CheckboxThemeData(
    side: const BorderSide(color: AppColors.border),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) return AppColors.primary;
      return Colors.white;
    }),
    checkColor: const WidgetStatePropertyAll(Colors.white),
  ),
  dividerTheme: const DividerThemeData(color: AppColors.divider, thickness: 1),
);
