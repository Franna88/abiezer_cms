import 'package:flutter/material.dart';
import 'color_theme.dart';
import 'text_styles.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      // Colors
      colorScheme: ColorScheme(
        primary: AppColors.primary, // Dark Blue
        secondary: AppColors.secondary, // Light Blue
        surface: AppColors.cardBackground, // White
        background: AppColors.background, // Light Gray
        error: AppColors.error, // Red
        onPrimary: AppColors.textButton, // White
        onSecondary: AppColors.textButton, // White
        onSurface: AppColors.textPrimary, // Dark Gray
        onBackground: AppColors.textPrimary, // Dark Gray
        onError: AppColors.textButton, // White
        brightness: Brightness.light,
      ),

      scaffoldBackgroundColor: AppColors.scaffoldBackground,
      cardColor: AppColors.cardBackground,
      dividerColor: AppColors.divider,
      primaryColor: AppColors.primary,

      // Typography
      textTheme: TextTheme(
        displayLarge: AppTextStyles.heading1,
        displayMedium: AppTextStyles.heading2,
        displaySmall: AppTextStyles.heading3,
        headlineMedium: AppTextStyles.heading4,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.buttonText,
        titleMedium: AppTextStyles.label,
      ).apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),

      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary, // Light Blue
          foregroundColor: AppColors.textButton, // White
          textStyle: AppTextStyles.buttonText,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          elevation: 2,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.secondary, // Light Blue
          textStyle: AppTextStyles.buttonText,
          side: BorderSide(color: AppColors.secondary), // Light Blue
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.secondary, // Light Blue
          textStyle: AppTextStyles.buttonText,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardBackground, // White
        contentPadding: const EdgeInsets.all(16),
        hintStyle: AppTextStyles.inputLabel,
        labelStyle: AppTextStyles.inputLabel,
        errorStyle: AppTextStyles.inputError.copyWith(
          color: AppColors.error,
        ), // Red
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColors.secondary,
            width: 2,
          ), // Light Blue
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.error), // Red
        ),
      ),

      // App bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary, // Dark Blue
        foregroundColor: AppColors.textButton, // White
        centerTitle: true,
        elevation: 0,
        titleTextStyle: AppTextStyles.heading3.copyWith(
          color: AppColors.textButton,
        ), // White
      ),

      // Card theme
      cardTheme: CardTheme(
        color: AppColors.cardBackground, // White
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(8),
      ),

      // Dialog theme
      dialogTheme: DialogTheme(
        backgroundColor: AppColors.cardBackground, // White
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Tab bar theme
      tabBarTheme: TabBarTheme(
        labelColor: AppColors.secondary, // Light Blue
        unselectedLabelColor: AppColors.textSecondary, // Dark Blue with opacity
        indicatorColor: AppColors.accent, // Green Accent
        labelStyle: AppTextStyles.label,
        unselectedLabelStyle: AppTextStyles.label,
      ),

      // Floating Action Button theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.secondary, // Light Blue
        foregroundColor: AppColors.textButton, // White
      ),

      // Switch theme
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.secondary; // Light Blue
          }
          return Colors.grey.shade400;
        }),
        trackColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.secondary.withOpacity(
              0.5,
            ); // Light Blue with opacity
          }
          return Colors.grey.shade300;
        }),
      ),
    );
  }
}
