import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

// All font sizes reduced by ~20% from original values
class AppTextStyles {
  static TextStyle get displayLarge => GoogleFonts.poppins(
        fontSize: 51, // was 64
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.1,
        letterSpacing: -1.5,
      );

  static TextStyle get displayMedium => GoogleFonts.poppins(
        fontSize: 38, // was 48
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.15,
        letterSpacing: -1.0,
      );

  static TextStyle get headlineLarge => GoogleFonts.poppins(
        fontSize: 29, // was 36
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.2,
      );

  static TextStyle get headlineMedium => GoogleFonts.poppins(
        fontSize: 22, // was 28
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.3,
      );

  static TextStyle get headlineSmall => GoogleFonts.poppins(
        fontSize: 18, // was 22
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.3,
      );

  static TextStyle get titleLarge => GoogleFonts.inter(
        fontSize: 14, // was 18
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get titleMedium => GoogleFonts.inter(
        fontSize: 13, // was 16
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: 13, // was 16
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.7,
      );

  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 11, // was 14
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.6,
      );

  static TextStyle get labelLarge => GoogleFonts.inter(
        fontSize: 10, // was 13
        fontWeight: FontWeight.w600,
        color: AppColors.accentCyan,
        letterSpacing: 1.2,
      );

  static TextStyle get labelMedium => GoogleFonts.inter(
        fontSize: 10, // was 12
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        letterSpacing: 0.8,
      );

  static TextStyle get codeStyle => GoogleFonts.firaCode(
        fontSize: 10, // was 13
        color: AppColors.accentCyan,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get navLink => GoogleFonts.inter(
        fontSize: 11, // was 14
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        letterSpacing: 0.3,
      );

  static TextStyle get accentText => GoogleFonts.poppins(
        fontSize: 14, // was 18
        fontWeight: FontWeight.w600,
        color: AppColors.accentCyan,
      );
}
