import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../utils/responsive.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;
  final IconData icon;

  const PlaceholderScreen({Key? key, required this.title, required this.icon})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: Responsive.getResponsiveValue(
              context: context,
              mobile: 64.0,
              tablet: 80.0,
              desktop: 96.0,
            ),
            color: AppTheme.primaryColor,
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: TextStyle(
              fontSize: Responsive.getResponsiveFontSize(
                context,
                mobile: 24,
                tablet: 28,
                desktop: 32,
              ),
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal:
                  isDesktop
                      ? 40
                      : isTablet
                      ? 30
                      : 20,
            ),
            child: Text(
              'This screen will be implemented in a future task. It will display $title related functionality.',
              style: TextStyle(
                fontSize: Responsive.getResponsiveFontSize(
                  context,
                  mobile: 16,
                  tablet: 18,
                  desktop: 20,
                ),
                color: AppTheme.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
