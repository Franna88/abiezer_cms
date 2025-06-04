import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF1A73E8);
  static const secondary = Color(0xFFFFA726);
  static const background = Color(0xFFF5F5F5);
  static const surface = Colors.white;
  static const error = Color(0xFFB00020);
  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFFA000);
  static const textPrimary = Color(0xFF212121);
  static const textSecondary = Color(0xFF757575);
  static const divider = Color(0xFFBDBDBD);
}

class AppTextStyles {
  static const heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const body1 = TextStyle(fontSize: 16, color: AppColors.textPrimary);

  static const body2 = TextStyle(fontSize: 14, color: AppColors.textSecondary);

  static const button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;

  // Responsive paddings
  static EdgeInsets get mobilePadding => const EdgeInsets.all(md);
  static EdgeInsets get tabletPadding => const EdgeInsets.all(lg);

  // Touch target sizes
  static const double minButtonHeight = 48.0;
  static const double minButtonWidth = 88.0;
}

class AppBorderRadius {
  static const double sm = 4.0;
  static const double md = 8.0;
  static const double lg = 12.0;

  static BorderRadius get buttonRadius => BorderRadius.circular(md);
  static BorderRadius get cardRadius => BorderRadius.circular(lg);
}
