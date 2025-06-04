import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../../utils/responsive.dart';
import '../../screens/admin/admin_dashboard_screen.dart';
import '../../screens/admin/users_screen.dart';
import '../../screens/admin/projects_screen.dart';
import '../../screens/pm_dashboard/pm_dashboard_screen.dart';
import '../../features/bom/screens/admin_bom_screen.dart';
import '../../features/bom/screens/pm_bom_screen.dart';
import '../navigation/side_nav.dart';
import '../../providers/user_provider.dart';
import 'package:provider/provider.dart';

class TabContentPlaceholder extends StatelessWidget {
  final NavTab tab;
  final String? projectName;
  final Function(NavTab)? onTabSelected;

  const TabContentPlaceholder({
    Key? key,
    required this.tab,
    this.projectName,
    this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final userProvider = Provider.of<UserProvider>(context);
    final isAdmin = userProvider.isAdmin;

    // Return appropriate screen based on tab and user role
    if (tab == NavTab.dashboard) {
      if (isAdmin) {
        return AdminDashboardScreen(onTabSelected: onTabSelected);
      } else {
        return const PMDashboardScreen();
      }
    }

    // Return Projects screen for admin
    if (tab == NavTab.projects && isAdmin) {
      return const ProjectsScreen();
    }

    // Return BoM screen based on user role
    if (tab == NavTab.bom) {
      if (isAdmin) {
        return const AdminBoMScreen();
      } else {
        return const PMBoMScreen();
      }
    }

    // Return Users screen for admin
    if (tab == NavTab.users && isAdmin) {
      return const UsersScreen();
    }

    // For all other tabs, show placeholder content
    return _buildComingSoonContent(context);
  }

  Widget _buildComingSoonContent(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Container(
      padding: EdgeInsets.all(
        Responsive.getResponsiveValue(
          context: context,
          mobile: 16.0,
          tablet: 24.0,
          desktop: 32.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tab heading with project name if available
          Row(
            children: [
              Icon(_getTabIcon(), size: 24, color: AppTheme.primaryColor),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _getTabTitle(),
                  style: isMobile ? AppTheme.titleStyle : AppTheme.headingStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          if (projectName != null) ...[
            const SizedBox(height: 8),
            Text(
              'Project: $projectName',
              style: TextStyle(
                fontSize: isMobile ? 14 : 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ],

          const SizedBox(height: 24),

          // Placeholder content
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.construction,
                    size: 64,
                    color: AppTheme.primaryColor.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text('Coming Soon', style: AppTheme.subheadingStyle),
                  const SizedBox(height: 8),
                  Text(
                    'The ${_getTabTitle()} functionality will be implemented in the next phase.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    _getTabDescription(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textLightColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getTabIcon() {
    switch (tab) {
      case NavTab.dashboard:
        return Icons.dashboard_outlined;
      case NavTab.projects:
        return Icons.folder_outlined;
      case NavTab.bom:
        return Icons.article_outlined;
      case NavTab.purchases:
        return Icons.shopping_cart_outlined;
      case NavTab.approvals:
        return Icons.done_all_outlined;
      case NavTab.reports:
        return Icons.bar_chart_outlined;
      case NavTab.users:
        return Icons.people_outline;
      case NavTab.settings:
        return Icons.settings_outlined;
      case NavTab.productivity:
        return Icons.analytics_outlined;
      default:
        return Icons.dashboard_outlined;
    }
  }

  String _getTabTitle() {
    switch (tab) {
      case NavTab.dashboard:
        return 'Dashboard';
      case NavTab.projects:
        return 'Projects';
      case NavTab.bom:
        return 'Bill of Materials';
      case NavTab.purchases:
        return 'Purchases';
      case NavTab.approvals:
        return 'Approvals';
      case NavTab.reports:
        return 'Reports';
      case NavTab.users:
        return 'Users';
      case NavTab.settings:
        return 'Settings';
      case NavTab.productivity:
        return 'My Productivity';
      default:
        return 'Dashboard';
    }
  }

  String _getTabDescription() {
    switch (tab) {
      case NavTab.dashboard:
        return 'Overview of project status, alerts, and key metrics';
      case NavTab.projects:
        return 'Create, manage, and monitor construction projects';
      case NavTab.bom:
        return 'Manage materials, track usage, and monitor inventory';
      case NavTab.purchases:
        return 'Request, approve, and track material purchases';
      case NavTab.approvals:
        return 'Review and approve material requests, transfers, and returns';
      case NavTab.reports:
        return 'Generate reports on costs, usage, and productivity';
      case NavTab.users:
        return 'Manage users, roles, and project assignments';
      case NavTab.settings:
        return 'Configure app settings and user preferences';
      case NavTab.productivity:
        return 'View your productivity metrics and project history';
      default:
        return '';
    }
  }
}
