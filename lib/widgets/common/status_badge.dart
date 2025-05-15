import 'package:flutter/material.dart';
import '../../core/theme/color_theme.dart';
import '../../core/theme/text_styles.dart';
import '../../core/utilities/utilities.dart';

class StatusBadge extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final double fontSize;
  final EdgeInsetsGeometry padding;
  final bool hasBorder;
  final StatusType type;

  const StatusBadge({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.fontSize = 12.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    this.hasBorder = true,
    this.type = StatusType.custom,
  });

  // Factory constructors for predefined status types
  factory StatusBadge.success(String text) {
    return StatusBadge(text: text, type: StatusType.success);
  }

  factory StatusBadge.warning(String text) {
    return StatusBadge(text: text, type: StatusType.warning);
  }

  factory StatusBadge.error(String text) {
    return StatusBadge(text: text, type: StatusType.error);
  }

  factory StatusBadge.info(String text) {
    return StatusBadge(text: text, type: StatusType.info);
  }

  factory StatusBadge.pending(String text) {
    return StatusBadge(text: text, type: StatusType.pending);
  }

  factory StatusBadge.approved(String text) {
    return StatusBadge(text: text, type: StatusType.approved);
  }

  factory StatusBadge.rejected(String text) {
    return StatusBadge(text: text, type: StatusType.rejected);
  }

  factory StatusBadge.lowStock(String text) {
    return StatusBadge(text: text, type: StatusType.lowStock);
  }

  factory StatusBadge.outOfStock(String text) {
    return StatusBadge(text: text, type: StatusType.outOfStock);
  }

  @override
  Widget build(BuildContext context) {
    final Color bgColor = backgroundColor ?? _getBackgroundColor();
    final Color txtColor = textColor ?? _getTextColor();

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: Utils.borderSM,
        border: hasBorder ? Border.all(color: txtColor.withOpacity(0.3)) : null,
      ),
      child: Text(
        text,
        style: AppTextStyles.bodySmall.copyWith(
          color: txtColor,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (type) {
      case StatusType.success:
      case StatusType.approved:
        return AppColors.success.withOpacity(0.15);
      case StatusType.warning:
      case StatusType.pending:
      case StatusType.lowStock:
        return AppColors.warning.withOpacity(0.15);
      case StatusType.error:
      case StatusType.rejected:
      case StatusType.outOfStock:
        return AppColors.error.withOpacity(0.15);
      case StatusType.info:
        return AppColors.info.withOpacity(0.15);
      case StatusType.custom:
        return AppColors.textSecondary.withOpacity(0.15);
    }
  }

  Color _getTextColor() {
    switch (type) {
      case StatusType.success:
      case StatusType.approved:
        return AppColors.success;
      case StatusType.warning:
      case StatusType.pending:
      case StatusType.lowStock:
        return AppColors.warning;
      case StatusType.error:
      case StatusType.rejected:
      case StatusType.outOfStock:
        return AppColors.error;
      case StatusType.info:
        return AppColors.info;
      case StatusType.custom:
        return AppColors.textPrimary;
    }
  }
}

enum StatusType {
  success,
  warning,
  error,
  info,
  pending,
  approved,
  rejected,
  lowStock,
  outOfStock,
  custom,
}
