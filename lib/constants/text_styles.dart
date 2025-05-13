import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart'; // make sure the path is correct

class AppTextStyles {
  static final TextStyle subtitle = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.subtitle,
  );

  static final TextStyle heading = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static final TextStyle button = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.buttonText,
  );

  static final TextStyle error = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.error,
  );

  static TextStyle guestButtonTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.labelLarge!.copyWith(
      color: AppColors.guestText,
    );
  }

  static final TextStyle link = GoogleFonts.inter(
  fontSize: 14,
  fontWeight: FontWeight.w500,
  color: AppColors.primary,
  decoration: TextDecoration.underline,
);

}
