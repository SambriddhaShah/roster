import 'package:flutter/material.dart';
import 'package:rooster_empployee/constants/appColors.dart';
import 'package:rooster_empployee/constants/appTextStyles.dart';

final ThemeData appTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    primary: AppColors.primary,
    primaryContainer: AppColors.primaryDark,
    secondary: AppColors.secondary,
    surface: AppColors.surface,
    error: AppColors.error,
  ),
  textTheme: TextTheme(
    displayLarge: AppTextStyles.headline1,
    displayMedium: AppTextStyles.headline2,
    bodyLarge: AppTextStyles.bodyLarge,
    bodyMedium: AppTextStyles.bodySmall,
    labelLarge: AppTextStyles.button,
    bodySmall: AppTextStyles.caption,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primary,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryDark),
    filled: true,
    fillColor: AppColors.surface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.primary, width: 2),
    ),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.primary,
    titleTextStyle: AppTextStyles.appBar,
    iconTheme: const IconThemeData(color: Colors.white),
  ),
);
