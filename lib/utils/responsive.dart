import 'package:flutter/material.dart';

class Responsive {
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  // Check if the current context is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  // Check if the current context is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < desktopBreakpoint;
  }

  // Check if the current context is desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopBreakpoint;
  }

  // Get responsive value based on screen size
  static T getResponsiveValue<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    required T desktop,
  }) {
    if (isDesktop(context)) {
      return desktop;
    } else if (isTablet(context)) {
      return tablet ?? mobile;
    } else {
      return mobile;
    }
  }

  // Get responsive padding
  static EdgeInsets getResponsivePadding(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: getResponsiveValue(
        context: context,
        mobile: 16.0,
        tablet: 24.0,
        desktop: 32.0,
      ),
      vertical: getResponsiveValue(
        context: context,
        mobile: 16.0,
        tablet: 20.0,
        desktop: 24.0,
      ),
    );
  }

  // Get responsive font size
  static double getResponsiveFontSize(
    BuildContext context, {
    required double mobile,
    double? tablet,
    required double desktop,
  }) {
    return getResponsiveValue(
      context: context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }

  // Get responsive width - percentage of screen width
  static double getResponsiveWidth(
    BuildContext context, {
    required double percentageMobile,
    double? percentageTablet,
    required double percentageDesktop,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (isDesktop(context)) {
      return screenWidth * (percentageDesktop / 100);
    } else if (isTablet(context)) {
      final percentage = percentageTablet ?? percentageMobile;
      return screenWidth * (percentage / 100);
    } else {
      return screenWidth * (percentageMobile / 100);
    }
  }
}
