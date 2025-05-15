import 'package:flutter/material.dart';

class AppColors {
  // Primary brand colors
  static const primary = Color(0xFF2E3853); // Dark Blue
  static const secondary = Color(0xFF2577CC); // Light Blue
  static const accent = Color(0xFFB9CC25); // Green Accent
  static const red = Color(0xFFCF2419); // Red

  // Background colors
  static const background = Color(0xFFF5F5F7); // Light Gray
  static const cardBackground = Color(0xFFFEFFFE); // White
  static const scaffoldBackground = Color(0xFFF5F5F7); // Light Gray
  static const progressBackground = Color(0xFFF5F5F7); // Light Gray

  // Text colors
  static const textPrimary = Color(0xFF2E3238); // Dark Gray
  static const textSecondary = Color(0xFF2E3853); // Dark Blue
  static const textHint = Color(0xFF2E3238); // Dark Gray, with opacity
  static const textButton = Color(0xFFFEFFFE); // White

  // Status colors
  static const success = Color(0xFFB9CC25); // Green Accent
  static const warning = Color(0xFF2577CC); // Light Blue
  static const error = Color(0xFFCF2419); // Red
  static const info = Color(0xFF2577CC); // Light Blue

  // Border colors
  static const border = Color(0xFFF5F5F7); // Light Gray
  static const divider = Color(0xFFF5F5F7); // Light Gray

  // Construction specific colors
  static const lowStock = Color(0xFF2577CC); // Light Blue for low stock warning
  static const outOfStock = Color(0xFFCF2419); // Red for out of stock
  static const approved = Color(0xFFB9CC25); // Green Accent for approved items
  static const pending = Color(0xFF2577CC); // Light Blue for pending approvals
  static const rejected = Color(0xFFCF2419); // Red for rejected items
}
