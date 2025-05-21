import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/nav_item_model.dart';
import '../providers/project_provider.dart';
import '../providers/user_provider.dart';
import '../utils/constants.dart';
import '../utils/responsive.dart';
import '../utils/app_theme.dart';

// Content screens
import 'dashboard/dashboard_content.dart';
import 'projects/projects_content.dart';
import 'bom/bom_content.dart';
import 'purchases/purchases_content.dart';
import 'approvals/approvals_content.dart';
import 'reports/reports_content.dart';
import 'productivity/productivity_content.dart';
import 'users/users_content.dart';
import 'settings/settings_content.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool _isDrawerOpen = false;

  @override
  void initState() {
    super.initState();
    // Load projects when the screen is first shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final projectProvider = Provider.of<ProjectProvider>(
        context,
        listen: false,
      );
      projectProvider.loadProjects(userProvider.user);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final projectProvider = Provider.of<ProjectProvider>(context);
    final selectedProject = projectProvider.selectedProject;
    final user = userProvider.user;

    // Check if mobile view
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);
    final isDesktop = Responsive.isDesktop(context);

    // Filter navigation items based on user role
    final userRole = user?.role ?? '';
    final filteredNavItems =
        navigationItems.where((item) => item.isAllowed(userRole)).toList();

    // Set content based on selected index
    Widget content;
    if (_selectedIndex >= filteredNavItems.length) {
      _selectedIndex = 0;
    }

    // Determine which content to display based on selected nav item
    String selectedRoute = filteredNavItems[_selectedIndex].route;

    switch (selectedRoute) {
      case '/dashboard':
        content = DashboardContent(selectedProject: selectedProject);
        break;
      case '/projects':
        content = ProjectsContent(selectedProject: selectedProject);
        break;
      case '/bom':
        content = BomContent(selectedProject: selectedProject);
        break;
      case '/purchases':
        content = PurchasesContent(selectedProject: selectedProject);
        break;
      case '/approvals':
        content = ApprovalsContent(selectedProject: selectedProject);
        break;
      case '/reports':
        content = ReportsContent(selectedProject: selectedProject);
        break;
      case '/productivity':
        content = ProductivityContent(selectedProject: selectedProject);
        break;
      case '/users':
        content = UsersContent(selectedProject: selectedProject);
        break;
      case '/settings':
        content = SettingsContent(selectedProject: selectedProject);
        break;
      default:
        content = DashboardContent(selectedProject: selectedProject);
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: kTopBarHeight,
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textPrimaryColor,
        elevation: 2,
        title: Row(
          children: [
            // Project Selector
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: _buildProjectSelector(projectProvider),
              ),
            ),

            // User info
            if (!isMobile) // Hide on mobile
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  '${user?.name ?? "User"} - ${userRole == "admin" ? "Admin" : "Project Manager"}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ),

            // Notifications
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {
                    // TODO: Show notifications
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Notifications feature coming soon'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  tooltip: 'Notifications',
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: const Text(
                      '2', // Hardcoded count for now
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        leading:
            isMobile
                ? IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    setState(() {
                      _isDrawerOpen = true;
                    });
                    Scaffold.of(context).openDrawer();
                  },
                )
                : null,
        automaticallyImplyLeading: false,
      ),
      drawer: isMobile ? _buildDrawer(filteredNavItems, userRole) : null,
      body: Row(
        children: [
          // Side Navigation for tablet and desktop
          if (!isMobile) _buildSideNav(filteredNavItems),

          // Main Content
          Expanded(
            child: Column(
              children: [
                // Main Content Area - wrapped in Expanded to take available space
                Expanded(
                  child: Padding(
                    padding:
                        isMobile
                            ? kMobilePadding
                            : isTablet
                            ? kTabletPadding
                            : kDesktopPadding,
                    child: content,
                  ),
                ),

                // Footer (hidden on mobile)
                if (!isMobile)
                  Container(
                    height: kFooterHeight,
                    width: double.infinity,
                    color: Colors.grey[200],
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          appVersion,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                        Text(
                          'Support: $supportEmail',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Build the project selector dropdown
  Widget _buildProjectSelector(ProjectProvider projectProvider) {
    final projects = projectProvider.projects;
    final selectedProject = projectProvider.selectedProject;

    return projectProvider.isLoading
        ? const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        )
        : DropdownButtonFormField<String>(
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            hintText: 'Select a project',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.dividerColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.dividerColor),
            ),
            isDense: true,
          ),
          value: selectedProject?.id,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          items:
              projects.map<DropdownMenuItem<String>>((project) {
                return DropdownMenuItem<String>(
                  value: project.id,
                  child: Text(
                    project.name,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textPrimaryColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
          onChanged: (String? projectId) {
            if (projectId != null) {
              projectProvider.selectProjectById(projectId);
            }
          },
        );
  }

  // Build the side navigation for tablet and desktop
  Widget _buildSideNav(List<NavItemModel> navItems) {
    return Container(
      width: kSideNavWidth,
      color: Colors.white,
      child: Column(
        children: [
          // App Logo
          Container(
            height: kTopBarHeight,
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.construction,
                  color: AppTheme.primaryColor,
                  size: 32,
                ),
                SizedBox(width: 8),
                Text(
                  'Abiezer',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),

          // Nav Items
          Expanded(
            child: ListView.builder(
              itemCount: navItems.length,
              itemBuilder: (context, index) {
                final item = navItems[index];
                final isSelected = index == _selectedIndex;

                return Material(
                  color:
                      isSelected
                          ? AppTheme.primaryColor.withOpacity(0.1)
                          : Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    child: Container(
                      height: 56,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color:
                                isSelected
                                    ? AppTheme.primaryColor
                                    : Colors.transparent,
                            width: 4,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            item.icon,
                            color:
                                isSelected
                                    ? AppTheme.primaryColor
                                    : AppTheme.textSecondaryColor,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              item.label,
                              style: TextStyle(
                                color:
                                    isSelected
                                        ? AppTheme.primaryColor
                                        : AppTheme.textSecondaryColor,
                                fontWeight:
                                    isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Build the drawer for mobile
  Widget _buildDrawer(List<NavItemModel> navItems, String userRole) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: AppTheme.primaryColor),
            accountName: Consumer<UserProvider>(
              builder: (context, userProvider, _) {
                return Text(
                  userProvider.user?.name ?? 'User',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                );
              },
            ),
            accountEmail: Text(
              userRole == "admin" ? "Admin" : "Project Manager",
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: AppTheme.primaryColor, size: 36),
            ),
          ),

          // Nav Items
          Expanded(
            child: ListView.builder(
              itemCount: navItems.length,
              itemBuilder: (context, index) {
                final item = navItems[index];
                final isSelected = index == _selectedIndex;

                return ListTile(
                  leading: Icon(
                    item.icon,
                    color:
                        isSelected
                            ? AppTheme.primaryColor
                            : AppTheme.textSecondaryColor,
                  ),
                  title: Text(
                    item.label,
                    style: TextStyle(
                      color:
                          isSelected
                              ? AppTheme.primaryColor
                              : AppTheme.textSecondaryColor,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  selected: isSelected,
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                      _isDrawerOpen = false;
                    });
                    Navigator.pop(context); // Close drawer
                  },
                );
              },
            ),
          ),

          // Footer in drawer
          Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              appVersion,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
