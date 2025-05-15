import 'package:flutter/material.dart';
import '../../core/theme/color_theme.dart';
import '../../core/theme/text_styles.dart';
import '../../core/utilities/utilities.dart';
import '../buttons/primary_button.dart';

class EmptyState extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final double iconSize;
  final Color? iconColor;

  const EmptyState({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.buttonText,
    this.onButtonPressed,
    this.iconSize = 80.0,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: Utils.paddingMD,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: iconColor ?? AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: AppTextStyles.heading3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (buttonText != null && onButtonPressed != null) ...[
              const SizedBox(height: 24),
              PrimaryButton(
                text: buttonText!,
                onPressed: onButtonPressed!,
                isFullWidth: false,
                width: 200,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Specialized factory constructors for common empty states
class NoDataFound extends EmptyState {
  NoDataFound({
    super.key,
    String title = 'No Data Found',
    String message = 'There are no items to display at this time.',
    IconData icon = Icons.inbox_outlined,
    String? buttonText,
    VoidCallback? onButtonPressed,
  }) : super(
         title: title,
         message: message,
         icon: icon,
         buttonText: buttonText,
         onButtonPressed: onButtonPressed,
       );
}

class NoProjectsFound extends EmptyState {
  NoProjectsFound({
    super.key,
    String title = 'No Projects Found',
    String message =
        'You have no projects yet. Create a new project to get started.',
    String buttonText = 'Create Project',
    required VoidCallback onButtonPressed,
  }) : super(
         title: title,
         message: message,
         icon: Icons.business_center_outlined,
         buttonText: buttonText,
         onButtonPressed: onButtonPressed,
       );
}

class NoMaterialsFound extends EmptyState {
  NoMaterialsFound({
    super.key,
    String title = 'No Materials Found',
    String message =
        'There are no materials in this project\'s Bill of Materials.',
    String buttonText = 'Add Materials',
    required VoidCallback onButtonPressed,
  }) : super(
         title: title,
         message: message,
         icon: Icons.category_outlined,
         buttonText: buttonText,
         onButtonPressed: onButtonPressed,
       );
}

class NoPurchasesFound extends EmptyState {
  NoPurchasesFound({
    super.key,
    String title = 'No Purchases Found',
    String message = 'There are no purchase records yet.',
    String buttonText = 'Add Purchase',
    required VoidCallback onButtonPressed,
  }) : super(
         title: title,
         message: message,
         icon: Icons.shopping_cart_outlined,
         buttonText: buttonText,
         onButtonPressed: onButtonPressed,
       );
}

class NoSearchResults extends EmptyState {
  NoSearchResults({
    super.key,
    String title = 'No Results Found',
    String message =
        'No matching items found. Try adjusting your search criteria.',
  }) : super(title: title, message: message, icon: Icons.search_off_outlined);
}
