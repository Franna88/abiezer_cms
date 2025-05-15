import 'package:flutter/material.dart';
import '../../../core/theme/color_theme.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utilities/utilities.dart';

class DashboardDrawer extends StatelessWidget {
  final int selectedIndex;
  final List<dynamic> navigationItems;
  final Function(int) onItemTapped;
  final bool isExpanded;

  const DashboardDrawer({
    super.key,
    required this.selectedIndex,
    required this.navigationItems,
    required this.onItemTapped,
    this.isExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isExpanded ? 250 : 80,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Drawer header
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 24,
              horizontal: isExpanded ? 16 : 8,
            ),
            decoration: BoxDecoration(color: AppColors.primary),
            alignment: Alignment.center,
            child:
                isExpanded
                    ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Abiezer Construction',
                          style: AppTextStyles.heading4.copyWith(
                            color: AppColors.textButton,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Materials Management',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textButton.withOpacity(0.8),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                    : const Icon(
                      Icons.business,
                      color: AppColors.textButton,
                      size: 32,
                    ),
          ),
          // Navigation items
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: navigationItems.length,
              itemBuilder: (context, index) {
                final item = navigationItems[index];
                final isSelected = selectedIndex == index;

                return _NavigationTile(
                  icon: item.icon,
                  label: item.label,
                  isSelected: isSelected,
                  isExpanded: isExpanded,
                  onTap: () => onItemTapped(index),
                );
              },
            ),
          ),
          // User/Logout section
          Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.divider)),
            ),
            child: _NavigationTile(
              icon: Icons.logout,
              label: 'Logout',
              isSelected: false,
              isExpanded: isExpanded,
              onTap: () {
                // Implement logout functionality
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _NavigationTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final bool isExpanded;
  final VoidCallback onTap;

  const _NavigationTile({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color:
          isSelected
              ? AppColors.secondary.withOpacity(0.1)
              : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 16,
            horizontal: isExpanded ? 16 : 8,
          ),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: isSelected ? AppColors.secondary : Colors.transparent,
                width: 4,
              ),
            ),
          ),
          child:
              isExpanded
                  ? Row(
                    children: [
                      Icon(
                        icon,
                        size: 24,
                        color:
                            isSelected
                                ? AppColors.secondary
                                : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        label,
                        style: (isSelected
                                ? AppTextStyles.bodyLarge
                                : AppTextStyles.bodyMedium)
                            .copyWith(
                              color:
                                  isSelected
                                      ? AppColors.secondary
                                      : AppColors.textPrimary,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                            ),
                      ),
                    ],
                  )
                  : Tooltip(
                    message: label,
                    child: Icon(
                      icon,
                      size: 24,
                      color:
                          isSelected
                              ? AppColors.secondary
                              : AppColors.textSecondary,
                    ),
                  ),
        ),
      ),
    );
  }
}
