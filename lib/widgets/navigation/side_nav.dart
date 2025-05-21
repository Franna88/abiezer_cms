import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/responsive.dart';
import '../../utils/app_theme.dart';
import 'side_nav_item.dart';

enum NavTab {
  dashboard,
  projects,
  bom,
  purchases,
  approvals,
  reports,
  users,
  settings,
  productivity,
}

class SideNav extends StatelessWidget {
  final NavTab selectedTab;
  final Function(NavTab) onTabSelected;
  final bool isExtended;

  const SideNav({
    Key? key,
    required this.selectedTab,
    required this.onTabSelected,
    this.isExtended = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final isAdmin = userProvider.isAdmin;

    return Container(
      width: isExtended ? 250 : 72,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 16),
          if (isExtended)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.construction,
                    color: AppTheme.primaryColor,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Abiezer',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        Text(
                          'Construction',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.textPrimaryColor.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Icon(
                Icons.construction,
                color: AppTheme.primaryColor,
                size: 32,
              ),
            ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Dashboard - available for both roles
                  SideNavItem(
                    icon: Icons.dashboard_outlined,
                    label: 'Dashboard',
                    isSelected: selectedTab == NavTab.dashboard,
                    onTap: () => onTabSelected(NavTab.dashboard),
                    isExtended: isExtended,
                  ),

                  // Projects - admin only
                  if (isAdmin)
                    SideNavItem(
                      icon: Icons.folder_outlined,
                      label: 'Projects',
                      isSelected: selectedTab == NavTab.projects,
                      onTap: () => onTabSelected(NavTab.projects),
                      isExtended: isExtended,
                    ),

                  // BoM - available for both roles
                  SideNavItem(
                    icon: Icons.article_outlined,
                    label: 'Bill of Materials',
                    isSelected: selectedTab == NavTab.bom,
                    onTap: () => onTabSelected(NavTab.bom),
                    isExtended: isExtended,
                  ),

                  // Purchases - available for both roles
                  SideNavItem(
                    icon: Icons.shopping_cart_outlined,
                    label: 'Purchases',
                    isSelected: selectedTab == NavTab.purchases,
                    onTap: () => onTabSelected(NavTab.purchases),
                    isExtended: isExtended,
                  ),

                  // Approvals - admin only
                  if (isAdmin)
                    SideNavItem(
                      icon: Icons.done_all_outlined,
                      label: 'Approvals',
                      isSelected: selectedTab == NavTab.approvals,
                      onTap: () => onTabSelected(NavTab.approvals),
                      isExtended: isExtended,
                    ),

                  // Reports - admin only
                  if (isAdmin)
                    SideNavItem(
                      icon: Icons.bar_chart_outlined,
                      label: 'Reports',
                      isSelected: selectedTab == NavTab.reports,
                      onTap: () => onTabSelected(NavTab.reports),
                      isExtended: isExtended,
                    ),

                  // My Productivity - project manager only
                  if (!isAdmin)
                    SideNavItem(
                      icon: Icons.analytics_outlined,
                      label: 'My Productivity',
                      isSelected: selectedTab == NavTab.productivity,
                      onTap: () => onTabSelected(NavTab.productivity),
                      isExtended: isExtended,
                    ),

                  // Users - admin only
                  if (isAdmin)
                    SideNavItem(
                      icon: Icons.people_outline,
                      label: 'Users',
                      isSelected: selectedTab == NavTab.users,
                      onTap: () => onTabSelected(NavTab.users),
                      isExtended: isExtended,
                    ),

                  // Settings - available for both roles
                  SideNavItem(
                    icon: Icons.settings_outlined,
                    label: 'Settings',
                    isSelected: selectedTab == NavTab.settings,
                    onTap: () => onTabSelected(NavTab.settings),
                    isExtended: isExtended,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
