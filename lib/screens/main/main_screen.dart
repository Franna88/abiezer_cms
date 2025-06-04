import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/project_model.dart';
import '../../providers/project_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/notification_provider.dart';
import '../../utils/responsive.dart';
import '../../widgets/navigation/side_nav.dart';
import '../../widgets/navigation/top_bar.dart';
import '../../widgets/navigation/app_footer.dart';
import '../../widgets/content/tab_content_placeholder.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  NavTab _selectedTab = NavTab.dashboard;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final projectProvider = Provider.of<ProjectProvider>(
      context,
      listen: false,
    );
    final notificationProvider = Provider.of<NotificationProvider>(
      context,
      listen: false,
    );

    if (userProvider.user != null) {
      // Fetch projects based on user role
      await projectProvider.fetchUserProjects(userProvider.user!);

      // Fetch notifications
      await notificationProvider.fetchNotifications(userProvider.user!.id);
    }
  }

  void _onTabSelected(NavTab tab) {
    setState(() {
      _selectedTab = tab;
    });

    // Close drawer if open on mobile
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final projectProvider = Provider.of<ProjectProvider>(context);
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);
    final isDesktop = Responsive.isDesktop(context);

    final isAdmin = userProvider.isAdmin;
    final ProjectModel? selectedProject = projectProvider.selectedProject;

    return Scaffold(
      key: _scaffoldKey,
      appBar: TopBar(
        onMenuTap:
            isMobile ? () => _scaffoldKey.currentState?.openDrawer() : null,
        isAdmin: isAdmin,
      ),
      drawer: isMobile
          ? Drawer(
              child: SideNav(
                selectedTab: _selectedTab,
                onTabSelected: _onTabSelected,
              ),
            )
          : null,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Side navigation - visible on tablet and desktop
          if (!isMobile)
            SideNav(
              selectedTab: _selectedTab,
              onTabSelected: _onTabSelected,
              isExtended: isDesktop,
            ),

          // Main content area
          Expanded(
            child: Column(
              children: [
                // Main content
                Expanded(
                  child: TabContentPlaceholder(
                    tab: _selectedTab,
                    projectName: selectedProject?.name,
                    onTabSelected: _onTabSelected,
                  ),
                ),

                // Footer - visible only on desktop
                if (isDesktop) const AppFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
