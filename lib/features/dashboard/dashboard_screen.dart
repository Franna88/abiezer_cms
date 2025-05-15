import 'package:flutter/material.dart';
import '../../core/models/user_model.dart';
import '../../core/theme/color_theme.dart';
import '../../core/theme/text_styles.dart';
import '../../core/utilities/constants.dart';
import '../../core/utilities/utilities.dart';
import '../../features/bom/bom_screen.dart';
import '../../features/projects/projects_screen.dart';
import 'widgets/dashboard_drawer.dart';
import 'widgets/dashboard_app_bar.dart';
import 'pages/overview_page.dart';

class DashboardScreen extends StatefulWidget {
  final UserModel currentUser;
  final int? initialIndex;
  final String? initialProjectId;

  const DashboardScreen({
    super.key,
    required this.currentUser,
    this.initialIndex,
    this.initialProjectId,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  String? _selectedProjectId;

  final List<_NavigationItem> _navigationItems = [
    _NavigationItem(
      icon: Icons.dashboard_outlined,
      label: 'Overview',
      route: AppConstants.routeDashboard,
    ),
    _NavigationItem(
      icon: Icons.business_outlined,
      label: 'Projects',
      route: AppConstants.routeProjects,
    ),
    _NavigationItem(
      icon: Icons.inventory_2_outlined,
      label: 'Bill of Materials',
      route: AppConstants.routeBoM,
    ),
    _NavigationItem(
      icon: Icons.shopping_cart_outlined,
      label: 'Purchases',
      route: AppConstants.routePurchases,
    ),
    _NavigationItem(
      icon: Icons.assessment_outlined,
      label: 'Reports',
      route: AppConstants.routeReports,
    ),
    _NavigationItem(
      icon: Icons.settings_outlined,
      label: 'Settings',
      route: AppConstants.routeSettings,
    ),
  ];

  @override
  void initState() {
    super.initState();

    // Set initial index if provided
    if (widget.initialIndex != null) {
      _selectedIndex = widget.initialIndex!;
    }

    // Set initial project ID if provided
    if (widget.initialProjectId != null) {
      _selectedProjectId = widget.initialProjectId;
    } else {
      // Check for route arguments to set selected index
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        if (args != null) {
          // Set selected index from arguments if provided
          if (args.containsKey('selectedIndex')) {
            final selectedIndex = args['selectedIndex'] as int;
            if (selectedIndex >= 0 && selectedIndex < _navigationItems.length) {
              setState(() {
                _selectedIndex = selectedIndex;
              });
            }
          }

          // Set selected project ID from arguments if provided
          if (args.containsKey('projectId')) {
            setState(() {
              _selectedProjectId = args['projectId'] as String?;
            });
          }
        }
      });
    }
  }

  void _onNavigationItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Close drawer if open on mobile
    if (Utils.isMobile(context) && _scaffoldKey.currentState!.isDrawerOpen) {
      Navigator.pop(context);
    }

    // In a real app, we'd navigate to different routes
    // Navigator.pushReplacementNamed(context, _navigationItems[index].route);
  }

  void _onProjectSelected(String projectId) {
    setState(() {
      _selectedProjectId = projectId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.scaffoldBackground,
      appBar: DashboardAppBar(
        title: _navigationItems[_selectedIndex].label,
        scaffoldKey: _scaffoldKey,
        showProjectSelector:
            _selectedIndex != 1, // Don't show project selector on Projects page
        onProjectSelected: _onProjectSelected,
      ),
      drawer:
          Utils.isMobile(context)
              ? DashboardDrawer(
                selectedIndex: _selectedIndex,
                navigationItems: _navigationItems,
                onItemTapped: _onNavigationItemTapped,
              )
              : null,
      body: Row(
        children: [
          // Side navigation for tablet and desktop
          if (!Utils.isMobile(context))
            DashboardDrawer(
              selectedIndex: _selectedIndex,
              navigationItems: _navigationItems,
              onItemTapped: _onNavigationItemTapped,
              isExpanded: Utils.isDesktop(context),
            ),

          // Main content area
          Expanded(child: _getPageForIndex(_selectedIndex)),
        ],
      ),
    );
  }

  Widget _getPageForIndex(int index) {
    // In a real app, we would use a router or conditional rendering
    switch (index) {
      case 0:
        return OverviewPage(projectId: _selectedProjectId);
      case 1: // Projects
        return ProjectsScreen(currentUser: widget.currentUser);
      case 2: // Bill of Materials
        // Directly embed the BomScreen instead of navigating to it
        return BomScreen(
          currentUser: widget.currentUser,
          projectId: _selectedProjectId,
        );
      default:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _navigationItems[index].icon,
                size: 80,
                color: AppColors.primary.withOpacity(0.7),
              ),
              const SizedBox(height: 16),
              Text(
                '${_navigationItems[index].label} Page',
                style: AppTextStyles.heading2,
              ),
              const SizedBox(height: 8),
              Text(
                'This page is under construction',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        );
    }
  }
}

class _NavigationItem {
  final IconData icon;
  final String label;
  final String route;

  _NavigationItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}
