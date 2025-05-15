import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {
  // Spacing constants
  static const double spacing_xs = 4.0;
  static const double spacing_sm = 8.0;
  static const double spacing_md = 16.0;
  static const double spacing_lg = 24.0;
  static const double spacing_xl = 32.0;
  static const double spacing_xxl = 48.0;

  // Common paddings
  static const EdgeInsets paddingXS = EdgeInsets.all(spacing_xs);
  static const EdgeInsets paddingSM = EdgeInsets.all(spacing_sm);
  static const EdgeInsets paddingMD = EdgeInsets.all(spacing_md);
  static const EdgeInsets paddingLG = EdgeInsets.all(spacing_lg);

  static const EdgeInsets paddingHorizontalSM = EdgeInsets.symmetric(
    horizontal: spacing_sm,
  );
  static const EdgeInsets paddingHorizontalMD = EdgeInsets.symmetric(
    horizontal: spacing_md,
  );
  static const EdgeInsets paddingHorizontalLG = EdgeInsets.symmetric(
    horizontal: spacing_lg,
  );

  static const EdgeInsets paddingVerticalSM = EdgeInsets.symmetric(
    vertical: spacing_sm,
  );
  static const EdgeInsets paddingVerticalMD = EdgeInsets.symmetric(
    vertical: spacing_md,
  );
  static const EdgeInsets paddingVerticalLG = EdgeInsets.symmetric(
    vertical: spacing_lg,
  );

  static const EdgeInsets pagePadding = EdgeInsets.symmetric(
    horizontal: spacing_lg,
    vertical: spacing_md,
  );

  // Border radius
  static const double borderRadiusSM = 4.0;
  static const double borderRadiusMD = 8.0;
  static const double borderRadiusLG = 12.0;
  static const double borderRadiusXL = 16.0;

  static BorderRadius borderSM = BorderRadius.circular(borderRadiusSM);
  static BorderRadius borderMD = BorderRadius.circular(borderRadiusMD);
  static BorderRadius borderLG = BorderRadius.circular(borderRadiusLG);
  static BorderRadius borderXL = BorderRadius.circular(borderRadiusXL);

  // Date formatters
  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('dd MMM yyyy, h:mm a').format(date);
  }

  // Currency formatter
  static String formatCurrency(double amount) {
    return NumberFormat.currency(symbol: 'R', decimalDigits: 2).format(amount);
  }

  // String utilities
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  static String getInitials(String name) {
    if (name.isEmpty) return '';
    List<String> names = name.split(' ');
    String initials = '';

    for (var i = 0; i < names.length && i < 2; i++) {
      if (names[i].isNotEmpty) {
        initials += names[i][0];
      }
    }

    return initials.toUpperCase();
  }

  // Validation utilities
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  static bool isValidPhone(String phone) {
    return RegExp(r'^\+?[0-9]{10,12}$').hasMatch(phone);
  }

  // Responsive utilities
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 1200;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1200;
  }

  static double getResponsiveWidth(
    BuildContext context, {
    double mobile = 1,
    double tablet = 0.7,
    double desktop = 0.5,
  }) {
    final width = MediaQuery.of(context).size.width;

    if (width >= 1200) {
      return width * desktop;
    } else if (width >= 600) {
      return width * tablet;
    } else {
      return width * mobile;
    }
  }

  // Image file validation
  static bool isImageFile(String fileName) {
    final validExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp'];
    fileName = fileName.toLowerCase();
    return validExtensions.any((ext) => fileName.endsWith(ext));
  }

  // File size formatter
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1048576) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1073741824) return '${(bytes / 1048576).toStringAsFixed(1)} MB';
    return '${(bytes / 1073741824).toStringAsFixed(1)} GB';
  }
}
