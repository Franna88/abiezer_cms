import 'package:flutter/material.dart';
import '../../../core/theme/color_theme.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utilities/utilities.dart';
import 'project_dropdown.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool showProjectSelector;
  final Function(String)? onProjectSelected;

  const DashboardAppBar({
    super.key,
    required this.title,
    required this.scaffoldKey,
    this.showProjectSelector = true,
    this.onProjectSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      elevation: 0,
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textButton,
      leading:
          Utils.isMobile(context)
              ? IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  scaffoldKey.currentState!.openDrawer();
                },
              )
              : null,
      actions: [
        // Project selector
        if (showProjectSelector)
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: ProjectDropdown(onProjectSelected: onProjectSelected),
            ),
          ),

        // Search button
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            // Implement search functionality
          },
        ),

        // Notifications
        IconButton(
          icon: Stack(
            children: [
              const Icon(Icons.notifications_outlined),
              // Notification badge
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  child: const Text(
                    '3',
                    style: TextStyle(
                      color: AppColors.textButton,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          onPressed: () {
            // Show notifications
          },
        ),

        // User profile
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: () {
              // Show profile menu
            },
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.accent,
                  child: Text(
                    'AC',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textButton,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (!Utils.isMobile(context)) ...[
                  const SizedBox(width: 8),
                  Text(
                    'Admin User',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textButton,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_drop_down, color: AppColors.textButton),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
