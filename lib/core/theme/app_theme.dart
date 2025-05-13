import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:coaching_ai_new/constants/colors.dart';
import 'package:coaching_ai_new/constants/text_styles.dart';

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  fontFamily: GoogleFonts.inter().fontFamily,
  colorSchemeSeed: AppColors.primary,
  scaffoldBackgroundColor: AppColors.background,
  textTheme: TextTheme(
    headlineSmall: AppTextStyles.heading,
    titleMedium: AppTextStyles.subtitle,
    labelLarge: AppTextStyles.button,
    bodyMedium: AppTextStyles.subtitle.copyWith(
      fontSize: 14,
      color: AppColors.primary,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      backgroundColor: AppColors.buttonPrimary,
      foregroundColor: AppColors.buttonText,
      shape: const StadiumBorder(),
      textStyle: AppTextStyles.button,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      foregroundColor: AppColors.buttonPrimary,
      side: const BorderSide(color: AppColors.buttonPrimary),
      shape: const StadiumBorder(),
      textStyle: AppTextStyles.button,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primary,
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      textStyle: AppTextStyles.button,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    hintStyle: AppTextStyles.subtitle.copyWith(color: AppColors.subtitle),
  ),
);
