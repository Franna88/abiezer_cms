import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../utils/app_theme.dart';
import '../utils/responsive.dart';

enum ButtonType { primary, secondary, text }

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final ButtonType type;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final bool isDisabled;
  final double? width;
  final double? height;

  const CustomButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.isDisabled = false,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonHeight =
        height ??
        Responsive.getResponsiveValue(
          context: context,
          mobile: 48.0,
          desktop: 52.0,
        );

    final buttonWidth = width ?? (isFullWidth ? double.infinity : null);

    final hasIcon = icon != null;

    Widget buttonContent = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          _buildLoadingIndicator()
        else ...[
          if (hasIcon) ...[Icon(icon, size: 20), const SizedBox(width: 8)],
          Text(
            label,
            style: AppTheme.buttonStyle.copyWith(
              color: _getTextColor(),
              fontSize: Responsive.getResponsiveFontSize(
                context,
                mobile: 14,
                desktop: 16,
              ),
            ),
          ),
        ],
      ],
    );

    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: _buildButton(buttonContent),
    );
  }

  Widget _buildButton(Widget buttonContent) {
    switch (type) {
      case ButtonType.primary:
        return ElevatedButton(
          onPressed: isDisabled || isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
            disabledBackgroundColor: AppTheme.primaryColor.withOpacity(0.6),
            disabledForegroundColor: Colors.white70,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ),
          child: buttonContent,
        );

      case ButtonType.secondary:
        return OutlinedButton(
          onPressed: isDisabled || isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppTheme.primaryColor,
            disabledForegroundColor: AppTheme.primaryColor.withOpacity(0.6),
            side: BorderSide(
              color:
                  isDisabled || isLoading
                      ? AppTheme.primaryColor.withOpacity(0.6)
                      : AppTheme.primaryColor,
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: buttonContent,
        );

      case ButtonType.text:
        return TextButton(
          onPressed: isDisabled || isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: AppTheme.primaryColor,
            disabledForegroundColor: AppTheme.primaryColor.withOpacity(0.6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: buttonContent,
        );
    }
  }

  Widget _buildLoadingIndicator() {
    Color color;

    switch (type) {
      case ButtonType.primary:
        color = Colors.white;
        break;
      case ButtonType.secondary:
      case ButtonType.text:
        color = AppTheme.primaryColor;
        break;
    }

    return SpinKitFadingCircle(color: color, size: 20.0);
  }

  Color _getTextColor() {
    switch (type) {
      case ButtonType.primary:
        return Colors.white;
      case ButtonType.secondary:
      case ButtonType.text:
        return AppTheme.primaryColor;
    }
  }
}
