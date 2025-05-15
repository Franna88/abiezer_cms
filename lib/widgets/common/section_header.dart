import 'package:flutter/material.dart';
import '../../core/theme/color_theme.dart';
import '../../core/theme/text_styles.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final bool hasDivider;
  final EdgeInsetsGeometry padding;
  final CrossAxisAlignment crossAxisAlignment;
  final TextStyle? titleStyle;

  const SectionHeader({
    super.key,
    required this.title,
    this.trailing,
    this.hasDivider = true,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: padding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: titleStyle ?? AppTextStyles.heading4),
              if (trailing != null) trailing!,
            ],
          ),
        ),
        if (hasDivider)
          Divider(height: 1, thickness: 1, color: AppColors.divider),
      ],
    );
  }
}

class DashboardSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final bool hasDivider;
  final EdgeInsetsGeometry padding;
  final CrossAxisAlignment crossAxisAlignment;

  const DashboardSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.hasDivider = true,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: padding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.heading3),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
        if (hasDivider)
          Divider(height: 1, thickness: 1, color: AppColors.divider),
      ],
    );
  }
}
